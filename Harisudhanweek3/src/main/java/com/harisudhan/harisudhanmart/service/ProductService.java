package com.harisudhan.harisudhanmart.service;

import com.harisudhan.harisudhanmart.dao.ProductDAO;
import com.harisudhan.harisudhanmart.model.Product;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public class ProductService {

    private final ProductDAO productDAO;

    public ProductService(ProductDAO productDAO) {
        this.productDAO = productDAO;
    }

    public Product createListing(long sellerId, String name, String description,
                                  BigDecimal price, int stockQty, String category, String imageUrl) {
        validate(name, price, stockQty);
        Product p = new Product(sellerId, name.trim(), description, price, stockQty, category, imageUrl);
        return productDAO.create(p);
    }

    public List<Product> getListingsForSeller(long sellerId) {
        return productDAO.findBySellerId(sellerId);
    }

    public Optional<Product> getById(long id) {
        return productDAO.findById(id);
    }

    /** Returns false if the product doesn't exist or doesn't belong to this seller. */
    public boolean updateListing(long id, long sellerId, String name, String description,
                                  BigDecimal price, int stockQty, String category, String imageUrl) {
        validate(name, price, stockQty);
        Optional<Product> existing = productDAO.findById(id);
        if (existing.isEmpty() || existing.get().getSellerId() != sellerId) {
            return false;
        }
        Product p = existing.get();
        p.setName(name.trim());
        p.setDescription(description);
        p.setPrice(price);
        p.setStockQty(stockQty);
        p.setCategory(category);
        p.setImageUrl(imageUrl);
        return productDAO.update(p);
    }

    public boolean deleteListing(long id, long sellerId) {
        return productDAO.delete(id, sellerId);
    }

    private void validate(String name, BigDecimal price, int stockQty) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Product name is required");
        }
        if (price == null || price.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Price must be greater than zero");
        }
        if (stockQty < 0) {
            throw new IllegalArgumentException("Stock quantity cannot be negative");
        }
    }
}
