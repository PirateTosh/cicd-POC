import datetime
import json
from flask import jsonify, request
from app.database.lTron_db import calculate_profit_loss, lTronstoreTransaction
from app.services.lTron.order_service import place_order
from app.services.lTron.dynamic_stock_purchase_service import (
    fetch_ohlc_data,
    get_current_stock_price,
)
from app.shared.queryExecution import execute_query
from app.shared.constants import (
    INSERT,
    INSERT_LTRON_STORE_TRANSACTION_QUERY,
    FOUND_ANOTHER_INSTANCE_OF_SCHEDULER_RUNNING,
    MAX_5_STOCKS_ALLOWED,
    NO_STOCKS_PROVIDED_IN_THE_LIST,
    RULES_EXECUTED_SUCCESSFULLY,
    RULE_2_PENDING_EXECUTION_AT_3_15_PM,
    RULE_1_HAS_BEEN_EXECUTED_WAITING_FOR_RULE_2,
    BOUGHT,
    FETCH_L_TRON_STATUS,
    LTRON_KILL_SWITCH_ACTIVATED_MESSAGE
)
from app import app
from app.shared.queryExecution import execute_query
from app.shared.constants import SELECT, FETCH_USER_ID

is_strategy_running = None
ltron_initial_capital = 500000
capital_allocation_to_start = ltron_initial_capital // 2
amount_to_invest_per_day = capital_allocation_to_start // 222
previous_price = 0.0
rule1_executed_today = False
rule2_executed_today = False


@app.route("/lTron_strategy", methods=["POST"])
def dynamic_Stock_Purchase_Strategy():
    global is_strategy_running
    global ltron_initial_capital
    global capital_allocation_to_start
    global amount_to_invest_per_day
    global previous_price
    global rule1_executed_today
    global rule2_executed_today

    if is_strategy_running:
        return FOUND_ANOTHER_INSTANCE_OF_SCHEDULER_RUNNING

    try:
        is_strategy_running = True
        data = request.get_json()

        stock_list = data.get("stock_list", [])[:5]  # Limit to the first 5 stocks
        userType = str(data.get("usertype"))
        exchange = "NSE"
        user_guid = str(data.get("guid"))

        user_id_data = execute_query(
            query_type=SELECT, query=FETCH_USER_ID, params=(user_guid)
        )
        user_id = user_id_data[0]
        tron_status = execute_query(
            query_type=SELECT, query=FETCH_L_TRON_STATUS, params=(user_id)
        )
        ltron_active_status = tron_status[0]
        if ltron_active_status == False:
            return LTRON_KILL_SWITCH_ACTIVATED_MESSAGE
        else:
            total_stocks = len(stock_list)
            if total_stocks > 5:
                is_strategy_running = False
                return MAX_5_STOCKS_ALLOWED

            if total_stocks == 0:
                is_strategy_running = False
                return NO_STOCKS_PROVIDED_IN_THE_LIST

            results = []  # List to store results for each stock

            # Run Rule 1 for all stocks
            if not rule1_executed_today:
                for stock_name in stock_list:
                    current_price, fyers_index_symbol = get_current_stock_price(
                        exchange, stock_name
                    )
                    amount_to_invest_per_stock = amount_to_invest_per_day / total_stocks
                    shares_to_buy = int(amount_to_invest_per_stock / current_price)
                    place_order(userType, fyers_index_symbol, shares_to_buy, True)
                    execute_query(
                        query_type=INSERT,
                        query=INSERT_LTRON_STORE_TRANSACTION_QUERY,
                        params=(
                            user_id,
                            BOUGHT,
                            fyers_index_symbol,
                            shares_to_buy,
                            current_price,
                        ),
                    )
                    results.append(
                        f"Order placed for {stock_name} @ {current_price} INR\n Quantity: {shares_to_buy}"
                    )

                # Set rule1_executed_today to True after Rule 1 has been executed for all stocks
                rule1_executed_today = True

            # Run Rule 2 at 3:15 PM
            current_time = datetime.datetime.now().time()
            if (
                not rule2_executed_today
                and current_time.hour == 15
                and current_time.minute == 15
            ):
                for stock_name in stock_list:
                    current_price, fyers_index_symbol = get_current_stock_price(
                        exchange, stock_name
                    )
                    previous_price = fetch_ohlc_data(exchange, stock_name)
                    if current_price <= 0.99 * previous_price:
                        amount_to_invest_per_stock = amount_to_invest_per_day / total_stocks
                        shares_to_buy = int(amount_to_invest_per_stock / current_price) * 5
                        place_order(userType, fyers_index_symbol, shares_to_buy, True)
                        execute_query(
                            query_type=INSERT,
                            query=INSERT_LTRON_STORE_TRANSACTION_QUERY,
                            params=(
                                user_id,
                                BOUGHT,
                                fyers_index_symbol,
                                shares_to_buy,
                                current_price,
                            ),
                        )
                        results.append(
                            f"Order placed for {stock_name} @ {current_price} INR\n Quantity: {shares_to_buy}"
                        )
                rule2_executed_today = True

            is_strategy_running = False
            # Check if rules have been successfully executed
            if rule1_executed_today and rule2_executed_today:
                profit_loss = calculate_profit_loss(exchange, user_id)
                print("Profit/Loss at the EOD - {profit_loss}")
                return RULES_EXECUTED_SUCCESSFULLY
            elif not results:
                if rule1_executed_today:
                    profit_loss = calculate_profit_loss(exchange, user_id)
                    print(profit_loss)
                    return RULE_2_PENDING_EXECUTION_AT_3_15_PM
                else:
                    return RULE_1_HAS_BEEN_EXECUTED_WAITING_FOR_RULE_2
            else:
                return results

    except Exception as e:
        is_strategy_running = False
        return jsonify({"error": str(e)}), 500
