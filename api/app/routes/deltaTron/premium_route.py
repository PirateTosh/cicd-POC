import ast
from decimal import Decimal
from flask import jsonify, request
from datetime import datetime
import pytz
from app.utils.deltaTron_helper_functions import (
    execute_shift_premium,
    format_active_orders,
    is_market_closing,
    process_active_orders,
    settle_account,
)
from app.services.deltaTron.order_service import get_quote
from app import app
from app.database.deltaTron_db import convert_data
from app.shared.queryExecution import execute_query
from app.shared.constants import (
    SELECT,
    UPDATE,
    SELECT_ACTIVE_ORDER_QUERY,
    SELECT_FIRSTSTEP_QUERY,
    SELECT_LASTSTEP_QUERY,
    SELECT_STRATEGY_EXECUTED_QUERY,
    UPDATE_FIRSTSTEP_STATUS_QUERY,
    FOUND_ANOTHER_INSTANCE_OF_SCHEDULER_RUNNING,
    ALL_ACTIVE_ORDERS_HAVE_BEEN_BOUGHT_BACK,
    FETCH_DELTA_TRON_STATUS,
    DELTATRON_KILL_SWITCH_ACTIVATED_MESSAGE,
    UPDATE_DELTATRON_VALUES_TO_INITIAL_STATUS,
    UPDATE_LASTSTEP_STATUS_QUERY
)

strategy_executed = False
firstStep = None
is_strategy_running = None
active_orders = []
fetched_closest_result = {}
prices = {}
purchased_stocks = []
lastStep = False
is_updated = False


@app.route("/deltaTron_strategy", methods=["POST"])
def premium_strategy():
    global strategy_executed
    global is_strategy_running
    global active_orders
    global fetched_closest_result
    global firstStep
    global prices
    global purchased_stocks
    global lastStep
    global is_updated

    active_orders_data = execute_query(
        query_type=SELECT, query=SELECT_ACTIVE_ORDER_QUERY
    )
    active_orders = convert_data(active_orders_data)
    firstStep = execute_query(query_type=SELECT, query=SELECT_FIRSTSTEP_QUERY)
    lastStep = execute_query(query_type=SELECT, query=SELECT_LASTSTEP_QUERY)
    strategy_executed = execute_query(
        query_type=SELECT, query=SELECT_STRATEGY_EXECUTED_QUERY
    )
    timezone = pytz.timezone("Asia/Kolkata")
    now = datetime.now(timezone)

    # restart the process on friday at 10:15 am

    try:
        data = request.get_json()
        entry_prices = ast.literal_eval(data.get("entry_price"))
        user_type = str(data.get("usertype"))
        tron_status = execute_query(
            query_type=SELECT, query=FETCH_DELTA_TRON_STATUS, params=(1)
        )
        deltatron_active_status = tron_status[0]
        if deltatron_active_status == False:
            settle_account(user_type)
            print(ALL_ACTIVE_ORDERS_HAVE_BEEN_BOUGHT_BACK)
            execute_query(
                query_type=UPDATE, query=UPDATE_DELTATRON_VALUES_TO_INITIAL_STATUS, params=(True,[25, 20, 15, 10],False,False,1)
            )
            is_strategy_running = False
            return DELTATRON_KILL_SWITCH_ACTIVATED_MESSAGE
        else:
            if (now.weekday() == 4 and ((now.hour == 10 and now.minute == 15) or (now.hour == 10 and now.minute == 16)) and not is_updated
            ):
                execute_query(
                    query_type=UPDATE, query=UPDATE_FIRSTSTEP_STATUS_QUERY, params=True
                )
                firstStep = execute_query(query_type=SELECT, query=SELECT_FIRSTSTEP_QUERY)
                is_updated = True

            if is_strategy_running is not None and is_strategy_running is True:
                return FOUND_ANOTHER_INSTANCE_OF_SCHEDULER_RUNNING
            is_strategy_running = True
            if is_market_closing(now):
                execute_query(
                    query_type=UPDATE, query=UPDATE_LASTSTEP_STATUS_QUERY, params=False
                )
                settle_account(user_type)
                return ALL_ACTIVE_ORDERS_HAVE_BEEN_BOUGHT_BACK

            if lastStep[0]:
                active_transactions_data = execute_query(
                    query_type=SELECT, query=SELECT_ACTIVE_ORDER_QUERY
                )
                active_transactions = convert_data(active_transactions_data)
                target_prices = ["10.00", "5.00", "2.50"]
                for price in target_prices:
                    matching_orders = [
                        order for order in active_transactions if order['entry_price'] == Decimal(price)
                    ]

                    if matching_orders:
                        ce_quotes, pe_quotes, symbol = get_quote(user_type)
                        for order in matching_orders:
                            stock_name, original_price, entry_price = order['stock_name'], order['price'],order['entry_price']
                            new_price = ce_quotes.get(stock_name) or pe_quotes.get(
                                stock_name
                            )

                            if new_price and float(new_price["ltp"]) <= 0.5 * float(
                                original_price
                            ):
                                shift_price = 0.5 * float(entry_price)
                                if shift_price > 2:
                                    is_strategy_running = False
                                    return execute_shift_premium(
                                        active_transactions, price, shift_price, stock_name, new_price
                                    )
                                else:
                                    is_strategy_running = False
                                    return execute_shift_premium(
                                        active_transactions, price, 1.5, stock_name, new_price
                                    )
                                    

            else:
                process_active_result = process_active_orders(
                    entry_prices, active_orders, user_type, strategy_executed[0], firstStep
                )
                return process_active_result

            return format_active_orders(active_orders, False)

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        is_strategy_running = False
