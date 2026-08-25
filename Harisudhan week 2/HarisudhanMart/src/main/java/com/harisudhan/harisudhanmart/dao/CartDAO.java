package com.harisudhan.harisudhanmart.dao;

import com.harisudhan.harisudhanmart.model.CartItem;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface CartDAO {
    CartItem addOrIncrement(long userId, long productId, int quantity) throws SQLException;
    boolean updateQuantity(long userId, long productId, int quantity) throws SQLException;
    boolean remove(long userId, long productId) throws SQLException;
    List<CartItem> findByUser(long userId) throws SQLException;
    Optional<CartItem> find(long userId, long productId) throws SQLException;
    void clearCart(long userId) throws SQLException;
}
