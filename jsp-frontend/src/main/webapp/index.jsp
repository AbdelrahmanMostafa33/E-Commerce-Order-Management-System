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
    <link rel="stylesheet" href="css/style2.css">


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
                <th>Quantity Available</th>
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

