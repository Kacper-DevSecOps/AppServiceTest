import os
import psycopg2

def test_db_connection():
    try:
        conn = psycopg2.connect(os.getenv('DATABASE_URL'))
        cursor = conn.cursor()
        cursor.execute('SELECT 1;')
        result = cursor.fetchone()
        assert result[0] == 1
        cursor.close()
        conn.close()
    except Exception as e:
        assert False, f"Database connection failed: {str(e)}"
