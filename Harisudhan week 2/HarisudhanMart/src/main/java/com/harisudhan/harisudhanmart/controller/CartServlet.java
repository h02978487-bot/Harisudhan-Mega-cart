package com.harisudhan.harisudhanmart.controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.harisudhan.harisudhanmart.dto.CartResponseDTO;
import com.harisudhan.harisudhanmart.exception.NotFoundException;
import com.harisudhan.harisudhanmart.exception.ValidationException;
import com.harisudhan.harisudhanmart.service.CartService;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * F4: cart add/update/remove/view. All routes require an authenticated session
 * (enforced by AuthFilter on /api/v1/cart/*).
 * GET  /api/v1/cart/view
 * POST /api/v1/cart/add    { productId, quantity }
 * POST /api/v1/cart/update { productId, quantity }
 * POST /api/v1/cart/remove { productId }
 */
@WebServlet(urlPatterns = {"/api/v1/cart/*"})
public class CartServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        long userId = currentUserId(req);
        CartService cartService = cartService();
        try {
            CartResponseDTO cart = cartService.viewCart(userId);
            writeJson(resp, HttpServletResponse.SC_OK, cart);
        } catch (SQLException e) {
            writeError(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "DB_ERROR", "Could not load cart");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo() == null ? "" : req.getPathInfo();
        long userId = currentUserId(req);
        CartService cartService = cartService();
        JsonObject body = JsonParser.parseString(readBody(req)).getAsJsonObject();

        if (!body.has("productId")) {
            writeError(resp, HttpServletResponse.SC_BAD_REQUEST, "VALIDATION_ERROR", "productId is required");
            return;
        }
        long productId = body.get("productId").getAsLong();

        try {
            if (pathInfo.endsWith("/add")) {
                int quantity = body.has("quantity") ? body.get("quantity").getAsInt() : 1;
                cartService.addItem(userId, productId, quantity);
            } else if (pathInfo.endsWith("/update")) {
                int quantity = body.get("quantity").getAsInt();
                cartService.updateItem(userId, productId, quantity);
            } else if (pathInfo.endsWith("/remove")) {
                cartService.removeItem(userId, productId);
            } else {
                writeError(resp, HttpServletResponse.SC_NOT_FOUND, "NOT_FOUND", "Unknown cart endpoint");
                return;
            }
            CartResponseDTO cart = cartService.viewCart(userId);
            writeJson(resp, HttpServletResponse.SC_OK, cart);
        } catch (ValidationException e) {
            writeError(resp, HttpServletResponse.SC_BAD_REQUEST, e.getFieldErrorCode(), e.getMessage());
        } catch (NotFoundException e) {
            writeError(resp, HttpServletResponse.SC_NOT_FOUND, "NOT_FOUND", e.getMessage());
        } catch (SQLException e) {
            writeError(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "DB_ERROR", "Cart operation failed");
        }
    }

    private CartService cartService() {
        return new CartService(daoFactory().cartDAO(), daoFactory().productDAO());
    }

    private long currentUserId(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return (long) session.getAttribute("userId");
    }
}
