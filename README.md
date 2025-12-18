# E-Commerce-Order-Management-System


## project Overview
This project implements an E-Commerce Order Management System using the Service-Oriented Architecture(SOA) principles

The system consists of :
- A Java JSP web application acting as the API Gateway and User Interface
- Five independent python Flask microservices , each responsible for a specific business capability
- RESTFUL communication using JSON over HTTP
- MySQL databases used by multiple services

## System Components

## FRONTEND
- Java JSP pages
- Jakarta Servlets
- Runs on Apache Tomcat
- communicates with backend services via REST APIs

## BACKEND MICROSERVICES
each service :
- Runs independently
- has it's own responsibility 
- communicates via HTTP REST APIs
- Runs on a dedicated port

## Services                      Port
JSP Application(Tomcat) ------>  8080
Order service           ------>  5001
inventory service       ------>  5002
pricing service         ------>  5003
customer service        ------>  5004
notification service    ------>  5005


## Service Interaction Flow

1. User run the project on **index.jsp** the **inventory servlet** is called
2. **inventory servlet** call **inventory service** --> get_all_inventory() on this end point '/api/inventory'
3. all the product catalog is displayed 
4. User clicks on Place order button 
5. User is redirected to **checkout.jsp**
6. User enter the order the customer_id product_id , quantity 
7. User clicks on submit order the **order servlet** calls the **order services**
8. the **order services** validate the input and add created_at field
9. the **order service** calls the8**inventory service** on this endpoint '/api/inventory/check/<int:product_id>'   to check the availabiity of the product and quantity 
10. the **order service** calls the **pricing services** to calculate the total amount of the order on this endpoint '/api/pricing/calculate'
11. the **order services** finally call the **inventory service** again but to update the database after placing the order on this endpoint /api/inventory/update'
12. the user is then redirected to the **confirmation.jsp** with the order confirmation and details

 






# 🛒 E-Commerce Order Management System API Documentation

This document provides detailed API documentation for the backend Flask microservices of the E-Commerce Order Management System.

---

## 1️⃣ Order Service (Port 5001)

**Base URL:** `http://localhost:5001`

### **Create Order**

**POST** `/api/orders/create`

**Request Body:**

```json
{
  "customer_id": 1,
  "product_id": 2,
  "quantity": 3
}
```

**Response:**

```json
{
  "message": "Order created successfully",
  "order_id": 101,
  "product_id": 2,
  "quantity": 3,
  "total_amount": 899.97,
  "status": "CONFIRMED",
  "created_at": "2025-12-18 12:30:00"
}
```

**Errors:**

* 400: Invalid input data / insufficient stock / inventory or pricing failure
* 500: Database error

### **Get Order Details**

**GET** `/api/orders/<int:order_id>`

**Response:**

```json
{
  "order_id": 101,
  "customer_id": 1,
  "product_id": 2,
  "quantity": 3,
  "total_amount": 899.97,
  "status": "CONFIRMED",
  "created_at": "2025-12-18 12:30:00"
}
```

**Errors:**

* 404: Order not found
* 500: Database error

---

## 2️⃣ Inventory Service (Port 5002)

**Base URL:** `http://localhost:5002`

### **Get All Inventory**

**GET** `/api/inventory`

**Response:**

```json
[
  {"product_id":1, "product_name":"Laptop", "quantity_available":50, "unit_price":999.99},
  {...}
]
```

### **Check Inventory**

**GET** `/api/inventory/check/<int:product_id>`

**Response:**

```json
{
  "product_id":2,
  "product_name":"Mouse",
  "quantity_available":200,
  "unit_price":29.99
}
```

**Errors:**

* 404: Product not found

### **Update Inventory**

**PUT** `/api/inventory/update`

**Request Body:**

```json
{
  "product_id": 2,
  "quantity": 3
}
```

**Response:**

```json
{
  "message": "Inventory updated successfully",
  "product_id": 2,
  "quantity_reduced": 3
}
```

**Errors:**

* 400: Invalid input / insufficient stock

---

## 3️⃣ Pricing Service (Port 5003)

**Base URL:** `http://localhost:5003`

### **Home**

**GET** `/`

* Returns service status

**Response:**

```html
<h2>PRICING SERVICE IS RUNNING → Port 5003</h2>
```

### **Calculate Price**

**POST** `/api/pricing/calculate`

**Request Body:**

```json
{
  "product_id": 1,
  "quantity": 2,
  "region": "default"  // optional
}
```

**Response:**

```json
{
  "product_id": 1,
  "quantity": 2,
  "unit_price": 999.99,
  "discount_percentage": 10.0,
  "tax_rate": 14.0,
  "subtotal": 1799.98,
  "total_price": 2051.97
}
```

**Errors:**

* 400: Invalid input data
* 404: Product not found in inventory

## Project Structure
```
Service_Oriented_Architecture_Project/
│├── Frontend/
│   ├── Servlets/
│   │   ├── orderServlet.java
│   │   ├── inventoryServlet.java
│   ├── JSP Files/
│   ├── index.jsp
│   ├── checkout.jsp
│   └── confirmation.jsp
│├── Backend/
│   ├── Services/
│   │   ├── order_service/
│   │   │   ├── app.py
│   │   ├── inventory_service/
│   │   │   ├── app.py
│   │   ├── pricing_service/
│   │   │   ├── app.py
│   │   ├── customer_service/
│   │   │   ├── app.py
│   │   └── notification_service/
│   │       ├── app.py
│   ├── README.md
│   ├── .gitignore
|   |── START_ALL.bat
│   └── ecommerce_system.sql


```
---


## SetUp Instructions

1. Clone Repository
-  git clone   https://github.com/AbdooMatrix/E-Commerce-Order-Management-System
- cd E-Commerce-Order-Management-System


2. DataBase Setup
 - run file --> ecommerce_system.sql

 3. Backend Microservices setup
 - python -m venv venv
 - venv\Scripts\activate
 - pip install flask mysql-connector-python requests
 - click on START_ALL.bat

 4. Frontend Setup
 - open project in intelliJ
 - Add Jakarta EE API
 - Deploy on Apache Tomcat 10 
 - Access http://localhost:8080/jsp_frontend_war_exploded/inventory

