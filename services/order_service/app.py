from flask import Flask ,request, jsonify
import mysql.connector ,requests ,datetime
from mysql.connector import Error

app = Flask(__name__)

DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '@Nour123456',      # ← your password
    'database': 'ecommerce_system'  
}

INVENTORY_CHECK_URL = 'http://localhost:5002/api/inventory/check'
INVENTORY_UPDATE_URL = 'http://localhost:5002/api/inventory/update'
PRICING_URL = 'http://localhost:5003/api/pricing/calculate'


def db_conn():
    return mysql.connector.connect(**DB_CONFIG)



@app.route('/')
def home():
    return "<h2>ORDER SERVICE IS RUNNING → Port 5001</h2>"         

@app.route('/db_test')
def test_db():
    try:
        conn = mysql.connector.connect(
            host='localhost',
            user='root',
            password='@Nour123456',      # ← your password
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

@app.route('/api/orders/create', methods=['POST'], strict_slashes=False)
def create_order():
    data = request.get_json()

    try: 
        customer_id = int(data['customer_id'])
        product_id = int(data['product_id'])
        quantity = int(data['quantity'])
       
    except (KeyError, TypeError, ValueError):
        return jsonify({'error': 'Invalid input data'}), 400
    

    #Generate order ID and timestamp
    
    created_at = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


    #check  the inventory
    inv_check_response = requests.get(f"{INVENTORY_CHECK_URL}/{product_id}")
    if inv_check_response.status_code != 200:
        try:
            details = inv_check_response.json()
        except ValueError:
            details = inv_check_response.text
        return jsonify({'error': 'Inventory check failed', 'details': details}), 400
    
    inventory_data = inv_check_response.json()
    if inventory_data['quantity_available'] < quantity:
        return jsonify({'error': 'Insufficient stock in inventory', 'available_quantity': inventory_data['quantity_available']}), 400

    #Calculate pricing
    pricing_response = requests.post(PRICING_URL, json={
        'product_id': product_id,
        'quantity': quantity})
    if pricing_response.status_code != 200:
        try:
            details = pricing_response.json()
        except ValueError:
            details = pricing_response.text
        return jsonify({'error': 'Pricing calculation failed', 'details': details}), 400
    

    pricing_data = pricing_response.json()
    total_amount = pricing_data['total_price']

    #save the created order to db
    conn = db_conn()
    try:
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO orders (customer_id, product_id, quantity, total_amount, status, created_at) "
            "VALUES (%s, %s, %s, %s, %s, %s)",
            (customer_id, product_id, quantity, total_amount, 'CONFIRMED', created_at)
        )
        order_id = cur.lastrowid


        conn.commit()
    except Error as e:
        conn.rollback()
        return jsonify({'error': 'Database error', 'details': str(e)}), 500
    finally:
        conn.close()
    
    #Update inventory
    inv_update_response = requests.put(INVENTORY_UPDATE_URL, json={
        'product_id': product_id,
        'quantity': quantity
    })

    if inv_update_response.status_code != 200:
        
        try:
            details = inv_update_response.json()
        except ValueError:
            details = inv_update_response.text

        return jsonify({
            'error': 'Inventory update failed',
            'details': details
        }), 400


    return jsonify({
        'message': 'Order created successfully',
        'order_id': order_id,
        'product_id': product_id,
        'quantity': quantity,
        'total_amount': total_amount,
        'status': 'CONFIRMED',
        'created_at': created_at
    }), 201


@app.route('/api/orders/<int:order_id>', methods=['GET'])
def get_order(order_id):
    conn = db_conn()
    try:
        cur = conn.cursor(dictionary=True)
        cur.execute("SELECT * FROM orders WHERE order_id = %s", (order_id,))
        order = cur.fetchone()
        if not order:
            return jsonify({'error': 'Order not found'}), 404
        
    except Error as e:
        return jsonify({'error': 'Database error', 'details': str(e)}), 500
    finally:
        conn.close()
    
    return jsonify(order), 200



if __name__ == '__main__':
    print(app.url_map)
    app.run(port=5001, debug=True)    