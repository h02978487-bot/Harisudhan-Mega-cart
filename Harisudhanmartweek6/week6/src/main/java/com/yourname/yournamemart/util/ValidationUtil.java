package com.yourname.yournamemart.util;

import com.yourname.yournamemart.dto.ReviewRequestDTO;
import com.yourname.yournamemart.exception.ValidationException;

/**
 * Central place for input validation rules. Add other entities' validation
 * methods here too (products, cart, checkout) to keep validation logic out
 * of servlets and services, per Section 12.
 */
public final class ValidationUtil {

    private static final int MAX_COMMENT_LENGTH = 1000;
    private static final int MIN_RATING = 1;
    private static final int MAX_RATING = 5;

    private ValidationUtil() {
    }

    /**
     * Validates a review submission. Throws ValidationException on the first
     * failure found; the servlet maps this to an HTTP 400 with a field-level
     * error (Section 13).
     */
    public static void validateReviewRequest(ReviewRequestDTO request) {
        if (request == null) {
            throw new ValidationException("body", "Request body is required");
        }
        if (request.getOrderId() <= 0) {
            throw new ValidationException("orderId", "A valid orderId is required");
        }
        if (request.getProductId() <= 0) {
            throw new ValidationException("productId", "A valid productId is required");
        }
        if (request.getRating() < MIN_RATING || request.getRating() > MAX_RATING) {
            throw new ValidationException("rating", "Rating must be between " + MIN_RATING + " and " + MAX_RATING);
        }
        if (request.getComment() != null && request.getComment().length() > MAX_COMMENT_LENGTH) {
            throw new ValidationException("comment", "Comment must be " + MAX_COMMENT_LENGTH + " characters or fewer");
        }
        // Basic XSS-guard note: comment is stored as-is here; it MUST be escaped
        // at render time with <c:out> / fn:escapeXml per Section 2, rule 4 -
        // never trust that this validation alone makes it safe to render raw.
    }
}
