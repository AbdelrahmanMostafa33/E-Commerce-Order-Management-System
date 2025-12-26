from flask import Flask, request, jsonify
import mysql.connector
import requests
import datetime

app = Flask(__name__)

# Database configuration
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '@Nour123456', 
    'database': 'ecommerce_system'
}

# Service URLs
CUSTOMER_SERVICE = "http://localhost:5004/api/customers"
INVENTORY_SERVICE = "http://localhost:5002/api/inventory/check"

# Helper function to get DB connection
def get_db():
    return mysql.connector.connect(**DB_CONFIG)

@app.route('/')
def home():
    return "<h2>NOTIFICATION SERVICE IS RUNNING → Port 5005</h2>"

@app.route("/api/notifications/send", methods=["POST"])
def send_notification():
    """
    Receives an order_id and customer_id from Order Service,
    fetches customer contact info, checks inventory status,
    sends a simulated notification, logs it to DB, and returns success.
    """
    try:
        data = request.json
        order_id = data["order_id"]
        customer_id = data["customer_id"]

  
        # Get customer info
        customer_resp = requests.get(f"{CUSTOMER_SERVICE}/{customer_id}")
        if customer_resp.status_code != 200:
            return jsonify({"error": "Customer not found"}), 404

        customer = customer_resp.json()
        customer_email = customer.get("email", "no-email@example.com")
        customer_phone = customer.get("phone", "N/A")

  
        # Check inventory for order items
        inventory_status = "All items available"

        # Generate notification message
        message = (
            f"Hello {customer.get('name', 'Customer')},\n"
            f"Your order #{order_id} is confirmed!\n"
            f"Inventory status: {inventory_status}\n"
            f"Thank you for shopping with us."
        )

     
        # Simulate sending email/SMS
        print(f"EMAIL TO: {customer_email}")
        print(f"SMS TO: {customer_phone}")
        print(f"Message:\n{message}")


        # Log notification to database
        db = get_db()
        cursor = db.cursor()

        cursor.execute("""
            INSERT INTO notification_log
            (order_id, customer_id, notification_type, message, sent_at)
            VALUES (%s, %s, %s, %s, NOW())
        """, (order_id, customer_id, "EMAIL+SMS", message))

        db.commit()
        cursor.close()
        db.close()

        # Return success
        return jsonify({"message": "Notification sent successfully"})

    except KeyError:
        return jsonify({"error": "Missing required fields: order_id, customer_id"}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(port=5005, debug=True)
