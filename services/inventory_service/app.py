from flask import Flask ,request, jsonify
import mysql.connector 

app = Flask(__name__)

DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '',      # ← your password
    'database': 'ecommerce_system'  
}

@app.route('/')
def home():
    return "<h2>INVENTORY SERVICE IS RUNNING → Port 5002</h2>"   


def db_conn():
    return mysql.connector.connect(**DB_CONFIG)


@app.route('/api/inventory', methods=['GET'])
def get_all_inventory():
    conn = db_conn()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM inventory")
    products = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(products),200

@app.route('/api/inventory/check/<int:product_id>', methods=['GET'])
def check_inventory(product_id):
    conn = db_conn()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM inventory WHERE product_id = %s", (product_id,))
    product = cursor.fetchone()
    cursor.close()
    conn.close()

    if not product:
        return jsonify({"error": "Product not found"}), 404
    return jsonify(product)

@app.route('/api/inventory/update', methods=['PUT'])
def update_inventory():
    data = request.get_json()
    
    try:
        product_id = int(data['product_id'])
        quantity = int(data['quantity'])
    except (KeyError, TypeError, ValueError):
        return jsonify({"error": "Invalid input data"}), 400
   

    conn = db_conn()
    try:
       cursor = conn.cursor()
       cursor.execute("SELECT quantity_available FROM inventory WHERE product_id = %s", (product_id,))
       row = cursor.fetchone()
       if not row or row[0] <quantity:
            return jsonify({"error": f"Insufficient stock for product_id {product_id}"}), 400
        
       cursor.execute("UPDATE inventory SET quantity_available = quantity_available - %s WHERE product_id = %s", (quantity, product_id))
       conn.commit()
    finally:
       cursor.close()
       conn.close()
    
    return jsonify({
        "message": "Inventory updated successfully",
        "product_id": product_id,
        "quantity_reduced": quantity
    }), 200



if __name__ == '__main__':
    app.run(port=5002, debug=True)                          
