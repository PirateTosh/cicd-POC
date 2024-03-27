import base64
import json
import datetime as dt
from time import sleep
from urllib import parse
import pyotp
import requests
from fyers_apiv3 import fyersModel
from app.config import (
    APP_ID,
    APP_SECRET,
    ERROR,
    FYERS_ID,
    CLIENT_ID,
    PIN,
    REDIRECT_URI,
    SUCCESS,
    TOTP_KEY,
    URL_SEND_LOGIN_OTP,
    URL_TOKEN,
    URL_VERIFY_PIN,
    URL_VERIFY_TOTP,
)
from app.shared.constants import (
    FYERS_ID_OR_APP_ID_IS_NOT_PRESENT,
    INSTANCE_ALREADY_EXISTS,
    FYERS_LOGIN_SUCCESSFUL,
    INVALID_ACCESS_TOKEN,
    ACCESS_TOKEN_NOT_GENERATED_CANNOT_PROCEED_WITH_LOGIN
)

fyers_instance = None


def send_login_otp(fy_id, app_id):
    try:
        payload = {"fy_id": fy_id, "app_id": app_id}
        result_string = requests.post(url=URL_SEND_LOGIN_OTP, json=payload)
        if result_string.status_code != 200:
            return [ERROR, result_string.text]

        result = json.loads(result_string.text)
        request_key = result["request_key"]

        return [SUCCESS, request_key]
    except Exception as e:
        return [ERROR, e]


def verify_otp(request_key, otp):
    try:
        payload = {"request_key": request_key, "otp": otp}
        result_string = requests.post(url=URL_VERIFY_TOTP, json=payload)
        if result_string.status_code != 200:
            return [ERROR, result_string.text]

        result = json.loads(result_string.text)
        request_key = result["request_key"]

        return [SUCCESS, request_key]
    except Exception as e:
        return [ERROR, e]


def verify_pin(request_key, identity_type, identifier):
    try:
        payload = {
            "request_key": request_key,
            "identity_type": identity_type,
            "identifier": identifier,
        }
        result_string = requests.post(url=URL_VERIFY_PIN, json=payload)
        if result_string.status_code != 200:
            return [ERROR, result_string.text]

        result = json.loads(result_string.text)
        access_token = result["data"]["access_token"]

        return [SUCCESS, access_token]
    except Exception as e:
        return [ERROR, e]


def get_auth_code(bearer_token, fyers_id, client_app_id, redirect_uri, appType):
    try:
        ses = requests.Session()
        ses.headers.update({"authorization": f"Bearer {bearer_token}"})
        payload = {
            "fyers_id": fyers_id,
            "app_id": client_app_id,
            "redirect_uri": redirect_uri,
            "appType": appType,
            "code_challenge": "",
            "state": "None",
            "Scope": "",
            "nonce": "",
            "response_type": "code",
            "create_cookie": True,
        }
        result_string = ses.post(url=URL_TOKEN, json=payload)
        if result_string.status_code != 308:
            return [ERROR, result_string.text]

        result = json.loads(result_string.text)
        url = result["Url"]
        auth_code = parse.parse_qs(parse.urlparse(url).query)["auth_code"][0]

        return [SUCCESS, auth_code]
    except Exception as e:
        return [ERROR, e]


def getEncodedString(string):
    string = str(string)
    base64_bytes = base64.b64encode(string.encode("ascii"))
    return base64_bytes.decode("ascii")


class FyersAPICallError(Exception):
    pass


def generate_fyers_instance():
    global fyers_instance
    status = ''
    if not FYERS_ID or not APP_ID:
        status = FYERS_ID_OR_APP_ID_IS_NOT_PRESENT
        print(status)
        return None,status

    try:
        # If fyers_instance already exists, return it
        if fyers_instance:
            status = INSTANCE_ALREADY_EXISTS
            return fyers_instance,status

        # Generates access token using Fyers API

        # Step 1 - Retrieve request_key from send_login_otp API
        send_otp_result = send_login_otp(getEncodedString(FYERS_ID), APP_ID)
        if send_otp_result[0] != SUCCESS:
            raise FyersAPICallError(f"send_login_otp failure - {send_otp_result[1]}")

        if dt.datetime.now().second % 30 > 27:
            sleep(5)

        # Step 2 - Retrieve request_key from verify_otp API
        send_otp_request_key = send_otp_result[1]
        otp = pyotp.TOTP(TOTP_KEY).now()
        verify_totp_result = verify_otp(send_otp_request_key, otp)
        if verify_totp_result[0] != SUCCESS:
            raise FyersAPICallError(
                f"verify_totp_result failure - {verify_totp_result[1]}"
            )

        # Step 3 - Verify Pin from verify_pin API
        verify_pin_request_key = verify_totp_result[1]
        identity_type = "pin"
        identifier = getEncodedString(PIN)
        verify_pin_result = verify_pin(
            verify_pin_request_key, identity_type, identifier
        )
        if verify_pin_result[0] != SUCCESS:
            raise FyersAPICallError(
                f"verify_pin_result failure - {verify_pin_result[1]}"
            )

        ses = requests.Session()
        ses.headers.update({"authorization": f"Bearer {verify_pin_result[1]}"})

        # Step 4 - Get auth code for API V2 App from trade access token
        bearer_token = verify_pin_result[1]
        fyers_id = FYERS_ID
        client_app_id = CLIENT_ID[:-4]
        redirect_uri = REDIRECT_URI
        appType = "100"
        token_result = get_auth_code(
            bearer_token, fyers_id, client_app_id, redirect_uri, appType
        )
        if token_result[0] != SUCCESS:
            raise FyersAPICallError(f"token_result failure - {token_result[1]}")

        auth_code = token_result[1]

        session = fyersModel.SessionModel(
            client_id=CLIENT_ID,
            redirect_uri=REDIRECT_URI,
            response_type="code",
            secret_key=APP_SECRET,
            grant_type="authorization_code",
        )
        session.set_token(auth_code)
        response = session.generate_token()
        if "access_token" in response:
            access_token =  response["access_token"]
            if access_token:
                fyers_instance = fyersModel.FyersModel(
                    client_id=CLIENT_ID, token=response["access_token"]
                )
                status = FYERS_LOGIN_SUCCESSFUL
                print(status)
                return fyers_instance,status
            else:
                status= INVALID_ACCESS_TOKEN
                print(status)
                return None,status 
        else:
            status= ACCESS_TOKEN_NOT_GENERATED_CANNOT_PROCEED_WITH_LOGIN
            print(status)
            return None,status 

    except FyersAPICallError as e:
        status =f'Error occurred: {e}' 
        print(status)
        return None,status
