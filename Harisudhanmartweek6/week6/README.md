# Week 6 add-on: Reviews & Ratings (F8) + Validation

This package implements F8 (product reviews and star ratings on completed
orders) plus input validation and edge-case handling, following the
Section 2 architecture (Servlet → Service → DAO, PreparedStatement only,
try-with-resources everywhere) and the Section 13 API contract (JSON
envelope, correct HTTP status codes, DTOs separate from entities).

## Before you commit this

1. **Rename the package.** This is checked in under
   `com.yourname.yournamemart` as a placeholder, matching the spec's
   default. Do a project-wide find/replace of `yourname` /
   `YourNameMart` with your actual name, in:
   - every `.java` file's `package` line and imports
   - the folder path `src/main/java/com/yourname/yournamemart`
   Most IDEs (IntelliJ: right-click package → Refactor → Rename) do this
   safely in one step.

2. **Merge, don't overwrite.** Copy these files into your existing Maven
   project at the matching paths. If you already have `ValidationUtil.java`,
   add the `validateReviewRequest` method into your existing file instead of
   replacing it.

3. **Wire `OrderLookupForReview`.** `ReviewService` needs one method —
   `isDeliveredOrderContainingProduct(orderId, buyerId, productId)` — backed
   by your existing `OrderDAO`/`OrderItemDAO`. Either make your OrderDAO
   implement this interface, or delete the interface and call your DAO
   directly inside `ReviewService`.

4. **Register `ReviewService` in your `ServletContextListener`**, the same
   place you already build your other services with the HikariCP
   `DataSource`, e.g.:
   ```java
   ReviewDAO reviewDAO = new ReviewDAOImpl(dataSource);
   ReviewService reviewService = new ReviewService(reviewDAO, orderDAO); // orderDAO implementing OrderLookupForReview
   context.setAttribute("reviewService", reviewService);
   ```

5. **Register the servlet** in `web.xml` (or an `@WebServlet` annotation, if
   that's how you've mapped the others) at `/api/v1/reviews`.

6. **Run the migration.** `db/migrations/V2__add_reviews_table.sql` adds the
   `reviews` table with FK indexes and a `UNIQUE(user_id, product_id)`
   constraint (belt-and-suspenders against duplicate reviews alongside the
   service-layer check).

7. **Escape at render time.** The comment field is stored as-is; when you
   render it in JSP, use `<c:out value="${review.comment}"/>` or
   `fn:escapeXml`, per Section 2 rule 4 — validation here does not make it
   safe to render raw.

## What's covered

- Rating bounds (1–5), comment length cap (1000 chars)
- Reviews only allowed on the reviewer's own DELIVERED orders
- One review per user per product (service check + DB unique constraint)
- 400/401/403/500 mapped correctly, no stack traces leaked to the client
- Unit tests (JUnit 5 + Mockito) for the four edge cases above

## Committing this to GitHub

```bash
git checkout -b feature/reviews-ratings
# copy/merge the files above into your project
git add .
git commit -m "feat: add product reviews and ratings (F8)"
git push -u origin feature/reviews-ratings
# open a PR into main, self-review, merge once CI is green
```
