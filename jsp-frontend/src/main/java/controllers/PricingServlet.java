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


@WebServlet("/calculatePrice")
public class PricingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productId = request.getParameter("productId");
        String quantity = request.getParameter("quantity");

        // Call Pricing Service to calculate price
        String pricingJson = String.format("{\"productId\":\"%s\",\"quantity\":%s}", productId, quantity);

        HttpClient Client = HttpClient.newHttpClient(); 
        HttpRequest pricingRequest = HttpRequest.newBuilder()
                .uri(URI.create("http://localhost:5003/api/pricing/calculate"))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(pricingJson))
                .build();

            try {
               HttpResponse<String> pricingResponse = Client.send(pricingRequest, HttpResponse.BodyHandlers.ofString());
                request.setAttribute("response", pricingResponse.body());
                request.getRequestDispatcher("pricingConfirmation.jsp").forward(request, response);
            } catch (InterruptedException e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
    }
    
}
