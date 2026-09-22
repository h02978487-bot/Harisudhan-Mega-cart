package com.harisudhan.controller;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.*;
import java.sql.*;

@WebServlet("/adminAction")
public class AdminActionServlet extends HttpServlet {

    private Connection getConn() throws SQLException {
        try { Class.forName("org.h2.Driver"); }
        catch (ClassNotFoundException e) { throw new SQLException(e); }
        return DriverManager.getConnection(
            "jdbc:h2:./data/harisudhanmart", "sa", "");
    }

    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
    throws ServletException, IOException {
        String role = (String) req.getSession().getAttribute("role");
        if (!"ADMIN".equals(role)) {
            res.sendRedirect("login.jsp"); return;
        }
        String action = req.getParameter("action");
        try (Connection conn = getConn()) {
            if ("deleteUser".equals(action)) {
                PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM users WHERE id=? AND role != 'ADMIN'");
                ps.setInt(1, Integer.parseInt(req.getParameter("id")));
                ps.executeUpdate();
            } else if ("deleteProduct".equals(action)) {
                PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM products WHERE id=?");
                ps.setInt(1, Integer.parseInt(req.getParameter("id")));
                ps.executeUpdate();
            } else if ("updateStatus".equals(action)) {
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE orders SET status=? WHERE id=?");
                ps.setString(1, req.getParameter("status"));
                ps.setInt(2, Integer.parseInt(req.getParameter("orderId")));
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        res.sendRedirect("admin.jsp");
    }
}
