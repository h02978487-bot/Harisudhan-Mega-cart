package com.yourname.yournamemart.model;

import java.sql.Timestamp;

/**
 * Entity representing a product review left by a buyer on a completed order.
 * Maps directly to the `reviews` table (Section 4 of the spec).
 */
public class Review {

    private long id;
    private long productId;
    private long userId;
    private int rating;        // 1-5 stars, validated in ReviewService
    private String comment;    // nullable, max length enforced in ValidationUtil
    private Timestamp createdAt;

    public Review() {
    }

    public Review(long productId, long userId, int rating, String comment) {
        this.productId = productId;
        this.userId = userId;
        this.rating = rating;
        this.comment = comment;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
