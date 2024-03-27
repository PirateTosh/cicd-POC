import psycopg2
from app.config import DATABASE_URL

def update_user_profile(email, name, user_id) :
    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()
        cursor.execute("UPDATE users SET email = %s, name = %s WHERE id = %s", (email, name, user_id))
        conn.commit()
    except Exception as e:
        print("Error while connecting to PostgreSQL")
        return False
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()
    return True