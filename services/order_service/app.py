from flask import Flask
import mysql.connector
from mysql.connector import Error

app = Flask(__name__)

@app.route('/')
def home():
    return "<h2>ORDER SERVICE IS RUNNING → Port 5001</h2>"         

@app.route('/db_test')
def test_db():
    try:
        conn = mysql.connector.connect(
            host='localhost',
            user='root',
            password='Matrix@1610',      # ← your password
            database='ecommerce_system'
        )
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM customers;")
        count = cursor.fetchone()[0]     # ← this gets the number
        conn.close()
        
        return f"""
        <h1 style='color:green'>DB CONNECTION SUCCESSFUL!</h1>
        <h2>Number of customers in database: <strong>{count}</strong></h2>
        """
    
    except Exception as e:
        return f"<h1 style='color:red'>DB CONNECTION FAILED</h1><p>Error: {e}</p>"

if __name__ == '__main__':
    app.run(port=5001, debug=True)                          