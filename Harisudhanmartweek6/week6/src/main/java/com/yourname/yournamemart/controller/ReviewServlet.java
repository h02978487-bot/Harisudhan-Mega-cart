package com.yourname.yournamemart.controller;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.yourname.yournamemart.dto.ReviewRequestDTO;
import com.yourname.yournamemart.dto.ReviewResponseDTO;
import com.yourname.yournamemart.exception.ValidationException;
import com.yourname.yournamemart.model.Review;
import com.yourname.yournamemart.service.ReviewService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Handles /api/v1/reviews (POST - submit a review) and
 * /api/v1/reviews?productId=... (GET - list reviews for a product).
 *
 * Thin by design: no SQL, no business rules here - that's ReviewService's
 * job (Section 12, SOLID rule). AuthFilter is expected to have already
 * rejected unauthenticated requests before this servlet runs; here we only
 * check that the logged-in user has the BUYER role for POST.
 */
public class ReviewServlet extends HttpServlet {

    private final Gson gson = new Gson();
    private ReviewService reviewService;

    @Override
    public void init() throws ServletException {
        // Pull the already-constructed service out of the ServletContext,
        // where your ServletContextListener should have placed it at
        // startup alongside the DataSource. Adjust the attribute name to
        // match whatever you use elsewhere in the app.
        Object svc = getServletContext().getAttribute("reviewService");
        if (!(svc instanceof ReviewService)) {
            throw new ServletException("ReviewService not found in ServletContext. "
                    + "Register it in your ServletContextListener alongside the DataSource.");
        }
        this.reviewService = (ReviewService) svc;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            writeError(resp, HttpServletResponse.SC_UNAUTHORIZED, "UNAUTHENTICATED", "Login required");
            return;
        }
        if (!"BUYER".equals(session.getAttribute("role"))) {
            writeError(resp, HttpServletResponse.SC_FORBIDDEN, "FORBIDDEN", "Only buyers can submit reviews");
            return;
        }

        long buyerId = (long) session.getAttribute("userId");

        try {
            ReviewRequestDTO request = gson.fromJson(readBody(req), ReviewRequestDTO.class);
            ReviewResponseDTO created = reviewService.submitReview(buyerId, request);

            resp.setStatus(HttpServletResponse.SC_CREATED);
            resp.getWriter().write(gson.toJson(new Envelope(true, created, null)));

        } catch (JsonSyntaxException e) {
            writeError(resp, HttpServletResponse.SC_BAD_REQUEST, "MALFORMED_JSON", "Request body is not valid JSON");
        } catch (ValidationException e) {
            writeError(resp, HttpServletResponse.SC_BAD_REQUEST, "VALIDATION_ERROR",
                    e.getField() + ": " + e.getMessage());
        } catch (Exception e) {
            // Never leak stack traces to the client (Section 9 security checklist)
            getServletContext().log("Unexpected error submitting review", e);
            writeError(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "SERVER_ERROR", "Something went wrong");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String productIdParam = req.getParameter("productId");
        try {
            long productId = Long.parseLong(productIdParam);
            List<ReviewResponseDTO> reviews = reviewService.getReviewsForProduct(productId);
            double average = reviewService.getAverageRating(productId);

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write(gson.toJson(new Envelope(true,
                    new ProductReviewsView(reviews, average), null)));

        } catch (NumberFormatException e) {
            writeError(resp, HttpServletResponse.SC_BAD_REQUEST, "VALIDATION_ERROR", "productId must be a number");
        } catch (ValidationException e) {
            writeError(resp, HttpServletResponse.SC_BAD_REQUEST, "VALIDATION_ERROR",
                    e.getField() + ": " + e.getMessage());
        } catch (Exception e) {
            getServletContext().log("Unexpected error fetching reviews", e);
            writeError(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "SERVER_ERROR", "Something went wrong");
        }
    }

    private String readBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = req.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }

    private void writeError(HttpServletResponse resp, int status, String code, String message) throws IOException {
        resp.setStatus(status);
        resp.getWriter().write(gson.toJson(new Envelope(false, null, new ApiError(code, message))));
    }

    // --- Response envelope shapes (Section 13, rule 2) ---

    private static class Envelope {
        final boolean success;
        final Object data;
        final ApiError error;

        Envelope(boolean success, Object data, ApiError error) {
            this.success = success;
            this.data = data;
            this.error = error;
        }
    }

    private static class ApiError {
        final String code;
        final String message;

        ApiError(String code, String message) {
            this.code = code;
            this.message = message;
        }
    }

    private static class ProductReviewsView {
        final List<ReviewResponseDTO> reviews;
        final double averageRating;

        ProductReviewsView(List<ReviewResponseDTO> reviews, double averageRating) {
            this.reviews = reviews;
            this.averageRating = averageRating;
        }
    }
}
