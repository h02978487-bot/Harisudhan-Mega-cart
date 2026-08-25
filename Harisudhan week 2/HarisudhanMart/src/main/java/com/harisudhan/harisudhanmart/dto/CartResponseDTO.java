package com.harisudhan.harisudhanmart.dto;

import java.math.BigDecimal;
import java.util.List;

public final class CartResponseDTO {
    private final List<CartItemResponseDTO> items;
    private final BigDecimal total;

    public CartResponseDTO(List<CartItemResponseDTO> items, BigDecimal total) {
        this.items = items;
        this.total = total;
    }

    public List<CartItemResponseDTO> getItems() { return items; }
    public BigDecimal getTotal() { return total; }
}
