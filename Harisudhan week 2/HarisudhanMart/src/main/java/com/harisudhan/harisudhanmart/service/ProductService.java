package com.harisudhan.harisudhanmart.service;

import com.harisudhan.harisudhanmart.dao.ProductDAO;
import com.harisudhan.harisudhanmart.dto.ProductRequestDTO;
import com.harisudhan.harisudhanmart.exception.ForbiddenException;
import com.harisudhan.harisudhanmart.exception.NotFoundException;
import com.harisudhan.harisudhanmart.exception.ValidationException;
import com.harisudhan.harisudhanmart.model.Product;
import com.harisudhan.harisudhanmart.util.ValidationUtil;
import java.sql.SQLException;
import java.util.List;

/**
 * F2 (seller CRUD) and F3 (buyer search) business rules. No JDBC here (spec Section 2) —
 * all persistence goes through ProductDAO.
 */
public class ProductService {

    private final ProductDAO productDAO;

    public ProductService(ProductDAO productDAO) {
        this.productDAO = productDAO;
    }

    public Product create(long sellerId, ProductRequestDTO dto) throws ValidationException, SQLException {
        validate(dto);
        Product product = new Product();
        product.setSellerId(sellerId);
        product.setName(dto.getName().trim());
        product.setDescription(dto.getDescription());
        product.setPrice(dto.getPrice());
        product.setStockQty(dto.getStockQty());
        product.setCategory(dto.getCategory());
        product.setImageUrl(dto.getImageUrl());
        return productDAO.create(product);
    }

    public Product update(long productId, long sellerId, ProductRequestDTO dto)
            throws ValidationException, NotFoundException, ForbiddenException, SQLException {
        validate(dto);
        Product existing = productDAO.findById(productId)
                .orElseThrow(() -> new NotFoundException("Product not found"));
        if (!existing.getSellerId().equals(sellerId)) {
            throw new ForbiddenException("You do not own this listing");
        }
        existing.setName(dto.getName().trim());
        existing.setDescription(dto.getDescription());
        existing.setPrice(dto.getPrice());
        existing.setStockQty(dto.getStockQty());
        existing.setCategory(dto.getCategory());
        existing.setImageUrl(dto.getImageUrl());
        productDAO.update(existing);
        return existing;
    }

    public void delete(long productId, long sellerId) throws NotFoundException, ForbiddenException, SQLException {
        Product existing = productDAO.findById(productId)
                .orElseThrow(() -> new NotFoundException("Product not found"));
        if (!existing.getSellerId().equals(sellerId)) {
            throw new ForbiddenException("You do not own this listing");
        }
        productDAO.delete(productId, sellerId);
    }

    public List<Product> search(String keyword, String category) throws SQLException {
        return productDAO.search(keyword, category);
    }

    public List<Product> listBySeller(long sellerId) throws SQLException {
        return productDAO.findBySeller(sellerId);
    }

    public Product getOrThrow(long productId) throws NotFoundException, SQLException {
        return productDAO.findById(productId).orElseThrow(() -> new NotFoundException("Product not found"));
    }

    private void validate(ProductRequestDTO dto) throws ValidationException {
        if (ValidationUtil.isBlank(dto.getName())) {
            throw new ValidationException("name", "Product name is required");
        }
        if (!ValidationUtil.isPositive(dto.getPrice())) {
            throw new ValidationException("price", "Price must be greater than zero");
        }
        if (!ValidationUtil.isNonNegativeInt(dto.getStockQty())) {
            throw new ValidationException("stockQty", "Stock quantity must be zero or more");
        }
        if (ValidationUtil.isBlank(dto.getCategory())) {
            throw new ValidationException("category", "Category is required");
        }
    }
}
