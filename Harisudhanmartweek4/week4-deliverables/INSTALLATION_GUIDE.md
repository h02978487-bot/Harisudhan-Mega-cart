# Week 4 Installation Guide

This guide walks you through integrating Week 4 deliverables into your HarisudhanMart project.

## Prerequisites

- Running HarisudhanMart project from Week 3
- Maven build tool
- H2 database (server mode on live deployment)
- Git repository with remote

## Step 1: Database Migration

Execute the migration on your H2 database:

```bash
# If using H2 server mode
java -cp h2*.jar org.h2.tools.Shell -url jdbc:h2:tcp://localhost:9092/./data/harisudhanmart -user sa

# Then paste contents of:
# db/migrations/V4__add_soft_delete_and_indexes.sql
```

Or use your ORM/migration tool (Flyway, Liquibase).

## Step 2: DAO Layer Extensions

Update `ProductDAO.java`:
```java
List<Product> findBySellerId(int sellerId) throws SQLException;
List<Product> findByCategory(String category) throws SQLException;
void softDelete(int productId) throws SQLException;
List<Product> findAllPaginated(int offset, int limit) throws SQLException;
int count() throws SQLException;
```

Implement these in `ProductDAOImpl.java` (see src/snippets/ProductDAO_additions.java).

Similarly, update `UserDAO` and `OrderDAO` with paginated queries.

## Step 3: Service Layer

Copy `SellerService.java` to:
```
src/main/java/com/harisudhan/harisudhanmart/service/SellerService.java
```

Copy `AdminService.java` to:
```
src/main/java/com/harisudhan/harisudhanmart/service/AdminService.java
```

Update dependencies (DataSource, DAOs) in servlet init().

## Step 4: Controller Layer

Copy `SellerProductServlet.java` to:
```
src/main/java/com/harisudhan/harisudhanmart/controller/SellerProductServlet.java
```

Create similar servlets:
- `SellerOrderServlet.java`
- `AdminUsersServlet.java`
- `AdminOrdersServlet.java`
- `AdminListingsServlet.java`

All must check role in doGet/doPost/doPut/doDelete before proceeding.

## Step 5: View Layer

Copy `seller-dashboard.jsp` to:
```
src/main/webapp/WEB-INF/seller-dashboard.jsp
```

Create admin JSP views:
```
src/main/webapp/WEB-INF/admin-dashboard.jsp
src/main/webapp/WEB-INF/admin-users.jsp
src/main/webapp/WEB-INF/admin-orders.jsp
```

## Step 6: Build & Test

```bash
# Clean and rebuild
mvn clean package

# Run embedded H2 tests
mvn test

# Deploy to Tomcat
cp target/harisudhanmart.war /var/lib/tomcat/webapps/

# Restart Tomcat
sudo systemctl restart tomcat
```

## Step 7: Verify on Live URL

1. **Seller flow:**
   - Log in as seller
   - Navigate to `/harisudhanmart/seller/products`
   - Create a product → see it in table
   - Edit product → verify changes
   - Delete product → verify soft delete

2. **Admin flow:**
   - Log in as admin
   - Navigate to `/harisudhanmart/admin/users`
   - Verify paginated user list
   - Navigate to `/harisudhanmart/admin/orders`
   - Verify paginated order list

3. **Auth verification:**
   - Log in as seller
   - Try to access `/harisudhanmart/admin/users`
   - Should get 403 Forbidden

## Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| `403 Forbidden on /seller/products` | User not logged in or role != SELLER | Verify session + login page works |
| `NullPointerException in service` | DataSource not injected | Check ServletContextListener initializes DataSource in context |
| Products still visible after delete | Soft delete not queried | Verify `is_deleted = false` in findBySellerId() WHERE clause |
| Modal not opening | JavaScript error | Check browser console; ensure `classList` supported (ES5+) |
| Pagination not working | LIMIT/OFFSET not implemented | Add offset/limit params to DAO queries |

## Git Push

```bash
git add .
git commit -m "feat: week 4 seller dashboard and admin panel"
git push origin main
```

You should have **minimum 6–8 commits** across the week. Use:
```
feat: ...
test: ...
perf: ...
fix: ...
```

---

**Ready?** Follow WEEK4_ROADMAP.md and WEEK4_CHECKLIST.md for day-by-day execution.
