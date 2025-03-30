from flask import Flask, request
import psycopg2, os

app = Flask(__name__)

def get_db_connection():
    conn = psycopg2.connect(os.getenv('DATABASE_URL'))
    return conn

@app.route('/')
def home():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('CREATE TABLE IF NOT EXISTS visits (count integer);')
    cursor.execute('SELECT count FROM visits;')
    result = cursor.fetchone()
    count = result[0] if result else 0
    count += 1
    cursor.execute('DELETE FROM visits;')
    cursor.execute('INSERT INTO visits (count) VALUES (%s);', (count,))
    conn.commit()
    cursor.close()
    conn.close()
    return f'Hello, Azure! Visit count: {count}'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
