package com.harisudhan.controller;

import com.harisudhan.model.Review;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.util.*;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private Connection getConn() throws SQLException {
        try { Class.forName("org.h2.Driver"); }
        catch (ClassNotFoundException e) { throw new SQLException(e); }
        return DriverManager.getConnection(
            "jdbc:h2:./data/harisudhanmart", "sa", "");
    }

    // Submit a review
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
    throws ServletException, IOException {
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        if (userId == null) {
            res.sendRedirect("login.jsp"); return;
        }

        int productId = Integer.parseInt(req.getParameter("productId"));
        int rating = Integer.parseInt(req.getParameter("rating"));
        String comment = req.getParameter("comment");

        if (rating < 1 || rating > 5) {
            res.sendRedirect("product.jsp?id=" + productId + "&error=badrating");
            return;
        }

        try (Connection conn = getConn()) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO reviews (product_id, user_id, rating, comment) VALUES (?, ?, ?, ?)");
            ps.setInt(1, productId);
            ps.setInt(2, userId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        res.sendRedirect("product.jsp?id=" + productId);
    }

    // Fetch reviews for a product
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse res)
    throws ServletException, IOException {
        int productId = Integer.parseInt(req.getParameter("productId"));
        List<Review> reviews = new ArrayList<>();
        double avgRating = 0;

        try (Connection conn = getConn()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT r.id, r.rating, r.comment, r.created_at, u.username " +
                "FROM reviews r JOIN users u ON r.user_id = u.id " +
                "WHERE r.product_id = ? ORDER BY r.created_at DESC");
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            int total = 0, count = 0;
            while (rs.next()) {
                Review r = new Review();
                r.setId(rs.getInt("id"));
                r.setProductId(productId);
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setUsername(rs.getString("username"));
                reviews.add(r);
                total += r.getRating();
                count++;
            }
            if (count > 0) avgRating = (double) total / count;
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        req.setAttribute("reviews", reviews);
        req.setAttribute("avgRating", avgRating);
        req.getRequestDispatcher("product.jsp?id=" + productId).forward(req, res);
    }
}
