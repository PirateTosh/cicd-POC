import psycopg2
from app.config import DATABASE_URL
from psycopg2 import sql
from decimal import Decimal
from collections import defaultdict

def DeltaTronstoreTransaction(user_id, transaction_type, Stock_detail, isExit):
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(DATABASE_URL)

        # Create a cursor object to execute SQL queries
        cursor = conn.cursor()

        query = sql.SQL(
            """
        INSERT INTO deltaTron_transactions (user_id, transaction_type, stock_symbol, quantity, price, entry_price)
        VALUES (%s, %s, %s, %s, %s, %s);
        """
        )

        try:
            if isExit :
                for item in Stock_detail:
                    # Insert Call Option (CE)
                    cursor.execute(
                        query,
                        (
                            user_id,
                            transaction_type,
                            item["stockName"],
                            item["lots"],
                            item["price"],
                            item["entry_price"],
                        ),
                    )
                # Commit the transactions if all inserts are successful
                conn.commit()
            else:
               for item in Stock_detail:
                # Insert Call Option (CE)
                cursor.execute(
                    query,
                    (
                        user_id,
                        transaction_type,
                        item["CE"][0],
                        item["count"],
                        item["CE"][1],
                        item["Entry_Price"],
                    ),
                )

                # Insert Put Option (PE)
                cursor.execute(
                    query,
                    (
                        user_id,
                        transaction_type,
                        item["PE"][0],
                        item["count"],
                        item["PE"][1],
                        item["Entry_Price"],
                    ),
                )

            # Commit the transactions if all inserts are successful
            conn.commit()
        except Exception as e:
            print(f"An error occurred: {e}")
            conn.rollback()  # Rollback in case of error
        finally:
            cursor.close()

    except psycopg2.Error as e:
        print(f"Error connecting to PostgreSQL: {e}")
    finally:
        # Close the cursor and connection
        if cursor:
            cursor.close()
        if conn:
            conn.close()


def getAciveOrders():
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(DATABASE_URL)

        # Create a cursor object to execute SQL queries
        cursor = conn.cursor()

        query = sql.SQL(
            """
                SELECT dt1.stock_symbol, 
                dt1.user_id, 
                dt1.entry_price, 
                SUM(dt1.quantity) AS total_quantity,
                dt1.price,
                dt1.transaction_type
                FROM deltaTron_transactions dt1
                WHERE dt1.transaction_type = 'sold'
                AND NOT EXISTS (
                    SELECT 1
                    FROM deltaTron_transactions dt2
                    WHERE dt1.stock_symbol = dt2.stock_symbol
                    AND dt1.user_id = dt2.user_id
                    AND dt1.entry_price = dt2.entry_price
                    AND dt2.transaction_type = 'bought'
                )
                GROUP BY dt1.stock_symbol, dt1.user_id, dt1.entry_price, dt1.price, dt1.transaction_type;
        """
        )
        cursor.execute(query)
        result = cursor.fetchall()
        orders = convert_data(result)
    except psycopg2.Error as e:
        print(f"Error connecting to PostgreSQL: {e}")
        return None
    finally:
        # Close the cursor and connection
        if cursor:
            cursor.close()
        if conn:
            conn.close()
    return orders


def get_active_transactions(user_id):
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(DATABASE_URL)

        # Create a cursor object to execute SQL queries
        cursor = conn.cursor()

        query = sql.SQL(
            """
            SELECT dt1.stock_symbol, 
                dt1.user_id, 
                dt1.entry_price, 
                SUM(dt1.quantity) AS total_quantity,
                dt1.price,
                dt1.transaction_type
            FROM deltaTron_transactions dt1
            WHERE (dt1.transaction_type = 'sold' AND dt1.user_id = %s AND NOT EXISTS (
                SELECT 1
                FROM deltaTron_transactions dt2
                WHERE dt1.stock_symbol = dt2.stock_symbol
                AND dt1.user_id = dt2.user_id
                AND dt1.entry_price = dt2.entry_price
                AND dt2.transaction_type = 'bought'
            )) OR (dt1.transaction_type = 'bought' AND dt1.user_id = %s AND NOT EXISTS (
                SELECT 1
                FROM deltatron_transactions dt2
                WHERE dt1.stock_symbol = dt2.stock_symbol
                AND dt1.user_id = dt2.user_id
                AND dt1.entry_price = dt2.entry_price
                AND dt2.transaction_type = 'sold'
            ))
            GROUP BY dt1.stock_symbol, dt1.user_id, dt1.entry_price, dt1.price, dt1.transaction_type;
            """
        )
        cursor.execute(query, (user_id, user_id))
        result = cursor.fetchall()
        # orders = convert_data(result)
    except psycopg2.Error as e:
        print(f"Error connecting to PostgreSQL: {e}")
        return None
    finally:
        # Close the cursor and connection
        if cursor:
            cursor.close()
        if conn:
            conn.close()
    return result


def shiftPremium(user_id, stock_name, entry_price, new_price):
    try:
        conn = psycopg2.connect(DATABASE_URL)

        cursor = conn.cursor()
        query = sql.SQL(
            """
            UPDATE deltaTron_transactions
            SET entry_price = %s,
                price = %s
            WHERE user_id = %s
            AND stock_symbol = %s;
            """
        )
        cursor.execute(query, (entry_price, new_price, user_id, stock_name))
        conn.commit()
        cursor.close()
        conn.close()

        print("Premium shifted successfully.")
    except psycopg2.Error as e:
        print(f"Error shifting premium: {e}")


def convert_data(db_results):
    formatted_data = []
    try:
        for row in db_results:
            stock_symbol, _, entry_price, quantity, price, _ = row
            formatted_data.append({
                "stock_name": stock_symbol,
                "lot_count": quantity,
                "price": float(price),
                "entry_price": float(entry_price)
            })

    except Exception as e:
        print(f"An error occurred while processing database results: {e}")
        return []

    # Successfully processed data
    return formatted_data
