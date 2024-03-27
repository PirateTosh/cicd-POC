import datetime
import logging

import pandas as pd
from app.utils.fyers_auth_service import generate_fyers_instance
from app.services.omegaTron.fyers_service import send_telegram_message


def get_current_stock_price(exchange, stock_name):
    fyers_instance, status = generate_fyers_instance()
    fyers_index_symbol = f"{exchange}:{stock_name}-EQ"

    try:
        if fyers_instance:
            data = {"symbols": fyers_index_symbol}
            response = fyers_instance.quotes(data=data)
            if response.get("code") == 200:
                lp_value = response["d"][0]["v"]["lp"]
                return lp_value, fyers_index_symbol
            else:
                error_message = response.get("message")
                if error_message:
                    return {"error": error_message}
                else:
                    return {"error": "An unexpected error occurred."}
        else:
            return {"error": "Fyers instance is not properly initialized."}
    except Exception as e:
        logging.error(f"Error in get_index_symbol_current_ltp: {str(e)}")
        return {"error": str(e)}


def place_fyers_order(trade_symbol, no_of_shares, shouldBuyShares):
    try:
        if shouldBuyShares is True:
            if buy_option(trade_symbol, no_of_shares) == True:
                print("Buy Order Success!")
                return True
        # else:
        #     if sell_option(trade_symbol, 1) == True:
        #         print("Sell Order Success!")
        #         return True
    except Exception as e:
        logging.info("Exception placing order: {e}")
        return False


def buy_option(trading_symbol, quantity):
    fyers_instance, status = generate_fyers_instance()
    # Place an order
    try:
        data = {
            "symbol": trading_symbol,
            "qty": quantity,
            "type": 2,
            "side": 1,
            "productType": "INTRADAY",
            "limitPrice": 0,
            "stopPrice": 0,
            "validity": "DAY",
            "disclosedQty": 0,
            "offlineOrder": False,
            "orderTag": "tag1",
        }
        # response = fyers_instance.place_order(data=data)
        # print(response)
        order_id = "Buy"
        cleaned_symbol = trading_symbol.replace("NSE:", "").replace("-EQ", "")
        send_telegram_message(
            "Buy Order placed for "
            + cleaned_symbol
            + "\nQuantity : "
            + str(quantity)
            + "\nOrder ID is: {}".format(order_id)
        )
        return True
    except Exception as e:
        send_telegram_message("Position exit failed for " + trading_symbol + ".")
        logging.info(
            "Position exit failed for " + trading_symbol + ": {}".format(e.message)
        )
        return False


def fetch_ohlc_data(exchange, stock_name):

    fyers_instance, status = generate_fyers_instance()
    fyers_index_symbol = f"{exchange}:{stock_name}-EQ"
    yesterday = datetime.datetime.now() - datetime.timedelta(days=1)
    range_from = range_to = yesterday.strftime("%Y-%m-%d")

    try:
        data = {
            "symbol": fyers_index_symbol,
            "resolution": "D",
            "date_format": "1",
            "range_from": range_from,
            "range_to": range_to,
            "cont_flag": "1",
        }
        dx = fyers_instance.history(data=data)
        dx = pd.DataFrame(dx["candles"])
        dx.columns = ["date", "open", "high", "low", "close", "volume"]
        dx["date"] = pd.to_datetime(dx["date"], unit="s")
        dx["date"] = (
            dx["date"]
            .dt.tz_localize("UTC")
            .dt.tz_convert("Asia/Kolkata")
            .dt.tz_localize(None)
        )
        close_price = dx["close"].iloc[-1]
        return close_price
    except Exception as e:
        print(e)
