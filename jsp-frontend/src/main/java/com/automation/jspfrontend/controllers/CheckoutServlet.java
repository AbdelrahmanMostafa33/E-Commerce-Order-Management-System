package com.automation.jspfrontend.controllers;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.net.URI;
import java.net.http.*;


import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String customerId = req.getParameter("customer_id");
        String[] productIds = req.getParameterValues("product_id[]");
        String[] quantities = req.getParameterValues("quantity[]");

        if (productIds == null || quantities == null || productIds.length != quantities.length) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid cart data");
            return;
        }

        HttpClient client = HttpClient.newHttpClient();
        JSONArray orderItems = new JSONArray();
        double total = 0;

        // 🔹 Fetch inventory once
        HttpRequest inventoryRequest = HttpRequest.newBuilder()
                .uri(URI.create("http://localhost:5002/api/inventory"))
                .GET()
                .build();

        JSONArray inventory;
        try {
            HttpResponse<String> inventoryResponse =
                    client.send(inventoryRequest, HttpResponse.BodyHandlers.ofString());
            inventory = new JSONArray(inventoryResponse.body());
        } catch (Exception e) {
            resp.sendError(500, "Failed to fetch inventory");
            return;
        }

        for (int i = 0; i < productIds.length; i++) {

            String qtyStr = quantities[i];

            // Skip empty or null quantities
            if (qtyStr == null || qtyStr.trim().isEmpty()) {
                continue;
            }

            int productId = Integer.parseInt(productIds[i]);
            int qty = Integer.parseInt(qtyStr);

            if (qty <= 0) continue;

            JSONObject product = null;

            for (int j = 0; j < inventory.length(); j++) {
                JSONObject p = inventory.getJSONObject(j);
                if (p.getInt("product_id") == productId) {
                    product = p;
                    break;
                }
            }

            if (product == null) {
                resp.sendError(400, "Product not found: " + productId);
                return;
            }

            int available = product.getInt("quantity_available");

            if (qty > available) {
                resp.sendError(400, "Not enough stock for product ID " + productId);
                return;
            }

            // 🔹 Pricing service
            JSONObject pricingPayload = new JSONObject();
            pricingPayload.put("product_id", productId);
            pricingPayload.put("quantity", qty);

            HttpRequest pricingRequest = HttpRequest.newBuilder()
                    .uri(URI.create("http://localhost:5003/api/pricing/calculate"))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(pricingPayload.toString()))
                    .build();

            HttpResponse<String> pricingResponse;

            try {
                pricingResponse = client.send(pricingRequest, HttpResponse.BodyHandlers.ofString());
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Request interrupted");
                return;
            }


            JSONObject pricingJson = new JSONObject(pricingResponse.body());
            double price = pricingJson.getDouble("total_price");

            JSONObject item = new JSONObject();
            item.put("product_id", productId);
            item.put("quantity", qty);
            item.put("price", price);

            orderItems.put(item);
            total += price;
        }

        req.setAttribute("items", orderItems.toString());
        req.setAttribute("total", total);
        req.setAttribute("customerId", customerId);

        req.getRequestDispatcher("checkout.jsp").forward(req, resp);
    }
}
