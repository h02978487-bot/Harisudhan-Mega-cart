package com.harisudhan.harisudhanmart.dto;

import com.harisudhan.harisudhanmart.model.Order;
import java.math.BigDecimal;
import java.util.List;

public final class OrderResponseDTO {
    private final Long id;
    private final String status;
    private final BigDecimal totalAmount;
    private final List<OrderItemResponseDTO> items;

    public OrderResponseDTO(Order order, List<OrderItemResponseDTO> items) {
        this.id = order.getId();
        this.status = order.getStatus().name();
        this.totalAmount = order.getTotalAmount();
        this.items = items;
    }

    public Long getId() { return id; }
    public String getStatus() { return status; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public List<OrderItemResponseDTO> getItems() { return items; }
}
