package com.yourname.yournamemart.service;

import com.yourname.yournamemart.dao.OrderLookupForReview;
import com.yourname.yournamemart.dao.ReviewDAO;
import com.yourname.yournamemart.dto.ReviewRequestDTO;
import com.yourname.yournamemart.dto.ReviewResponseDTO;
import com.yourname.yournamemart.exception.ValidationException;
import com.yourname.yournamemart.model.Review;
import com.yourname.yournamemart.util.ValidationUtil;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Business rules for reviews (F8). Depends on the ReviewDAO interface, not
 * ReviewDAOImpl, per Section 12's SOLID rule.
 */
public class ReviewService {

    private final ReviewDAO reviewDAO;
    private final OrderLookupForReview orderLookup;

    public ReviewService(ReviewDAO reviewDAO, OrderLookupForReview orderLookup) {
        this.reviewDAO = reviewDAO;
        this.orderLookup = orderLookup;
    }

    /**
     * Submits a review. Validation runs first (Section 13, rule 5: validate
     * before any DAO call). Edge cases covered:
     *  - order must belong to the reviewer, be DELIVERED, and contain the product
     *  - one review per user per product (no duplicates)
     */
    public ReviewResponseDTO submitReview(long buyerId, ReviewRequestDTO request) {
        ValidationUtil.validateReviewRequest(request);

        boolean eligible = orderLookup.isDeliveredOrderContainingProduct(
                request.getOrderId(), buyerId, request.getProductId());
        if (!eligible) {
            throw new ValidationException("orderId",
                    "You can only review a product from one of your own delivered orders");
        }

        boolean alreadyReviewed = reviewDAO.findByUserAndProduct(buyerId, request.getProductId()).isPresent();
        if (alreadyReviewed) {
            throw new ValidationException("productId", "You have already reviewed this product");
        }

        Review review = new Review(request.getProductId(), buyerId, request.getRating(), request.getComment());
        Review saved = reviewDAO.insert(review);
        return ReviewResponseDTO.fromEntity(saved);
    }

    public List<ReviewResponseDTO> getReviewsForProduct(long productId) {
        if (productId <= 0) {
            throw new ValidationException("productId", "A valid productId is required");
        }
        return reviewDAO.findByProductId(productId).stream()
                .map(ReviewResponseDTO::fromEntity)
                .collect(Collectors.toList());
    }

    public double getAverageRating(long productId) {
        return reviewDAO.findAverageRating(productId);
    }
}
