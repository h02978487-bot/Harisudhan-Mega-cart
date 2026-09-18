package com.harisudhan.harisudhanmart.service;

import com.harisudhan.harisudhanmart.dao.CartDAO;
import com.harisudhan.harisudhanmart.dao.OrderDAO;
import com.harisudhan.harisudhanmart.dao.ProductDAO;
import com.harisudhan.harisudhanmart.dto.OrderItemResponseDTO;
import com.harisudhan.harisudhanmart.dto.OrderResponseDTO;
import com.harisudhan.harisudhanmart.exception.InsufficientStockException;
import com.harisudhan.harisudhanmart.exception.ValidationException;
import com.harisudhan.harisudhanmart.model.CartItem;
import com.harisudhan.harisudhanmart.model.Order;
import com.harisudhan.harisudhanmart.model.OrderItem;
import com.harisudhan.harisudhanmart.model.Product;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** F5/F6 business rules. Checkout is transactional end-to-end inside OrderDAO#placeOrder. */
public class OrderService {

    private final OrderDAO orderDAO;
    private final CartDAO cartDAO;
    private final ProductDAO productDAO;

    public OrderService(OrderDAO orderDAO, CartDAO cartDAO, ProductDAO productDAO) {
        this.orderDAO = orderDAO;
        this.cartDAO = cartDAO;
        this.productDAO = productDAO;
    }

    public OrderResponseDTO checkout(long buyerId, boolean mockPaymentConfirmed)
            throws ValidationException, InsufficientStockException, SQLException {
        if (!mockPaymentConfirmed) {
            throw new ValidationException("paymentConfirmed", "Mock payment confirmation is required");
        }
        List<CartItem> cartItems = cartDAO.findByUser(buyerId);
        if (cartItems.isEmpty()) {
            throw new ValidationException("cart", "Cart is empty");
        }

        List<OrderItem> orderItems = new ArrayList<>();
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem cartItem : cartItems) {
            Product product = productDAO.findById(cartItem.getProductId())
                    .orElseThrow(() -> new ValidationException("cart", "A product in your cart no longer exists"));
            OrderItem orderItem = new OrderItem();
            orderItem.setProductId(product.getId());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setUnitPrice(product.getPrice());
            orderItems.add(orderItem);
            total = total.add(product.getPrice().multiply(BigDecimal.valueOf(cartItem.getQuantity())));
        }

        Order order = orderDAO.placeOrder(buyerId, orderItems, total);
        List<OrderItemResponseDTO> itemDTOs = new ArrayList<>();
        for (OrderItem item : orderItems) {
            itemDTOs.add(new OrderItemResponseDTO(item.getProductId(), item.getQuantity(), item.getUnitPrice()));
        }
        return new OrderResponseDTO(order, itemDTOs);
    }

    public List<Order> buyerHistory(long buyerId) throws SQLException {
        return orderDAO.findByBuyer(buyerId);
    }

    public List<Order> sellerIncomingOrders(long sellerId) throws SQLException {
        return orderDAO.findBySeller(sellerId);
    }

    public List<OrderItem> itemsForOrder(long orderId) throws SQLException {
        return orderDAO.findItemsByOrder(orderId);
    }
}
