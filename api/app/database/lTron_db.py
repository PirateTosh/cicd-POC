import psycopg2
from app.config import DATABASE_URL
from psycopg2 import sql

from app.services.lTron.dynamic_stock_purchase_service import get_current_stock_price
from app.shared.queryExecution import execute_query
from app.shared.constants import (
    SELECT,
    SELECT_DISTINCT_STOCK_SYMBOL_QUERY,
    SELECT_STOCK_SYMBOL_QUERY,
)


def lTronstoreTransaction(user_id, transaction_type, stock_symbol, quantity, price):
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(DATABASE_URL)

        # Create a cursor object to execute SQL queries
        cursor = conn.cursor()

        query = sql.SQL(
            """
        INSERT INTO lTron_transactions (user_id, transaction_type, stock_symbol, quantity, price)
        VALUES (%s, %s, %s, %s, %s);
        """
        )

        # Execute the query with the provided parameters
        cursor.execute(
            query, (user_id, transaction_type, stock_symbol, quantity, price)
        )

        # Commit the transaction to persist the changes
        conn.commit()

    except psycopg2.Error as e:
        print(f"Error connecting to PostgreSQL: {e}")
    finally:
        # Close the cursor and connection
        if cursor:
            cursor.close()
        if conn:
            conn.close()


def calculate_profit_loss(exchange, user_id):

    distinct_symbols = execute_query(
        query_type=SELECT, query=SELECT_DISTINCT_STOCK_SYMBOL_QUERY, params=(user_id)
    )

    # Dictionary to store current prices of stocks
    current_prices = {}

    # Fetch current prices for each distinct stock symbol
    for symbol_tuple in distinct_symbols:
        stock_symbol = symbol_tuple[0]
        stock_name = stock_symbol.replace("NSE:", "").replace("-EQ", "")
        current_price, _ = get_current_stock_price(exchange, stock_name)
        current_prices[stock_symbol] = current_price

    bought_transactions = execute_query(
        query_type=SELECT, query=SELECT_STOCK_SYMBOL_QUERY, params=(user_id)
    )

    # Calculate profit/loss for each transaction
    total_profit_loss = 0
    for stock_symbol, quantity, bought_price in bought_transactions:
        current_price = current_prices.get(stock_symbol, 0)
        try:
            # Convert Decimal to float
            current_price = float(current_price)
            bought_price = float(bought_price)
            quantity = float(quantity)

            # Calculate profit/loss
            profit_loss = (current_price - bought_price) * quantity
            total_profit_loss += profit_loss
        except TypeError as e:
            print(f"Error calculating profit/loss: {e}")
            # Handle the error or log the exception

    return f"{total_profit_loss:.2f}"
