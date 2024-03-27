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

# Running scrape_opstra script

To run the script, follow these steps:

>>Log in to the website: Open your web browser and navigate to "https://opstra.definedge.com/". Log in using your credentials.

>>Navigate to Option Simulator: Once logged in, navigate to the "Option Simulator" section under "Options".

>>Capture Headers and Cookies:

    Open DevTools: Right-click on the webpage and select "Inspect" or press Ctrl+Shift+I (Windows/Linux) or Cmd+Opt+I (Mac) to open Chrome DevTools.
    Navigate to the "Network" Tab.
    Reload the Page.
    Find the Request corresponding to the "Get Option Chain" action.
    View Headers: Click on the request and go to the "Headers" tab to capture the headers.
    View Cookies: In the "Headers" tab, find the "Cookies" section to capture the cookies.

>>Update Script: Copy the captured headers and cookies into the script in the appropriate places.

>>Update Date List: Update the dates list in the script with the days you want to collect data for.

>>Update your database_url in script

>>Run Script: After updating the script, execute it using a Python interpreter. Ensure you have the necessary Python libraries installed (requests, psycopg2).
    command : python scrape_opstra.py.py

>>Monitor Execution: The script will iterate through the dates and times specified in the dates list. It will make requests to the website, retrieve data, and insert it into the PostgreSQL database specified in DATABASE_URL. Monitor the script's output for any errors or exceptions.

>>Check Logs: After execution, check the logs (failed_expiry_dates.log and success_expiry_dates.log) for any failed attempts or successful insertions.


# Running script scrape_deltaCopr_nse.py

>>Import Libraries: Ensure you have the necessary libraries installed in your Python environment. The script uses datetime, timedelta from datetime, requests, and psycopg2.
if not install using command pip install <library_name> example pip install psycopg2

>>Set Target Date: The script sets the target_date as one day before the current date. You can adjust this date if needed.

>>Update Database Connection: Update the DATABASE_URL variable with the connection details for your PostgreSQL database.

>>Run the Script: Execute the script using a Python interpreter.
Command : python scrape_deltaCopr_nse.py


# Running script scrape_securityArchives_nse.py

>>Import Libraries: Ensure you have the necessary libraries installed in your Python environment. The script uses datetime, timedelta from datetime, requests, and psycopg2.
if not install using command pip install <library_name> example pip install psycopg2

>>Calculate Dates: The script calculates today's date and 31 days ago from the current date.

>>Update Database Connection: Replace the DATABASE_URL variable with the connection details for your PostgreSQL database.

>>Run the Script: Execute the script using a Python interpreter.
Command : python scrape_securityArchives_nse.py


