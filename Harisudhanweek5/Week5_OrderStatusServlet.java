// File: src/main/java/com/yourname/yournamemart/controller/OrderStatusServlet.java
package com.yourname.yournamemart.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.yourname.yournamemart.dto.ApiResponse;
import com.yourname.yournamemart.exception.ValidationException;
import com.yourname.yournamemart.model.Order;
import com.yourname.yournamemart.model.User;
import com.yourname.yournamemart.service.OrderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;

@WebServlet(urlPatterns = "/api/v1/orders/*/status")
public class OrderStatusServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(OrderStatusServlet.class);
    private OrderService orderService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        this.orderService = (OrderService) getServletContext()
            .getAttribute("orderService");
        this.gson = new Gson();
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            // Authentication check
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.getWriter().write(gson.toJson(
                    new ApiResponse(false, null, 
                        new ApiResponse.ErrorDetail("UNAUTHORIZED", "Login required"))
                ));
                return;
            }

            User user = (User) session.getAttribute("user");
            
            // Only SELLER and ADMIN can update order status
            if (!("SELLER".equals(user.getRole()) || "ADMIN".equals(user.getRole()))) {
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                resp.getWriter().write(gson.toJson(
                    new ApiResponse(false, null, 
                        new ApiResponse.ErrorDetail("FORBIDDEN", "Only sellers and admins can update order status"))
                ));
                return;
            }

            // Extract order ID from URL: /api/v1/orders/{orderId}/status
            String pathInfo = req.getPathInfo();
            long orderId = extractOrderId(pathInfo);

            // Parse request body for new status
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = req.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
            JsonObject body = gson.fromJson(sb.toString(), JsonObject.class);
            String newStatus = body.has("status") ? body.get("status").getAsString() : null;

            if (newStatus == null || newStatus.trim().isEmpty()) {
                throw new ValidationException("Status field required");
            }

            // Update status
            Order updated = orderService.updateOrderStatus(orderId, newStatus);
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write(gson.toJson(
                new ApiResponse(true, updated, null)
            ));

        } catch (ValidationException e) {
            logger.warn("Validation error in order status update: {}", e.getMessage());
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, 
                    new ApiResponse.ErrorDetail("VALIDATION_ERROR", e.getMessage()))
            ));
        } catch (Exception e) {
            logger.error("Error updating order status", e);
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, 
                    new ApiResponse.ErrorDetail("SERVER_ERROR", "Status update failed"))
            ));
        }
    }

    private long extractOrderId(String pathInfo) {
        // pathInfo format: /orders/{orderId}/status
        String[] parts = pathInfo.split("/");
        try {
            return Long.parseLong(parts[2]);
        } catch (NumberFormatException | ArrayIndexOutOfBoundsException e) {
            throw new ValidationException("Invalid order ID in URL");
        }
    }
}
