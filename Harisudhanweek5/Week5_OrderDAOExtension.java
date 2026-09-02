// Add these methods to your existing OrderDAO interface and implementation
// File: src/main/java/com/yourname/yournamemart/dao/OrderDAO.java

// ===== DAO INTERFACE ADDITIONS =====
public interface OrderDAO {
    // Existing methods...
    
    // Week 5: Order Status Workflow
    Order updateOrderStatus(long orderId, String newStatus);
    List<Order> getOrdersByStatus(String status);
    List<Order> getOrdersBySellerAndStatus(long sellerId, String status);
}

// ===== IMPLEMENTATION =====
// File: src/main/java/com/yourname/yournamemart/dao/impl/OrderDAOImpl.java

@Override
public Order updateOrderStatus(long orderId, String newStatus) {
    String sql = "UPDATE orders SET status = ? WHERE id = ?";
    try (Connection conn = dataSource.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setString(1, newStatus);
        pstmt.setLong(2, orderId);
        int rowsUpdated = pstmt.executeUpdate();
        if (rowsUpdated == 0) {
            throw new DataAccessException("Order not found");
        }
    } catch (SQLException e) {
        logger.error("Error updating order status for order {}: {}", orderId, newStatus, e);
        throw new DataAccessException("Failed to update order status", e);
    }
    // Fetch and return updated order
    return findById(orderId);
}

@Override
public List<Order> getOrdersByStatus(String status) {
    String sql = "SELECT id, buyer_id, status, total_amount, created_at FROM orders "
               + "WHERE status = ? ORDER BY created_at DESC";
    List<Order> orders = new ArrayList<>();
    try (Connection conn = dataSource.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setString(1, status);
        try (ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        }
    } catch (SQLException e) {
        logger.error("Error fetching orders by status: {}", status, e);
        throw new DataAccessException("Failed to fetch orders", e);
    }
    return orders;
}

@Override
public List<Order> getOrdersBySellerAndStatus(long sellerId, String status) {
    String sql = "SELECT DISTINCT o.id, o.buyer_id, o.status, o.total_amount, o.created_at "
               + "FROM orders o "
               + "JOIN order_items oi ON o.id = oi.order_id "
               + "JOIN products p ON oi.product_id = p.id "
               + "WHERE p.seller_id = ? AND o.status = ? "
               + "ORDER BY o.created_at DESC";
    List<Order> orders = new ArrayList<>();
    try (Connection conn = dataSource.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setLong(1, sellerId);
        pstmt.setString(2, status);
        try (ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        }
    } catch (SQLException e) {
        logger.error("Error fetching seller orders by status - seller: {}, status: {}", sellerId, status, e);
        throw new DataAccessException("Failed to fetch seller orders", e);
    }
    return orders;
}
