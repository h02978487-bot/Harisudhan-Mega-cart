package com.harisudhan.harisudhanmart.service;

import com.harisudhan.harisudhanmart.dao.UserDAO;
import com.harisudhan.harisudhanmart.dao.OrderDAO;
import com.harisudhan.harisudhanmart.dao.ProductDAO;
import com.harisudhan.harisudhanmart.model.User;
import com.harisudhan.harisudhanmart.model.Order;
import com.harisudhan.harisudhanmart.dto.UserResponseDTO;
import com.harisudhan.harisudhanmart.dto.OrderResponseDTO;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Admin service: user lookup, order management, product moderation.
 */
public class AdminService {
    private UserDAO userDAO;
    private OrderDAO orderDAO;
    private ProductDAO productDAO;

    public AdminService(UserDAO userDAO, OrderDAO orderDAO, ProductDAO productDAO) {
        this.userDAO = userDAO;
        this.orderDAO = orderDAO;
        this.productDAO = productDAO;
    }

    /**
     * Get all users (paginated).
     */
    public Page<UserResponseDTO> getAllUsers(int pageNum, int pageSize) throws SQLException {
        int offset = (pageNum - 1) * pageSize;
        List<User> users = userDAO.findAllPaginated(offset, pageSize);
        int total = userDAO.count();

        return new Page<>(
            users.stream().map(this::userToDTO).collect(Collectors.toList()),
            pageNum, pageSize, total
        );
    }

    /**
     * Get all orders (paginated).
     */
    public Page<OrderResponseDTO> getAllOrders(int pageNum, int pageSize) throws SQLException {
        int offset = (pageNum - 1) * pageSize;
        List<Order> orders = orderDAO.findAllPaginated(offset, pageSize);
        int total = orderDAO.count();

        return new Page<>(
            orders.stream().map(this::orderToDTO).collect(Collectors.toList()),
            pageNum, pageSize, total
        );
    }

    /**
     * Soft-delete (moderate) a product.
     */
    public void removeProduct(int productId) throws SQLException {
        productDAO.softDelete(productId);
    }

    private UserResponseDTO userToDTO(User u) {
        UserResponseDTO dto = new UserResponseDTO();
        dto.setId(u.getId());
        dto.setName(u.getName());
        dto.setEmail(u.getEmail());
        dto.setRole(u.getRole());
        return dto;
    }

    private OrderResponseDTO orderToDTO(Order o) {
        OrderResponseDTO dto = new OrderResponseDTO();
        dto.setId(o.getId());
        dto.setBuyerId(o.getBuyerId());
        dto.setStatus(o.getStatus());
        dto.setTotalAmount(o.getTotalAmount());
        return dto;
    }
}

/**
 * Pagination wrapper for paginated results.
 */
class Page<T> {
    private List<T> content;
    private int pageNum;
    private int pageSize;
    private int totalCount;
    private int totalPages;

    public Page(List<T> content, int pageNum, int pageSize, int totalCount) {
        this.content = content;
        this.pageNum = pageNum;
        this.pageSize = pageSize;
        this.totalCount = totalCount;
        this.totalPages = (totalCount + pageSize - 1) / pageSize;
    }

    // Getters
    public List<T> getContent() { return content; }
    public int getPageNum() { return pageNum; }
    public int getPageSize() { return pageSize; }
    public int getTotalCount() { return totalCount; }
    public int getTotalPages() { return totalPages; }
    public boolean hasNext() { return pageNum < totalPages; }
    public boolean hasPrev() { return pageNum > 1; }
}
