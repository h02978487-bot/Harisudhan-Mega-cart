package com.harisudhan.harisudhanmart.dto;

import java.math.BigDecimal;

/** Request body for product create/update (F2). Separate from the Product entity. */
public final class ProductRequestDTO {
    private String name;
    private String description;
    private BigDecimal price;
    private Integer stockQty;
    private String category;
    private String imageUrl;

    public String getName() { return name; }
    public String getDescription() { return description; }
    public BigDecimal getPrice() { return price; }
    public Integer getStockQty() { return stockQty; }
    public String getCategory() { return category; }
    public String getImageUrl() { return imageUrl; }
}
