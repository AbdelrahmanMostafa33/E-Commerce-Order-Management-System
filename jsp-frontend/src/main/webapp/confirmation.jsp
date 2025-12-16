<%--
  Created by IntelliJ IDEA.
  User: dell
  Date: 12/16/2025
  Time: 5:07 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Order Confirmation</title>
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
            text-align: center;
        }

        h1 {
            color: #28a745;
            margin-bottom: 10px;
        }

        h3 {
            color: #333;
            margin-bottom: 20px;
        }

        pre {
            background-color: #f1f1f1;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
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
            margin-top: 20px;
        }

        button:hover {
            background-color: #0056b3;
        }

        a {
            text-decoration: none;
        }
    </style>


</head>
<body>

<div class="container">
    <h1>Order Confirmed</h1>
    <h3>Order Details</h3>

    <pre>
        <%=request.getAttribute("orderResponse")%>
    </pre>

    <a href="inventory">
        <button>Back to Products</button>
    </a>

</div>

</body>
</html>
