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
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 70%;
            max-width: 900px;
            margin: 40px auto;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #0d1b4c; /* dark blue */
            margin: 20px 0;
            text-align: center;
            font-weight:700;
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
            background-color: #0d1b4c; /* dark blue */
            color: #fff;
            font-weight: 500;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #e6f0ff;
        }

        /* Back button larger */
        a.back {
            display: inline-block;
            font-size: 18px;
            font-weight: bold;
            padding: 12px 25px;
            background-color: #0d1b4c;
            color: #fff;
            border-radius: 8px;
            text-decoration: none;
            margin-bottom: 20px;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        a.back:hover {
            background-color: #1a2b66;
            transform: translateY(-2px);
        }

        /* Total price aligned right */
        .total {
            font-weight: bold;
            font-size: 23px;
            text-align: right;
            margin-top: 20px;
            margin-bottom: 20px;
        }

        /* Confirm order button centered */
        form {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }

        button {
            padding: 12px 25px;
            background-color: #0d1b4c;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        button:hover {
            background-color: #1a2b66;
            transform: translateY(-2px);
        }

        /* Responsive adjustments */
        @media (max-width: 600px) {
            table, th, td {
                font-size: 14px;
            }

            a.back, button {
                width: 100%;
                text-align: center;
            }

            .total {
                text-align: center;
            }
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
