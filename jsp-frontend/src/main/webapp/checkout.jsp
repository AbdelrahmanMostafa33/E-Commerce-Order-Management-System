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
            width: 60%;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
        }

        h1 {
            text-align: center;
            color: #333;
        }

        .product-row {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
        }

        .product-row input {
            flex: 1;
            padding: 8px;
        }

        button {
            padding: 10px;
            background-color: #28a745;
            border: none;
            color: white;
            cursor: pointer;
            border-radius: 4px;
            font-size: 16px;
            margin-top: 10px;
            width: 100%;
        }

        button:hover {
            background-color: #218838;
        }

        .add-btn {
            background-color: #120c5e;
        }

        .add-btn:hover {
            background-color: #0056b3;
        }
    </style>

    <script>
        function addProductRow() {
            const container = document.getElementById("products");

            const row = document.createElement("div");
            row.className = "product-row";

            row.innerHTML =
                '<input type="number" name="product_id[]" placeholder="Product ID" required>' +
                '<input type="number" name="quantity[]" placeholder="Quantity" required>';

            container.appendChild(row);
        }
    </script>

</head>
<body>

<div class="container">
    <h1>Place Your Order</h1>

    <form action="submitOrder" method="post">

        <label>Customer ID</label>
        <input type="number" name="customer_id" required>

        <h3>Products</h3>

        <div id="products">
            <div class="product-row">
                <input type="number" name="product_id[]" placeholder="Product ID" required>
                <input type="number" name="quantity[]" placeholder="Quantity" required>
            </div>
        </div>

        <button type="button" class="add-btn" onclick="addProductRow()">
            + Add Another Product
        </button>

        <button type="submit">
            Submit Order
        </button>

    </form>
</div>

</body>
</html>
