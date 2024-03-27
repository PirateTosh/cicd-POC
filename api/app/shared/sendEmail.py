from email.message import EmailMessage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders
import smtplib
import ssl

def send_email(email_receiver, subject, body, file_path=None):
    email_sender = 'mohan.pandey@xorlabs.com'
    email_password = 'jcjn ewhp jhyw gzse'

    try:
        em = MIMEMultipart()
        em["From"] = email_sender
        em["To"] = email_receiver
        em["Subject"] = subject

        em.attach(MIMEText(body, "plain"))

        if file_path:
            attachment = open(file_path, "rb")
            file_mime = MIMEBase("application", "octet-stream")
            file_mime.set_payload(attachment.read())
            encoders.encode_base64(file_mime)
            attachment.close()
            file_mime.add_header("Content-Disposition", f"attachment; filename= {file_path.split('/')[-1]}")
            em.attach(file_mime)

        context = ssl.create_default_context()
        with smtplib.SMTP_SSL("smtp.gmail.com", 465, context=context) as smtp:
            smtp.login(email_sender, email_password)
            smtp.send_message(em)
            print("Email sent successfully!")
            return True
    except Exception as e:
        print(f"Failed to send email: {e}")
        return False