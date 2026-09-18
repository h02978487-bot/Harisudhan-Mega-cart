package com.harisudhan.harisudhanmart.dao;

import com.harisudhan.harisudhanmart.exception.InsufficientStockException;
import com.harisudhan.harisudhanmart.model.Order;
import com.harisudhan.harisudhanmart.model.OrderItem;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface OrderDAO {

    /**
     * Places an order atomically: inserts the order row, inserts each order_item,
     * decrements product stock for each item, and clears the buyer's cart.
     * Commits only if every step succeeds; rolls back entirely otherwise (F5).
     */
    Order placeOrder(long buyerId, List<OrderItem> items, BigDecimal totalAmount)
            throws SQLException, InsufficientStockException;

    Optional<Order> findById(long id) throws SQLException;

    List<Order> findByBuyer(long buyerId) throws SQLException;

    List<Order> findBySeller(long sellerId) throws SQLException;

    List<OrderItem> findItemsByOrder(long orderId) throws SQLException;

    boolean updateStatus(long orderId, Order.Status status) throws SQLException;
}
