import calendar
from datetime import datetime, timedelta

# Get respective Symbol according to Weekday
indices_symbols = {
    "MONDAY": "midcpnifty",
    "TUESDAY": "finnifty",
    "WEDNESDAY": "banknifty",
    "THURSDAY": "nifty",
    "FRIDAY": "sensex",
}
indices_zerodha_exchange = {
    "midcpnifty": "NFO",
    "finnifty": "NFO",
    "banknifty": "NFO",
    "nifty": "NFO",
    "sensex": "BFO",
}
indices_trader_exchange = {
    "midcpnifty": "NSE",
    "finnifty": "NSE",
    "banknifty": "NSE",
    "nifty": "NSE",
    "sensex": "BSE",
}

indices_lot_quantity = {
    "midcpnifty": 40,
    "finnifty": 40,
    "banknifty": 15,
    "nifty": 50,
    "sensex": 10,
}

fyers_index_symbols = {
    "MONDAY": "MIDCPNIFTY",
    "TUESDAY": "FINNIFTY",
    "WEDNESDAY": "NIFTYBANK",
    "THURSDAY": "NIFTY50",
    "FRIDAY": "SENSEX",
}


def find_last_thursday_week(year, month):
    # Get the calendar for the given year and month
    cal = calendar.monthcalendar(year, month)

    # Check if Thursday is present in the last week
    last_week = cal[-1]
    if (
        last_week[calendar.THURSDAY] != 0
    ):  # Check if Thursday is non-zero in the last week
        return len(cal)  # If Thursday is in the last week, return the week number

    # If Thursday is not in the last week, find the week containing the last Thursday
    for week_num, week in reversed(list(enumerate(cal, start=1))):
        if (
            week[calendar.THURSDAY] != 0
        ):  # Check if Thursday is non-zero in the current week
            return week_num  # Return the week number containing the last Thursday

    return None  # Return None if Thursday is not found in the month


def is_date_in_last_thursday_week(year, month, day):
    # Find the week containing the last Thursday
    last_thursday_week = find_last_thursday_week(year, month)

    if last_thursday_week is not None:
        # Check if the passed date falls within the week containing the last Thursday
        first_day_of_last_week = datetime(
            year, month, calendar.monthcalendar(year, month)[last_thursday_week - 1][0]
        )
        end_of_last_week = first_day_of_last_week + timedelta(
            days=6
        )  # Assuming Sunday is the end of the week
        return (
            datetime(year, month, day) >= first_day_of_last_week
            and datetime(year, month, day) <= end_of_last_week
        )

    return False  # Return False if Thursday is not found in the month


def last_week_of_month(year, month, day):
    last_day_of_month = (datetime(year, month, 1) + timedelta(days=32)).replace(
        day=1
    ) - timedelta(days=1)
    next_week = day + 7

    if next_week > last_day_of_month.day:
        return True
    return False


# Replace banknifty with Thursday if it's the last week of the month
today = datetime.today()
year = today.year
month = today.month
day = today.day

if is_date_in_last_thursday_week(year, month, day):
    indices_symbols["THURSDAY"] = "banknifty"
    fyers_index_symbols["THURSDAY"] = "NIFTYBANK"
