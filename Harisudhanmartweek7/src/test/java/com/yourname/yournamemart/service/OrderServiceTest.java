package com.yourname.yournamemart.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * Template service test. Rename types/methods to match your actual
 * OrderService / CartDAO / ProductDAO / OrderDAO. The point of this layer
 * of tests (per Section 9) is verifying business rules WITHOUT touching a
 * real database — the DAO is mocked.
 */
@ExtendWith(MockitoExtension.class)
class OrderServiceTest {

    @Mock private CartDAO cartDAO;
    @Mock private ProductDAO productDAO;
    @Mock private OrderDAO orderDAO;

    private OrderService orderService;

    @BeforeEach
    void setUp() {
        orderService = new OrderServiceImpl(cartDAO, productDAO, orderDAO);
    }

    @Test
    @DisplayName("placeOrder() rejects checkout when cart is empty")
    void placeOrderRejectsEmptyCart() {
        when(cartDAO.findByUserId(1L)).thenReturn(List.of());

        var ex = assertThrows(IllegalStateException.class,
                () -> orderService.placeOrder(1L));

        assertTrue(ex.getMessage().toLowerCase().contains("empty"));
        verifyNoInteractions(orderDAO);
    }

    @Test
    @DisplayName("placeOrder() rejects an item whose requested quantity exceeds stock")
    void placeOrderRejectsInsufficientStock() throws SQLException {
        var cartItem = new CartItem(1L, 1L, /* productId */ 100L, /* qty */ 5);
        var product = new Product(100L, 2L, "Widget", "desc",
                new BigDecimal("9.99"), /* stockQty */ 2, "Tools");

        when(cartDAO.findByUserId(1L)).thenReturn(List.of(cartItem));
        when(productDAO.findById(100L)).thenReturn(java.util.Optional.of(product));

        var ex = assertThrows(IllegalStateException.class,
                () -> orderService.placeOrder(1L));

        assertTrue(ex.getMessage().toLowerCase().contains("stock"));
        verifyNoInteractions(orderDAO);
    }

    @Test
    @DisplayName("placeOrder() computes total_amount as the sum of qty * unit_price")
    void placeOrderComputesCorrectTotal() throws SQLException {
        var cartItem = new CartItem(1L, 1L, 100L, 3);
        var product = new Product(100L, 2L, "Widget", "desc",
                new BigDecimal("9.99"), 10, "Tools");

        when(cartDAO.findByUserId(1L)).thenReturn(List.of(cartItem));
        when(productDAO.findById(100L)).thenReturn(java.util.Optional.of(product));
        when(orderDAO.insert(any())).thenAnswer(inv -> inv.getArgument(0));

        Order result = orderService.placeOrder(1L);

        assertEquals(new BigDecimal("29.97"), result.getTotalAmount());
        verify(cartDAO).clearForUser(1L);
    }
}
