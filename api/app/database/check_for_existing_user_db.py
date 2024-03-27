import psycopg2
from app.config import DATABASE_URL

def checkForExistingEmail(email) :
    result = {}
    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()
        cursor.execute("select id from users where email like %s", (email,))
        result = cursor.fetchone()
    except Exception as e:
        return e
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()
    return result