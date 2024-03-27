### Prerequisites
- Python 3.x installed on your system.

## Getting Started

Open your command line and navigate to the "api" directory, "Path_of_the_Project\api" and 
Then, run the following commands:

 # For Unix or MacOS
>> python3 -m venv venv

>> source venv/bin/activate

# For Windows
>> python -m venv venv

>> venv/scripts/activate

Now run the following command to install all required lib for this project (written in requirements.txt) : 

>> pip3 install -r requirements.txt

To Run the application:
    python run.py to run backend code.
    To run backtesting, update config file and set usertype = Backtesting


# Setting up db tables for backtesting
>> Creating table for opstra data (or run scrape_opstra.py file)
CREATE TABLE IF NOT EXISTS public.opstra_data_v2
(
    id SERIAL PRIMARY KEY,
    datetime VARCHAR(255),
    calldelta VARCHAR(255),
    calliv VARCHAR(255),
    callltp VARCHAR(255),
    callvega VARCHAR(255),
    putdelta DOUBLE PRECISION,
    putiv DOUBLE PRECISION,
    putltp DOUBLE PRECISION,
    putvega DOUBLE PRECISION,
    strikes DOUBLE PRECISION,
    index_x VARCHAR(255),
    index_y DOUBLE PRECISION,
    name VARCHAR(255)
);

ALTER TABLE IF EXISTS public.opstra_data_v2
    OWNER TO current_user;

>> Table to store backtesting transactions
CREATE TABLE IF NOT EXISTS public.backtest_transactions
(
    transaction_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    transaction_type VARCHAR(10) NOT NULL,
    stock_symbol VARCHAR(25) NOT NULL,
    quantity INTEGER NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    backtesting_date VARCHAR
);

ALTER TABLE IF EXISTS public.backtest_transactions
    OWNER TO current_user;

>>Table to store transactions
CREATE TABLE IF NOT EXISTS public.transactions
(
    transaction_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    transaction_type VARCHAR(10) NOT NULL,
    stock_symbol VARCHAR(25) NOT NULL,
    quantity INTEGER NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE IF EXISTS public.transactions
    OWNER TO current_user;

# Import data into opstra_data table
>> Download the csv file from above drive location
https://drive.google.com/file/d/1CePLHikOvkHbww0OBwkvXHD1NAPyhTwV/view?usp=sharing
 # For windows
    >> Run this in PGAdmin
        run the following command
        COPY opstra_data_v2 FROM 'directory_path\\data\\opstra.csv' WITH CSV HEADER;
 # For linux
        >> Run this in terminal
        sudo mkdir /var/lib/postgresql/csv_data
        sudo mv /<replace with you file location>/opstra.csv /var/lib/postgresql/csv_data/
        sudo chown -R postgres:postgres /var/lib/postgresql/csv_data
        >> Run this in PGAdmin
        COPY public.opstra_data_v2 FROM '/var/lib/postgresql/csv_data/opstra.csv' WITH CSV HEADER;

# Running Backtesting
After successfully installing all requirements as per instructions above and also setting up database. Follow the below instructions to execute Backtesting :
>>In the omegaTron_config.ini set usertype = Backtesting 
>>Add dates that you want to run backtest on in section [backtesting] in config file (at present the data file contains dates for year 2023)
>>now start the API(backend code) by running command 'python run.py'
>>now start the console(frontend/trigger code) by running command 'python run.py'
NOTE : Make sure to run both run.py (one is in the api code another is in the console code)
>>The testing will execute and save transactions in DB and will create a report using the same.
>>The report can be found in the console folder 
>> The report is also sent on mail which is at the moment hardcoded as user module is not in developed. Email can for now be changed from file backtesting_service.py in function send_report_mail() set reciever's email to yours. 

#### Release 0.0.0.4V ####

>>Table to store lTron_transactions
CREATE TABLE IF NOT EXISTS public.lTron_transactions
(
    transaction_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    transaction_type VARCHAR(10) NOT NULL,
    stock_symbol VARCHAR(25) NOT NULL,
    quantity INTEGER NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE IF EXISTS public.lTron_transactions
    OWNER TO current_user;

>>Table for storing funds

CREATE TABLE funds (
    user_id INT PRIMARY KEY,
    base_funds DECIMAL,
    ride_funds DECIMAL
);

>>Dummy entry for running/testing

INSERT INTO funds (user_id, base_funds, ride_funds)
VALUES (1, 2500000, 2500000);



# Setting Up to Run Indicators
# To set up and run the indicators, follow these steps:

>> Hit the endpoint get_adx_rsi to calculate the following indicators:
ADX
DI+
DI-
RSI
EMA8
EMA21
MA50
MA200
ATR
Height of Candle
Height of Candle Body

>> The endpoint will compute the indicators mentioned above.

>> After calculating the indicators, a table will be created in a PostgreSQL database to store the data for 5-minute, 15-minute, and 1-hour resolutions with table names 5_min_table, 15_min_table and 60_min_table

>> The data will be stored in the table with the following columns:
Date
ADX
DI+
DI-
RSI
EMA8
EMA21
MA50
MA200
ATR
Height of Candle
Height of Candle Body
This setup allows for the retrieval and storage of indicator data for analysis and further processing.

>>Table to store delta_tron condition values
CREATE TABLE delta_tron_values (
    userid INTEGER PRIMARY KEY,
    firstStep BOOLEAN NOT NULL,
    prices NUMERIC[] NOT NULL,
    strategy_executed BOOLEAN NOT NULL,
    lastStep BOOLEAN NOT NULL
);

ALTER TABLE IF EXISTS public.delta_tron_values
    OWNER TO current_user;

INSERT INTO delta_tron_values (userid, firstStep, prices, strategy_executed, lastStep)
VALUES (1, TRUE, ARRAY[25, 20, 15, 10], FALSE, FALSE);


>>Table to store delta_tron transactions
CREATE TABLE IF NOT EXISTS public.deltaTron_transactions
(
    transaction_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    transaction_type VARCHAR(10) NOT NULL,
    stock_symbol VARCHAR(25) NOT NULL,
    quantity INTEGER NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    entry_price NUMERIC(10,2) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE IF EXISTS public.deltaTron_transactions
    OWNER TO current_user;


>>Table to store user details
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    user_guid UUID,
    name VARCHAR(255),
    telegram_id BIGINT,
    email VARCHAR(255),
    password VARCHAR(255),
    dob DATE,
    phone_number VARCHAR(20),
    ltron_status BOOLEAN DEFAULT true,
    deltatron_status BOOLEAN DEFAULT true,
    omegatron_status BOOLEAN DEFAULT true
);


ALTER TABLE IF EXISTS public.users
    OWNER TO current_user;

>> Insert query for users table (dummy data)
INSERT INTO users (user_guid, name, telegram_id, email, password, dob, phone_number, ltron_status, deltatron_status, omegatron_status)
VALUES ('0c4e3cb3-9a5d-4e0f-a587-b1176b8f7efc', 'test user', NULL, 'new_user@xorlabs.com', '4dbd5e49147b5102ee2731ac03dd0db7decc3b8715c3df3c1f3ddc62dcbcf86d', '1990-05-15', '+91xxxxxxxxxx', true, true, true);
