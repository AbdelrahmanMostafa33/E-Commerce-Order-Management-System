package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.URI;


@WebServlet("/updateInventory")
public class InventoryServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productId = request.getParameter("productId");
        String quantity = request.getParameter("quantity");

        // Call Inventory Service to update the inventory
        String inventoryJson = String.format("{\"productId\":\"%s\",\"quantity\":%s}", productId, quantity);

        HttpClient Client = HttpClient.newHttpClient(); 
        HttpRequest inventoryRequest = HttpRequest.newBuilder()
                .uri(URI.create("http://localhost:5002/api/inventory/update"))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(inventoryJson))
                .build();

            try {
               HttpResponse<String> inventoryResponse = Client.send(inventoryRequest, HttpResponse.BodyHandlers.ofString());
                request.setAttribute("response", inventoryResponse.body());
                request.getRequestDispatcher("inventoryConfirmation.jsp").forward(request, response);
            } catch (InterruptedException e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
    }
    
}
