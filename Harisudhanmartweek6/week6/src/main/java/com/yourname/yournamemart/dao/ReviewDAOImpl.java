package com.yourname.yournamemart.dao;

import com.yourname.yournamemart.exception.DataAccessException;
import com.yourname.yournamemart.model.Review;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * JDBC implementation. All SQL for reviews lives here (Section 2, rule 1).
 * Every Connection / PreparedStatement / ResultSet uses try-with-resources
 * (Section 2, rule 6). The DataSource comes from the HikariCP pool owned by
 * the ServletContextListener (Section 2, rule 5) - it is injected here, this
 * class never calls DriverManager.getConnection() itself.
 */
public class ReviewDAOImpl implements ReviewDAO {

    private final DataSource dataSource;

    public ReviewDAOImpl(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public Review insert(Review review) {
        String sql = "INSERT INTO reviews (product_id, user_id, rating, comment, created_at) "
                + "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setLong(1, review.getProductId());
            ps.setLong(2, review.getUserId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    review.setId(keys.getLong(1));
                }
            }
            return review;
        } catch (SQLException e) {
            throw new DataAccessException("Failed to insert review", e);
        }
    }

    @Override
    public List<Review> findByProductId(long productId) {
        String sql = "SELECT id, product_id, user_id, rating, comment, created_at "
                + "FROM reviews WHERE product_id = ? ORDER BY created_at DESC";
        List<Review> reviews = new ArrayList<>();

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapRow(rs));
                }
            }
            return reviews;
        } catch (SQLException e) {
            throw new DataAccessException("Failed to fetch reviews for product " + productId, e);
        }
    }

    @Override
    public Optional<Review> findByUserAndProduct(long userId, long productId) {
        String sql = "SELECT id, product_id, user_id, rating, comment, created_at "
                + "FROM reviews WHERE user_id = ? AND product_id = ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);
            ps.setLong(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
                return Optional.empty();
            }
        } catch (SQLException e) {
            throw new DataAccessException("Failed to look up existing review", e);
        }
    }

    @Override
    public double findAverageRating(long productId) {
        String sql = "SELECT AVG(rating) AS avg_rating FROM reviews WHERE product_id = ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("avg_rating");
                }
                return 0.0;
            }
        } catch (SQLException e) {
            throw new DataAccessException("Failed to compute average rating", e);
        }
    }

    private Review mapRow(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setId(rs.getLong("id"));
        review.setProductId(rs.getLong("product_id"));
        review.setUserId(rs.getLong("user_id"));
        review.setRating(rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        review.setCreatedAt(rs.getTimestamp("created_at"));
        return review;
    }
}
