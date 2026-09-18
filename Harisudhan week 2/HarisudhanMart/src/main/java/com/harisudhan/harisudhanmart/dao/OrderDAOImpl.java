package com.harisudhan.harisudhanmart.dao;

import com.harisudhan.harisudhanmart.exception.InsufficientStockException;
import com.harisudhan.harisudhanmart.model.Order;
import com.harisudhan.harisudhanmart.model.OrderItem;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import javax.sql.DataSource;

/**
 * F5 checkout persistence. placeOrder() runs on a single Connection with
 * autoCommit=false so the order row, its order_items, the stock decrements, and the
 * cart clear either all commit together or all roll back together.
 */
public class OrderDAOImpl implements OrderDAO {

    private final DataSource dataSource;

    public OrderDAOImpl(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public Order placeOrder(long buyerId, List<OrderItem> items, BigDecimal totalAmount)
            throws SQLException, InsufficientStockException {
        String insertOrderSql = "INSERT INTO orders (buyer_id, status, total_amount) VALUES (?, 'PENDING', ?)";
        String insertItemSql =
                "INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
        String decrementStockSql =
                "UPDATE products SET stock_qty = stock_qty - ? WHERE id = ? AND stock_qty >= ?";
        String clearCartSql = "DELETE FROM cart_items WHERE user_id = ?";

        try (Connection conn = dataSource.getConnection()) {
            conn.setAutoCommit(false);
            try {
                long orderId;
                try (PreparedStatement ps =
                        conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setLong(1, buyerId);
                    ps.setBigDecimal(2, totalAmount);
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        keys.next();
                        orderId = keys.getLong(1);
                    }
                }

                try (PreparedStatement stockPs = conn.prepareStatement(decrementStockSql);
                     PreparedStatement itemPs = conn.prepareStatement(insertItemSql)) {
                    for (OrderItem item : items) {
                        stockPs.setInt(1, item.getQuantity());
                        stockPs.setLong(2, item.getProductId());
                        stockPs.setInt(3, item.getQuantity());
                        int updated = stockPs.executeUpdate();
                        if (updated == 0) {
                            conn.rollback();
                            throw new InsufficientStockException(
                                    "Insufficient stock for product id " + item.getProductId());
                        }

                        itemPs.setLong(1, orderId);
                        itemPs.setLong(2, item.getProductId());
                        itemPs.setInt(3, item.getQuantity());
                        itemPs.setBigDecimal(4, item.getUnitPrice());
                        itemPs.addBatch();
                    }
                    itemPs.executeBatch();
                }

                try (PreparedStatement cartPs = conn.prepareStatement(clearCartSql)) {
                    cartPs.setLong(1, buyerId);
                    cartPs.executeUpdate();
                }

                conn.commit();

                Order order = new Order();
                order.setId(orderId);
                order.setBuyerId(buyerId);
                order.setStatus(Order.Status.PENDING);
                order.setTotalAmount(totalAmount);
                return order;
            } catch (InsufficientStockException e) {
                throw e;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    @Override
    public Optional<Order> findById(long id) throws SQLException {
        String sql = "SELECT * FROM orders WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(mapOrder(rs)) : Optional.empty();
            }
        }
    }

    @Override
    public List<Order> findByBuyer(long buyerId) throws SQLException {
        String sql = "SELECT * FROM orders WHERE buyer_id = ? ORDER BY created_at DESC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, buyerId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Order> orders = new ArrayList<>();
                while (rs.next()) {
                    orders.add(mapOrder(rs));
                }
                return orders;
            }
        }
    }

    @Override
    public List<Order> findBySeller(long sellerId) throws SQLException {
        String sql = "SELECT DISTINCT o.* FROM orders o "
                + "JOIN order_items oi ON oi.order_id = o.id "
                + "JOIN products p ON p.id = oi.product_id "
                + "WHERE p.seller_id = ? ORDER BY o.created_at DESC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, sellerId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Order> orders = new ArrayList<>();
                while (rs.next()) {
                    orders.add(mapOrder(rs));
                }
                return orders;
            }
        }
    }

    @Override
    public List<OrderItem> findItemsByOrder(long orderId) throws SQLException {
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                List<OrderItem> items = new ArrayList<>();
                while (rs.next()) {
                    items.add(mapItem(rs));
                }
                return items;
            }
        }
    }

    @Override
    public boolean updateStatus(long orderId, Order.Status status) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getLong("id"));
        order.setBuyerId(rs.getLong("buyer_id"));
        order.setStatus(Order.Status.valueOf(rs.getString("status")));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            order.setCreatedAt(ts.toLocalDateTime());
        }
        return order;
    }

    private OrderItem mapItem(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setId(rs.getLong("id"));
        item.setOrderId(rs.getLong("order_id"));
        item.setProductId(rs.getLong("product_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getBigDecimal("unit_price"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            item.setCreatedAt(ts.toLocalDateTime());
        }
        return item;
    }
}
