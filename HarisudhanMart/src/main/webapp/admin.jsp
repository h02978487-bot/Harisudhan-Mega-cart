<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String role = (String) session.getAttribute("role");
    if (userId == null || !"ADMIN".equals(role)) {
        response.sendRedirect("login.jsp"); return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Panel - HarisudhanMart</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; margin: 0; }
        .header { background: #131921; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .header a { color: #ff9900; text-decoration: none; font-size: 22px; font-weight: bold; }
        .container { max-width: 1100px; margin: 30px auto; }
        .stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 25px; border-radius: 8px; text-align: center; border-top: 4px solid #ff9900; }
        .stat-num { font-size: 36px; font-weight: bold; color: #131921; }
        .stat-label { color: #666; margin-top: 5px; }
        .section { background: white; border-radius: 8px; padding: 20px; margin-bottom: 25px; }
        h2 { color: #131921; border-bottom: 2px solid #ff9900; padding-bottom: 10px; }
        h3 { color: #131921; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #131921; color: white; padding: 12px; text-align: left; }
        td { padding: 11px; border-bottom: 1px solid #eee; font-size: 14px; }
        tr:hover { background: #f9f9f9; }
        .badge { padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; }
        .BUYER { background: #cce5ff; color: #004085; }
        .SELLER { background: #d4edda; color: #155724; }
        .ADMIN { background: #f8d7da; color: #721c24; }
        .PENDING { background: #fff3cd; color: #856404; }
        .DELIVERED { background: #d4edda; color: #155724; }
        .CONFIRMED { background: #cce5ff; color: #004085; }
        .btn-del { background: #e74c3c; color: white; border: none; padding: 5px 12px; border-radius: 4px; cursor: pointer; font-size: 12px; }
        .tabs { display: flex; gap: 10px; margin-bottom: 20px; }
        .tab { padding: 10px 25px; border: none; border-radius: 4px; cursor: pointer; font-size: 15px; background: #eee; }
        .tab.active { background: #ff9900; color: white; font-weight: bold; }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
    </style>
</head>
<body>
<div class="header">
    <a href="index.jsp">🛒 HarisudhanMart</a>
    <span style="color:#ff9900;">👑 Admin Panel</span>
</div>
<div class="container">
    <h2>👑 Admin Dashboard</h2>
<%
    try {
        Class.forName("org.h2.Driver");
        Connection conn = DriverManager.getConnection("jdbc:h2:./data/harisudhanmart","sa","");

        // Stats
        ResultSet rs1 = conn.createStatement().executeQuery("SELECT COUNT(*) FROM users");
        rs1.next(); int totalUsers = rs1.getInt(1);

        ResultSet rs2 = conn.createStatement().executeQuery("SELECT COUNT(*) FROM orders");
        rs2.next(); int totalOrders = rs2.getInt(1);

        ResultSet rs3 = conn.createStatement().executeQuery("SELECT COUNT(*) FROM products");
        rs3.next(); int totalProducts = rs3.getInt(1);
%>
    <div class="stats">
        <div class="stat-card">
            <div class="stat-num"><%= totalUsers %></div>
            <div class="stat-label">👥 Total Users</div>
        </div>
        <div class="stat-card">
            <div class="stat-num"><%= totalOrders %></div>
            <div class="stat-label">📦 Total Orders</div>
        </div>
        <div class="stat-card">
            <div class="stat-num"><%= totalProducts %></div>
            <div class="stat-label">🛍️ Total Products</div>
        </div>
    </div>

    <div class="tabs">
        <button class="tab active" onclick="showTab('users')">👥 Users</button>
        <button class="tab" onclick="showTab('orders')">📦 Orders</button>
        <button class="tab" onclick="showTab('products')">🛍️ Products</button>
    </div>

    <!-- USERS TAB -->
    <div id="users" class="tab-content active">
        <div class="section">
            <h3>All Users</h3>
            <table>
                <tr><th>#</th><th>Name</th><th>Email</th><th>Role</th><th>Joined</th><th>Action</th></tr>
<%
        PreparedStatement uPs = conn.prepareStatement("SELECT * FROM users ORDER BY created_at DESC");
        ResultSet uRs = uPs.executeQuery();
        while (uRs.next()) {
%>
                <tr>
                    <td><%= uRs.getInt("id") %></td>
                    <td><%= uRs.getString("name") %></td>
                    <td><%= uRs.getString("email") %></td>
                    <td><span class="badge <%= uRs.getString("role") %>"><%= uRs.getString("role") %></span></td>
                    <td><%= uRs.getTimestamp("created_at").toString().substring(0,10) %></td>
                    <td>
                        <% if (!uRs.getString("role").equals("ADMIN")) { %>
                        <form method="post" action="adminAction" style="display:inline">
                            <input type="hidden" name="action" value="deleteUser"/>
                            <input type="hidden" name="id" value="<%= uRs.getInt("id") %>"/>
                            <button type="submit" class="btn-del" onclick="return confirm('Delete this user?')">Delete</button>
                        </form>
                        <% } %>
                    </td>
                </tr>
<%      } %>
            </table>
        </div>
    </div>

    <!-- ORDERS TAB -->
    <div id="orders" class="tab-content">
        <div class="section">
            <h3>All Orders</h3>
            <table>
                <tr><th>Order#</th><th>Buyer</th><th>Total</th><th>Status</th><th>Date</th><th>Action</th></tr>
<%
        PreparedStatement oPs = conn.prepareStatement(
            "SELECT o.*, u.name as buyer_name FROM orders o JOIN users u ON o.buyer_id=u.id ORDER BY o.created_at DESC");
        ResultSet oRs = oPs.executeQuery();
        while (oRs.next()) {
%>
                <tr>
                    <td>#<%= oRs.getInt("id") %></td>
                    <td><%= oRs.getString("buyer_name") %></td>
                    <td>Rs.<%= oRs.getDouble("total_amount") %></td>
                    <td><span class="badge <%= oRs.getString("status") %>"><%= oRs.getString("status") %></span></td>
                    <td><%= oRs.getTimestamp("created_at").toString().substring(0,10) %></td>
                    <td>
                        <form method="post" action="adminAction" style="display:inline">
                            <input type="hidden" name="action" value="updateStatus"/>
                            <input type="hidden" name="orderId" value="<%= oRs.getInt("id") %>"/>
                            <select name="status" style="padding:4px;font-size:12px;">
                                <option>PENDING</option>
                                <option>CONFIRMED</option>
                                <option>SHIPPED</option>
                                <option>DELIVERED</option>
                                <option>CANCELLED</option>
                            </select>
                            <button type="submit" style="background:#28a745;color:white;border:none;padding:5px 10px;border-radius:4px;cursor:pointer;font-size:12px;">Update</button>
                        </form>
                    </td>
                </tr>
<%      } %>
            </table>
        </div>
    </div>

    <!-- PRODUCTS TAB -->
    <div id="products" class="tab-content">
        <div class="section">
            <h3>All Products</h3>
            <table>
                <tr><th>#</th><th>Name</th><th>Category</th><th>Price</th><th>Stock</th><th>Seller</th><th>Action</th></tr>
<%
        PreparedStatement pPs = conn.prepareStatement(
            "SELECT p.*, u.name as seller_name FROM products p JOIN users u ON p.seller_id=u.id ORDER BY p.created_at DESC");
        ResultSet pRs = pPs.executeQuery();
        while (pRs.next()) {
%>
                <tr>
                    <td><%= pRs.getInt("id") %></td>
                    <td><%= pRs.getString("name") %></td>
                    <td><%= pRs.getString("category") %></td>
                    <td>Rs.<%= pRs.getDouble("price") %></td>
                    <td><%= pRs.getInt("stock_qty") %></td>
                    <td><%= pRs.getString("seller_name") %></td>
                    <td>
                        <form method="post" action="adminAction" style="display:inline">
                            <input type="hidden" name="action" value="deleteProduct"/>
                            <input type="hidden" name="id" value="<%= pRs.getInt("id") %>"/>
                            <button type="submit" class="btn-del" onclick="return confirm('Delete this product?')">Delete</button>
                        </form>
                    </td>
                </tr>
<%      } %>
            </table>
        </div>
    </div>
<%
        conn.close();
    } catch(Exception e) { out.println("Error: " + e.getMessage()); }
%>
</div>
<script>
function showTab(name) {
    document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
    document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
    document.getElementById(name).classList.add('active');
    event.target.classList.add('active');
}
</script>
</body>
</html>
