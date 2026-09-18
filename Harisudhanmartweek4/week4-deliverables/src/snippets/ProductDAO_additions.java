// Add these methods to ProductDAO interface

/**
 * Find all non-deleted products by seller ID.
 */
List<Product> findBySellerId(int sellerId) throws SQLException;

/**
 * Find all non-deleted products in a category.
 */
List<Product> findByCategory(String category) throws SQLException;

/**
 * Soft-delete a product (set is_deleted = true).
 */
void softDelete(int productId) throws SQLException;

/**
 * Find all products with pagination.
 */
List<Product> findAllPaginated(int offset, int limit) throws SQLException;

/**
 * Get total count of non-deleted products.
 */
int count() throws SQLException;
