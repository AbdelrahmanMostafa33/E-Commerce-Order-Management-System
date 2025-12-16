package com.automation.jspfrontend.controllers;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.net.URI;
import java.net.http.*;

@WebServlet("/submitOrder")
public class OrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String customerId = request.getParameter("customer_id");
        String productId = request.getParameter("product_id");
        String quantity = request.getParameter("quantity");

        String jsonPayload = String.format("{\"customer_id\":%s,\"product_id\":%s,\"quantity\":%s}",customerId, productId, quantity);

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest orderRequest = HttpRequest.newBuilder()
                .uri(URI.create("http://localhost:5001/api/orders/create"))
                .header("Content-Type","application/json")
                .POST(HttpRequest.BodyPublishers.ofString(jsonPayload))
                .build();

        try{
            HttpResponse<String> orderResponse = client.send(orderRequest,HttpResponse.BodyHandlers.ofString());
            request.setAttribute("orderResponse",orderResponse.body());
            request.getRequestDispatcher("confirmation.jsp").forward(request,response);
        }catch(InterruptedException e){
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

    }
}
