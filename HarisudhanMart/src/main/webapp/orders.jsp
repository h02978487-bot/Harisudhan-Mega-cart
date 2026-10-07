<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) { response.sendRedirect("login.jsp"); return; }
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Orders - HarisudhanMart</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; margin: 0; }
        .header { background: #131921; color: white; padding: 15px 30px; }
        .header a { color: #ff9900; text-decoration: none; font-size: 22px; font-weight: bold; }
        .container { max-width: 900px; margin: 30px auto; }
        .success { background: #d4edda; color: #155724; padding: 15px; border-radius: 8px; margin-bottom: 20px; font-size: 16px; }
        .order-card { background: white; border-radius: 8px; padding: 20px; margin-bottom: 20px; border-left: 4px solid #ff9900; }
        .order-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .order-id { font-size: 18px; font-weight: bold; color: #131921; }
        .status { padding: 5px 12px; border-radius: 20px; font-size: 13px; font-weight: bold; }
        .PENDING { background: #fff3cd; color: #856404; }
        .CONFIRMED { background: #cce5ff; color: #004085; }
        .SHIPPED { background: #d1ecf1; color: #0c5460; }
        .DELIVERED { background: #d4edda; color: #155724; }
        .CANCELLED { background: #f8d7da; color: #721c24; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th { background: #f0f0f0; padding: 10px; text-align: left; font-size: 13px; }
        td { padding: 10px; border-bottom: 1px solid #eee; font-size: 14px; }
        .total { text-align: right; font-weight: bold; font-size: 16px; color: #b12704; margin-top: 10px; }
        .empty { text-align: center; padding: 60px; background: white; border-radius: 8px; color: #666; }
        .btn-review { background: #ff9900; color: white; border: none; padding: 6px 14px; border-radius: 4px; cursor: pointer; font-size: 13px; }
        h2 { color: #131921; }
    </style>
</head>
<body>
<div class="header">
    <a href="index.jsp">🛒 HarisudhanMart</a>
</div>
<div class="container">
    <h2>📦 My Orders</h2>
    <% if ("true".equals(success)) { %>
    <div class="success">✅ Order placed successfully! Thank you for shopping with HarisudhanMart!</div>
    <% } %>
<%
    try {
        Class.forName("org.h2.Driver");
        Connection conn = DriverManager.getConnection("jdbc:h2:./data/harisudhanmart","sa","");
        PreparedStatement ps = conn.prepareStatement(
            "SELECT * FROM orders WHERE buyer_id=? ORDER BY created_at DESC");
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        boolean hasOrders = false;
        while (rs.next()) {
            hasOrders = true;
            int orderId = rs.getInt("id");
            String status = rs.getString("status");
            double total = rs.getDouble("total_amount");
            String date = rs.getTimestamp("created_at").toString().substring(0,16);
%>
    <div class="order-card">
        <div class="order-header">
            <span class="order-id">Order #<%= orderId %></span>
            <span class="status <%= status %>"><%= status %></span>
        </div>
        <small style="color:#666;">Placed on: <%= date %></small>
        <table>
            <tr><th>Product</th><th>Qty</th><th>Unit Price</th><th>Subtotal</th><th>Review</th></tr>
<%
            PreparedStatement items = conn.prepareStatement(
                "SELECT oi.*, p.name FROM order_items oi JOIN products p ON oi.product_id=p.id WHERE oi.order_id=?");
            items.setInt(1, orderId);
            ResultSet itemRs = items.executeQuery();
            while (itemRs.next()) {
%>
            <tr>
                <td><%= itemRs.getString("name") %></td>
                <td><%= itemRs.getInt("quantity") %></td>
                <td>Rs.<%= itemRs.getDouble("unit_price") %></td>
                <td>Rs.<%= itemRs.getInt("quantity") * itemRs.getDouble("unit_price") %></td>
                <td>
                    <% if ("DELIVERED".equals(status)) { %>
                    <button class="btn-review" onclick="location.href='review.jsp?productId=<%= itemRs.getInt("product_id") %>&orderId=<%= orderId %>'">
                        ⭐ Review
                    </button>
                    <% } else { %>
                    <span style="color:#999;font-size:12px;">After delivery</span>
                    <% } %>
                </td>
            </tr>
<%          } %>
        </table>
        <div class="total">Order Total: Rs.<%= total %></div>
    </div>
<%
        }
        conn.close();
        if (!hasOrders) {
%>
    <div class="empty">
        <h3>No orders yet!</h3>
        <p>Start shopping to see your orders here.</p>
        <a href="index.jsp" style="color:#ff9900;">Browse Products →</a>
    </div>
<%      } %>
<%  } catch(Exception e) { out.println("Error: " + e.getMessage()); } %>
</div>
</body>
</html>
