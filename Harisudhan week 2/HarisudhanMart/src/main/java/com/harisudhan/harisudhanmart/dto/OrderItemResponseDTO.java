package com.harisudhan.harisudhanmart.dto;

import java.math.BigDecimal;

public final class OrderItemResponseDTO {
    private final Long productId;
    private final Integer quantity;
    private final BigDecimal unitPrice;

    public OrderItemResponseDTO(Long productId, Integer quantity, BigDecimal unitPrice) {
        this.productId = productId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public Long getProductId() { return productId; }
    public Integer getQuantity() { return quantity; }
    public BigDecimal getUnitPrice() { return unitPrice; }
}
