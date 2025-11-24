# services/inventory_service/app.py

from flask import Flask, jsonify, request
import mysql.connector

app = Flask(__name__)

# Use your real database credentials
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'Omar@11122002',
    'database': 'ecommerce_system',
    'port': 3306
}


# -----------------------------
# Database Connection Function
# -----------------------------
def db_conn():
    return mysql.connector.connect(**DB_CONFIG)


# -----------------------------
# Home Route (to test server)
# -----------------------------
@app.route("/")
def home():
    return "Inventory Service Running"


# -----------------------------
# DB Test Route
# -----------------------------
@app.route("/db_test")
def db_test():
    try:
        conn = db_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM inventory")
        result = cursor.fetchone()
        return jsonify({"inventory_count": result[0]})
    except mysql.connector.Error as err:
        return jsonify({"error": str(err)})
    finally:
        conn.close()


# -----------------------------
# Run Server
# -----------------------------
if __name__ == "__main__":
    app.run(port=5002, debug=True)
