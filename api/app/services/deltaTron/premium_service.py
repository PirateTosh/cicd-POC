from decimal import Decimal
from app.services.deltaTron.fyers_service import buy_option
from app.services.deltaTron.order_service import place_order


def find_closest_stock(
    option_data, price_lower_bound, price_upper_bound, entry_price, assigned_stocks
):
    closest_stock = None
    closest_last_price = None
    min_difference = float("inf")
    found_valid_stock = False

    while not found_valid_stock:
        for stock, data in option_data.items():
            if stock in assigned_stocks and assigned_stocks[stock] != entry_price:
                continue  # Skip if stock is already assigned to a different entry price

            try:
                last_price = float(data["ltp"])
                if price_lower_bound <= last_price <= price_upper_bound:
                    price_difference = abs(Decimal(entry_price) - Decimal(last_price))
                    if price_difference < min_difference or (
                        price_difference == min_difference
                        and last_price > closest_last_price
                    ):
                        min_difference = price_difference
                        closest_last_price = last_price
                        closest_stock = stock
                        found_valid_stock = True
            except ValueError:
                print(f"Invalid last price for {stock}, not a valid number")

        if not found_valid_stock:
            # Increase the price bounds if no valid stock found within the range
            price_lower_bound /= Decimal(1.1)  # Increasing lower bound by 10%
            # price_upper_bound *= 1.1  # Increasing upper bound by 10%

    return closest_stock, closest_last_price, assigned_stocks


def process_entry_price(
    ce_option_data, pe_option_data, entry_price, ce_assigned_stocks, pe_assigned_stocks
):
    lower_bound = entry_price - 4
    upper_bound = entry_price

    closest_ce_stock, closest_ce_last_price, ce_assigned_stocks = find_closest_stock(
        ce_option_data, lower_bound, upper_bound, entry_price, ce_assigned_stocks
    )

    closest_pe_stock, closest_pe_last_price, pe_assigned_stocks = find_closest_stock(
        pe_option_data, lower_bound, upper_bound, entry_price, pe_assigned_stocks
    )
    return (
        closest_ce_stock,
        closest_ce_last_price,
        closest_pe_stock,
        closest_pe_last_price,
        ce_assigned_stocks,
        pe_assigned_stocks,
    )


def fetch_closest_ltp(ce_option_data, pe_option_data, entry_prices):
    results = []
    ce_assigned_stocks = {}
    pe_assigned_stocks = {}

    # Define the ratio of purchase quantities
    if len(entry_prices) != 1:
        purchase_ratios = [1, 2, 3, 4]
    else:
        purchase_ratios = [10]

    for i, entry_price in enumerate(entry_prices):
        (
            stock,
            price,
            pe_stock,
            pe_price,
            ce_assigned_stocks,
            pe_assigned_stocks,
        ) = process_entry_price(
            ce_option_data,
            pe_option_data,
            entry_price,
            ce_assigned_stocks,
            pe_assigned_stocks,
        )
        ce_assigned_stocks[stock] = entry_price
        pe_assigned_stocks[pe_stock] = entry_price

        # Get the purchase ratio
        purchase_ratio = purchase_ratios[i]

        results.append(
            {
                "stock_name": stock,
                "lot_count": purchase_ratio,
                "price": float(price),
                "entry_price": float(entry_price)
            }
        )
        results.append(
            {
                "stock_name": pe_stock,
                "lot_count": purchase_ratio,
                "price": float(pe_price),
                "entry_price": float(entry_price)
            }
        )

    return results


def find_current_ltp(ce_quotes, pe_quotes, stock_info):
    result_list = []

    try:
        # for stock_info in stock_list:
        prices = []
        pe_prices = []

        for stocks in stock_info:
            option_type = "CE" if stocks['stock_name'][-2:] == "CE" else "PE"
            if option_type == 'CE':
                price = ce_quotes.get(stocks['stock_name'], {}).get("ltp")
            elif option_type == 'PE':
                price = pe_quotes.get(stocks['stock_name'], {}).get("ltp")
            if price is not None:
                prices.append({
                "stock_name": stocks['stock_name'],
                "lot_count": stocks['lot_count'],
                "price": float(price),
                "entry_price": float(stocks['entry_price'])
            })

    except Exception as e:
        # Handle exceptions
        print(f"Error occurred: {e}")
        # You might want to log the error or handle it in a different way based on your requirements

    return prices


def exit_options(option_data_list, current_price, user_type):
    exit_stocks = []
    try:
        ce_stocks = []
        pe_stocks = []
        current_ce_stock = []
        current_pe_stock = []
        for entry in option_data_list:
            if entry['stock_name'][-2:] == 'CE':
                ce_stocks.append(entry)
            elif entry['stock_name'][-2:] == 'PE':
                pe_stocks.append(entry)
        for entry in current_price:
            if entry['stock_name'][-2:] == 'CE':
                current_ce_stock.append(entry)
            elif entry['stock_name'][-2:] == 'PE':
                current_pe_stock.append(entry)
        ce_list = [
            {"stock_name": ce['stock_name'], "price": ce['price'], "lot_count": ce['lot_count'],"entry_price": ce['entry_price']}
            for ce in ce_stocks
        ]
        pe_list = [
            {"stock_name": pe['stock_name'], "price": pe['price'], "lot_count": pe['lot_count'],"entry_price": pe['entry_price']}
            for pe in pe_stocks
        ]
        current_ce_list = [
            {"stock_name": ce['stock_name'], "price": ce['price'], "lot_count": ce['lot_count']}
            for ce in current_ce_stock
        ]
        current_pe_list = [
            {"stock_name": pe['stock_name'], "price": pe['price'], "lot_count": pe['lot_count']}
            for pe in current_pe_stock
        ]
        # Check if the current price is 50% or less than the initial price for CE stocks
        for ce_stock in ce_list:
            for value in current_ce_list:
                if ce_stock["stock_name"] == value["stock_name"]:
                    if value["price"] <= 0.5 * ce_stock["price"]:
                        place_order(user_type, ce_stock, True)
                        exit_stocks.append(
                            {
                                "stock_name": ce_stock["stock_name"],
                                "lot_count": ce_stock["lot_count"],
                                "price": value["price"],
                                "entry_price": ce_stock["entry_price"],
                            }
                        )
                        break

        # Check if the current price is 50% or less than the initial price for PE stocks
        for pe_stock in pe_list:
            for value in current_pe_list:
                if pe_stock["stock_name"] == value["stock_name"]:
                    if value["price"] <= 0.5 * pe_stock["price"]:
                        place_order(user_type, pe_stock, True)
                        exit_stocks.append(
                            {
                                "stock_name": pe_stock["stock_name"],
                                "lot_count": pe_stock["lot_count"],
                                "price": value["price"],
                                "entry_price": pe_stock["entry_price"],
                            }
                        )
                        break

    except Exception as e:
        # Handle exceptions
        print(f"Error occurred: {e}")
    return exit_stocks
