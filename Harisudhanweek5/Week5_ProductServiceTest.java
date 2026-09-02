// File: src/test/java/com/yourname/yournamemart/service/ProductServiceTest.java
package com.yourname.yournamemart.service;

import com.yourname.yournamemart.dao.ProductDAO;
import com.yourname.yournamemart.exception.ValidationException;
import com.yourname.yournamemart.model.Product;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class ProductServiceTest {
    @Mock
    private ProductDAO productDAO;
    
    private ProductService productService;

    @BeforeEach
    void setUp() {
        productService = new ProductService(productDAO);
    }

    @Test
    void testSearchByKeyword_Success() {
        // Arrange
        String keyword = "laptop";
        Product p1 = new Product(1, 1, "Dell Laptop", "High-end laptop", 
            new BigDecimal("899.99"), 5, "Electronics", null);
        when(productDAO.searchByKeyword(keyword))
            .thenReturn(Arrays.asList(p1));

        // Act
        List<Product> results = productService.searchByKeyword(keyword);

        // Assert
        assertEquals(1, results.size());
        assertEquals("Dell Laptop", results.get(0).getName());
        verify(productDAO).searchByKeyword(keyword);
    }

    @Test
    void testSearchByKeyword_EmptyKeyword() {
        // Assert
        assertThrows(ValidationException.class, () -> 
            productService.searchByKeyword("")
        );
    }

    @Test
    void testSearchByKeyword_NullKeyword() {
        // Assert
        assertThrows(ValidationException.class, () -> 
            productService.searchByKeyword(null)
        );
    }

    @Test
    void testSearchByKeyword_KeywordTooLong() {
        // Assert
        String longKeyword = "a".repeat(101);
        assertThrows(ValidationException.class, () -> 
            productService.searchByKeyword(longKeyword)
        );
    }

    @Test
    void testFilterByCategory_Success() {
        // Arrange
        String category = "Electronics";
        Product p1 = new Product(1, 1, "Laptop", "Dell", 
            new BigDecimal("999.99"), 3, "Electronics", null);
        Product p2 = new Product(2, 1, "Phone", "iPhone", 
            new BigDecimal("799.99"), 10, "Electronics", null);
        when(productDAO.filterByCategory(category))
            .thenReturn(Arrays.asList(p1, p2));

        // Act
        List<Product> results = productService.filterByCategory(category);

        // Assert
        assertEquals(2, results.size());
        verify(productDAO).filterByCategory(category);
    }

    @Test
    void testFilterByCategory_EmptyCategory() {
        // Assert
        assertThrows(ValidationException.class, () -> 
            productService.filterByCategory("")
        );
    }

    @Test
    void testSearchAndFilter_BothProvided() {
        // Arrange
        String keyword = "laptop";
        String category = "Electronics";
        Product p1 = new Product(1, 1, "Dell Laptop", "High-end", 
            new BigDecimal("899.99"), 5, "Electronics", null);
        when(productDAO.searchAndFilter(keyword, category))
            .thenReturn(Arrays.asList(p1));

        // Act
        List<Product> results = productService.searchAndFilter(keyword, category);

        // Assert
        assertEquals(1, results.size());
        verify(productDAO).searchAndFilter(keyword, category);
    }

    @Test
    void testSearchAndFilter_OnlyKeyword() {
        // Arrange
        String keyword = "laptop";
        Product p1 = new Product(1, 1, "Laptop", "Dell", 
            new BigDecimal("999.99"), 3, "Electronics", null);
        when(productDAO.searchByKeyword(keyword))
            .thenReturn(Arrays.asList(p1));

        // Act
        List<Product> results = productService.searchAndFilter(keyword, null);

        // Assert
        assertEquals(1, results.size());
        verify(productDAO).searchByKeyword(keyword);
    }

    @Test
    void testGetAllCategories_Success() {
        // Arrange
        List<String> categories = Arrays.asList("Electronics", "Books", "Clothing");
        when(productDAO.getAllCategories()).thenReturn(categories);

        // Act
        List<String> results = productService.getAllCategories();

        // Assert
        assertEquals(3, results.size());
        assertTrue(results.contains("Electronics"));
        verify(productDAO).getAllCategories();
    }
}
