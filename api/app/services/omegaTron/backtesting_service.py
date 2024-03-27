import os
import psycopg2
from psycopg2 import sql
from datetime import datetime
import pandas as pd
from app.shared.sendEmail import send_email
from app.config import DATABASE_URL
from app.shared.queryExecution import execute_query
from app.shared.constants import(
    SELECT,
    INSERT,
    TRUNCATE,
    TRUNCATE_TABLE_BACKTEST_TRANSACTION_QUERY,
    SELECT_CALCULATE_TOTAL_TRADES_QUERY,
    SELECT_CALCULATE_PL_METRICS_QUERY,
    INSERT_OMEGATRON_STORE_TRANSACTION_QUERY,
    INSERT_OMEGATRON_STORE_BACKTEST_TRANSACTION_QUERY,
    SELECT_TRANSACTION_FOR_DATE_QUERY,
    SELECT_FETCH_OPSTRA_DATA_QUERY,
    SOLD,
    BOUGHT,
    NIFTY
)   


def send_report_mail(
    # email_sender="paritosh.singh@xorlabs.com",
    # email_password="luwj wucw zdgm uzht",
    email_receiver="mohan.pandey@xorlabs.com",
    subject="BackTesting Report",
    body="PFA report",
    file_path="backtesting_results.xlsx",
):
    try:
        send_email(email_receiver, subject, body, file_path)
        return True
    except Exception as e:
        print(f"Error sending email: {e}")
        return False  # Email sending failed


def backtesting_report(user_id, date, isLastDate):
    xls_file_path = "backtesting_results.xlsx"
    date_without_time = datetime.strptime(date, "%d%b%Y%H:%M").strftime("%d%b%Y")

    # Check if the file exists
    if os.path.exists(xls_file_path):
        # Load existing data from the file
        df_existing = pd.read_excel(xls_file_path)

        # Create a DataFrame for the current date
        df_new = pd.DataFrame({"Date": [date_without_time]})
        df_new["Total Number of Trades"] = calculate_total_trades(user_id, date)
        pl_metrics = calculate_pl_metrics(user_id, date)

        df_new["Total Profit Booked"] = pl_metrics["Total Profit Booked"]
        df_new["Total Loss Booked"] = pl_metrics["Total Loss Booked"]
        df_new["Net P/L Booked"] = pl_metrics["Net P/L Booked"]
        df_new["Total Capital"] = 0
        df_new["Hit-rate %"] = pl_metrics["Hit-rate"]
        df_new["MaxDrawDown"] = pl_metrics["Max Loss"]
        df_new["MaxDrawDownSymbol"] = pl_metrics["Max Loss Symbol"]
        # Append the new data to the existing DataFrame
        df_combined = pd.concat([df_existing, df_new], ignore_index=True)

        # Write the combined DataFrame to the Excel file
        df_combined.to_excel(xls_file_path, index=False)
    else:
        # If the file doesn't exist, create a new DataFrame and write it to the file
        df = pd.DataFrame({"Date": [date_without_time]})
        df["Total Number of Trades"] = calculate_total_trades(user_id, date)
        pl_metrics = calculate_pl_metrics(user_id, date)
        df["Total Profit Booked"] = pl_metrics["Total Profit Booked"]
        df["Total Loss Booked"] = pl_metrics["Total Loss Booked"]
        df["Net P/L Booked"] = pl_metrics["Net P/L Booked"]
        df["Total Capital"] = 0
        df["Hit-rate %"] = pl_metrics["Hit-rate"]
        df["MaxDrawDown"] = pl_metrics["Max Loss"]
        df["MaxDrawDownSymbol"] = pl_metrics["Max Loss Symbol"]
        df.to_excel(xls_file_path, index=False)

    if isLastDate:
        update_and_generate_summary(user_id, xls_file_path)


def get_transactions_for_date(user_id, date):

    date_without_time = date[:-6]

    transactions = execute_query(
        query_type=SELECT,
        query=SELECT_TRANSACTION_FOR_DATE_QUERY,
        params=(f"{user_id}%", f"{date_without_time}%"),
    )

    # update date time format and add space
    # Convert tuples to lists, update date time format, and add space
    transactions_list = [list(transaction) for transaction in transactions]

    for i in range(len(transactions_list)):
        original_datetime = transactions_list[i][1]
        modified_datetime = original_datetime[:-5] + " " + original_datetime[-5:]
        transactions_list[i][1] = modified_datetime

    # Convert lists back to tuples
    transactions = [tuple(transaction) for transaction in transactions_list]

    return pd.DataFrame(transactions)


def update_and_generate_summary(user_id, file_path="backtesting_results.xlsx"):
    # Read the Excel file into a DataFrame
    df = pd.read_excel(file_path)

    all_dates = df.iloc[:, 0].tolist()

    # Calculate the summary row
    summary_row = pd.Series(
        {
            "Date": "Summary",
            "Total Number of Trades": df["Total Number of Trades"].sum(),
            "Total Profit Booked": df["Total Profit Booked"].sum(),
            "Total Loss Booked": df["Total Loss Booked"].sum(),
            "Net P/L Booked": df["Net P/L Booked"].sum(),
            "Total Capital": df["Total Capital"].sum(),
            "Hit-rate %": df["Hit-rate %"].mean(),
            "MaxDrawDown": df["MaxDrawDown"].max(),
            "MaxDrawDownSymbol": df.loc[
                df["MaxDrawDown"].idxmax(), "MaxDrawDownSymbol"
            ],
        }
    )

    # Append the summary row to the DataFrame
    df = pd.concat([df, summary_row.to_frame().T], ignore_index=True)

    # Write the updated DataFrame back to the Excel file
    df.to_excel(file_path, index=False)
    # Calling function to add day transactions
    append_transactions(user_id, all_dates)

    if send_report_mail():
        current_datetime = datetime.now().strftime("%Y%m%d_%H%M%S")
        # Extract the file name and extension
        base_name, extension = os.path.splitext(file_path)
        # Construct the new file name with appended date-time
        new_file_name = f"{base_name}_{current_datetime}{extension}"
        # Rename the file
        os.rename(file_path, new_file_name)
        print(f"File renamed successfully to: {new_file_name}")
        execute_query(
            query_type=TRUNCATE, query=TRUNCATE_TABLE_BACKTEST_TRANSACTION_QUERY
        )
    else:
        print("Failed to send report mail.")


def append_transactions(user_id, all_dates, xls_file_path="backtesting_results.xlsx"):
    for date in all_dates:
        df_transactions = get_transactions_for_date(user_id, date)
        with pd.ExcelWriter(xls_file_path, engine="openpyxl", mode="a") as writer:
            df_transactions.to_excel(writer, sheet_name=date, index=False)


def process_data(input_data):
    ce_option_chain = {}
    pe_option_chain = {}

    for entry in input_data:
        datetime_str, call_ltp, put_ltp, strikes = entry

        # Extract relevant components from datetime
        if len(datetime_str) < 14:
            datetime_str = "0" + datetime_str

        # Extract relevant components from datetime
        year = datetime_str[7:9]
        month_str = datetime_str[2:5]
        day = datetime_str[0:2]

        # Convert month abbreviation to numeric value
        month_dict = {
            "JAN": "01",
            "FEB": "02",
            "MAR": "03",
            "APR": "04",
            "MAY": "05",
            "JUN": "06",
            "JUL": "07",
            "AUG": "08",
            "SEP": "09",
            "OCT": "10",
            "NOV": "11",
            "DEC": "12",
        }
        month = month_dict.get(month_str.upper(), "00")

        # Create the key in the desired format for both CE and PE
        ce_key = f"NIFTY{year}{month}{day}{str(int(strikes))}CE"
        pe_key = f"NIFTY{year}{month}{day}{str(int(strikes))}PE"

        # Add the keys to the output dictionaries if not present
        if ce_key not in ce_option_chain:
            ce_option_chain[ce_key] = {"ltp": 0}
        if pe_key not in pe_option_chain:
            pe_option_chain[pe_key] = {"ltp": 0}

        # Set 'ltp' to the value of call_ltp or put_ltp if not None
        if call_ltp is not None:
            ce_option_chain[ce_key]["ltp"] = call_ltp
        if put_ltp is not None:
            pe_option_chain[pe_key]["ltp"] = put_ltp

    return ce_option_chain, pe_option_chain


def get_backtesting_quote(date):
    opstra_data = fetch_opstra_data(date)
    ce_option_chain, pe_option_chain = process_data(opstra_data)

    return ce_option_chain, pe_option_chain, NIFTY


def storeTransaction(user_id, transaction_type, stock_symbol, quantity, price, date):

    if date is None:

        execute_query(
            query_type=INSERT,
            query=INSERT_OMEGATRON_STORE_TRANSACTION_QUERY,
            params=(user_id, transaction_type, stock_symbol, quantity, price),
        )

    else:
        # timestamp = date
        timestamp = date
        # Define the SQL query to insert the transaction details into the 'transactions' table
        execute_query(
            query_type=INSERT,
            query=INSERT_OMEGATRON_STORE_BACKTEST_TRANSACTION_QUERY,
            params=(
                user_id,
                transaction_type,
                stock_symbol,
                quantity,
                price,
                timestamp,
            ),
        )


def fetch_opstra_data(date_str):
    if date_str and date_str[0] == "0":
        date = date_str.lstrip("0").upper()
        # date = date.upper()
    else:
        date = date_str.upper()
    rows = execute_query(
        query_type=SELECT, query=SELECT_FETCH_OPSTRA_DATA_QUERY, params=(f"{date}%",)
    )

    # Return the fetched data
    return rows


def calculate_total_trades(user_id, date):

    # Remove time from the date
    date_without_time = datetime.strptime(date, "%d%b%Y%H:%M").strftime("%d%b%Y")
    # Fetch the count
    count = execute_query(
        query_type=SELECT,
        query=SELECT_CALCULATE_TOTAL_TRADES_QUERY,
        params=(
            f"{user_id}%",
            f"{date_without_time}%",
        ),
    )

    # Return the total trades count
    return count[0]


def calculate_pl_metrics(user_id, date):
    date_without_time = datetime.strptime(date, "%d%b%Y%H:%M").strftime("%d%b%Y")
    rows = execute_query(
        query_type=SELECT,
        query=SELECT_CALCULATE_PL_METRICS_QUERY,
        params=(f"{user_id}%", f"{date_without_time}%"),
    )

    sold_transactions = {}
    bought_transactions = {}
    profits = []
    losses = []

    for row in rows:
        stock_symbol, transaction_type, price = row
        if transaction_type == SOLD:
            sold_transactions[stock_symbol] = price
        elif transaction_type == BOUGHT:
            bought_transactions[stock_symbol] = price

    # Calculate profits and losses
    for stock_symbol, sold_price in sold_transactions.items():
        if stock_symbol in bought_transactions:
            bought_price = bought_transactions[stock_symbol]
            if sold_price > bought_price:
                profit = sold_price - bought_price
                profits.append(profit)
            else:
                loss = bought_price - sold_price
                # Append a dictionary with stock_symbol and price keys
                losses.append({"stock_symbol": stock_symbol, "price": loss})

    # Calculate hit rate
    total_trades = len(rows)  # len(profits) + len(losses)
    hit_rate = (len(profits) / total_trades) * 100 if total_trades > 0 else 0

    # Calculate total profit, total loss, and net P/L
    total_profit = sum(profits)  # sum(entry["price"] for entry in profits)
    total_loss = sum(entry["price"] for entry in losses)
    net_pl = total_profit - total_loss

    # Find maximum loss
    max_loss_entry = max(losses, key=lambda entry: entry["price"], default=None)
    max_loss_symbol = max_loss_entry["stock_symbol"] if max_loss_entry else None
    max_loss = max_loss_entry["price"] if max_loss_entry else 0.0

    # Return the calculated metrics
    return {
        "Total Profit Booked": total_profit,
        "Total Loss Booked": total_loss,
        "Net P/L Booked": net_pl,
        "Profits": profits,
        "Losses": losses,
        "Max Loss Symbol": max_loss_symbol,
        "Max Loss": max_loss,
        "Hit-rate": hit_rate,
    }


def truncate_transactions_table():
    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()

        query = sql.SQL(
            """
            TRUNCATE TABLE backtest_transactions;
        """
        )
        cursor.execute(query)
        conn.commit()

    except psycopg2.Error as e:
        print(f"Error connecting to PostgreSQL: {e}")
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()
