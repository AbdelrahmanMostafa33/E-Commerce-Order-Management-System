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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style2.css">

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
