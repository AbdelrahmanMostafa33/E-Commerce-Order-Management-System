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


@WebServlet("/submitOrder")
public class OrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String customerId = request.getParameter("customer_id");
        String productId = request.getParameter("product_id");
        String quantity = request.getParameter("quantity");

        //call pricing service to get the total amount
        String pricingJson = String.format("{\"productId\":\"%s\",\"quantity\":%s}", productId, quantity);
        HttpClient Client = HttpClient.newHttpClient(); 
        HttpRequest pricingRequest = HttpRequest.newBuilder()
                .uri(URI.create("http://localhost:5003/api/pricing/calculate"))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(pricingJson))
                .build();
        
        double totalAmount ;
        try {
        HttpResponse<String> pricingResponse = Client.send(pricingRequest, HttpResponse.BodyHandlers.ofString());
        if (pricingResponse.statusCode() != 200) {
            request.setAttribute("response", pricingResponse.body());
            request.getRequestDispatcher("orderConfirmation.jsp").forward(request, response);
            return;
        }
        String body = pricingResponse.body();
        totalAmount = Double.parseDouble(body.replaceAll(".*\"total\":([0-9\\.]+).*", "$1"));
        } catch (InterruptedException e) {
          response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }
        


        // Call Order Service to submit the order
        String orderJson = String.format("{\"customerId\":\"%s\",\"productId\":\"%s\",\"quantity\":%s}],\"total_amount\":%s}", customerId, productId, quantity ,totalAmount);


 
        HttpRequest orderRequest = HttpRequest.newBuilder()
                .uri(URI.create("http://localhost:5001/api/orders/create"))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(orderJson))
                .build();

            try {
               HttpResponse<String> orderResponse = Client.send(orderRequest, HttpResponse.BodyHandlers.ofString());
                request.setAttribute("response", orderResponse.body());
                request.getRequestDispatcher("orderConfirmation.jsp").forward(request, response);
            } catch (InterruptedException e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }
