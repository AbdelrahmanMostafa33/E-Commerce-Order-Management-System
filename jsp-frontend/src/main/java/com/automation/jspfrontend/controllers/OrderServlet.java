package com.automation.jspfrontend.controllers;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.net.URI;
import java.net.http.*;
import java.util.Arrays;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/submitOrder")
public class OrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String customerId = request.getParameter("customer_id");
        String[] productIds = request.getParameterValues("product_id[]");
        String[] quantities = request.getParameterValues("quantity[]");

        // Validate input
        if (customerId == null || productIds == null || quantities == null || productIds.length != quantities.length) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order data");
            return;
        }

        System.out.println("DEBUG customerId=" + customerId);
        System.out.println("DEBUG productIds=" + Arrays.toString(productIds));
        System.out.println("DEBUG quantities=" + Arrays.toString(quantities));

        HttpClient client = HttpClient.newHttpClient();
        JSONArray productsArray = new JSONArray();

        for (int i = 0; i < productIds.length; i++) {
            try {
                int productId = Integer.parseInt(productIds[i]);
                int qty = Integer.parseInt(quantities[i]);

                // Check stock
                HttpRequest stockRequest = HttpRequest.newBuilder()
                        .uri(URI.create("http://localhost:5002/api/inventory/check/" + productId))
                        .GET()
                        .build();

                HttpResponse<String> stockResponse = client.send(stockRequest, HttpResponse.BodyHandlers.ofString());
                JSONObject stockJson = new JSONObject(stockResponse.body());

                int availableQty = stockJson.getInt("quantity_available"); // make sure it matches inventory service
                if (qty > availableQty) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                            "Not enough stock for product ID: " + productId);
                    return;
                }

                JSONObject item = new JSONObject();
                item.put("product_id", productId);
                item.put("quantity", qty);
                productsArray.put(item);

            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid product or quantity at index " + i);
                return;
            }
        }

        // Build order payload
        JSONObject orderPayload = new JSONObject();
        orderPayload.put("customer_id", Integer.parseInt(customerId));
        orderPayload.put("products", productsArray);

        // Send to Order Service
        HttpRequest orderRequest = HttpRequest.newBuilder()
                .uri(URI.create("http://localhost:5001/api/orders/create"))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(orderPayload.toString()))
                .build();

        try {
            HttpResponse<String> orderResponse = client.send(orderRequest, HttpResponse.BodyHandlers.ofString());
            JSONObject orderJson = new JSONObject(orderResponse.body());

            // Forward to confirmation page
        request.setAttribute("orderResponse", orderJson.toString(4)); // pretty print JSON
        request.getRequestDispatcher("confirmation.jsp").forward(request, response);

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create order");
            e.printStackTrace();
        }
    }
}
