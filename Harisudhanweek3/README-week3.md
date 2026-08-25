# Week 3 (Aug 10–16) — Seller Dashboard: Listing Management

Per the spec's timeline, Week 3 output is: **"Review feedback addressed; seller
dashboard (listing management) started."** This drop covers the listing-management
half (F2): create, edit, delete product listings as a Seller.

## Files, and where they go in your existing repo

```
src/main/java/com/harisudhan/harisudhanmart/model/Product.java
src/main/java/com/harisudhan/harisudhanmart/dao/ProductDAO.java
src/main/java/com/harisudhan/harisudhanmart/dao/ProductDAOImpl.java
src/main/java/com/harisudhan/harisudhanmart/service/ProductService.java
src/main/java/com/harisudhan/harisudhanmart/controller/SellerProductServlet.java
src/main/webapp/seller/dashboard.jsp
src/main/webapp/seller/edit-product.jsp
```

## Before you commit — wiring this needs in your existing code

1. **DataSource → ProductService**, in your `ServletContextListener`
   (`contextInitialized`), alongside wherever you already build other DAOs:
   ```java
   ProductDAO productDAO = new ProductDAOImpl(dataSource);
   ProductService productService = new ProductService(productDAO);
   sce.getServletContext().setAttribute("productService", productService);
   ```
2. **Session attributes** — the servlet expects `session.getAttribute("userId")`
   (a `Long`) and `session.getAttribute("role")` (`"SELLER"`) to already be set
   by your login servlet from Week 1. If your attribute names differ, update
   `requireSeller()` in `SellerProductServlet`.
3. **`products` table** — the spec's schema (Section 4) doesn't list
   `image_url`, but F2 requires it. Add it as a migration rather than
   hand-editing the table:

   `db/migrations/V4__add_product_image_url.sql`
   ```sql
   ALTER TABLE products ADD COLUMN image_url VARCHAR(500);
   ```
4. **JSTL functions taglib** — `edit-product.jsp` uses `fn:escapeXml`; confirm
   `jakarta.tags.functions` (or `http://java.sun.com/jsp/jstl/functions` if
   you're on the older javax JSTL artifact) resolves in your `pom.xml`
   dependencies the same way your existing JSPs do.

## Suggested commit order (conventional commits, per Section 8)

```
feat: add Product model and ProductDAO
feat: implement ProductDAOImpl with prepared statements
feat: add ProductService with listing validation
feat: add SellerProductServlet for CRUD listing management
feat: add seller dashboard and edit-listing JSPs
docs: add V4 migration for product image_url column
```
That's 6 commits — covers the "3 commits/week × 2 weeks" MVP-checkpoint math and
keeps each commit scoped to one layer, which is easier to explain if you're
asked about the code.

## What this does NOT cover yet
- Admin moderation of listings (F7) — separate servlet, not in this drop.
- Search/filter (F3) — scheduled for Week 5 in the spec.
- Unit/DAO tests for `ProductService`/`ProductDAOImpl` — Section 9 wants these
  before Sep 21, not necessarily this week, but adding a couple of JUnit tests
  now is low effort and strengthens the commit history.

## A note on using this as-is
This follows the spec's architecture (thin servlet → service → DAO,
PreparedStatement-only, ownership check on update/delete). Since it's a solo,
individually-graded capstone, it's worth reading through before pushing —
you'll want to be able to explain the ownership check in `ProductService`
and the try-with-resources pattern in the DAO if asked in review.
