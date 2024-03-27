import psycopg2
from app.config import DATABASE_URL
from app.shared.constants import (
    SELECT,
    UPDATE,
    INSERT,
    DELETE
)
from psycopg2 import sql

def getFirstStepStatus():
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(DATABASE_URL)

        # Create a cursor object to execute SQL queries
        cursor = conn.cursor()

        query = sql.SQL(
            """
                select firststep from delta_tron_values where userid = 1
        """
        )
        cursor.execute(query)    
        result = cursor.fetchone()
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


def updateFirstStepStatus(status):
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(DATABASE_URL)

        # Create a cursor object to execute SQL queries
        cursor = conn.cursor()

        query = sql.SQL(
            """
                UPDATE delta_tron_values
                SET firststep = %s
                WHERE userid = 1;
        """
        )
        cursor.execute(query,[status]) 
        conn.commit()
    except psycopg2.Error as e:
        print(f"Error connecting to PostgreSQL: {e}")
        return None
    finally:
        # Close the cursor and connection
        if cursor:
            cursor.close()
        if conn:
            conn.close()
def getLastStepStatus():
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(DATABASE_URL)

        # Create a cursor object to execute SQL queries
        cursor = conn.cursor()

        query = sql.SQL(
            """
                select lastStep from delta_tron_values where userid = 1
        """
        )
        cursor.execute(query)    
        result = cursor.fetchone()
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


def updateLastStepStatus(status):
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(DATABASE_URL)

        # Create a cursor object to execute SQL queries
        cursor = conn.cursor()

        query = sql.SQL(
            """
                UPDATE delta_tron_values
                SET lastStep = %s
                WHERE userid = 1;
        """
        )
        cursor.execute(query,[status]) 
        conn.commit()
    except psycopg2.Error as e:
        print(f"Error connecting to PostgreSQL: {e}")
        return None
    finally:
        # Close the cursor and connection
        if cursor:
            cursor.close()
        if conn:
            conn.close()

def updatePrices(prices):
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(DATABASE_URL)

        # Create a cursor object to execute SQL queries
        cursor = conn.cursor()

        query = sql.SQL(
            """
                UPDATE delta_tron_values
                SET prices = %s
                WHERE userid = 1;
        """
        )
        cursor.execute(query,(prices,))    
        conn.commit()
    except psycopg2.Error as e:
        print(f"Error connecting to PostgreSQL: {e}")
        return None
    finally:
        # Close the cursor and connection
        if cursor:
            cursor.close()
        if conn:
            conn.close()


def updateStrategy(status):
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(DATABASE_URL)

        # Create a cursor object to execute SQL queries
        cursor = conn.cursor()

        query = sql.SQL(
            """
                UPDATE delta_tron_values
                SET strategy_executed = %s
                WHERE userid = 1;
        """
        )
        cursor.execute(query,[status]) 
        conn.commit()
    except psycopg2.Error as e:
        print(f"Error connecting to PostgreSQL: {e}")
        return None
    finally:
        # Close the cursor and connection
        if cursor:
            cursor.close()
        if conn:
            conn.close()

def getStrategy():
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(DATABASE_URL)

        # Create a cursor object to execute SQL queries
        cursor = conn.cursor()

        query = sql.SQL(
            """
                SELECT strategy_executed FROM delta_tron_values 
                where userid = 1
        """
        )
        cursor.execute(query) 
        result = cursor.fetchone()
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
    
def getPrices():
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(DATABASE_URL)

        # Create a cursor object to execute SQL queries
        cursor = conn.cursor()

        query = sql.SQL(
            """
                SELECT prices FROM delta_tron_values 
                where userid = 1
        """
        )
        cursor.execute(query) 
        result = cursor.fetchone()
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


# def execute_query(query_type, query, params=None):

#     try:
#         # Connect to the PostgreSQL database
#         conn = psycopg2.connect(DATABASE_URL)

#         # Create a cursor object to execute SQL queries
#         cursor = conn.cursor()

#         if query_type.upper() == SELECT:
#             if params is not None:
#                 cursor.execute(query, params if isinstance(params, tuple) else (params,))
#             else:
#                 cursor.execute(query)

#             if cursor.rowcount == 1:
#                 results = cursor.fetchone()  # Fetch one row
#             else:
#                 results = cursor.fetchall()  # Fetch all rows
#         elif query_type.upper() in [INSERT,UPDATE,DELETE]:
#             if params is not None:
#                 cursor.execute(query, params if isinstance(params, tuple) else (params,))
#             else:
#                 cursor.execute(query)

#             conn.commit()
#             results = None  # No results for these types of queries
#         else:
#             print("Invalid query type. Supported types: INSERT, UPDATE, DELETE, SELECT")
#             return None

#     except psycopg2.Error as e:
#         print(f"Error connecting to PostgreSQL: {e}")
#         return None
#     finally:
#         # Close the cursor and connection
#         if cursor:
#             cursor.close()
#         if conn:
#             conn.close()
#     return results