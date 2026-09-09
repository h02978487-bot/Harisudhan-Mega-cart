package com.yourname.yournamemart.dao;

import org.junit.jupiter.api.*;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.*;
import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Template DAO test. Rename ProductDAO / method names to match your actual
 * DAO interface + implementation. Swap the connection setup for however
 * your project wires its DataSource in tests (this uses a raw
 * DriverManager connection purely for the isolated test schema — your
 * production code must still never call DriverManager.getConnection()
 * outside the ServletContextListener, per Section 2 rule 5).
 *
 * Uses an embedded, per-test in-memory H2 instance per Section 3/9:
 * jdbc:h2:mem:test;DB_CLOSE_DELAY=-1
 */
class ProductDAOTest {

    private static Connection conn;
    private ProductDAO productDAO;

    @BeforeAll
    static void setUpDatabase() throws Exception {
        conn = DriverManager.getConnection("jdbc:h2:mem:test;DB_CLOSE_DELAY=-1");
        String schema = Files.readString(Path.of("schema.sql"));
        try (Statement st = conn.createStatement()) {
            for (String stmt : schema.split(";")) {
                if (!stmt.isBlank()) {
                    st.execute(stmt);
                }
            }
        }
    }

    @AfterAll
    static void tearDownDatabase() throws SQLException {
        conn.close();
    }

    @BeforeEach
    void setUp() throws SQLException {
        // Adjust constructor to match your DAO — pass a DataSource/Connection
        // supplier consistent with how HikariCP hands out connections in prod.
        productDAO = new ProductDAOImpl(() -> conn);
        try (Statement st = conn.createStatement()) {
            st.execute("DELETE FROM products");
            st.execute("DELETE FROM users");
            st.execute("""
                INSERT INTO users (id, name, email, password_hash, role, created_at)
                VALUES (1, 'Test Seller', 'seller@test.com', 'hash', 'SELLER', CURRENT_TIMESTAMP)
            """);
        }
    }

    @Test
    @DisplayName("insert() persists a product with all fields and generates an id")
    void insertPersistsProduct() throws SQLException {
        var product = new Product(null, 1L, "Widget", "A test widget",
                new BigDecimal("19.99"), 10, "Tools");

        Product saved = productDAO.insert(product);

        assertNotNull(saved.getId());
        Product fetched = productDAO.findById(saved.getId()).orElseThrow();
        assertEquals("Widget", fetched.getName());
        assertEquals(new BigDecimal("19.99"), fetched.getPrice());
        assertEquals(10, fetched.getStockQty());
    }

    @Test
    @DisplayName("findByCategory() returns only products in that category")
    void findByCategoryFiltersCorrectly() throws SQLException {
        productDAO.insert(new Product(null, 1L, "Hammer", "desc",
                new BigDecimal("9.99"), 5, "Tools"));
        productDAO.insert(new Product(null, 1L, "Novel", "desc",
                new BigDecimal("14.99"), 3, "Books"));

        List<Product> tools = productDAO.findByCategory("Tools");

        assertEquals(1, tools.size());
        assertEquals("Hammer", tools.get(0).getName());
    }

    @Test
    @DisplayName("delete() removes the product so findById returns empty")
    void deleteRemovesProduct() throws SQLException {
        Product saved = productDAO.insert(new Product(null, 1L, "Temp", "desc",
                new BigDecimal("5.00"), 1, "Misc"));

        productDAO.delete(saved.getId());

        assertTrue(productDAO.findById(saved.getId()).isEmpty());
    }

    @Test
    @DisplayName("insert() rejects a negative stock quantity at the DAO boundary")
    void insertRejectsNegativeStock() {
        var invalid = new Product(null, 1L, "Bad", "desc",
                new BigDecimal("5.00"), -1, "Misc");

        assertThrows(IllegalArgumentException.class, () -> productDAO.insert(invalid));
    }
}
