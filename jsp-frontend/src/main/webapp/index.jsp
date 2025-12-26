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
    <style>
        /* General page styling */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            color: #333;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 30px;
            background-color: #ffffff;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            text-align: center; /* Center all content */
        }

        h2 {
            color: #0d1b4c; /* darker blue */
            margin-bottom: 15px;
            font-weight: 600;
        }

        select, input[type="number"] {
            padding: 8px 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
            width: 80%;
            max-width: 400px;
            box-sizing: border-box;
            margin-bottom: 20px;
        }

        select:focus, input[type="number"]:focus {
            outline: none;
            border-color: #0d1b4c;
            box-shadow: 0 0 5px rgba(13, 27, 76, 0.4);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        th, td {
            text-align: left;
            padding: 12px 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        th {
            background-color: #0d1b4c; /* darker blue */
            color: #fff;
            font-weight: 500;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #e6f0ff;
        }

        button {
            background-color: #0d1b4c; /* darker blue */
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            cursor: pointer;
            margin: 5px;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        button:hover {
            background-color: #1a2b66;
            transform: translateY(-2px);
        }

        button:disabled {
            background-color: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        /* Button container for side-by-side layout */
        .button-group {
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        /* Responsive tweaks */
        @media (max-width: 600px) {
            th, td {
                padding: 8px 10px;
            }

            select, input[type="number"] {
                width: 100%;
            }
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
