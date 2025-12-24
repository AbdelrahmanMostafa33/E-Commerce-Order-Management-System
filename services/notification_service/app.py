from flask import Flask, request, jsonify
import mysql.connector
import requests

app = Flask(__name__)

DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "@Nour123456",
    "database": "ecommerce_system"
}

@app.route('/')
def home():
    return "<h2>NOTIFICATION SERVICE IS RUNNING → Port 5005</h2>"   

CUSTOMER_SERVICE = "http://localhost:5004/api/customers"
INVENTORY_SERVICE = "http://localhost:5002/api/inventory/check"

def get_db():
    return mysql.connector.connect(**DB_CONFIG)

@app.route("/api/notifications/send", methods=["POST"])
def send_notification():
    data = request.json
    order_id = data["order_id"]
    customer_id = data["customer_id"]

    # 1️⃣ Get customer info
    customer = requests.get(f"{CUSTOMER_SERVICE}/{customer_id}").json()

    # 2️⃣ Simulated inventory call (example)
    inventory_status = "All items available"

    message = f"Your order #{order_id} is confirmed. {inventory_status}"

    # 3️⃣ Simulate email
    print(f"EMAIL SENT TO: {customer['email']}")
    print(f"Subject: Order #{order_id} Confirmed")
    print(f"Body: {message}")

    # 4️⃣ Log notification
    db = get_db()
    cursor = db.cursor()

    cursor.execute("""
        INSERT INTO notification_log (order_id, customer_id, notification_type, message)
        VALUES (%s, %s, %s, %s)
    """, (order_id, customer_id, "EMAIL", message))

    db.commit()
    cursor.close()
    db.close()

    return jsonify({"message": "Notification sent successfully"})

if __name__ == "__main__":
    app.run(port=5005)
