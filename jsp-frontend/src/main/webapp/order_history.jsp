<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.json.JSONArray, org.json.JSONObject" %>

<%
    JSONArray orders = (JSONArray) request.getAttribute("orders");
    String customerId = (String) request.getAttribute("customerId");
%>

<html>
<head>
    <title>Order History</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f6f8; margin:0; padding:0; }
        .container { width: 70%; margin: 40px auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { margin-top: 0; }
        .order-card { border:1px solid #ddd; border-radius:6px; padding:15px; margin-bottom:15px; background:#fafafa; }
        a.button, button { padding:10px 20px; background-color:#120c5e; color:white; border:none; border-radius:4px; cursor:pointer; text-decoration:none; display:inline-block; margin-top:15px; }
    </style>
</head>
<body>
<div class="container">
    <h2>Order History</h2>
    <a href="index.jsp" class="button">⬅ Back</a>
    <br><br>

    <%
        if (orders == null || orders.length() == 0) {
    %>
        <p>No orders found.</p>
    <%
        } else {
            for (int i = 0; i < orders.length(); i++) {
                JSONObject o = orders.getJSONObject(i);
    %>
                <div class="order-card">
                    <b>Order ID:</b> <%= o.getInt("order_id") %><br>
                    <b>Total:</b> <%= o.get("total_amount") %><br>
                    <b>Status:</b> <%= o.getString("status") %><br>
                    <b>Date:</b> <%= o.getString("created_at") %>
                </div>
    <%
            }
        }
    %>
</div>
</body>
</html>
