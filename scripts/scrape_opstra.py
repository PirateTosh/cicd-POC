import requests
from datetime import datetime, timedelta, timezone
import psycopg2

DATABASE_URL = "host=localhost port=5432 dbname=ppi user=postgres password=pass@123# sslmode=prefer connect_timeout=10"

conn = psycopg2.connect(DATABASE_URL)

create_table_sql = """
CREATE TABLE IF NOT EXISTS opstra_data (
    id SERIAL PRIMARY KEY,
    datetime VARCHAR(255),
    CallDelta VARCHAR(255),
    CallIV VARCHAR(255),
    CallLTP VARCHAR(255),
    CallVega VARCHAR(255),
    PutDelta FLOAT,
    PutIV FLOAT,
    PutLTP FLOAT,
    PutVega FLOAT,
    Strikes FLOAT,
    index_x VARCHAR(255),
    index_y FLOAT,
    name VARCHAR(255)
);
"""

with conn.cursor() as cursor:
    cursor.execute(create_table_sql)

conn.commit()
conn.close()


def insert_option_chain_data(conn, data, datetime_str):
    for record in data.get("optionchaindata", []):
        put_delta_raw = record.get("PutDelta", None)
        put_delta = None

        if put_delta_raw is not None and put_delta_raw != "-":
            put_delta = abs(float(put_delta_raw)) / 10
            put_delta = f"{put_delta:.2f}"

        call_delta_raw = record.get("CallDelta", None)
        call_delta = None

        if call_delta_raw is not None and call_delta_raw != "-":
            call_delta = abs(float(call_delta_raw)) / 10
            call_delta = f"{call_delta:.2f}"

        put_iv = record.get("PutIV", None) if record.get("PutIV") != "-" else None
        put_ltp = record.get("PutLTP", None) if record.get("PutLTP") != "-" else None
        put_vega = record.get("PutVega", None) if record.get("PutVega") != "-" else None
        strikes = record.get("Strikes", None) if record.get("Strikes") != "-" else None
        index_x = record.get("index_x", "")
        index_y = record.get("index_y", None) if record.get("index_y") != "-" else None

        call_iv = record.get("CallIV", None) if record.get("CallIV") != "-" else None
        call_ltp = record.get("CallLTP", None) if record.get("CallLTP") != "-" else None
        call_vega = (
            record.get("CallVega", None) if record.get("CallVega") != "-" else None
        )

        sql = """
        INSERT INTO opstra_data (datetime,calldelta,calliv,callltp,callvega, putdelta, putiv, putltp, putvega, strikes, index_x, index_y)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s,%s,%s,%s,%s)
        """
        values = (
            datetime_str,
            call_delta,
            call_iv,
            call_ltp,
            call_vega,
            put_delta,
            put_iv,
            put_ltp,
            put_vega,
            strikes,
            index_x,
            index_y,
        )

        try:
            with conn.cursor() as cursor:
                cursor.execute(sql, values)
        except Exception as e:
            print(f"Error inserting data: {e}")

            with open("failed_expiry_dates.log", "a") as log_file:
                log_file.write(f"Failed for expiry date: {datetime_str}\n")

            # If insertion fails, raise an exception to trigger rollback
            raise Exception("Insertion failed")

    # If all insertions are successful, return success
    return "Insertion successful"


def get_epoch_from_datetime(date_str, time_str):
    dt_str = f"{date_str} {time_str}"
    dt_object = datetime.strptime(dt_str, "%d%b%Y %H:%M")

    # Set the timezone to GMT+5:30
    gmt_timezone = timezone(timedelta(hours=5, minutes=30))
    dt_object = dt_object.replace(tzinfo=gmt_timezone)

    # Calculate the difference from the Unix epoch
    unix_epoch = datetime(1970, 1, 1, tzinfo=timezone.utc)
    delta = dt_object - unix_epoch

    # Convert the timedelta to seconds and return the result
    return int(delta.total_seconds())


# List of dates
dates = [
    "05JAN2023",
    "12JAN2023",
    "19JAN2023",
    "25JAN2023",
    "02FEB2023",
    "09FEB2023",
    "16FEB2023",
    "23FEB2023",
    "02MAR2023",
    "09MAR2023",
    "16MAR2023",
    "23MAR2023",
    "29MAR2023",
    "06APR2023",
    "13APR2023",
    "20APR2023",
    "27APR2023",
    "04MAY2023",
    "11MAY2023",
    "18MAY2023",
    "25MAY2023",
    "08JUN2023",
    "15JUN2023",
    "22JUN2023",
    "28JUN2023",
    "06JUL2023",
    "13JUL2023",
    "20JUL2023",
    "27JUL2023",
    "03AUG2023",
    "10AUG2023",
    "17AUG2023",
    "24AUG2023",
    "31AUG2023",
    "07SEP2023",
    "14SEP2023",
    "21SEP2023",
    "28SEP2023",
    "05OCT2023",
    "12OCT2023",
    "19OCT2023",
    "26OCT2023",
    "02NOV2023",
    "16NOV2023",
    "23NOV2023",
    "30NOV2023",
    "07DEC2023",
    "14DEC2023",
    "21DEC2023",
    "28DEC2023",
    "04JAN2024",
    "11JAN2024",
    "18JAN2024",
    "25JAN2024",
    "01FEB2024",
    "08FEB2024",
    "15FEB2024",
    "22FEB2024",
]

start_time = "09:16"
end_time = "15:17"
current_time = datetime.strptime(start_time, "%H:%M")
increment = timedelta(minutes=1)

for expiry_date in dates:
    conn = psycopg2.connect(DATABASE_URL)

    try:
        while current_time <= datetime.strptime(end_time, "%H:%M"):
            epoch = get_epoch_from_datetime(expiry_date, current_time.strftime("%H:%M"))
            datetime_str = expiry_date + current_time.strftime("%H:%M")
            url = f"https://opstra.definedge.com/api/optionsimulator/optionchain/{epoch}&NIFTY&{expiry_date}"

            headers = {
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
                "Referer": "https://opstra.definedge.com/options-simulator",
            }

            cookies = {
                "_ga": "GA1.1.1510979647.1682252243",
                "JSESSIONID": "7DBD03C6B00AE78E1BC187269B0BC9B4",
                "_ga_50VZ2CLHRH": "GS1.1.1706445113.8.0.1706445113.0.0.0",
            }

            response = requests.get(url, headers=headers, cookies=cookies)

            if response.status_code == 200:
                data = response.json()
                insert_status = insert_option_chain_data(conn, data, datetime_str)
                if insert_status == "Insertion successful":
                    print(f"Data inserted successfully for {datetime_str}")
                else:
                    print(f"Failed inserting data for {datetime_str}")
                    with open("failed_expiry_dates.log", "a") as log_file:
                        log_file.write(f"Failed for expiry date: {datetime_str}\n")
                    # Rollback and close the connection
                    conn.rollback()
                    break
            else:
                print(f"Request failed with status code {response.status_code}")
                print(response.text)
                with open("failed_expiry_dates.log", "a") as log_file:
                    log_file.write(f"Failed for expiry date: {datetime_str}\n")
                # Rollback and close the connection
                conn.rollback()
                break

            # Increment the current time by 1 minute
            current_time += increment

        else:
            # Commit changes if the loop completes without a break
            conn.commit()
            with open("success_expiry_dates.log", "a") as log_file:
                log_file.write(f"Successfull for expiry date: {expiry_date}\n")
            print(f"All data stored successfully in db for {expiry_date}")

    except Exception as e:
        print(f"Exception: {e}")
        with open("failed_expiry_dates.log", "a") as log_file:
            log_file.write(f"Failed for expiry date: {datetime_str}\n")
        # Rollback and close the connection
        conn.rollback()
    finally:
        conn.close()

    # Reset current_time for the next date
    current_time = datetime.strptime(start_time, "%H:%M")
