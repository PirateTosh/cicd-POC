import psycopg2
from app.config import DATABASE_URL

def updatePassword(email, hashed_password):
    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()

        query = "UPDATE users SET password = %s WHERE email = %s"
        cursor.execute(query, (hashed_password, email))
        conn.commit()
    except Exception as e:
        print("Error while connecting to PostgreSQL:", e)
        return False
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()
    return True

def checkUser(email):
    value = {}
    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()

        query = "SELECT * FROM Users WHERE Email = %s"
        cursor.execute(query, (email,))

        value = cursor.fetchone()
        return value
    except Exception as e:
        return value