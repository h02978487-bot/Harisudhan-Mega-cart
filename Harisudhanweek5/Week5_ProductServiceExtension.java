// Add these methods to your existing ProductService
// File: src/main/java/com/yourname/yournamemart/service/ProductService.java

@Override
public List<Product> searchByKeyword(String keyword) {
    if (keyword == null || keyword.trim().isEmpty()) {
        throw new ValidationException("Search keyword cannot be empty");
    }
    if (keyword.length() > 100) {
        throw new ValidationException("Search keyword too long (max 100 chars)");
    }
    return productDAO.searchByKeyword(keyword.trim());
}

@Override
public List<Product> filterByCategory(String category) {
    if (category == null || category.trim().isEmpty()) {
        throw new ValidationException("Category cannot be empty");
    }
    return productDAO.filterByCategory(category);
}

@Override
public List<Product> searchAndFilter(String keyword, String category) {
    if ((keyword == null || keyword.trim().isEmpty()) && 
        (category == null || category.trim().isEmpty())) {
        throw new ValidationException("At least one search criterion required");
    }
    
    String trimmedKeyword = keyword != null ? keyword.trim() : "";
    String trimmedCategory = category != null ? category.trim() : "";
    
    // If only keyword, search by keyword
    if (trimmedKeyword.isEmpty()) {
        return filterByCategory(trimmedCategory);
    }
    // If only category, filter by category
    if (trimmedCategory.isEmpty()) {
        return searchByKeyword(trimmedKeyword);
    }
    // Both provided
    return productDAO.searchAndFilter(trimmedKeyword, trimmedCategory);
}

@Override
public List<String> getAllCategories() {
    return productDAO.getAllCategories();
}
