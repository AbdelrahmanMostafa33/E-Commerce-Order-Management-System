from flask import Flask ,request, jsonify
import mysql.connector ,requests ,datetime
from mysql.connector import Error

app = Flask(__name__)

DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '',     
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


@app.route('/api/orders', methods=['GET'])
def get_orders_by_customer():
    customer_id = request.args.get('customer_id')

    if not customer_id:
        return jsonify({'error': 'customer_id is required'}), 400

    conn = db_conn()
    try:
        cur = conn.cursor(dictionary=True)

        cur.execute("""
            SELECT order_id, total_amount, status, created_at
            FROM orders
            WHERE customer_id = %s
            ORDER BY created_at DESC
        """, (customer_id,))

        orders = cur.fetchall()

        return jsonify(orders), 200

    except Error as e:
        return jsonify({'error': 'Database error', 'details': str(e)}), 500

    finally:
        conn.close()       



@app.route('/api/orders/create', methods=['POST'], strict_slashes=False)
def create_order():
    data = request.get_json()

    try: 
        customer_id = int(data['customer_id'])
        products = data['products']
        if not isinstance(products, list) or len(products) == 0:
            raise ValueError("Products must be a non-empty list")

       
    except (KeyError, TypeError, ValueError):
        return jsonify({'error': 'Invalid input data'}), 400
    

    #Generate order ID and timestamp
    
    created_at = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    total_amount = 0
    order_items = []


    for item in products:
        try:
            product_id = int(item['product_id'])
            quantity = int(item['quantity'])
        except (KeyError, TypeError, ValueError):
            return jsonify({'error': 'Invalid product data'}), 400
        
        #check  the inventory
        inv_check_response = requests.get(f"{INVENTORY_CHECK_URL}/{product_id}")
        if inv_check_response.status_code != 200:
            return jsonify({'error': f'Product {product_id} not found'}), 404
        
        inventory_data = inv_check_response.json()
        if inventory_data['quantity_available'] < quantity:
            return jsonify({'error': 'Insufficient stock in inventory', 'product_id': product_id ,'available_quantity': inventory_data['quantity_available']}), 400

        #Calculate pricing
        pricing_response = requests.post(PRICING_URL, json={
            'product_id': product_id,
            'quantity': quantity})
        if pricing_response.status_code != 200:
            return jsonify({'error': 'Pricing calculation failed'}), 400
        

        pricing_data = pricing_response.json()
        total_amount += pricing_data['total_price']

        order_items.append({
            'product_id': product_id,
            'quantity': quantity,
            'unit_price': pricing_data['unit_price'],
            'total_price': pricing_data['total_price']
        })

    #save the created order to db
    conn = db_conn()
    try:
        cur = conn.cursor()
        # Insert order header
        cur.execute(
            """INSERT INTO orders (customer_id, total_amount, status, created_at)
               VALUES (%s, %s, %s, %s)""",
            (customer_id, total_amount, 'CONFIRMED', created_at)
        )
        order_id = cur.lastrowid

        # Insert order items
        for item in order_items:
            cur.execute(
                """INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price)
                   VALUES (%s, %s, %s, %s, %s)""",
                (order_id, item['product_id'], item['quantity'], item['unit_price'], item['total_price'])
            )


        conn.commit()
    except Error as e:
        conn.rollback()
        return jsonify({'error': 'Database error', 'details': str(e)}), 500
    finally:
        conn.close()
    
    #Update inventory
    for item in order_items:
        requests.put(INVENTORY_UPDATE_URL, json={
            'product_id': item['product_id'],
            'quantity': item['quantity']
        })

    # -------------------------------
    # Send notification to customer
    # -------------------------------
    NOTIFICATION_URL = 'http://localhost:5005/api/notifications/send'

    try:
        requests.post(NOTIFICATION_URL, json={
            'order_id': order_id,
            'customer_id': customer_id
        })
    except Exception as e:
        # Log error, but don't fail the order
        print(f"Notification failed: {e}")


    # -------------------------------
    # Update loyalty points
    # -------------------------------
    LOYALTY_URL = f"http://localhost:5004/api/customers/{customer_id}/loyalty"

    # Rule: 1 point per $10 spent
    loyalty_points = int(total_amount // 10)

    try:
        requests.put(LOYALTY_URL, json={
            "points": loyalty_points
        })
    except Exception as e:
        print(f"Loyalty update failed: {e}")


    return jsonify({
        'message': 'Order created successfully',
        'order_id': order_id,
        'customer_id': customer_id,
        'items': order_items,
        'total_amount': total_amount,
        'status': 'CONFIRMED',
        'created_at': created_at
    }), 201


@app.route('/api/orders/<int:order_id>', methods=['GET'])
def get_order(order_id):
    conn = db_conn()
    try:
        cur = conn.cursor(dictionary=True)
        # Order header
        cur.execute("SELECT * FROM orders WHERE order_id = %s", (order_id,))
        order = cur.fetchone()
        if not order:
            return jsonify({'error': 'Order not found'}), 404
        
        # Order items
        cur.execute(
            """SELECT oi.product_id, i.product_name, oi.quantity,
                      oi.unit_price, oi.total_price
               FROM order_items oi
               JOIN inventory i ON oi.product_id = i.product_id
               WHERE oi.order_id = %s""",
            (order_id,)
        )
        order_items = cur.fetchall()
        order['items'] = order_items
              
    except Error as e:
        return jsonify({'error': 'Database error', 'details': str(e)}), 500
    finally:
        conn.close()
    
    return jsonify(order), 200



if __name__ == '__main__':
    print(app.url_map)
    app.run(port=5001, debug=True)    