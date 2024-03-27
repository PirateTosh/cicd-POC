from datetime import datetime, timedelta
import requests
import psycopg2
from psycopg2 import sql


# Calculate today's date and 31 days ago
today = datetime.now().strftime("%d-%m-%Y")
thirty_one_days_ago = (datetime.now() - timedelta(days=31)).strftime("%d-%m-%Y")

url = f"https://www.nseindia.com/api/historical/securityArchives?from={thirty_one_days_ago}&to={today}&symbol=DELTACORP&dataType=priceVolumeDeliverable&series=ALL"

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Referer": "https://www.nseindia.com/report-detail/eq_security",
    "Origin": "https://www.nseindia.com",
}

# Replace DATABASE_URL with your actual PostgreSQL database URL
DATABASE_URL = "host=localhost port=5432 dbname=postgres user=postgres password=xorSprinters@8 sslmode=prefer connect_timeout=10"
conn = psycopg2.connect(DATABASE_URL)
cursor = conn.cursor()

# Check if the table exists, if not, create it
cursor.execute(
    """
    CREATE TABLE IF NOT EXISTS security_archives_data (
        id TEXT,
        SYMBOL TEXT,
        SERIES TEXT,
        TRADE_HIGH_PRICE REAL,
        TRADE_LOW_PRICE REAL,
        OPENING_PRICE REAL,
        CLOSING_PRICE REAL,
        LAST_TRADED_PRICE REAL,
        PREVIOUS_CLS_PRICE REAL,
        TOT_TRADED_QTY INTEGER,
        TOT_TRADED_VAL REAL,
        TOTAL_TRADES INTEGER,
        COP_DELIV_QTY INTEGER,
        COP_DELIV_PERC REAL,
        VWAP REAL
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
            INSERT INTO security_archives_data VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        )

        cursor.execute(
            insert_query,
            (
                record["_id"],
                record["CH_SYMBOL"],
                record["CH_SERIES"],
                record["CH_TRADE_HIGH_PRICE"],
                record["CH_TRADE_LOW_PRICE"],
                record["CH_OPENING_PRICE"],
                record["CH_CLOSING_PRICE"],
                record["CH_LAST_TRADED_PRICE"],
                record["CH_PREVIOUS_CLS_PRICE"],
                record["CH_TOT_TRADED_QTY"],
                record["CH_TOT_TRADED_VAL"],
                record["CH_TOTAL_TRADES"],
                record["COP_DELIV_QTY"],
                record["COP_DELIV_PERC"],
                record["VWAP"],
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
