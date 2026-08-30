package com.harisudhan.harisudhanmart.service;

import com.harisudhan.harisudhanmart.dao.ProductDAO;
import com.harisudhan.harisudhanmart.dao.OrderDAO;
import com.harisudhan.harisudhanmart.model.Product;
import com.harisudhan.harisudhanmart.model.Order;
import com.harisudhan.harisudhanmart.dto.ProductResponseDTO;
import com.harisudhan.harisudhanmart.exception.ValidationException;
import com.harisudhan.harisudhanmart.exception.AuthorizationException;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Business logic for seller operations: product management and order viewing.
 */
public class SellerService {
    private ProductDAO productDAO;
    private OrderDAO orderDAO;

    public SellerService(ProductDAO productDAO, OrderDAO orderDAO) {
        this.productDAO = productDAO;
        this.orderDAO = orderDAO;
    }

    /**
     * Create a new product for the seller.
     */
    public ProductResponseDTO createProduct(CreateProductRequest req, int sellerId) 
            throws SQLException {
        if (req.getName() == null || req.getName().trim().isEmpty()) {
            throw new ValidationException("Product name is required");
        }
        if (req.getPrice() <= 0) {
            throw new ValidationException("Price must be greater than 0");
        }
        if (req.getStockQty() < 0) {
            throw new ValidationException("Stock quantity cannot be negative");
        }
        if (req.getCategory() == null || req.getCategory().trim().isEmpty()) {
            throw new ValidationException("Category is required");
        }

        Product p = new Product();
        p.setSellerId(sellerId);
        p.setName(req.getName());
        p.setDescription(req.getDescription());
        p.setPrice(req.getPrice());
        p.setStockQty(req.getStockQty());
        p.setCategory(req.getCategory());

        productDAO.create(p);
        return mapToDTO(p);
    }

    /**
     * Edit an existing product (seller can only edit their own).
     */
    public ProductResponseDTO editProduct(int productId, EditProductRequest req, int sellerId) 
            throws SQLException {
        Product p = productDAO.findById(productId);
        if (p == null) {
            throw new ValidationException("Product not found");
        }
        if (p.getSellerId() != sellerId) {
            throw new AuthorizationException("You can only edit your own products");
        }

        p.setName(req.getName());
        p.setDescription(req.getDescription());
        p.setPrice(req.getPrice());
        p.setStockQty(req.getStockQty());
        p.setCategory(req.getCategory());

        productDAO.update(p);
        return mapToDTO(p);
    }

    /**
     * Delete a product (seller can only delete their own).
     */
    public void deleteProduct(int productId, int sellerId) throws SQLException {
        Product p = productDAO.findById(productId);
        if (p == null) {
            throw new ValidationException("Product not found");
        }
        if (p.getSellerId() != sellerId) {
            throw new AuthorizationException("You can only delete your own products");
        }
        productDAO.softDelete(productId);
    }

    /**
     * Get all products for the seller.
     */
    public List<ProductResponseDTO> getMyProducts(int sellerId) throws SQLException {
        return productDAO.findBySellerId(sellerId)
            .stream()
            .map(this::mapToDTO)
            .collect(Collectors.toList());
    }

    /**
     * Get incoming orders for seller's products.
     */
    public List<OrderWithItemsDTO> getIncomingOrders(int sellerId) throws SQLException {
        return orderDAO.findBySellerIdWithItems(sellerId);
    }

    private ProductResponseDTO mapToDTO(Product p) {
        ProductResponseDTO dto = new ProductResponseDTO();
        dto.setId(p.getId());
        dto.setSellerId(p.getSellerId());
        dto.setName(p.getName());
        dto.setDescription(p.getDescription());
        dto.setPrice(p.getPrice());
        dto.setStockQty(p.getStockQty());
        dto.setCategory(p.getCategory());
        return dto;
    }
}
