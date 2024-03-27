import datetime
import pandas as pd

from datetime import timedelta
from flask import jsonify
from app.database.indicators_db import store_data_in_postgresql
from app.utils.fyers_auth_service import generate_fyers_instance
from dateutil.relativedelta import relativedelta
from ta.trend import ema_indicator, sma_indicator, ADXIndicator
from ta.momentum import RSIIndicator
from ta.volatility import AverageTrueRange
from app.utils.helper_fuctions import date_difference_in_days

fyers_instance, status = generate_fyers_instance()


def fetch_ohlc_data(symbol, resolution, range_from, range_to):
    # Check if the difference between dates is more than 366 days
    if date_difference_in_days(range_from, range_to) > 366:
        return jsonify(
            {"error": "Date range exceeds 366 days, It should be under 366 days."}
        )

    try:
        final_symbol = f"NSE:{symbol}-INDEX"
        data = {
            "symbol": final_symbol,
            "resolution": resolution,
            "date_format": "1",
            "range_from": range_from,
            "range_to": range_to,
            "cont_flag": "1",
        }
        dx = fyers_instance.history(data=data)
        dx = pd.DataFrame(dx["candles"])
        dx.columns = ["date", "open", "high", "low", "close", "volume"]
        dx["date"] = pd.to_datetime(dx["date"], unit="s")
        dx["date"] = (
            dx["date"]
            .dt.tz_localize("UTC")
            .dt.tz_convert("Asia/Kolkata")
            .dt.tz_localize(None)
        )
        return dx
    except Exception as e:
        print(e)


def get_dates_in_3_month_intervals(start_date, end_date):
    dates = []
    current_date = start_date.replace(day=1)  # Start from the beginning of the month
    while current_date < end_date:
        next_date = current_date + relativedelta(months=3)
        if next_date > end_date:
            next_date = end_date
        dates.append((current_date, next_date))
        current_date = next_date + timedelta(days=1)
    return dates


def get_indicators_for_resolution(symbol, resolutions):
    end_date = datetime.date.today()
    start_date = datetime.date(2023, 1, 1)
    dates = get_dates_in_3_month_intervals(start_date, end_date)

    for resolution in resolutions:
        all_data = []  # List to accumulate data for all date ranges
        for date_range in dates:
            range_from, range_to = date_range
            range_from_str = range_from.strftime("%Y-%m-%d")
            range_to_str = range_to.strftime("%Y-%m-%d")
            ohlc_data = fetch_ohlc_data(
                symbol, resolution, range_from_str, range_to_str
            )

            # Calculate EMA for window size 8 and 21
            ohlc_data["EMA_8"] = ema_indicator(
                ohlc_data["close"], window=8, fillna=False
            )
            ohlc_data["EMA_21"] = ema_indicator(
                ohlc_data["close"], window=21, fillna=False
            )

            # Calculate SMA for window size 50 and 200
            ohlc_data["SMA_50"] = sma_indicator(
                ohlc_data["close"], window=50, fillna=False
            )
            ohlc_data["SMA_200"] = sma_indicator(
                ohlc_data["close"], window=200, fillna=False
            )

            # Calculate ADX, ADX+ and ADX- for window size 14
            adx = ADXIndicator(
                ohlc_data["high"],
                ohlc_data["low"],
                ohlc_data["close"],
                window=14,
                fillna=False,
            )
            ohlc_data["ADX"] = adx.adx()
            ohlc_data["ADX_POS"] = adx.adx_pos()
            ohlc_data["ADX_NEG"] = adx.adx_neg()

            # Calculate RSI for window size 14
            rsi = RSIIndicator(ohlc_data["close"], window=14, fillna=False)
            ohlc_data["RSI"] = rsi.rsi()

            # Calculate ATR for window size 14
            atr = AverageTrueRange(
                ohlc_data["high"],
                ohlc_data["low"],
                ohlc_data["close"],
                window=14,
                fillna=False,
            )
            ohlc_data["ATR"] = atr.average_true_range()

            # Calculate candle height
            ohlc_data["Candle_Height"] = ohlc_data["high"] - ohlc_data["low"]

            # Calculate candle body height
            ohlc_data["Candle_Body_Height"] = abs(
                ohlc_data["open"] - ohlc_data["close"]
            )

            # Drop columns not needed
            ohlc_data.drop(columns=["volume"], inplace=True)

            all_data.append(ohlc_data)  # Append data for current date range

        # Concatenate data for all date ranges into a single DataFrame
        all_data_df = pd.concat(all_data, ignore_index=True)
        store_data_in_postgresql(all_data_df, resolution)


def get_indicators():
    symbol = "NIFTY50"
    resolutions = ["5", "15", "60"]
    get_indicators_for_resolution(symbol, resolutions)
    return "Data retrieval and storage successful for all resolutions."
