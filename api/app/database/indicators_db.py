import psycopg2
from psycopg2 import Error
from app.config import DATABASE_URL


def create_table_if_not_exists(conn, cursor, resolution):
    try:
        # Check if the table exists
        cursor.execute(
            f"SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = '{resolution}_min_table');"
        )
        table_exists = cursor.fetchone()[0]

        if table_exists:
            # If the table exists, truncate it (remove all existing data)
            cursor.execute(f'TRUNCATE TABLE "{resolution}_min_table";')
        else:
            # If the table does not exist, create it
            create_table_query = f"""
                CREATE TABLE "{resolution}_min_table" (
                    date TIMESTAMP,
                    open NUMERIC,
                    high NUMERIC,
                    low NUMERIC,
                    close NUMERIC,
                    EMA_8 NUMERIC,
                    EMA_21 NUMERIC,
                    SMA_50 NUMERIC,
                    SMA_200 NUMERIC,
                    ADX NUMERIC,
                    ADX_POS NUMERIC,
                    ADX_NEG NUMERIC,
                    RSI NUMERIC,
                    ATR NUMERIC,
                    Candle_Height NUMERIC,
                    Candle_Body_Height NUMERIC
                );
            """
            cursor.execute(create_table_query)

        # Commit the transaction
        conn.commit()

    except psycopg2.Error as e:
        print("Error while creating/truncating table:", e)


def store_data_in_postgresql(data, resolution):
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(DATABASE_URL)

        # Create a cursor object to execute SQL queries
        cursor = conn.cursor()

        # Create or truncate table based on resolution
        create_table_if_not_exists(conn, cursor, resolution)

        # Convert DataFrame to list of tuples
        data_tuples = [tuple(x) for x in data.to_numpy()]

        # Prepare SQL query for inserting data into PostgreSQL table
        insert_query = f"""
            INSERT INTO "{resolution}_min_table" (date, open, high, low, close, EMA_8, EMA_21, SMA_50, SMA_200, ADX, ADX_POS, ADX_NEG, RSI, ATR, Candle_Height, Candle_Body_Height)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """

        # Execute the insert query
        cursor.executemany(insert_query, data_tuples)

        # Commit the transaction
        conn.commit()

        print("Data inserted successfully into PostgreSQL")

    except (Exception, Error) as error:
        print("Error while connecting to PostgreSQL:", error)

    finally:
        # Close the cursor and connection
        if cursor:
            cursor.close()
        if conn:
            conn.close()
            print("PostgreSQL connection is closed")
