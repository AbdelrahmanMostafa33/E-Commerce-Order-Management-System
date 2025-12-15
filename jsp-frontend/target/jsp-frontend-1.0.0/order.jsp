

<html>
<head><title>Order Page</title></head>
<body>
    <h1> Create Order </h1>
    <form action="submitOrder" method="post">
        <label>Customer ID:</label>
        <input type="text" name="customer_id" required><br>
        <label>Product ID:</label>
        <input type="text" name="product_id" required><br>
        <label>Quantity:</label>
        <input type="number" name="quantity" required><br><br>
        <button type="submit">Create Order</button>
    </form>
    <div id="responseMessage"></div>
</body>

</html>
