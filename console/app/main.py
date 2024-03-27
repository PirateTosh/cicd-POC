import configparser
import datetime
import os
import time
from app.scheduler.omegaTron_scheduler import run_omegaTron_strategy
from app.scheduler.lTron_scheduler import run_lTron_strategy
from app.scheduler.deltaTron_scheduler import run_deltaTron_strategy
from app.scheduler.backtesting_scheduler import run_omegaTron_backtesting


def run_application():
    current_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

    # Construct the absolute path to your ini file
    config_path = os.path.join(current_dir, "app", "config", "omegaTron_config.ini")

    # Read from the config file - omegaTron_config.ini
    config = configparser.ConfigParser()
    config.read(config_path)
    # Access configuration values
    try:
        usertype = config.get("configuration", "usertype")

        if usertype.lower() == "backtesting":
            run_omegaTron_backtesting()
        else:
            run_consoleApp()
    except ValueError as ve:
        # Handle case where not a valid number
        print(f"Error fetching values from config: {ve}")
    except Exception as e:
        # Handle any other exceptions
        print(f"An unexpected error occurred: {e}")


def run_consoleApp():
    try:
        print("Release Version - 0.0.0.4")
        print("Release Date - 06-03-2024")

        # Run the function at an interval of 5 seconds from Monday to Friday between 9:00 AM and 3:30 PM
        while True:
            current_day = datetime.datetime.now().weekday()
            current_time = datetime.datetime.now().time()
            # Check if it's Monday (0) to Friday (4)
            if current_day < 5:
                if datetime.time(9, 15) <= current_time <= datetime.time(15, 25):
                    run_omegaTron_strategy()
                    run_lTron_strategy()
                    run_deltaTron_strategy()
            time.sleep(5)

    except Exception as e:
        print(f"An error occurred: {e}")
