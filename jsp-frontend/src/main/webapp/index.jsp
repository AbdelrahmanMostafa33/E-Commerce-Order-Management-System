<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Map<String, Object>> products = (List<Map<String, Object>>) request.getAttribute("products");
    List<Map<String, Object>> customers = (List<Map<String, Object>>) request.getAttribute("customers");

    if (products == null || customers == null) {
        response.sendRedirect("inventory");
        return;
    }
%>

<html>
<head>
    <title>Available Products</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 70%;
            margin: 40px auto;
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }

        button {
            padding: 10px 20px;
            background-color: #120c5e;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 15px;
        }

        select, input {
            padding: 8px;
            width: 100%;
        }
    </style>
</head>

<body>

<div class="container">

    <h2>Select Customer</h2>
    <select id="customerSelect" name="customer_id" form="orderForm" required>
        <option value="">-- Select Customer --</option>
        <% for (Map<String, Object> c : customers) { %>
            <option value="<%= c.get("id") %>">
                <%= c.get("name") %> (ID: <%= c.get("id") %>)
            </option>
        <% } %>
    </select>

    <form id="orderForm" action="checkout" method="post">

        <h2>Available Products</h2>

        <table>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Price</th>
                <th>Available</th>
                <th>Quantity</th>
            </tr>

            <% for (Map<String, Object> product : products) { %>
            <tr>
                <td><%= product.get("id") %></td>
                <td><%= product.get("name") %></td>
                <td><%= product.get("price") %></td>
                <td><%= product.get("quantity_available") %></td>
                <td>
                    <input type="number"
                           name="quantity[]"
                           min="0"
                           max="<%= product.get("quantity_available") %>">
                    <input type="hidden" name="product_id[]" value="<%= product.get("id") %>">
                </td>
            </tr>
            <% } %>
        </table>

        <button type="submit">Place Order</button>
    </form>

    <br>

    <!-- PROFILE + HISTORY BUTTONS -->
    <form action="profile" method="get">
        <input type="hidden" name="customer_id" id="profileCustomerId">
        <button type="submit">View Profile</button>
    </form>

    <form action="order-history" method="get">
        <input type="hidden" name="customer_id" id="historyCustomerId">
        <button type="submit">View Order History</button>
    </form>

</div>

<script>
    const customerSelect = document.getElementById("customerSelect");

    customerSelect.addEventListener("change", function () {
        document.getElementById("profileCustomerId").value = this.value;
        document.getElementById("historyCustomerId").value = this.value;
    });
</script>

</body>
</html>
