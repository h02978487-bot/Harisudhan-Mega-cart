package com.harisudhan.harisudhanmart.controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.harisudhan.harisudhanmart.dto.ProductRequestDTO;
import com.harisudhan.harisudhanmart.dto.ProductResponseDTO;
import com.harisudhan.harisudhanmart.exception.ForbiddenException;
import com.harisudhan.harisudhanmart.exception.NotFoundException;
import com.harisudhan.harisudhanmart.exception.ValidationException;
import com.harisudhan.harisudhanmart.model.Product;
import com.harisudhan.harisudhanmart.service.ProductService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * F2 (seller CRUD) and F3 (buyer browse/search).
 * GET /api/v1/products            -> search/list (public, no login required)
 * GET /api/v1/products/{id}       -> product detail (public)
 * POST /api/v1/products/create    -> seller only (session enforced by AuthFilter + role check here)
 * POST /api/v1/products/update    -> seller, must own the listing
 * POST /api/v1/products/delete    -> seller, must own the listing (soft delete)
 */
@WebServlet(urlPatterns = {"/api/v1/products", "/api/v1/products/*"})
public class ProductServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        ProductService productService = new ProductService(daoFactory().productDAO());
        String pathInfo = req.getPathInfo();
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                String keyword = req.getParameter("q");
                String category = req.getParameter("category");
                List<Product> products = productService.search(keyword, category);
                List<ProductResponseDTO> dtos = products.stream()
                        .map(ProductResponseDTO::fromEntity).collect(Collectors.toList());
                writeJson(resp, HttpServletResponse.SC_OK, dtos);
                return;
            }
            long id = Long.parseLong(pathInfo.substring(1));
            Product product = productService.getOrThrow(id);
            writeJson(resp, HttpServletResponse.SC_OK, ProductResponseDTO.fromEntity(product));
        } catch (NumberFormatException e) {
            writeError(resp, HttpServletResponse.SC_BAD_REQUEST, "INVALID_ID", "Invalid product id");
        } catch (NotFoundException e) {
            writeError(resp, HttpServletResponse.SC_NOT_FOUND, "NOT_FOUND", e.getMessage());
        } catch (SQLException e) {
            writeError(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "DB_ERROR", "Could not load products");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath() + (req.getPathInfo() == null ? "" : req.getPathInfo());
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            writeError(resp, HttpServletResponse.SC_UNAUTHORIZED, "UNAUTHENTICATED", "Login required");
            return;
        }
        if (!"SELLER".equals(session.getAttribute("role"))) {
            writeError(resp, HttpServletResponse.SC_FORBIDDEN, "FORBIDDEN", "Seller role required");
            return;
        }
        long sellerId = (long) session.getAttribute("userId");
        ProductService productService = new ProductService(daoFactory().productDAO());

        if (path.endsWith("/create")) {
            handleCreate(req, resp, productService, sellerId);
        } else if (path.endsWith("/update")) {
            handleUpdate(req, resp, productService, sellerId);
        } else if (path.endsWith("/delete")) {
            handleDelete(req, resp, productService, sellerId);
        } else {
            writeError(resp, HttpServletResponse.SC_NOT_FOUND, "NOT_FOUND", "Unknown product endpoint");
        }
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp,
            ProductService productService, long sellerId) throws IOException {
        ProductRequestDTO dto = GSON.fromJson(readBody(req), ProductRequestDTO.class);
        try {
            Product created = productService.create(sellerId, dto);
            writeJson(resp, HttpServletResponse.SC_CREATED, ProductResponseDTO.fromEntity(created));
        } catch (ValidationException e) {
            writeError(resp, HttpServletResponse.SC_BAD_REQUEST, e.getFieldErrorCode(), e.getMessage());
        } catch (SQLException e) {
            writeError(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "DB_ERROR", "Could not create product");
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp,
            ProductService productService, long sellerId) throws IOException {
        JsonObject body = JsonParser.parseString(readBody(req)).getAsJsonObject();
        if (!body.has("id")) {
            writeError(resp, HttpServletResponse.SC_BAD_REQUEST, "VALIDATION_ERROR", "Product id is required");
            return;
        }
        long productId = body.get("id").getAsLong();
        ProductRequestDTO dto = GSON.fromJson(body, ProductRequestDTO.class);
        try {
            Product updated = productService.update(productId, sellerId, dto);
            writeJson(resp, HttpServletResponse.SC_OK, ProductResponseDTO.fromEntity(updated));
        } catch (ValidationException e) {
            writeError(resp, HttpServletResponse.SC_BAD_REQUEST, e.getFieldErrorCode(), e.getMessage());
        } catch (NotFoundException e) {
            writeError(resp, HttpServletResponse.SC_NOT_FOUND, "NOT_FOUND", e.getMessage());
        } catch (ForbiddenException e) {
            writeError(resp, HttpServletResponse.SC_FORBIDDEN, "FORBIDDEN", e.getMessage());
        } catch (SQLException e) {
            writeError(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "DB_ERROR", "Could not update product");
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp,
            ProductService productService, long sellerId) throws IOException {
        JsonObject body = JsonParser.parseString(readBody(req)).getAsJsonObject();
        if (!body.has("id")) {
            writeError(resp, HttpServletResponse.SC_BAD_REQUEST, "VALIDATION_ERROR", "Product id is required");
            return;
        }
        long productId = body.get("id").getAsLong();
        try {
            productService.delete(productId, sellerId);
            writeJson(resp, HttpServletResponse.SC_OK, null);
        } catch (NotFoundException e) {
            writeError(resp, HttpServletResponse.SC_NOT_FOUND, "NOT_FOUND", e.getMessage());
        } catch (ForbiddenException e) {
            writeError(resp, HttpServletResponse.SC_FORBIDDEN, "FORBIDDEN", e.getMessage());
        } catch (SQLException e) {
            writeError(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "DB_ERROR", "Could not delete product");
        }
    }
}
