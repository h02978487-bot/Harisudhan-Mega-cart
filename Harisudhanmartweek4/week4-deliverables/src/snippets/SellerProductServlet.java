package com.harisudhan.harisudhanmart.controller;

import com.harisudhan.harisudhanmart.service.SellerService;
import com.harisudhan.harisudhanmart.model.User;
import com.harisudhan.harisudhanmart.dto.ProductResponseDTO;
import com.google.gson.Gson;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for seller product management (CRUD).
 * Routes:
 *   GET  /seller/products       → list my products (JSP view)
 *   POST /seller/products       → create product (JSON)
 *   PUT  /seller/products?id=X  → edit product (JSON)
 *   DELETE /seller/products?id=X → delete product (JSON)
 */
@WebServlet("/seller/products")
public class SellerProductServlet extends HttpServlet {
    private SellerService sellerService;
    private Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        DataSource ds = (DataSource) getServletContext().getAttribute("dataSource");
        this.sellerService = new SellerService(
            new ProductDAOImpl(ds),
            new OrderDAOImpl(ds)
        );
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User seller = (User) req.getSession().getAttribute("user");
        if (seller == null || !seller.getRole().equals("SELLER")) {
            resp.sendError(403, "Forbidden: Seller role required");
            return;
        }

        try {
            List<ProductResponseDTO> myProducts = sellerService.getMyProducts(seller.getId());
            req.setAttribute("products", myProducts);
            req.getRequestDispatcher("/WEB-INF/seller-dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendError(500, "Error fetching products");
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User seller = (User) req.getSession().getAttribute("user");
        if (seller == null || !seller.getRole().equals("SELLER")) {
            resp.setStatus(403);
            resp.setContentType("application/json");
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, new ErrorDetail("FORBIDDEN", "Seller role required"))
            ));
            return;
        }

        resp.setContentType("application/json");
        try {
            CreateProductRequest createReq = gson.fromJson(
                req.getReader(), CreateProductRequest.class
            );
            ProductResponseDTO created = sellerService.createProduct(createReq, seller.getId());
            resp.getWriter().write(gson.toJson(
                new ApiResponse(true, created, null)
            ));
        } catch (ValidationException e) {
            resp.setStatus(400);
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, new ErrorDetail("VALIDATION_ERROR", e.getMessage()))
            ));
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, new ErrorDetail("SERVER_ERROR", "Failed to create product"))
            ));
            e.printStackTrace();
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User seller = (User) req.getSession().getAttribute("user");
        if (seller == null || !seller.getRole().equals("SELLER")) {
            resp.setStatus(403);
            resp.setContentType("application/json");
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, new ErrorDetail("FORBIDDEN", "Seller role required"))
            ));
            return;
        }

        resp.setContentType("application/json");
        try {
            int productId = Integer.parseInt(req.getParameter("id"));
            EditProductRequest editReq = gson.fromJson(
                req.getReader(), EditProductRequest.class
            );
            ProductResponseDTO updated = sellerService.editProduct(productId, editReq, seller.getId());
            resp.getWriter().write(gson.toJson(
                new ApiResponse(true, updated, null)
            ));
        } catch (AuthorizationException e) {
            resp.setStatus(403);
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, new ErrorDetail("FORBIDDEN", e.getMessage()))
            ));
        } catch (ValidationException e) {
            resp.setStatus(400);
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, new ErrorDetail("VALIDATION_ERROR", e.getMessage()))
            ));
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, new ErrorDetail("SERVER_ERROR", "Failed to update product"))
            ));
            e.printStackTrace();
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User seller = (User) req.getSession().getAttribute("user");
        if (seller == null || !seller.getRole().equals("SELLER")) {
            resp.setStatus(403);
            resp.setContentType("application/json");
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, new ErrorDetail("FORBIDDEN", "Seller role required"))
            ));
            return;
        }

        resp.setContentType("application/json");
        try {
            int productId = Integer.parseInt(req.getParameter("id"));
            sellerService.deleteProduct(productId, seller.getId());
            resp.getWriter().write(gson.toJson(
                new ApiResponse(true, null, null)
            ));
        } catch (AuthorizationException e) {
            resp.setStatus(403);
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, new ErrorDetail("FORBIDDEN", e.getMessage()))
            ));
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, new ErrorDetail("SERVER_ERROR", "Failed to delete product"))
            ));
            e.printStackTrace();
        }
    }
}
