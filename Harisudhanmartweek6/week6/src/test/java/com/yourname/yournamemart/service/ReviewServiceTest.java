package com.yourname.yournamemart.service;

import com.yourname.yournamemart.dao.OrderLookupForReview;
import com.yourname.yournamemart.dao.ReviewDAO;
import com.yourname.yournamemart.dto.ReviewRequestDTO;
import com.yourname.yournamemart.exception.ValidationException;
import com.yourname.yournamemart.model.Review;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Service-layer tests with the DAO mocked, per Section 9's testing matrix.
 * Covers the edge cases required for Week 6: invalid rating, review on a
 * non-delivered/foreign order, and duplicate reviews.
 */
class ReviewServiceTest {

    @Mock
    private ReviewDAO reviewDAO;

    @Mock
    private OrderLookupForReview orderLookup;

    private ReviewService reviewService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        reviewService = new ReviewService(reviewDAO, orderLookup);
    }

    private ReviewRequestDTO validRequest() {
        ReviewRequestDTO dto = new ReviewRequestDTO();
        dto.setOrderId(10L);
        dto.setProductId(5L);
        dto.setRating(4);
        dto.setComment("Good product");
        return dto;
    }

    @Test
    void rejectsRatingOutsideOneToFive() {
        ReviewRequestDTO dto = validRequest();
        dto.setRating(6);

        ValidationException ex = assertThrows(ValidationException.class,
                () -> reviewService.submitReview(1L, dto));
        assertEquals("rating", ex.getField());
        verifyNoInteractions(reviewDAO);
    }

    @Test
    void rejectsReviewOnOrderThatIsNotEligible() {
        ReviewRequestDTO dto = validRequest();
        when(orderLookup.isDeliveredOrderContainingProduct(10L, 1L, 5L)).thenReturn(false);

        ValidationException ex = assertThrows(ValidationException.class,
                () -> reviewService.submitReview(1L, dto));
        assertEquals("orderId", ex.getField());
        verify(reviewDAO, never()).insert(any());
    }

    @Test
    void rejectsDuplicateReviewForSameUserAndProduct() {
        ReviewRequestDTO dto = validRequest();
        when(orderLookup.isDeliveredOrderContainingProduct(10L, 1L, 5L)).thenReturn(true);
        when(reviewDAO.findByUserAndProduct(1L, 5L)).thenReturn(Optional.of(new Review()));

        ValidationException ex = assertThrows(ValidationException.class,
                () -> reviewService.submitReview(1L, dto));
        assertEquals("productId", ex.getField());
        verify(reviewDAO, never()).insert(any());
    }

    @Test
    void savesValidReview() {
        ReviewRequestDTO dto = validRequest();
        when(orderLookup.isDeliveredOrderContainingProduct(10L, 1L, 5L)).thenReturn(true);
        when(reviewDAO.findByUserAndProduct(1L, 5L)).thenReturn(Optional.empty());
        when(reviewDAO.insert(any(Review.class))).thenAnswer(invocation -> {
            Review r = invocation.getArgument(0);
            r.setId(99L);
            return r;
        });

        var result = reviewService.submitReview(1L, dto);

        assertEquals(99L, result.getId());
        assertEquals(4, result.getRating());
        verify(reviewDAO).insert(any(Review.class));
    }
}
