package com.harisudhan.harisudhanmart.dto;

import java.math.BigDecimal;

public final class CartItemResponseDTO {
    private final Long productId;
    private final String productName;
    private final BigDecimal unitPrice;
    private final Integer quantity;
    private final BigDecimal subtotal;

    public CartItemResponseDTO(Long productId, String productName, BigDecimal unitPrice, Integer quantity) {
        this.productId = productId;
        this.productName = productName;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
        this.subtotal = unitPrice.multiply(BigDecimal.valueOf(quantity));
    }

    public Long getProductId() { return productId; }
    public String getProductName() { return productName; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public Integer getQuantity() { return quantity; }
    public BigDecimal getSubtotal() { return subtotal; }
}
