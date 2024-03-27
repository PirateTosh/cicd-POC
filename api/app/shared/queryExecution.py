import psycopg2
from app.config import DATABASE_URL
from app.shared.constants import (
    SELECT,
    UPDATE,
    INSERT,
    DELETE,
    TRUNCATE
)

def execute_query(query_type, query, params=None):

    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(DATABASE_URL)

        # Create a cursor object to execute SQL queries
        cursor = conn.cursor()

        if query_type.upper() == SELECT:
            if params is not None:
                cursor.execute(query, params if isinstance(params, tuple) else (params,))
            else:
                cursor.execute(query)

            if cursor.rowcount == 1:
                results = cursor.fetchone()  # Fetch one row
            else:
                results = cursor.fetchall()  # Fetch all rows
        elif query_type.upper() in [INSERT,UPDATE,DELETE,TRUNCATE]:
            if params is not None:
                cursor.execute(query, params if isinstance(params, tuple) else (params,))
            else:
                cursor.execute(query)

            conn.commit()
            results = None  # No results for these types of queries
        else:
            print("Invalid query type. Supported types: INSERT, UPDATE, DELETE, SELECT, TRUNCATE")
            return None

    except psycopg2.Error as e:
        print(f"Error connecting to PostgreSQL: {e}")
        return None
    finally:
        # Close the cursor and connection
        if cursor:
            cursor.close()
        if conn:
            conn.close()
    return results