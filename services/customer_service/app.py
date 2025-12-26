from flask import Flask, jsonify, request
import mysql.connector
import requests

app = Flask(__name__)

DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '',      
    'database': 'ecommerce_system'
}

@app.route('/')
def home():
    return "<h2>CUSTOMER SERVICE IS RUNNING → Port 5004</h2>"   

ORDER_SERVICE_URL = "http://localhost:5001/api/orders"

def get_db():
    return mysql.connector.connect(**DB_CONFIG)

# Get all customers
@app.route("/api/customers", methods=["GET"])
def get_all_customers():
    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute("SELECT customer_id, name FROM customers")
    customers = cursor.fetchall()

    cursor.close()
    db.close()

    return jsonify(customers)

# Get customer profile
@app.route("/api/customers/<int:customer_id>", methods=["GET"])
def get_customer(customer_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute("SELECT * FROM customers WHERE customer_id=%s", (customer_id,))
    customer = cursor.fetchone()

    cursor.close()
    db.close()

    if not customer:
        return jsonify({"error": "Customer not found"}), 404

    return jsonify(customer)

# Get customer orders (calls Order Service)
@app.route("/api/customers/<int:customer_id>/orders", methods=["GET"])
def get_customer_orders(customer_id):
    db = get_db()
    cursor = db.cursor()

    cursor.execute("SELECT customer_id FROM customers WHERE customer_id=%s", (customer_id,))
    if not cursor.fetchone():
        return jsonify({"error": "Customer not found"}), 404

    cursor.close()
    db.close()

    response = requests.get(f"{ORDER_SERVICE_URL}?customer_id={customer_id}")
    return jsonify(response.json())

# Update loyalty points
@app.route("/api/customers/<int:customer_id>/loyalty", methods=["PUT"])
def update_loyalty(customer_id):
    data = request.json
    points = data.get("points", 0)

    db = get_db()
    cursor = db.cursor()

    cursor.execute("""
        UPDATE customers
        SET loyalty_points = loyalty_points + %s
        WHERE customer_id = %s
    """, (points, customer_id))

    db.commit()
    cursor.close()
    db.close()

    return jsonify({"message": "Loyalty points updated"})
    
if __name__ == "__main__":
    app.run(port=5004)
