package com.yourname.yournamemart.dto;

import com.yourname.yournamemart.model.Review;

/**
 * Public-facing shape of a review returned to clients.
 */
public class ReviewResponseDTO {

    private long id;
    private long productId;
    private long userId;
    private int rating;
    private String comment;
    private String createdAt;

    public static ReviewResponseDTO fromEntity(Review review) {
        ReviewResponseDTO dto = new ReviewResponseDTO();
        dto.id = review.getId();
        dto.productId = review.getProductId();
        dto.userId = review.getUserId();
        dto.rating = review.getRating();
        dto.comment = review.getComment();
        dto.createdAt = review.getCreatedAt() != null ? review.getCreatedAt().toString() : null;
        return dto;
    }

    public long getId() {
        return id;
    }

    public long getProductId() {
        return productId;
    }

    public long getUserId() {
        return userId;
    }

    public int getRating() {
        return rating;
    }

    public String getComment() {
        return comment;
    }

    public String getCreatedAt() {
        return createdAt;
    }
}
