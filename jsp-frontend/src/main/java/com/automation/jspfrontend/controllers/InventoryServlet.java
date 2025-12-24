package com.automation.jspfrontend.controllers;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.net.URI;
import java.net.http.*;
import java.util.*;

import org.json.JSONArray;
import org.json.JSONObject;





@WebServlet("/inventory")
public class InventoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpClient client = HttpClient.newHttpClient();

        try {
            // ================= INVENTORY =================
            HttpRequest invRequest = HttpRequest.newBuilder()
                    .uri(URI.create("http://localhost:5002/api/inventory"))
                    .GET()
                    .build();

            HttpResponse<String> invResponse =
                    client.send(invRequest, HttpResponse.BodyHandlers.ofString());

            String invBody = invResponse.body();
            System.out.println("INVENTORY RESPONSE:\n" + invBody);

            JSONArray invArray = new JSONArray(invBody);

            List<Map<String, Object>> products = new ArrayList<>();

            for (int i = 0; i < invArray.length(); i++) {
                JSONObject p = invArray.getJSONObject(i);

                Map<String, Object> product = new HashMap<>();
                product.put("id", p.getInt("product_id"));
                product.put("name", p.getString("product_name"));
                product.put("price", p.getString("unit_price"));
                product.put("quantity_available", p.getInt("quantity_available"));

                products.add(product);
            }

            // ================= CUSTOMERS =================
            HttpRequest customerRequest = HttpRequest.newBuilder()
                    .uri(URI.create("http://localhost:5004/api/customers"))
                    .GET()
                    .build();

            HttpResponse<String> customerResponse =
                    client.send(customerRequest, HttpResponse.BodyHandlers.ofString());

            String customerBody = customerResponse.body();
            System.out.println("CUSTOMERS RESPONSE:\n" + customerBody);

            JSONArray customerArray = new JSONArray(customerBody);

            List<Map<String, Object>> customers = new ArrayList<>();

            for (int i = 0; i < customerArray.length(); i++) {
                JSONObject c = customerArray.getJSONObject(i);

                Map<String, Object> customer = new HashMap<>();
                customer.put("id", c.getInt("customer_id"));
                customer.put("name", c.getString("name"));

                customers.add(customer);
            }

            request.setAttribute("products", products);
            request.setAttribute("customers", customers);

            request.getRequestDispatcher("/index.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
