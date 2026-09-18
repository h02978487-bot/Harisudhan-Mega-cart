package com.harisudhan.harisudhanmart.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Product {
    private long id;
    private long sellerId;
    private String name;
    private String description;
    private BigDecimal price;
    private int stockQty;
    private String category;
    private String imageUrl;
    private LocalDateTime createdAt;

    public Product() { }

    public Product(long sellerId, String name, String description, BigDecimal price,
                    int stockQty, String category, String imageUrl) {
        this.sellerId = sellerId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stockQty = stockQty;
        this.category = category;
        this.imageUrl = imageUrl;
    }

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getSellerId() { return sellerId; }
    public void setSellerId(long sellerId) { this.sellerId = sellerId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getStockQty() { return stockQty; }
    public void setStockQty(int stockQty) { this.stockQty = stockQty; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
