import os
import requests
import configparser
from datetime import datetime


def job(api_baseurl, usertype, stock_list, guid):
    try:
        data = {"usertype": usertype, "stock_list": stock_list, "guid": guid}
        headers = {"Content-Type": "application/json"}
        response = requests.post(
            api_baseurl + "lTron_strategy", json=data, headers=headers
        )

        print(
            f"---------- LTron Strategy Executed at {datetime.now().strftime('%m/%d/%Y %H:%M:%S')} ----------\n"
        )
        print(response.text)

    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")


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
        usertype = config.get("configuration", "usertype")
        stock_list_str = config.get("configuration", "stock_list")
        guid = config.get("configuration", "guid")

        stock_list = [
            stock.strip().strip('"') for stock in stock_list_str[1:-1].split(",")
        ]
    except ValueError:
        # Handle case where not a valid number
        print("Error fetching values from config, not a valid number")

    return api_baseurl, usertype, stock_list, guid


def run_lTron_strategy():
    api_baseurl, usertype, stock_list, guid = get_config_parameters()
    job(api_baseurl, usertype, stock_list, guid)
