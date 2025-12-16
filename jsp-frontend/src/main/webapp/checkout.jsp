<%--
  Created by IntelliJ IDEA.
  User: dell
  Date: 12/16/2025
  Time: 4:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Checkout</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 50%;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        form label {
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            font-weight: bold;
        }

        form input {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button {
            padding: 10px 20px;
            background-color: #28a745;
            border: none;
            color: white;
            cursor: pointer;
            border-radius: 4px;
            font-size: 16px;
            margin-top: 15px;
            width: 100%;
        }

        button:hover {
            background-color: #218838;
        }
    </style>

</head>
<body>

<div class="container">
    <h1>Place Your Order</h1>

    <form action="submitOrder" method="post">
        <label>Customer ID</label>
        <input type="number" name="customer_id" required>

        <label>Product ID</label>
        <input type="number" name="product_id" required>

        <label>Quantity</label>
        <input type="number" name="quantity" required>

        <button type="submit">Submit Order</button>

    </form>
</div>

</body>
</html>
