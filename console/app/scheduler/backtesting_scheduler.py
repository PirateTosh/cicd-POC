import json
import os
import time
import psycopg2
import requests
import configparser
from datetime import datetime, timedelta


DATABASE_URL = "host=localhost port=5432 dbname=ppi user=postgres password=pass@123# sslmode=prefer connect_timeout=10"


def get_record_count_for_date(date_pattern):
    try:
        # Establish a connection to the PostgreSQL database
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()

        # SQL query to get the count for the given date pattern
        query = """
            SELECT COUNT(*) as record_count
            FROM opstra_data
            WHERE datetime LIKE %s
        """

        # Execute the query with the date pattern as a parameter
        cursor.execute(query, (f"{date_pattern}%",))

        # Fetch the result
        result = cursor.fetchone()

        # Close the cursor and connection
        cursor.close()
        conn.close()

        # Return the record count
        return result[0] if result else 0

    except Exception as e:
        print(f"An error occurred: {e}")
        return 0


def job(api_baseurl, entry_price, threshold, guid, usertype, dates):
    try:
        json_string_cleaned = dates.replace("\n", "").replace(" ", "")

        date_list = json_string_cleaned.strip("[]").split(",")

        # Clean each date string and append it to the list
        date_list = [date.strip().strip('"') for date in date_list]
        if date_list[-1] == "":
            date_list.pop()
        headers = {"Content-Type": "application/json"}
        
        if os.path.exists('../api/backtesting_results.xlsx'):
            print("Error: Old backtesting report is present in API directory. Please remove/backup it from ../api/backtesting_results.xlsx")
            quit()
            
        for date in date_list:
            if date == date_list[-1]:
                isLastDate = True
            else:
                isLastDate = False
            print(" ")
            print(f"----------- Backtesting started for expiry: {date} -----------")
            isFailed = False
            # Set the start and end time for the current date
            start_time = datetime.strptime(date + " 09:16", "%d%b%Y %H:%M")
            end_time = datetime.strptime(date + " 15:17", "%d%b%Y %H:%M")

            # Iterate over each minute within the specified range
            current_time = start_time
            while current_time <= end_time:
                # print(f"Running for time: {current_time.strftime('%d%b%Y%H:%M')}")
                # Prepare the data with the current datetime value
                data = {
                    "entry_price": entry_price,
                    "threshold": threshold,
                    "guid": guid,
                    "usertype": usertype,
                    "date": current_time.strftime(
                        "%d%b%Y%H:%M"
                    ),  # Convert datetime to the required format
                    "isLastDate": isLastDate,
                }

                # Make the API request
                response = requests.post(
                    api_baseurl + "omegaTron_strategy", json=data, headers=headers
                )
                if response.text == "Data not found for date":
                    print(f"Error: Data not found for the timestamp: {current_time.strftime('%d%b%Y %H:%M')}")
                    print(f"Error: Backtesting could not complete for this expiry.")
                    isFailed = True
                    break
                # Increment the current time by one minute
                current_time += timedelta(minutes=1)
            if isFailed == False:
                print(f"----------- Backtesting completed for: {date} -----------")
    except Exception as e:
        print(f"Error: {e}")
        print(f"Error: Backtesting could not complete, exiting now.")


def get_config_parameters():
    # Get the current file's directory (assuming this script is inside the project)
    current_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

    # Construct the absolute path to your ini file
    config_path = os.path.join(current_dir, "config", "omegaTron_config.ini")

    # Read from the config file - omegaTron_config.ini
    config = configparser.ConfigParser()
    config.read(config_path)
    # Access configuration values
    try:
        api_baseurl = config.get("api_connection", "api_baseurl")
        entry_price = float(config.get("configuration", "entry_price"))
        threshold = float(config.get("configuration", "threshold"))
        guid = config.get("configuration", "guid")
        dates = config.get("backtesting", "dates")

    except ValueError:
        # Handle case where not a valid number
        print("Error fetching values from config, not a valid number")

    return api_baseurl, entry_price, threshold, guid, dates


def run_omegaTron_backtesting():

    api_baseurl, entry_price, threshold, guid, dates = get_config_parameters()
    job(api_baseurl, entry_price, threshold, guid, "Backtesting", dates)
