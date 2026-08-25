package com.harisudhan.harisudhanmart.dao;

import com.harisudhan.harisudhanmart.model.Review;
import java.sql.SQLException;
import java.util.List;

/** Full review-eligibility rules (F8) land in Week 6. Stubbed now so DAOFactory compiles. */
public interface ReviewDAO {
    Review create(Review review) throws SQLException;
    List<Review> findByProduct(long productId) throws SQLException;
}
