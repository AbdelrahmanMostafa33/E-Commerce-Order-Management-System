<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.json.JSONObject" %>

<%
    JSONObject customer = (JSONObject) request.getAttribute("customer");
%>

<html>
<head>
    <title>Customer Profile</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f6f8; margin:0; padding:0; }
        .container { width: 50%; margin: 40px auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { margin-top: 0; }
        p { font-size: 16px; line-height: 1.5; }
        a.button { padding:10px 20px; background-color:#120c5e; color:white; border:none; border-radius:4px; cursor:pointer; text-decoration:none; display:inline-block; margin-top:15px; }
    </style>
</head>
<body>
<div class="container">
    <h2>Customer Profile</h2>
    <p><b>ID:</b> <%= customer.getInt("customer_id") %></p>
    <p><b>Name:</b> <%= customer.getString("name") %></p>
    <p><b>Loyalty Points:</b> <%= customer.optInt("loyalty_points", 0) %></p>

    <a href="index.jsp" class="button">⬅ Back</a>
</div>
</body>
</html>
