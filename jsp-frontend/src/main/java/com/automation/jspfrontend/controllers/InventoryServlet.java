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
public class InventoryServlet  extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest inv_request = HttpRequest.newBuilder().uri(URI.create("http://localhost:5002/api/inventory")).GET().build();
        try{
            HttpResponse<String> inv_Response = client.send(inv_request,HttpResponse.BodyHandlers.ofString());
            JSONArray jsonArray = new JSONArray(inv_Response.body());
            List<Map<String,Object>> products = new ArrayList<>();

            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject jsonObject = jsonArray.getJSONObject(i);
                Map<String, Object> product = new HashMap<>();
                product.put("id", jsonObject.getInt("product_id"));
                product.put("name", jsonObject.getString("product_name"));
                product.put("price", jsonObject.getDouble("unit_price"));
                product.put("quantity_available", jsonObject.getInt("quantity_available"));
                products.add(product);
            }
            request.setAttribute("products", products);
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }catch(InterruptedException e){
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

}
