package com.yourname.yournamemart.dao;

import com.yourname.yournamemart.model.Review;

import java.util.List;
import java.util.Optional;

/**
 * DAO abstraction for the reviews table. Service layer depends on this
 * interface, not on ReviewDAOImpl directly (Section 12, SOLID rule).
 */
public interface ReviewDAO {

    Review insert(Review review);

    List<Review> findByProductId(long productId);

    Optional<Review> findByUserAndProduct(long userId, long productId);

    double findAverageRating(long productId);
}
