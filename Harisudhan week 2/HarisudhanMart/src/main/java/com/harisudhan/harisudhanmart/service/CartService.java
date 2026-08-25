package com.harisudhan.harisudhanmart.service;

import com.harisudhan.harisudhanmart.dao.CartDAO;
import com.harisudhan.harisudhanmart.dao.ProductDAO;
import com.harisudhan.harisudhanmart.dto.CartItemResponseDTO;
import com.harisudhan.harisudhanmart.dto.CartResponseDTO;
import com.harisudhan.harisudhanmart.exception.NotFoundException;
import com.harisudhan.harisudhanmart.exception.ValidationException;
import com.harisudhan.harisudhanmart.model.CartItem;
import com.harisudhan.harisudhanmart.model.Product;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** F4 business rules. No JDBC here — all persistence via CartDAO/ProductDAO. */
public class CartService {

    private final CartDAO cartDAO;
    private final ProductDAO productDAO;

    public CartService(CartDAO cartDAO, ProductDAO productDAO) {
        this.cartDAO = cartDAO;
        this.productDAO = productDAO;
    }

    public void addItem(long userId, long productId, int quantity)
            throws ValidationException, NotFoundException, SQLException {
        if (quantity < 1) {
            throw new ValidationException("quantity", "Quantity must be at least 1");
        }
        Product product = productDAO.findById(productId)
                .orElseThrow(() -> new NotFoundException("Product not found"));
        if (!product.isActive()) {
            throw new NotFoundException("Product not found");
        }
        cartDAO.addOrIncrement(userId, productId, quantity);
    }

    public void updateItem(long userId, long productId, int quantity)
            throws ValidationException, NotFoundException, SQLException {
        if (quantity < 1) {
            throw new ValidationException("quantity", "Quantity must be at least 1");
        }
        boolean updated = cartDAO.updateQuantity(userId, productId, quantity);
        if (!updated) {
            throw new NotFoundException("Item not in cart");
        }
    }

    public void removeItem(long userId, long productId) throws NotFoundException, SQLException {
        boolean removed = cartDAO.remove(userId, productId);
        if (!removed) {
            throw new NotFoundException("Item not in cart");
        }
    }

    public CartResponseDTO viewCart(long userId) throws SQLException {
        List<CartItem> items = cartDAO.findByUser(userId);
        List<CartItemResponseDTO> responseItems = new ArrayList<>();
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items) {
            Product product = productDAO.findById(item.getProductId()).orElse(null);
            if (product == null) {
                continue;
            }
            CartItemResponseDTO dto = new CartItemResponseDTO(
                    product.getId(), product.getName(), product.getPrice(), item.getQuantity());
            responseItems.add(dto);
            total = total.add(dto.getSubtotal());
        }
        return new CartResponseDTO(responseItems, total);
    }
}
