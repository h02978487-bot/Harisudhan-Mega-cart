// File: src/test/java/com/yourname/yournamemart/service/OrderServiceTest.java
package com.yourname.yournamemart.service;

import com.yourname.yournamemart.dao.OrderDAO;
import com.yourname.yournamemart.exception.ValidationException;
import com.yourname.yournamemart.model.Order;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class OrderServiceTest {
    @Mock
    private OrderDAO orderDAO;
    
    private OrderService orderService;

    @BeforeEach
    void setUp() {
        orderService = new OrderService(orderDAO);
    }

    @Test
    void testUpdateOrderStatus_PendingToConfirmed_Success() {
        // Arrange
        long orderId = 1L;
        Order existingOrder = new Order(orderId, 2L, "PENDING", new BigDecimal("100.00"), null);
        Order updatedOrder = new Order(orderId, 2L, "CONFIRMED", new BigDecimal("100.00"), null);
        
        when(orderDAO.findById(orderId)).thenReturn(existingOrder);
        when(orderDAO.updateOrderStatus(orderId, "CONFIRMED")).thenReturn(updatedOrder);

        // Act
        Order result = orderService.updateOrderStatus(orderId, "CONFIRMED");

        // Assert
        assertEquals("CONFIRMED", result.getStatus());
        verify(orderDAO).findById(orderId);
        verify(orderDAO).updateOrderStatus(orderId, "CONFIRMED");
    }

    @Test
    void testUpdateOrderStatus_InvalidTransition() {
        // Arrange
        long orderId = 1L;
        Order existingOrder = new Order(orderId, 2L, "DELIVERED", new BigDecimal("100.00"), null);
        when(orderDAO.findById(orderId)).thenReturn(existingOrder);

        // Act & Assert
        assertThrows(ValidationException.class, () -> 
            orderService.updateOrderStatus(orderId, "PENDING")
        );
        verify(orderDAO, never()).updateOrderStatus(anyLong(), anyString());
    }

    @Test
    void testUpdateOrderStatus_InvalidStatus() {
        // Arrange
        long orderId = 1L;

        // Act & Assert
        assertThrows(ValidationException.class, () -> 
            orderService.updateOrderStatus(orderId, "INVALID_STATUS")
        );
        verify(orderDAO, never()).findById(anyLong());
    }

    @Test
    void testUpdateOrderStatus_OrderNotFound() {
        // Arrange
        long orderId = 999L;
        when(orderDAO.findById(orderId)).thenReturn(null);

        // Act & Assert
        assertThrows(ValidationException.class, () -> 
            orderService.updateOrderStatus(orderId, "CONFIRMED")
        );
    }

    @Test
    void testGetOrdersByStatus_Success() {
        // Arrange
        String status = "CONFIRMED";
        Order o1 = new Order(1L, 2L, "CONFIRMED", new BigDecimal("100.00"), null);
        Order o2 = new Order(2L, 3L, "CONFIRMED", new BigDecimal("200.00"), null);
        when(orderDAO.getOrdersByStatus(status))
            .thenReturn(Arrays.asList(o1, o2));

        // Act
        List<Order> results = orderService.getOrdersByStatus(status);

        // Assert
        assertEquals(2, results.size());
        assertTrue(results.stream().allMatch(o -> "CONFIRMED".equals(o.getStatus())));
        verify(orderDAO).getOrdersByStatus(status);
    }

    @Test
    void testGetOrdersByStatus_InvalidStatus() {
        // Act & Assert
        assertThrows(ValidationException.class, () -> 
            orderService.getOrdersByStatus("INVALID")
        );
        verify(orderDAO, never()).getOrdersByStatus(anyString());
    }

    @Test
    void testGetSellerOrdersByStatus_Success() {
        // Arrange
        long sellerId = 1L;
        String status = "SHIPPED";
        Order o1 = new Order(1L, 2L, "SHIPPED", new BigDecimal("150.00"), null);
        when(orderDAO.getOrdersBySellerAndStatus(sellerId, status))
            .thenReturn(Arrays.asList(o1));

        // Act
        List<Order> results = orderService.getSellerOrdersByStatus(sellerId, status);

        // Assert
        assertEquals(1, results.size());
        assertEquals("SHIPPED", results.get(0).getStatus());
        verify(orderDAO).getOrdersBySellerAndStatus(sellerId, status);
    }

    @Test
    void testStatusTransitions_ValidSequence() {
        // Valid transitions: PENDING → CONFIRMED → SHIPPED → DELIVERED
        long orderId = 1L;
        
        // PENDING → CONFIRMED
        Order pending = new Order(orderId, 1L, "PENDING", new BigDecimal("100.00"), null);
        Order confirmed = new Order(orderId, 1L, "CONFIRMED", new BigDecimal("100.00"), null);
        when(orderDAO.findById(orderId)).thenReturn(pending);
        when(orderDAO.updateOrderStatus(orderId, "CONFIRMED")).thenReturn(confirmed);
        assertEquals("CONFIRMED", orderService.updateOrderStatus(orderId, "CONFIRMED").getStatus());

        // CONFIRMED → SHIPPED
        when(orderDAO.findById(orderId)).thenReturn(confirmed);
        Order shipped = new Order(orderId, 1L, "SHIPPED", new BigDecimal("100.00"), null);
        when(orderDAO.updateOrderStatus(orderId, "SHIPPED")).thenReturn(shipped);
        assertEquals("SHIPPED", orderService.updateOrderStatus(orderId, "SHIPPED").getStatus());

        // SHIPPED → DELIVERED
        when(orderDAO.findById(orderId)).thenReturn(shipped);
        Order delivered = new Order(orderId, 1L, "DELIVERED", new BigDecimal("100.00"), null);
        when(orderDAO.updateOrderStatus(orderId, "DELIVERED")).thenReturn(delivered);
        assertEquals("DELIVERED", orderService.updateOrderStatus(orderId, "DELIVERED").getStatus());
    }

    @Test
    void testStatusTransitions_CancelFromPending() {
        // PENDING → CANCELLED should be allowed
        long orderId = 1L;
        Order pending = new Order(orderId, 1L, "PENDING", new BigDecimal("100.00"), null);
        Order cancelled = new Order(orderId, 1L, "CANCELLED", new BigDecimal("100.00"), null);
        
        when(orderDAO.findById(orderId)).thenReturn(pending);
        when(orderDAO.updateOrderStatus(orderId, "CANCELLED")).thenReturn(cancelled);
        
        assertEquals("CANCELLED", orderService.updateOrderStatus(orderId, "CANCELLED").getStatus());
    }
}
