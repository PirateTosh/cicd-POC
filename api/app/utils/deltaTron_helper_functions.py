import ast
from app.database.userInfo import (
    getPrices,
)

from app.shared.queryExecution import execute_query
from app.services.deltaTron.order_service import get_quote, place_order
from app.services.deltaTron.premium_service import (
    exit_options,
    fetch_closest_ltp,
    find_current_ltp,
)

from app.database.deltaTron_db import (
    convert_data,
    get_active_transactions,
    getAciveOrders,
)


from app.shared.constants import (
    SELECT,
    UPDATE,
    INSERT,
    UPDATE_SHIFT_PREMIUM_QUERY,
    INSERT_DELTATRON_STORE_TRANSACTION_QUERY,
    UPDATE_STRATEGY_EXECUTED_QUERY,
    UPDATE_LASTSTEP_STATUS_QUERY,
    SELECT_ACTIVE_ORDER_QUERY,
    UPDATE_PRICES_QUERY,
    UPDATE_FIRSTSTEP_STATUS_QUERY,
    SELECT_FIRSTSTEP_QUERY,
    SOLD,
    BOUGHT,
)


def check_strategy_running(fetched_closest_result):
    for pair in fetched_closest_result:
        ce_last_price = pair["CE"][1]
        pe_last_price = pair["PE"][1]

        if ce_last_price / pe_last_price >= 2 or pe_last_price / ce_last_price >= 2:
            return False

    return True


def append_stock_names_to_active_orders(data):
    active_orders = []

    for pair in data:
        ce_stock_name = pair["CE"][0].split("CE")[0]
        pe_stock_name = pair["PE"][0].split("PE")[0]

        active_orders.append(ce_stock_name)
        active_orders.append(pe_stock_name)

    return active_orders


def get_entry_prices(data):
    entry_prices = ast.literal_eval(data.get("entry_price"))
    user_type = str(data.get("usertype"))
    return entry_prices, user_type


def is_market_closing(now):
    return now.weekday() == 3 and (
        now.hour > 23 or (now.hour == 15 and now.minute >= 20)
    )


def execute_shift_premium(
    active_transactions, price, shift_price, stock_name, new_price
):
    for order in active_transactions:
        if order['stock_name'] == stock_name:
            execute_query(
                query_type=UPDATE,
                query=UPDATE_SHIFT_PREMIUM_QUERY,
                params=(shift_price, float(new_price["ltp"]), 1, stock_name),
            )
            return f"Execution Completed. {price} premium shifted to {shift_price}\n"


def process_active_orders(
    entry_prices, active_orders, user_type, strategy_executed, firstStep
):
    ce_quotes, pe_quotes, symbol = get_quote(user_type)
    prices = entry_prices if firstStep[0] else getPrices()[0]
    fetched_closest_result = active_orders

    if not strategy_executed:
        fetched_closest_result = fetch_closest_ltp(ce_quotes, pe_quotes, prices)
        place_order(user_type, fetched_closest_result, False)
        for item in fetched_closest_result:
            execute_query(
                query_type=INSERT,
                query=INSERT_DELTATRON_STORE_TRANSACTION_QUERY,
                params=(
                    1,
                    SOLD,
                    item["stock_name"],
                    item["lot_count"],
                    item["price"],
                    item["entry_price"],
                ),
            )
        fetched_closest_result_buy = fetch_closest_ltp(ce_quotes, pe_quotes, [4])
        place_order(user_type, fetched_closest_result_buy, True)
        for item in fetched_closest_result_buy:
            execute_query(
                query_type=INSERT,
                query=INSERT_DELTATRON_STORE_TRANSACTION_QUERY,
                params=(
                    1,
                    BOUGHT,
                    item["stock_name"],
                    item["lot_count"],
                    item["price"],
                    item["entry_price"],
                ),
            )
        fetched_closest_result.extend(fetched_closest_result_buy)
        execute_query(
            query_type=UPDATE, query=UPDATE_STRATEGY_EXECUTED_QUERY, params=True
        )
        strategy_executed = True
        if prices[-1] < 2:
            execute_query(
                query_type=UPDATE, query=UPDATE_LASTSTEP_STATUS_QUERY, params=True
            )
        return format_active_orders(fetched_closest_result, False)
    
    enteries = filter_highest_entry_price(fetched_closest_result)
    current_ltp = find_current_ltp(ce_quotes, pe_quotes, enteries)
    value = exit_options(enteries, current_ltp, user_type)

    if len(value) == len(enteries):
        for item in value:
            execute_query(
                query_type=INSERT,
                query=INSERT_DELTATRON_STORE_TRANSACTION_QUERY,
                params=(
                    1,
                    BOUGHT,
                    item["stock_name"],
                    item["lot_count"],
                    item["price"],
                    item["entry_price"],
                ),
            )
        active_orders_data = execute_query(
            query_type=SELECT, query=SELECT_ACTIVE_ORDER_QUERY
        )
        active_orders = convert_data(active_orders_data)
        if value[0]["entry_price"] in prices:
            prices.remove(value[0]["entry_price"])
            if prices:
                new_price = max(prices[-1] / 2, 1.5)
                prices.append(new_price)
                execute_query(
                    query_type=UPDATE, query=UPDATE_PRICES_QUERY, params=prices
                )
            execute_query(
                query_type=UPDATE, query=UPDATE_STRATEGY_EXECUTED_QUERY, params=False
            )
            strategy_executed = False
            execute_query(
                query_type=UPDATE, query=UPDATE_FIRSTSTEP_STATUS_QUERY, params=False
            )
            firstStep = execute_query(query_type=SELECT, query=SELECT_FIRSTSTEP_QUERY)
            return format_active_orders(value, True)
    elif len(value) > 0:
        for item in value:
            execute_query(
                query_type=INSERT,
                query=INSERT_DELTATRON_STORE_TRANSACTION_QUERY,
                params=(
                    1,
                    BOUGHT,
                    item["stock_name"],
                    item["lot_count"],
                    item["price"],
                    item["entry_price"],
                ),
            )

    return format_active_orders(active_orders, True)


def format_active_orders(fetched_closest_result, isExit=False):
    orders_info = ""

    for pair in fetched_closest_result:
        stock_name = pair["stock_name"]
        lots = pair["lot_count"]
        price = pair["price"]
        entry_price = pair["entry_price"]
        orders_info += f"{stock_name}, Lots: {lots}, Exit Price: {price}, Entry Price: {entry_price}\n"
    if isExit:
        return f"Exit Orders:\n{orders_info}"
    else:
        return f"Active Orders:\n{orders_info}"
        


def get_stock_count(stock_name, active_orders):
    for order in active_orders:
        if order["CE"][0] == stock_name:
            return order["count"]
    return 1


def settle_account(user_type):
    try:
        active_transactions_data = get_active_transactions(1)
        sold_transactions = []
        bought_transactions = []
        ce_quotes, pe_quotes, symbol = get_quote(user_type)
        for transaction in active_transactions_data:
            if transaction[-1] == "sold":
                sold_transactions.append(transaction)
            elif transaction[-1] == "bought":
                bought_transactions.append(transaction)

        active_sold_transactions = convert_data(sold_transactions)
        active_bought_transactions = convert_data(bought_transactions)
        if active_sold_transactions is None and active_bought_transactions is None:
            print("No active transactions.")
            return None
        else:
            for transaction in active_sold_transactions:
                try:
                    current_ltp = find_current_ltp(ce_quotes, pe_quotes, transaction)
                    ce_stocks, pe_stocks, entry_price = (
                        current_ltp[0]["CE"],
                        current_ltp[0]["PE"],
                        current_ltp[0]["Entry_Price"]
                    )
                    ce_list = [
                        {"stock_name": ce[0], "price": ce[1], "lot_count": ce[2]}
                        for ce in ce_stocks
                    ]
                    pe_list = [
                        {"stock_name": pe[0], "price": pe[1], "lot_count": pe[2]}
                        for pe in pe_stocks
                    ]
                    if len(ce_list) > 0:
                        place_order(user_type, ce_list, True)
                        execute_query(
                            query_type=INSERT,
                            query=INSERT_DELTATRON_STORE_TRANSACTION_QUERY,
                            params=(
                                1,
                                BOUGHT,
                                ce_list[0]["stock_name"],
                                ce_list[0]["lot_count"],
                                ce_list[0]["price"],
                                entry_price,
                            ),
                        )
                    if len(pe_list) > 0:
                        place_order(user_type, pe_list, True)
                        execute_query(
                            query_type=INSERT,
                            query=INSERT_DELTATRON_STORE_TRANSACTION_QUERY,
                            params=(
                                1,
                                BOUGHT,
                                pe_list[0]["stock_name"],
                                pe_list[0]["lot_count"],
                                pe_list[0]["price"],
                                entry_price,
                            ),
                        )
                except Exception as e:
                    print(f"Error occurred: {e}")

            for transaction in active_bought_transactions:
                try:
                    data = convert_data_format(transaction)
                    current_ltp = find_current_ltp(ce_quotes, pe_quotes, transaction)
                    ce_stocks, pe_stocks, entry_price = (
                        current_ltp[0]["CE"],
                        current_ltp[0]["PE"],
                        current_ltp[0]["Entry_Price"]
                    )
                    ce_list = [
                        {"stock_name": ce[0], "price": ce[1], "lot_count": ce[2]}
                        for ce in ce_stocks
                    ]
                    pe_list = [
                        {"stock_name": pe[0], "price": pe[1], "lot_count": pe[2]}
                        for pe in pe_stocks
                    ]
                    if len(ce_list) > 0:
                        place_order(user_type, ce_list, False)
                        execute_query(
                            query_type=INSERT,
                            query=INSERT_DELTATRON_STORE_TRANSACTION_QUERY,
                            params=(
                                1,
                                SOLD,
                                ce_list[0]["stock_name"],
                                ce_list[0]["lot_count"],
                                ce_list[0]["price"],
                                entry_price,
                            ),
                        )
                    if len(pe_list) > 0:
                        place_order(user_type, pe_list, False)
                        execute_query(
                            query_type=INSERT,
                            query=INSERT_DELTATRON_STORE_TRANSACTION_QUERY,
                            params=(
                                1,
                                SOLD,
                                pe_list[0]["stock_name"],
                                pe_list[0]["lot_count"],
                                pe_list[0]["price"],
                                entry_price,
                            ),
                        )

                except Exception as e:
                    print(f"Error occurred: {e}")

    except Exception as e:
        print(f"An error occurred: {e}")


def convert_data_format(data):
    output_data = {"Entry_Price": 4, "CE": None, "PE": None, "count": 10}

    ce_data = data.get("CE", [])
    pe_data = data.get("PE", [])

    ce_symbol, ce_entry_price, ce_quantity = ce_data[0] if ce_data else (None, None, 0)
    pe_symbol, pe_entry_price, pe_quantity = pe_data[0] if pe_data else (None, None, 0)

    output_data["CE"] = (ce_symbol, ce_entry_price) if ce_symbol else None
    output_data["PE"] = (pe_symbol, pe_entry_price) if pe_symbol else None

    output_data["count"] = ce_quantity
    output_list = []
    output_list.append(output_data)

    return output_list


def check_fund_margin(allocated_capital, active_transactions):

    pass

def filter_highest_entry_price(data):
    highest_entry_price = max(entry['entry_price'] for entry in data)
    highest_entry_price_entries = [entry for entry in data if entry['entry_price'] == highest_entry_price]
    return highest_entry_price_entries
