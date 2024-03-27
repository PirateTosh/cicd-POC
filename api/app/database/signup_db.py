import psycopg2
from app.config import DATABASE_URL
from psycopg2 import sql

def addUser(email,user_guid,hashed_password,name) :
    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()
        cursor.execute("INSERT INTO Users (User_guid, Email, Password,name) VALUES (%s, %s, %s, %s)", (user_guid, email, hashed_password, name))
        conn.commit()
    except Exception as e:
        print("Error while connecting to PostgreSQL")
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()