// File: src/main/java/com/yourname/yournamemart/controller/SearchServlet.java
package com.yourname.yournamemart.controller;

import com.google.gson.Gson;
import com.yourname.yournamemart.dto.ApiResponse;
import com.yourname.yournamemart.exception.ValidationException;
import com.yourname.yournamemart.model.Product;
import com.yourname.yournamemart.service.ProductService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/api/v1/search", "/api/v1/categories"})
public class SearchServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(SearchServlet.class);
    private ProductService productService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        this.productService = (ProductService) getServletContext()
            .getAttribute("productService");
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String path = req.getRequestURI();

        try {
            if (path.endsWith("/categories")) {
                handleGetCategories(req, resp);
            } else if (path.endsWith("/search")) {
                handleSearch(req, resp);
            } else {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write(gson.toJson(
                    new ApiResponse(false, null, 
                        new ApiResponse.ErrorDetail("NOT_FOUND", "Endpoint not found"))
                ));
            }
        } catch (ValidationException e) {
            logger.warn("Validation error in search: {}", e.getMessage());
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, 
                    new ApiResponse.ErrorDetail("VALIDATION_ERROR", e.getMessage()))
            ));
        } catch (Exception e) {
            logger.error("Error in search servlet", e);
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, 
                    new ApiResponse.ErrorDetail("SERVER_ERROR", "Search failed"))
            ));
        }
    }

    private void handleSearch(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        String keyword = req.getParameter("keyword");
        String category = req.getParameter("category");

        List<Product> results;
        if (keyword != null && !keyword.trim().isEmpty() && 
            category != null && !category.trim().isEmpty()) {
            results = productService.searchAndFilter(keyword, category);
        } else if (keyword != null && !keyword.trim().isEmpty()) {
            results = productService.searchByKeyword(keyword);
        } else if (category != null && !category.trim().isEmpty()) {
            results = productService.filterByCategory(category);
        } else {
            throw new ValidationException("Provide at least one search criterion (keyword or category)");
        }

        resp.setStatus(HttpServletResponse.SC_OK);
        resp.getWriter().write(gson.toJson(
            new ApiResponse(true, results, null)
        ));
    }

    private void handleGetCategories(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        List<String> categories = productService.getAllCategories();
        resp.setStatus(HttpServletResponse.SC_OK);
        resp.getWriter().write(gson.toJson(
            new ApiResponse(true, categories, null)
        ));
    }
}
