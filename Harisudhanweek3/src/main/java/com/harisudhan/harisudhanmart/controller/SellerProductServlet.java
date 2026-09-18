package com.harisudhan.harisudhanmart.controller;

import com.harisudhan.harisudhanmart.model.Product;
import com.harisudhan.harisudhanmart.service.ProductService;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Thin controller: no SQL here. Handles the seller listing-management screens.
 * AuthFilter is assumed to already guarantee an authenticated session before
 * requests reach this servlet; here we additionally confirm the SELLER role
 * and that a seller only ever touches their own listings.
 */
@WebServlet("/seller/products")
public class SellerProductServlet extends HttpServlet {

    private ProductService productService;

    @Override
    public void init() {
        // ProductService is expected to be built in the ServletContextListener
        // (same lifecycle as the HikariCP DataSource) and stored in the
        // ServletContext under this attribute name.
        this.productService = (ProductService) getServletContext().getAttribute("productService");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Long sellerId = requireSeller(req, resp);
        if (sellerId == null) return;

        String action = req.getParameter("action");
        if ("edit".equals(action)) {
            showEditForm(req, resp, sellerId);
            return;
        }

        List<Product> listings = productService.getListingsForSeller(sellerId);
        req.setAttribute("listings", listings);
        forward(req, resp, "/seller/dashboard.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Long sellerId = requireSeller(req, resp);
        if (sellerId == null) return;

        String action = req.getParameter("action");
        try {
            switch (action == null ? "" : action) {
                case "create":
                    handleCreate(req, sellerId);
                    break;
                case "update":
                    handleUpdate(req, sellerId);
                    break;
                case "delete":
                    handleDelete(req, sellerId);
                    break;
                default:
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
                    return;
            }
        } catch (IllegalArgumentException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("listings", productService.getListingsForSeller(sellerId));
            forward(req, resp, "/seller/dashboard.jsp");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/seller/products");
    }

    private void handleCreate(HttpServletRequest req, long sellerId) {
        productService.createListing(
                sellerId,
                req.getParameter("name"),
                req.getParameter("description"),
                parsePrice(req.getParameter("price")),
                parseInt(req.getParameter("stockQty")),
                req.getParameter("category"),
                req.getParameter("imageUrl")
        );
    }

    private void handleUpdate(HttpServletRequest req, long sellerId) {
        long id = Long.parseLong(req.getParameter("id"));
        boolean ok = productService.updateListing(
                id, sellerId,
                req.getParameter("name"),
                req.getParameter("description"),
                parsePrice(req.getParameter("price")),
                parseInt(req.getParameter("stockQty")),
                req.getParameter("category"),
                req.getParameter("imageUrl")
        );
        if (!ok) {
            throw new IllegalArgumentException("Listing not found or not owned by this seller");
        }
    }

    private void handleDelete(HttpServletRequest req, long sellerId) {
        long id = Long.parseLong(req.getParameter("id"));
        productService.deleteListing(id, sellerId);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp, long sellerId)
            throws ServletException, IOException {
        long id = Long.parseLong(req.getParameter("id"));
        Optional<Product> product = productService.getById(id);
        if (product.isEmpty() || product.get().getSellerId() != sellerId) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        req.setAttribute("product", product.get());
        forward(req, resp, "/seller/edit-product.jsp");
    }

    /** Confirms the caller is logged in as SELLER; writes a 403 and returns null otherwise. */
    private Long requireSeller(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null
                || !"SELLER".equals(session.getAttribute("role"))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Seller login required");
            return null;
        }
        return (Long) session.getAttribute("userId");
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String path)
            throws ServletException, IOException {
        RequestDispatcher rd = req.getRequestDispatcher(path);
        rd.forward(req, resp);
    }

    private BigDecimal parsePrice(String raw) {
        try {
            return new BigDecimal(raw);
        } catch (Exception e) {
            throw new IllegalArgumentException("Price must be a valid number");
        }
    }

    private int parseInt(String raw) {
        try {
            return Integer.parseInt(raw);
        } catch (Exception e) {
            throw new IllegalArgumentException("Stock quantity must be a whole number");
        }
    }
}
