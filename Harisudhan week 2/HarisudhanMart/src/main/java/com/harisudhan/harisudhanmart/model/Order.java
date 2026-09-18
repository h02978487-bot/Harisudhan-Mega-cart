package com.harisudhan.harisudhanmart.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Order {
    public enum Status { PENDING, CONFIRMED, SHIPPED, DELIVERED, CANCELLED }

    private Long id;
    private Long buyerId;
    private Status status;
    private BigDecimal totalAmount;
    private LocalDateTime createdAt;

    public Order() { }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getBuyerId() { return buyerId; }
    public void setBuyerId(Long buyerId) { this.buyerId = buyerId; }
    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
