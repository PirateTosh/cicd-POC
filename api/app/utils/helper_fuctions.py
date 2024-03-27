import datetime
from io import StringIO

import pandas as pd


# Function to get the difference in days between two dates
def date_difference_in_days(start_date, end_date):
    start = datetime.datetime.strptime(start_date, "%Y-%m-%d")
    end = datetime.datetime.strptime(end_date, "%Y-%m-%d")
    return (end - start).days


def find_start_end_dates(resolution):
    # Set end date as current date
    end_date = datetime.date.today()

    # Set start date based on resolution
    if resolution in ["5", "15", "60"]:  # Assuming resolution is in minutes
        # Calculate start date as 2 months back from the current date
        start_date = end_date - datetime.timedelta(days=60)
    elif resolution == "D":  # Daily resolution
        # Calculate start date as 6 months back from the current date
        start_date = end_date - datetime.timedelta(
            days=6 * 30
        )  # Assuming 30 days in a month
    elif resolution == "W":  # Weekly resolution
        # First end_date and start_date (Current date and a year back)
        start_date = end_date - datetime.timedelta(days=365)
        end_date_str_1 = end_date.strftime("%Y-%m-%d")
        start_date_str_1 = start_date.strftime("%Y-%m-%d")

        # Second end_date and start_date (A day before the first start_date and a year back)
        end_date_2 = start_date - datetime.timedelta(days=1)
        start_date_2 = end_date_2 - datetime.timedelta(days=365)
        end_date_str_2 = end_date_2.strftime("%Y-%m-%d")
        start_date_str_2 = start_date_2.strftime("%Y-%m-%d")

        # Third end_date and start_date (A day before the second start_date and a year back)
        end_date_3 = start_date_2 - datetime.timedelta(days=1)
        start_date_3 = end_date_3 - datetime.timedelta(days=365)
        end_date_str_3 = end_date_3.strftime("%Y-%m-%d")
        start_date_str_3 = start_date_3.strftime("%Y-%m-%d")

        return [
            (start_date_str_1, end_date_str_1),
            (start_date_str_2, end_date_str_2),
            (start_date_str_3, end_date_str_3),
        ]

    # For other resolutions, return start_date and end_date as before
    start_date_str = start_date.strftime("%Y-%m-%d")
    end_date_str = end_date.strftime("%Y-%m-%d")
    return start_date_str, end_date_str


def convert_date_ranges_to_variables(date_ranges):
    range_from_1, range_to_1 = date_ranges[0]
    range_from_2, range_to_2 = date_ranges[1]
    range_from_3, range_to_3 = date_ranges[2]

    return range_from_1, range_to_1, range_from_2, range_to_2, range_from_3, range_to_3


def fetch_records_from_ohlc_data(ohlc_data):
    sdata = pd.DataFrame()
    dx = pd.DataFrame.from_dict(ohlc_data)
    sdata = pd.concat([sdata, dx], ignore_index=True)
    json_data = sdata.to_json(orient="records")
    return json_data


def combined_ohlc_data(ohlc_data_1, ohlc_data_2, ohlc_data_3):
    ohlc_data_1st_year = fetch_records_from_ohlc_data(ohlc_data_1)
    ohlc_data_2nd_year = fetch_records_from_ohlc_data(ohlc_data_2)
    ohlc_data_3rd_year = fetch_records_from_ohlc_data(ohlc_data_3)

    # Convert JSON strings to DataFrames using StringIO
    df1 = pd.read_json(StringIO(ohlc_data_1st_year))
    df2 = pd.read_json(StringIO(ohlc_data_2nd_year))
    df3 = pd.read_json(StringIO(ohlc_data_3rd_year))

    # Concatenate DataFrames, sort, and reset index
    combined_df = pd.concat([df1, df2, df3], ignore_index=True)
    combined_df = combined_df.sort_values(by="date", ascending=True)
    combined_df = combined_df.reset_index(drop=True)
    return combined_df


def convert_daily_to_weekly(daily_data):
    # Check if the input is a string (assuming it's a JSON string)
    if isinstance(daily_data, str):
        daily_data_io = StringIO(daily_data)
        # Convert the string to a DataFrame
        try:
            daily_data = pd.read_json(daily_data_io)
        except ValueError:
            return "Invalid JSON string provided"

    # Check if 'date' column exists in the DataFrame
    if "date" not in daily_data.columns:
        return "DataFrame must contain a 'date' column"

    # Set 'date' column as the index
    daily_data["date"] = pd.to_datetime(daily_data["date"])
    daily_data.set_index("date", inplace=True)

    # Resample the daily data into weekly intervals and aggregate OHLC values
    weekly_data = daily_data.resample("W").agg(
        {
            "open": "first",
            "high": "max",
            "low": "min",
            "close": "last",
            "volume": "sum",  # You might also aggregate volume
        }
    )

    # Reset index to have 'date' as a column
    weekly_data.reset_index(inplace=True)

    return weekly_data
