package com.harisudhan.harisudhanmart.dao;

import com.harisudhan.harisudhanmart.model.Product;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface ProductDAO {
    Product create(Product product) throws SQLException;
    Optional<Product> findById(long id) throws SQLException;
    List<Product> search(String keyword, String category) throws SQLException;
    List<Product> findBySeller(long sellerId) throws SQLException;
    boolean update(Product product) throws SQLException;
    boolean delete(long id, long sellerId) throws SQLException;
}
