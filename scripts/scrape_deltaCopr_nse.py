from datetime import datetime, timedelta
import requests
import psycopg2
from psycopg2 import sql


today = datetime.now().strftime("%d-%m-%Y")
target_date = (datetime.now() - timedelta(days=1)).strftime("%d-%m-%Y")

url = f"https://www.nseindia.com/api/historical/fo/derivatives?&from={target_date}&to={target_date}&instrumentType=FUTSTK&symbol=DELTACORP"

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Referer": "https://www.nseindia.com/report-detail/eq_security",
    "Origin": "https://www.nseindia.com",
}

DATABASE_URL = "host=localhost port=5432 dbname=postgres user=postgres password=xorSprinters@8 sslmode=prefer connect_timeout=10"
conn = psycopg2.connect(DATABASE_URL)
cursor = conn.cursor()

# Check if the table exists, if not, create it
cursor.execute(
    """
    CREATE TABLE IF NOT EXISTS deltacorp_historical_data (
    id VARCHAR(255),
    FH_INSTRUMENT VARCHAR(255),
    FH_SYMBOL VARCHAR(255),
    FH_EXPIRY_DT VARCHAR(255),
    FH_STRIKE_PRICE DECIMAL,
    FH_OPTION_TYPE VARCHAR(2),
    FH_MARKET_TYPE VARCHAR(1),
    FH_OPENING_PRICE DECIMAL,
    FH_TRADE_HIGH_PRICE DECIMAL
)
"""
)

try:
    print("Sending request to API...")
    response = requests.get(url, headers=headers, timeout=10)
    if response.status_code == 200:
        print("Request successful. Processing data...")
        data = response.json()["data"]
    else:
        print(f"Error occurred, status code: {response.status_code}")

    # Insert data into the PostgreSQL database
    for record in data:
        insert_query = sql.SQL(
            """
            INSERT INTO deltacorp_historical_data VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        )

        cursor.execute(
            insert_query,
            (
                record["_id"],
                record["FH_INSTRUMENT"],
                record["FH_SYMBOL"],
                record["FH_EXPIRY_DT"],
                record["FH_STRIKE_PRICE"],
                record["FH_OPTION_TYPE"],
                record["FH_MARKET_TYPE"],
                record["FH_OPENING_PRICE"],
                record["FH_TRADE_HIGH_PRICE"],
            ),
        )

    print("Data processing complete. Committing changes to the database...")
    conn.commit()
    print("Changes committed successfully.")

except requests.exceptions.RequestException as e:
    print(f"Error fetching data: {e}")
    conn.rollback()

finally:
    # Close the database connection
    conn.close()
