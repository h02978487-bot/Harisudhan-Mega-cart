// Add these methods to your existing ProductDAO interface and implementation
// File: src/main/java/com/yourname/yournamemart/dao/ProductDAO.java

// ===== DAO INTERFACE ADDITIONS =====
public interface ProductDAO {
    // Existing methods...
    
    // Week 5: Search & Filter
    List<Product> searchByKeyword(String keyword);
    List<Product> filterByCategory(String category);
    List<Product> searchAndFilter(String keyword, String category);
    List<String> getAllCategories();
}

// ===== IMPLEMENTATION =====
// File: src/main/java/com/yourname/yournamemart/dao/impl/ProductDAOImpl.java

@Override
public List<Product> searchByKeyword(String keyword) {
    String sql = "SELECT id, seller_id, name, description, price, stock_qty, category, created_at "
               + "FROM products WHERE LOWER(name) LIKE ? OR LOWER(description) LIKE ? "
               + "ORDER BY created_at DESC";
    List<Product> results = new ArrayList<>();
    try (Connection conn = dataSource.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        String searchTerm = "%" + keyword.toLowerCase() + "%";
        pstmt.setString(1, searchTerm);
        pstmt.setString(2, searchTerm);
        try (ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                results.add(mapResultSetToProduct(rs));
            }
        }
    } catch (SQLException e) {
        logger.error("Error searching products by keyword: {}", keyword, e);
        throw new DataAccessException("Search failed", e);
    }
    return results;
}

@Override
public List<Product> filterByCategory(String category) {
    String sql = "SELECT id, seller_id, name, description, price, stock_qty, category, created_at "
               + "FROM products WHERE category = ? ORDER BY created_at DESC";
    List<Product> results = new ArrayList<>();
    try (Connection conn = dataSource.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setString(1, category);
        try (ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                results.add(mapResultSetToProduct(rs));
            }
        }
    } catch (SQLException e) {
        logger.error("Error filtering products by category: {}", category, e);
        throw new DataAccessException("Filter failed", e);
    }
    return results;
}

@Override
public List<Product> searchAndFilter(String keyword, String category) {
    String sql = "SELECT id, seller_id, name, description, price, stock_qty, category, created_at "
               + "FROM products WHERE (LOWER(name) LIKE ? OR LOWER(description) LIKE ?) "
               + "AND category = ? ORDER BY created_at DESC";
    List<Product> results = new ArrayList<>();
    try (Connection conn = dataSource.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        String searchTerm = "%" + keyword.toLowerCase() + "%";
        pstmt.setString(1, searchTerm);
        pstmt.setString(2, searchTerm);
        pstmt.setString(3, category);
        try (ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                results.add(mapResultSetToProduct(rs));
            }
        }
    } catch (SQLException e) {
        logger.error("Error in search and filter", e);
        throw new DataAccessException("Search and filter failed", e);
    }
    return results;
}

@Override
public List<String> getAllCategories() {
    String sql = "SELECT DISTINCT category FROM products WHERE category IS NOT NULL ORDER BY category";
    List<String> categories = new ArrayList<>();
    try (Connection conn = dataSource.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql);
         ResultSet rs = pstmt.executeQuery()) {
        while (rs.next()) {
            categories.add(rs.getString("category"));
        }
    } catch (SQLException e) {
        logger.error("Error fetching categories", e);
        throw new DataAccessException("Failed to fetch categories", e);
    }
    return categories;
}
