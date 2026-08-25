package com.harisudhan.harisudhanmart.dao;

import com.harisudhan.harisudhanmart.model.Product;

import java.util.List;
import java.util.Optional;

public interface ProductDAO {
    Product create(Product product);
    Optional<Product> findById(long id);
    List<Product> findBySellerId(long sellerId);
    List<Product> findAll();
    boolean update(Product product);
    boolean delete(long id, long sellerId);
}
