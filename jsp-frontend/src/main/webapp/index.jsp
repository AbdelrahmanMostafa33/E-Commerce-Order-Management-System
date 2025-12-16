<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
        List<Map<String ,Object>> products =(List<Map<String, Object>>) request.getAttribute("products");
        if (products == null) {
            response.sendRedirect("inventory");
            return;
        }
%>
<html>
<head>
    <meta charset="UTF-8">
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
            align-content: center;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        table th, table td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }

        button {
            padding: 10px 20px;
            background-color: #120c5e;
            border: none;
            color: white;
            cursor: pointer;
            border-radius: 4px;
            font-size: 16px;
            width: 60%;
            align-content: center;
            display: block;
            margin: 20px auto 0 auto;
        }

        button:hover {
            background-color: #0056b3;
        }

        input, select {
            padding: 8px;
            width: 100%;
            margin-bottom: 10px;
        }

        p {
            text-align: center;
            font-style: italic;
        }
    </style>


</head>
<body>
<div class ="container">
    <h1>Available Products</h1>

    <%
        if (products.isEmpty()){
    %>
    <p>No products available.</p>
    <%
        }else {

        %>
        <table>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Price</th>
                <th>Quantity</th>
            </tr>
            <%
                for (Map<String, Object> product : products) {
            %>
            <tr>
                <td><%= product.get("id") %></td>
                <td><%= product.get("name") %></td>
                <td><%= product.get("price") %></td>
                <td><%= product.get("quantity_available") %></td>
            </tr>
            <% } %>
        </table>
    <% } %>
    <br>
    <form action="checkout.jsp" method="get">
        <button type="submit">Place Order</button>
    </form>


</div>
</body>
</html>

