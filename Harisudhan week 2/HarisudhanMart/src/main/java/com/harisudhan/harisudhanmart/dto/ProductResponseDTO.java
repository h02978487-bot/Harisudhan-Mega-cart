package com.harisudhan.harisudhanmart.dto;

import com.harisudhan.harisudhanmart.model.Product;
import java.math.BigDecimal;

public final class ProductResponseDTO {
    private final Long id;
    private final Long sellerId;
    private final String name;
    private final String description;
    private final BigDecimal price;
    private final Integer stockQty;
    private final String category;
    private final String imageUrl;

    private ProductResponseDTO(Product product) {
        this.id = product.getId();
        this.sellerId = product.getSellerId();
        this.name = product.getName();
        this.description = product.getDescription();
        this.price = product.getPrice();
        this.stockQty = product.getStockQty();
        this.category = product.getCategory();
        this.imageUrl = product.getImageUrl();
    }

    public static ProductResponseDTO fromEntity(Product product) {
        return new ProductResponseDTO(product);
    }

    public Long getId() { return id; }
    public Long getSellerId() { return sellerId; }
    public String getName() { return name; }
    public String getDescription() { return description; }
    public BigDecimal getPrice() { return price; }
    public Integer getStockQty() { return stockQty; }
    public String getCategory() { return category; }
    public String getImageUrl() { return imageUrl; }
}
