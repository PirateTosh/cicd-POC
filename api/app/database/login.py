import psycopg2
from app.config import DATABASE_URL

def getUserByEmailAndPassword(email, hashed_password):
    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()

        query = "SELECT * FROM Users WHERE Email = %s AND Password = %s"
        cursor.execute(query, (email, hashed_password))

        user_data = cursor.fetchone()

        if user_data:
            user_dict = {
                'id': user_data[0],
                'user_id': user_data[1],
                'email': user_data[3],
                'password': user_data[4],
                'name': user_data[5]
            }
            return user_dict
        else:
            return None
    except Exception as e:
        print("Error while connecting to PostgreSQL:", e)
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()
