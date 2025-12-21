/* ===============================
   DATABASE
================================ */
DROP DATABASE IF EXISTS ecommerce_system;
CREATE DATABASE ecommerce_system
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

USE ecommerce_system;

/* ===============================
   CUSTOMERS
================================ */
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  customer_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  phone VARCHAR(20),
  loyalty_points INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (customer_id),
  UNIQUE KEY email (email)
) ENGINE=InnoDB;

INSERT INTO customers (customer_id, name, email, phone, loyalty_points, created_at) VALUES
(1,'Ahmed Hassan','ahmed@example.com','01012345678',100,'2025-11-25 19:05:48'),
(2,'Sara Mohamed','sara@example.com','01098765432',250,'2025-11-25 19:05:48'),
(3,'Omar Ali','omar@example.com','01055555555',50,'2025-11-25 19:05:48');

/* ===============================
   INVENTORY
================================ */
DROP TABLE IF EXISTS inventory;

CREATE TABLE inventory (
  product_id INT NOT NULL AUTO_INCREMENT,
  product_name VARCHAR(100) NOT NULL,
  quantity_available INT NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (product_id)
) ENGINE=InnoDB;

INSERT INTO inventory (product_id, product_name, quantity_available, unit_price, last_updated) VALUES
(1,'Laptop',50,999.99,'2025-11-25 19:05:40'),
(2,'Mouse',200,29.99,'2025-11-25 19:05:40'),
(3,'Keyboard',150,79.99,'2025-11-25 19:05:40'),
(4,'Monitor',75,299.99,'2025-11-25 19:05:40'),
(5,'Headphones',100,149.99,'2025-11-25 19:05:40');

INSERT INTO inventory (product_id, product_name, quantity_available, unit_price, last_updated) VALUES
(6,'screen',300,200,'2025-11-25 19:05:40')
/* ===============================
   NOTIFICATION LOG
================================ */
DROP TABLE IF EXISTS notification_log;

CREATE TABLE notification_log (
  notification_id INT NOT NULL AUTO_INCREMENT,
  order_id INT NOT NULL,
  customer_id INT NOT NULL,
  notification_type VARCHAR(50),
  message TEXT,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (notification_id)
) ENGINE=InnoDB;

/* ===============================
   PRICING RULES
================================ */
DROP TABLE IF EXISTS pricing_rules;

CREATE TABLE pricing_rules (
  rule_id INT NOT NULL AUTO_INCREMENT,
  product_id INT,
  min_quantity INT,
  discount_percentage DECIMAL(5,2),
  PRIMARY KEY (rule_id)
) ENGINE=InnoDB;

INSERT INTO pricing_rules (rule_id, product_id, min_quantity, discount_percentage) VALUES
(1,1,5,10.00),
(2,2,10,15.00),
(3,3,10,12.00);

INSERT INTO pricing_rules (rule_id, product_id, min_quantity, discount_percentage) VALUES
(4,6,5,50.00)

/* ===============================
   TAX RATES
================================ */
DROP TABLE IF EXISTS tax_rates;

CREATE TABLE tax_rates (
  region VARCHAR(50) NOT NULL,order_itemscustomers
  tax_rate DECIMAL(5,2),
  PRIMARY KEY (region)
) ENGINE=InnoDB;
INSERT INTO tax_rates (region, tax_rate) VALUES
('CA', 7.25),
('NY', 8.875),
('DEFAULT', 5.00);

/* ===============================
  Orders
================================ */
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  total_amount DECIMAL(12,2),
  status VARCHAR(30),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
) ENGINE=InnoDB;


CREATE TABLE order_items (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(10,2),
  total_price DECIMAL(12,2),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES inventory(product_id)
) ENGINE=InnoDB;



select * From inventory;

select * FROM orders;

SELECT * FROM customers WHERE customer_id = 1;
