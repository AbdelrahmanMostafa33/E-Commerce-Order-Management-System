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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style2.css">

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
