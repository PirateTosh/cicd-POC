import psycopg2
from app.config import DATABASE_URL
from app.services.omegaTron.fyers_service import send_telegram_message
from app.services.omegaTron.profitabillity_from_trons import calculate_profit
import smtplib
import ssl
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders


def get_total_capital(user_id=1):
    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()
        cursor.execute("SELECT ride_funds FROM funds WHERE user_id = %s", (user_id,))
        total_capital = cursor.fetchone()[0]
        conn.close()
        return total_capital
    except (Exception, psycopg2.Error) as error:
        print("Error fetching total capital:", error)
        return None


def allocate_capital(tron="delta", user_id=1):
    try:
        total_ride_capital = get_total_capital(user_id)
        overall_profit = calculate_profit(user_id)
        if total_ride_capital is not None and overall_profit is not None:
            omega_tron_profit = overall_profit.get("omegaTron", 0)
            if tron == "delta":
                if omega_tron_profit >= 10.0:
                    delta_tron_allocation = 0.8 * total_ride_capital
                else:
                    delta_tron_allocation = total_ride_capital

        return delta_tron_allocation
    except Exception as e:
        print(f"An error occurred: {e}")


def out_of_funds(allocation_amount, tron, user_id=1):
    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()
        if tron == "delta":
            cursor.execute(
                "SELECT ride_funds FROM funds WHERE user_id = %s", (user_id,)
            )
        else:
            cursor.execute(
                "SELECT base_funds FROM funds WHERE user_id = %s", (user_id,)
            )

        total_capital = cursor.fetchone()[0]
        conn.close()

        if allocation_amount > total_capital:
            send_telegram_message(
                "Insufficient funds re fund the account to resume service"
            )
            out_of_fund_mail()
            return True
        else:
            False
    except (Exception, psycopg2.Error) as error:
        print("Error fetching total capital:", error)
        return None


def out_of_fund_mail(
    email_sender="paritosh.singh@xorlabs.com",
    email_password="luwj wucw zdgm uzht",
    email_receiver="paritosh.singh@xorlabs.com",
    subject="PPI : Out of funds alert",
    body="Funds withdraw has happend, refund the account to resume service",
):
    try:
        # Create a multipart message
        em = MIMEMultipart()
        em["From"] = email_sender
        em["To"] = email_receiver
        em["Subject"] = subject

        # Attach text body
        em.attach(MIMEText(body, "plain"))

        # Add SSL (layer of security)
        context = ssl.create_default_context()

        # Log in and send the email
        with smtplib.SMTP_SSL("smtp.gmail.com", 465, context=context) as smtp:
            smtp.login(email_sender, email_password)
            smtp.sendmail(email_sender, email_receiver, em.as_string())

        return True
    except Exception as e:
        print(f"Error sending email: {e}")
        return False  # Email sending failed
