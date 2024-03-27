import calendar
from datetime import datetime, timedelta
import logging
from app.utils.rules_evaluation_service import EvaluationService
from app.utils.telegram_service import telegram_send_message
from app.utils.fyers_auth_service import generate_fyers_instance
from app.utils.validation import escape_telegram_reserved_chars
from app.utils.exchange_util import (
    indices_symbols,
    indices_lot_quantity,
    last_week_of_month,
)
from app.shared.constants import (
    NSE_NIFTY50_INDEX,
    MAX_PAIN_NOT_NUMERIC_ERROR,
    NSE_NIFTY,
    NSE,
    NIFTY50,
    INVALID_EXPIRY_TYPE_MESSAGE,
    ORDER_EXIT_SUCCESS_MESSAGE,
    SELL_ORDER_SUCCESS_MESSAGE,
)

# Setup one time data
today = datetime.today()
current_day = today.strftime("%A").upper()
symbol = indices_symbols.get(current_day)
index_symbol = NIFTY50
exchange = NSE


def get_index_symbol_current_ltp():
    fyers_instance, status = generate_fyers_instance()
    fyers_index_symbol = NSE_NIFTY50_INDEX
    try:
        if fyers_instance:
            data = {"symbols": fyers_index_symbol}
            response = fyers_instance.quotes(data=data)
            if response.get("code") == 200:
                lp_value = response["d"][0]["v"]["lp"]
            return lp_value
    except Exception as e:
        return f"Error: {str(e)}"


def find_45_values_less_than_nearest_hundred(nearest_hundred):
    values_less_than_nearest_hundred = [nearest_hundred - 50 * i for i in range(1, 46)]

    return values_less_than_nearest_hundred


def find_44_values_more_than_nearest_hundred(nearest_hundred):
    values_more_than_nearest_hundred = [nearest_hundred + 50 * i for i in range(1, 45)]

    return values_more_than_nearest_hundred


def find_nearest_value(max_pain):
    return round(max_pain / 50) * 50


def get_list_of_nearest_50_symbol():
    max_pain = get_index_symbol_current_ltp()

    # Check if max_pain is numeric before further calculations
    if isinstance(max_pain, (int, float)):
        nearest_lp_round_value = find_nearest_value(max_pain)
        less_than_values = find_45_values_less_than_nearest_hundred(
            nearest_lp_round_value
        )
        more_than_values = find_44_values_more_than_nearest_hundred(
            nearest_lp_round_value
        )
        strike_price_values = (
            less_than_values + [nearest_lp_round_value] + more_than_values
        )
        strike_price_values_sorted = sorted(strike_price_values)
        return strike_price_values_sorted
    else:
        return MAX_PAIN_NOT_NUMERIC_ERROR


def convert_symbol_in_expected_form(is_last_week_of_month, strikePrice, optionType):
    formatted_symbol = NSE_NIFTY

    calculated_year, calculated_month, day = next_thursday()

    year = calculated_year % 100
    month = calendar.month_abbr[calculated_month][:3].upper()
    day = day

    weekly_expiray_month_dict = {
        "JAN": "1",
        "FEB": "2",
        "MAR": "3",
        "APR": "4",
        "MAY": "5",
        "JUN": "6",
        "JUL": "7",
        "AUG": "8",
        "SEP": "9",
        "OCT": "O",
        "NOV": "N",
        "DEC": "D",
    }

    # Format the symbol based on the expiry type (weekly or monthly)
    if is_last_week_of_month == False:
        month_abbr = weekly_expiray_month_dict[month]
        formatted_symbol += f"{year:02d}{month_abbr}{day:02d}{strikePrice}{optionType}"
    elif is_last_week_of_month == True:
        formatted_symbol += f"{year:02d}{month}{strikePrice}{optionType}"
    else:
        raise ValueError(INVALID_EXPIRY_TYPE_MESSAGE)

    return formatted_symbol


def next_thursday():
    today = datetime.now()
    days_ahead = (
        3 - today.weekday() + 7
    ) % 7  # Calculate days until next Thursday (Thursday has index 3)
    next_thursday_date = today + timedelta(days=days_ahead)
    year = next_thursday_date.year
    month = next_thursday_date.month
    day = next_thursday_date.day

    return year, month, day
    # return next_thursday_date.strftime('%Y-%m-%d')


def fyers_option_chain(option_type):
    formatted_symbols = []  # Initialize an empty list to store formatted symbols
    strikes = get_list_of_nearest_50_symbol()
    year, month, day = next_thursday()
    is_last_week_of_month = last_week_of_month(year, month, day)
    # Print the formatted strikes
    for index, formatted_strike in enumerate(strikes, start=1):
        formatted_symbol = convert_symbol_in_expected_form(
            is_last_week_of_month, formatted_strike, option_type
        )
        formatted_symbols.append(formatted_symbol)
    return formatted_symbols


def extract_shortname_lp_values(data):
    fyers_instance, status = generate_fyers_instance()
    if fyers_instance:
        response = fyers_instance.quotes(data=data)
        if response.get("code") == 200:
            result = response.get("d", [])
            # Extracting 'short_name' and 'lp' values and creating a new dictionary
            new_dict = {}
            for item in result:
                short_name = item.get("v", {}).get("short_name")
                lp = item.get("v", {}).get("lp")
                if short_name and lp is not None:
                    new_dict[short_name] = {"ltp": lp}
            return new_dict
        else:
            error_message = response.get("message")
            return (
                {"error": error_message}
                if error_message
                else {"error": "An unexpected error occurred."}
            )
    else:
        return {"error": "Fyers instance is not properly initialized."}


def process_symbols(formatted_symbols_list):
    chunk_size = 50
    num_chunks = len(formatted_symbols_list) + chunk_size - 1

    results = []
    for i in range(num_chunks):
        start_idx = i * chunk_size
        end_idx = min((i + 1) * chunk_size, len(formatted_symbols_list))
        chunk = formatted_symbols_list[start_idx:end_idx]

        if len(chunk) > 0:
            final_output = ",".join(chunk)
            data = {"symbols": final_output}

            result = extract_shortname_lp_values(data)
            results.append(result)
        else:
            break

    single_list = {}
    for result in results:
        for short_name, lp in result.items():
            single_list[short_name] = lp

    return single_list


def fyers_get_strike_price_ltp(option_type):
    if option_type == "CE":
        ce_formatted_symbols_list = fyers_option_chain(option_type)
        return process_symbols(ce_formatted_symbols_list)
    elif option_type == "PE":
        pe_formatted_symbols_list = fyers_option_chain(option_type)
        return process_symbols(pe_formatted_symbols_list)


def get_fyers_quote():
    ce_option_chain = fyers_get_strike_price_ltp("CE")
    pe_option_chain = fyers_get_strike_price_ltp("PE")

    return ce_option_chain, pe_option_chain, symbol


def send_telegram_message(message):
    escaped_message = escape_telegram_reserved_chars(message)
    telegram_send_message(EvaluationService.chat_ids, escaped_message)


def place_fyers_order(list_of_fetched_symbol, isExit):
    try:
        if isExit is True:
            if buy_option(list_of_fetched_symbol) == True:
                print(ORDER_EXIT_SUCCESS_MESSAGE)
                return True
        else:
            if sell_option(list_of_fetched_symbol) == True:
                print(SELL_ORDER_SUCCESS_MESSAGE)
                return True
    except Exception as e:
        logging.info("Exception placing order: {e}")
        return False


def order(fyers_instance, symbol, quantity):
    order_data = {
        "symbol": symbol,
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
    # response = fyers_instance.place_order(data=order_data)
    # print(response)
    return order_data


def buy_option(data):
    try:
        fyers_instance, status = generate_fyers_instance()

        if "lot_count" in data:
            stock_name = data["stock_name"]
            quantity = data["lot_count"]
            formatted_symbol = f"{exchange}:{stock_name}"
            order_data = order(
                fyers_instance,
                formatted_symbol,
                indices_lot_quantity.get("nifty") * quantity,
            )
            order_id = "Buy"
            send_telegram_message(
                f"Position exited for {stock_name}. ID is: {order_id}"
            )

        elif "lot_count" in data[0]:
            stock_name = data[0]["stock_name"]
            quantity = data[0]["lot_count"]
            formatted_symbol = f"{exchange}:{stock_name}"
            order_data = order(
                fyers_instance,
                formatted_symbol,
                indices_lot_quantity.get("nifty") * quantity,
            )
            order_id = "Buy"
            send_telegram_message(
                f"Position exited for {stock_name}. ID is: {order_id}"
            )

        else:
            ce_info = data[0]["CE"]
            pe_info = data[0]["PE"]
            quantity = data[0]["count"]

            for option_info in [ce_info, pe_info]:
                if option_info:
                    symbol = f"{exchange}:{option_info[0]}"
                    quantity = indices_lot_quantity.get("nifty") * quantity
                    order_data = order(fyers_instance, symbol, quantity)
                    send_telegram_message(
                        f"Buy Order placed for {option_info[0]}. ID is: {'Buy CE Order ID' if option_info is ce_info else 'Buy PE Order ID'}"
                    )

    except Exception as e:
        if ce_info:
            send_telegram_message(f"Buy Order placement failed for {ce_info[0]}.")
            logging.info(f"Buy Order placement failed for {ce_info[0]}: {str(e)}")
        if pe_info:
            send_telegram_message(f"Buy Order placement failed for {pe_info[0]}.")
            logging.info(f"Buy Order placement failed for {pe_info[0]}: {str(e)}")


def sell_option(trading_symbols_quantities):
    fyers_instance, status = generate_fyers_instance()
    for index, trade_info in enumerate(trading_symbols_quantities):
        symbol = trade_info['stock_name']
        quantity = trade_info['lot_count']

        new_quantity = indices_lot_quantity.get("nifty") * quantity

        formatted_symbol = f"{exchange}:{symbol}" if symbol else None

        try:
            data = {
                "symbol": formatted_symbol,
                "qty": new_quantity,
                "type": 2,
                "side": -1,
                "productType": "INTRADAY",
                "limitPrice": 0,
                "stopPrice": 0,
                "validity": "DAY",
                "disclosedQty": 0,
                "offlineOrder": False,
                "orderTag": "tag1",
            }
            send_telegram_message(
                "Sell Order placed for "
                + symbol
                + ". ID is: {}".format("Sell CE Order ID")
            )

        except Exception as e:
            if symbol:
                send_telegram_message(
                    "Sell Order placement failed for " + symbol + "."
                )
                logging.info(
                    "Sell Order placement failed for "
                    + symbol
                    + ": {}".format(e.message)
                )
