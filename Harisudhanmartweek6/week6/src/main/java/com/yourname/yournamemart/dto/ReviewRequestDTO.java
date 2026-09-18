package com.yourname.yournamemart.dto;

/**
 * Shape of the JSON body accepted by POST /api/v1/reviews.
 * Kept separate from the Review entity per Section 13, rule 4.
 */
public class ReviewRequestDTO {

    private long orderId;      // the completed order this review is tied to
    private long productId;
    private int rating;
    private String comment;

    public long getOrderId() {
        return orderId;
    }

    public void setOrderId(long orderId) {
        this.orderId = orderId;
    }

    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
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
}
