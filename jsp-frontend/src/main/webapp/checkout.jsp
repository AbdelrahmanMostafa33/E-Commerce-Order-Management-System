<%@ page import="org.json.JSONArray, org.json.JSONObject" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // JSON string of items passed from servlet
    String itemsStr = (String) request.getAttribute("items"); 
    JSONArray items = new JSONArray(itemsStr);
    double total = (double) request.getAttribute("total");
    String customerId = (String) request.getAttribute("customerId");
%>

<html>
<head>
    <title>Order Review</title>
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

        h2 {
            margin-top: 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th, td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }

        th {
            background-color: #f0f0f0;
        }

        button {
            padding: 10px 20px;
            background-color: #120c5e;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
        }

        .total {
            font-weight: bold;
            font-size: 18px;
            margin-bottom: 20px;
        }

        a.back {
            display: inline-block;
            margin-bottom: 20px;
            text-decoration: none;
            color: #120c5e;
            font-weight: bold;
        }

        a.back:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <a href="index.jsp" class="back">⬅ Back</a>
    <h2>Order Review</h2>

    <table>
        <tr>
            <th>Product ID</th>
            <th>Quantity</th>
            <th>Price</th>
        </tr>
        <%
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
        %>
        <tr>
            <td><%= item.getInt("product_id") %></td>
            <td><%= item.getInt("quantity") %></td>
            <td>$<%= String.format("%.2f", item.getDouble("price")) %></td>
        </tr>
        <%
            }
        %>
    </table>

    <p class="total">Total: $<%= String.format("%.2f", total) %></p>

    <form action="submitOrder" method="post">
        <input type="hidden" name="customer_id" value="<%= customerId %>">

        <%
            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
        %>
        <input type="hidden" name="product_id[]" value="<%= item.getInt("product_id") %>">
        <input type="hidden" name="quantity[]" value="<%= item.getInt("quantity") %>">
        <%
            }
        %>

        <button type="submit">Confirm Order</button>
    </form>
</div>
</body>
</html>
