# ----------------------------QUERY-------------------------------
SELECT = "SELECT"
UPDATE = "UPDATE"
INSERT = "INSERT"
DELETE = "DELETE"
TRUNCATE = "TRUNCATE"
SELECT_ACTIVE_ORDER_QUERY = """
                SELECT dt1.stock_symbol, 
                dt1.user_id, 
                dt1.entry_price, 
                SUM(dt1.quantity) AS total_quantity,
                dt1.price,
                dt1.transaction_type
                FROM deltaTron_transactions dt1
                WHERE dt1.transaction_type = 'sold'
                AND NOT EXISTS (
                    SELECT 1
                    FROM deltaTron_transactions dt2
                    WHERE dt1.stock_symbol = dt2.stock_symbol
                    AND dt1.user_id = dt2.user_id
                    AND dt1.entry_price = dt2.entry_price
                    AND dt2.transaction_type = 'bought'
                )
                GROUP BY dt1.stock_symbol, dt1.user_id, dt1.entry_price, dt1.price, dt1.transaction_type;
        """
SELECT_FIRSTSTEP_QUERY = """
                select firststep from delta_tron_values where userid = 1
        """
SELECT_LASTSTEP_QUERY = """
                select lastStep from delta_tron_values where userid = 1
        """
SELECT_STRATEGY_EXECUTED_QUERY = """
                SELECT strategy_executed FROM delta_tron_values 
                where userid = 1
        """
SELECT_STOCK_SYMBOL_QUERY = """
                SELECT stock_symbol, quantity, price
                FROM lTron_transactions
                WHERE user_id= %s AND transaction_type = 'bought';
        """
SELECT_DISTINCT_STOCK_SYMBOL_QUERY = """
                SELECT DISTINCT stock_symbol
                FROM lTron_transactions
                WHERE user_id= %s AND transaction_type = 'bought';
        """
SELECT_CALCULATE_TOTAL_TRADES_QUERY = """
                SELECT COUNT(*)
                FROM backtest_transactions
                WHERE user_id= %s AND backtesting_date LIKE %s
        """
SELECT_CALCULATE_PL_METRICS_QUERY = """
                SELECT stock_symbol, transaction_type, price
                FROM backtest_transactions
                WHERE user_id= %s AND backtesting_date LIKE %s
        """
SELECT_TRANSACTION_FOR_DATE_QUERY = """
                SELECT stock_symbol, backtesting_date, price, transaction_type
                FROM backtest_transactions
                WHERE user_id= %s AND backtesting_date LIKE %s
        """
SELECT_FETCH_OPSTRA_DATA_QUERY = """
            SELECT datetime, callltp, putltp, strikes
            FROM opstra_data
            WHERE datetime LIKE %s
            ORDER BY datetime ASC 
        """

UPDATE_FIRSTSTEP_STATUS_QUERY = """
                UPDATE delta_tron_values
                SET firststep = %s
                WHERE userid = 1;
        """
UPDATE_LASTSTEP_STATUS_QUERY = """
                UPDATE delta_tron_values
                SET lastStep = %s
                WHERE userid = 1;
        """
UPDATE_PRICES_QUERY = """
                UPDATE delta_tron_values
                SET prices = %s
                WHERE userid = 1;
            """
UPDATE_STRATEGY_EXECUTED_QUERY = """
                UPDATE delta_tron_values
                SET strategy_executed = %s
                WHERE userid = 1;
        """
UPDATE_SHIFT_PREMIUM_QUERY = """
                UPDATE deltaTron_transactions
                SET entry_price = %s,
                    price = %s
                WHERE user_id = %s
                AND stock_symbol = %s;
        """
UPDATE_OMEGA_TRON_ACTIVE_STATUS = """
                UPDATE users
                SET omegatron_status = %s
                WHERE id = %s;
"""
UPDATE_DELTA_TRON_ACTIVE_STATUS = """
                UPDATE users
                SET deltatron_status = %s
                WHERE id = %s;
"""
UPDATE_L_TRON_ACTIVE_STATUS = """
                UPDATE users
                SET ltron_status = %s
                WHERE id = %s;
"""
UPDATE_DELTATRON_VALUES_TO_INITIAL_STATUS = """
                UPDATE delta_tron_values
                SET firstStep = %s,
                    prices = %s,
                    strategy_executed = %s,
                    lastStep = %s
                WHERE userid = %s;
"""
INSERT_DELTATRON_STORE_TRANSACTION_QUERY = """
                INSERT INTO deltaTron_transactions (user_id, transaction_type, stock_symbol, quantity, price, entry_price)
                VALUES (%s, %s, %s, %s, %s, %s);
        """
INSERT_LTRON_STORE_TRANSACTION_QUERY = """
                INSERT INTO lTron_transactions (user_id, transaction_type, stock_symbol, quantity, price)
                VALUES (%s, %s, %s, %s, %s);
        """
LOGIN_QUERY = "SELECT * FROM Users WHERE email = %s AND password = %s"
CHECK_ALREADY_EXISTING_EMAIL = "SELECT id FROM Users WHERE email like %s"
INSERT_OMEGATRON_STORE_TRANSACTION_QUERY = """
                INSERT INTO transactions (user_id, transaction_type, stock_symbol, quantity, price)
                VALUES (%s, %s, %s, %s, %s);
        """
INSERT_OMEGATRON_STORE_BACKTEST_TRANSACTION_QUERY = """
                INSERT INTO backtest_transactions (user_id, transaction_type, stock_symbol, quantity, price, backtesting_date)
                VALUES (%s, %s, %s, %s, %s, %s);
        """
TRUNCATE_TABLE_BACKTEST_TRANSACTION_QUERY = """
            TRUNCATE TABLE backtest_transactions;
        """
ADD_USER = "INSERT INTO Users (User_guid, Email, Password,name, dob, phone_number) VALUES (%s, %s, %s, %s, %s, %s)"
UPDATE_PASSWORD = "UPDATE users SET password = %s WHERE email = %s"
CHECK_PASSWORD = "SELECT * FROM Users WHERE Email = %s"
UPDATE_PROFILE = "UPDATE users SET email = %s, name = %s, dob = %s, phone_number = %s WHERE id = %s"
FETCH_USER_ID = "SELECT id from users WHERE user_guid = %s"
FETCH_DELTA_TRON_STATUS = "SELECT deltatron_status from users WHERE id = %s"
FETCH_OMEGA_TRON_STATUS = "SELECT omegatron_status from users WHERE id = %s"
FETCH_L_TRON_STATUS = "SELECT ltron_status from users WHERE id = %s"
# ----------------------------------Routes--------------------------------------------
POST = "POST"
LTRON_STRATEGY_ROUTE = "/lTron_strategy"
NSE = "NSE"

# ----------------------------------Other constants-----------------------------------
BOUGHT = "bought"
SOLD = "sold"
FYERS = "Fyers"
BACKTESTING = "Backtesting"
NIFTY = "NIFTY"
TRON_NAME = 'tron_name'
TRON_STATUS = 'tron_status'
OMEGA_TRON = "omega_tron"
DELTA_TRON = "delta_tron"
L_TRON = "l_ton"
FOUND_ANOTHER_INSTANCE_OF_SCHEDULER_RUNNING = (
    "Found another instance of scheduler running, skipping this schedule.\n"
)
MAX_5_STOCKS_ALLOWED = (
    "Maximum 5 stocks allowed. Only the first 5 stocks will be considered."
)
NO_STOCKS_PROVIDED_IN_THE_LIST = "No stocks provided in the list."
RULES_EXECUTED_SUCCESSFULLY = (
    "Rules executed successfully. No further execution required."
)
RULE_2_PENDING_EXECUTION_AT_3_15_PM = "Rule 2 pending execution at 3:15 PM."
RULE_1_HAS_BEEN_EXECUTED_WAITING_FOR_RULE_2 = (
    "Rule 1 has been executed. Waiting for Rule 2 to execute at 3:15 PM."
)
FYERS_ID_OR_APP_ID_IS_NOT_PRESENT = (
    "FYERS_ID or APP_ID is not present. Cannot proceed with login."
)
INSTANCE_ALREADY_EXISTS = "Instance already exists"
FYERS_LOGIN_SUCCESSFUL = "Fyers Login Successful"
INVALID_ACCESS_TOKEN = "Invalid Access Token"
ACCESS_TOKEN_NOT_GENERATED_CANNOT_PROCEED_WITH_LOGIN = (
    "Access Token not generated, Can not proceed with Login"
)
ALL_ACTIVE_ORDERS_HAVE_BEEN_BOUGHT_BACK = "All active orders have been bought back"
NSE_NIFTY50_INDEX = "NSE:NIFTY50-INDEX"
MAX_PAIN_NOT_NUMERIC_ERROR = "Error: Max pain is not a numeric value"
NSE_NIFTY = "NSE:NIFTY"
NIFTY50 = "NIFTY50"
INVALID_EXPIRY_TYPE_MESSAGE = "Invalid expiry_type. Use 'weekly' or 'monthly'."
ORDER_EXIT_SUCCESS_MESSAGE = "Order Exit Success!"
SELL_ORDER_SUCCESS_MESSAGE = "Sell Order Success!"
INVALID_ENTRY_PRICE_MESSAGE = "Passed value for entry_price is not a valid number"
KILL_SWITCH_ACTIVATED_MESSAGE = "Kill Switch is activated for Omega Tron therefore no more active automated trading is allowed."
LTRON_KILL_SWITCH_ACTIVATED_MESSAGE = "Kill Switch is activated for LTron therefore no more Stock buying is allowed."
DELTATRON_KILL_SWITCH_ACTIVATED_MESSAGE = "Kill Switch is activated for DeltaTron therefore no more active automated trading is allowed."
DATA_NOT_FOUND_FOR_DATE = "Data not found for date"
ALL_ACTIVE_ORDERS_BOUGHT_BACK_EXITING = "All active orders bought back..Exiting"
KILL_SWITCH_TOGGLED_SUCCESSFULLY = "Kill Switch is toggled successfully"
MAX_PAIN_RETRIEVAL_FAILED_ERROR = "Error: Max pain retrieval failed."
INVALID_KILLSWITCH_TYPE_MESSAGE = "Invalid kill switch type. Use 'omega_tron', 'l_ton' or 'delta_tron'."
OMEGA_TRON_PROFIT = """
        SELECT 
            (SUM(CASE WHEN transaction_type = 'sold' THEN price * quantity ELSE 0 END) - 
            SUM(CASE WHEN transaction_type = 'bought' THEN price * quantity ELSE 0 END)) / 
            SUM(CASE WHEN transaction_type = 'bought' THEN price * quantity ELSE 0 END) AS net_balance
        FROM 
            transactions
        WHERE 
            user_id = %s
        GROUP BY 
            user_id"""
DELTA_TRON_PROFIT = """
        SELECT 
            (SUM(CASE WHEN transaction_type = 'sold' THEN price * quantity ELSE 0 END) - 
            SUM(CASE WHEN transaction_type = 'bought' THEN price * quantity ELSE 0 END)) / 
            SUM(CASE WHEN transaction_type = 'bought' THEN price * quantity ELSE 0 END) AS net_balance
        FROM 
            deltatron_transactions
		LEFT JOIN users on users.id = deltatron_transactions.user_id
        WHERE 
            user_id = 1
        GROUP BY 
            user_id"""
