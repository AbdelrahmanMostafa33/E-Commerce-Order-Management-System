from flask import Flask ,request, jsonify
import mysql.connector ,requests

app = Flask(__name__)

DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '@Nour123456',      # ← your password
    'database': 'ecommerce_system'  
}

INVENTORY_URL = 'http://localhost:5002/api/inventory/check/{product_id}'

@app.route('/')
def home():
    return "<h2>PRICING SERVICE IS RUNNING → Port 5003</h2>"  


def db_conn():
    return mysql.connector.connect(**DB_CONFIG)


@app.route('/api/pricing/calculate', methods=['POST'])
def calculate_price():
    data = request.get_json()
    
    try:
        product_id = int(data['product_id'])
        quantity = int(data['quantity'])
    except (KeyError, TypeError, ValueError):
        return jsonify({"error": "Invalid input data"}), 400
    

    inv_response = requests.get(INVENTORY_URL.format(product_id=product_id))
    if inv_response.status_code != 200:
         return jsonify({"error": f"Product ID {product_id} not found in inventory"}), 404
        
    product = inv_response.json()
    base_price = float(product['unit_price'])


    conn = db_conn()

    try:
        cursor = conn.cursor()
        cursor.execute(
                "SELECT discount_percentage FROM pricing_rules WHERE product_id=%s AND min_quantity<=%s",
                (product_id, quantity)
            )
        rule = cursor.fetchone()
        discount = float(rule["discount_percentage"]) if rule else 0
    finally:
            cursor.close()
            conn.close()
        
    subtotal = base_price * quantity* (1 - discount / 100)
 
    return jsonify({
        'product_id': product_id,
        'quantity': quantity,
        'unit_price': base_price,
        'discount_percentage': discount,
        'total_price': round(subtotal, 2)
    }), 200


if __name__ == '__main__':
    app.run(port=5003, debug=True)                          