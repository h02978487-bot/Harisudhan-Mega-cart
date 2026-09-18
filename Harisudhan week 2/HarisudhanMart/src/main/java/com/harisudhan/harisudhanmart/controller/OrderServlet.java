package com.harisudhan.harisudhanmart.controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.harisudhan.harisudhanmart.dto.OrderResponseDTO;
import com.harisudhan.harisudhanmart.exception.InsufficientStockException;
import com.harisudhan.harisudhanmart.exception.ValidationException;
import com.harisudhan.harisudhanmart.model.Order;
import com.harisudhan.harisudhanmart.service.OrderService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * F5 (checkout) and F6 (order history). All routes require an authenticated session
 * (enforced by AuthFilter on /api/v1/orders/*).
 * GET  /api/v1/orders          -> buyer's own order history
 * GET  /api/v1/orders/seller   -> seller's incoming orders (orders containing their products)
 * POST /api/v1/orders/checkout { mockPaymentConfirmed: true }
 */
@WebServlet(urlPatterns = {"/api/v1/orders/*"})
public class OrderServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String pathInfo = req.getPathInfo() == null ? "" : req.getPathInfo();
        HttpSession session = req.getSession(false);
        long userId = (long) session.getAttribute("userId");
        OrderService orderService = orderService();
        try {
            List<Order> orders = pathInfo.endsWith("/seller")
                    ? orderService.sellerIncomingOrders(userId)
                    : orderService.buyerHistory(userId);
            writeJson(resp, HttpServletResponse.SC_OK, orders);
        } catch (SQLException e) {
            writeError(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "DB_ERROR", "Could not load orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo() == null ? "" : req.getPathInfo();
        if (!pathInfo.endsWith("/checkout")) {
            writeError(resp, HttpServletResponse.SC_NOT_FOUND, "NOT_FOUND", "Unknown order endpoint");
            return;
        }
        HttpSession session = req.getSession(false);
        long buyerId = (long) session.getAttribute("userId");

        JsonObject body = JsonParser.parseString(readBody(req)).getAsJsonObject();
        boolean paymentConfirmed =
                body.has("mockPaymentConfirmed") && body.get("mockPaymentConfirmed").getAsBoolean();

        OrderService orderService = orderService();
        try {
            OrderResponseDTO order = orderService.checkout(buyerId, paymentConfirmed);
            writeJson(resp, HttpServletResponse.SC_CREATED, order);
        } catch (ValidationException e) {
            writeError(resp, HttpServletResponse.SC_BAD_REQUEST, e.getFieldErrorCode(), e.getMessage());
        } catch (InsufficientStockException e) {
            writeError(resp, HttpServletResponse.SC_CONFLICT, "INSUFFICIENT_STOCK", e.getMessage());
        } catch (SQLException e) {
            writeError(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "DB_ERROR", "Checkout failed");
        }
    }

    private OrderService orderService() {
        return new OrderService(daoFactory().orderDAO(), daoFactory().cartDAO(), daoFactory().productDAO());
    }
}
