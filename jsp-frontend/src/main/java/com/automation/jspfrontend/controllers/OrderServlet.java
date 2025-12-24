package com.automation.jspfrontend.controllers;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.http.*;

@WebServlet("/submitOrder")
public class OrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String customerId = request.getParameter("customer_id");
        String[] productIds = request.getParameterValues("product_id[]");
        String[] quantities = request.getParameterValues("quantity[]");

        if (productIds == null || quantities == null || productIds.length != quantities.length) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product data");
            return;
        }

        // Build products JSON array
        StringBuilder productsJson = new StringBuilder("[");
        for (int i = 0; i < productIds.length; i++) {
            productsJson.append("{")
                    .append("\"product_id\":").append(productIds[i]).append(",")
                    .append("\"quantity\":").append(quantities[i])
                    .append("}");
            if (i < productIds.length - 1) {
                productsJson.append(",");
            }
        }
        productsJson.append("]");

        String jsonPayload =
                "{ \"customer_id\": " + customerId + "," +
                        "  \"products\": " + productsJson + " }";
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

        // Update loyalty
        URL loyaltyUrl = new URL("http://localhost:5004/api/customers/" + customerId + "/loyalty");
        HttpURLConnection loyaltyCon = (HttpURLConnection) loyaltyUrl.openConnection();
        loyaltyCon.setRequestMethod("PUT");
        loyaltyCon.setDoOutput(true);
        loyaltyCon.getOutputStream().write("{\"points\":10}".getBytes());

        // Send notification
        URL notifyUrl = new URL("http://localhost:5005/api/notifications/send");
        HttpURLConnection notifyCon = (HttpURLConnection) notifyUrl.openConnection();
        notifyCon.setRequestMethod("POST");
        notifyCon.setDoOutput(true);
        String orderId = null;
        notifyCon.getOutputStream().write(
            ("{\"order_id\":" + orderId + ",\"customer_id\":" + customerId + "}").getBytes()
        );


    }
}
