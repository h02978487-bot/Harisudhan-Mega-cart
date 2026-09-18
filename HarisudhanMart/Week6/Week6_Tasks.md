# Week 6 — Aug 31 to Sep 6
## Goal: Reviews/Ratings + Edge Cases + Input Validation

---

## Tasks

### 1. Product Reviews & Star Ratings — Feature F8

**ReviewDAO**:
- `addReview(Review review)` — INSERT
- `getReviewsByProduct(long productId)` — returns list
- `hasReviewed(long userId, long productId)` — prevents duplicate review
- `getAverageRating(long productId)` — returns DECIMAL avg

**ReviewService**:
- `submitReview(long userId, long productId, int rating, String comment)`:
  - Check: buyer must have a DELIVERED order containing this product
  - Check: buyer has not already reviewed this product
  - Validate: rating between 1 and 5
  - Save review
- `getProductReviews(long productId)`
- `getAverageRating(long productId)`

**ReviewServlet** (POST `/reviews`):
- Validate → call service → redirect to product page

**product-detail.jsp** (new page, GET `/products/{id}`):
- Product name, description, price, stock, seller name
- Average star rating (★★★★☆ style)
- Review form (only shown if: logged in as BUYER + has DELIVERED order with this product + not yet reviewed)
- List of existing reviews: reviewer name, rating stars, comment, date

**products.jsp** — update product cards:
- Show average star rating under each product name

### 2. Database Migration — V3
`db/migrations/V3__add_review_index.sql`:
```sql
CREATE INDEX idx_reviews_product ON reviews(product_id);
CREATE INDEX idx_reviews_user ON reviews(user_id);
```

### 3. Edge Case Handling
Fix and test these edge cases:

| Scenario | Expected Behaviour |
|---|---|
| Add out-of-stock product to cart | 400 error: "Product out of stock" |
| Place order with stock=0 for any item | 400 error: "Insufficient stock for [product name]" |
| Access /seller/* as BUYER | 403 Forbidden |
| Access /admin/* as SELLER | 403 Forbidden |
| Submit review twice for same product | 409 Conflict: "Already reviewed" |
| Submit review without a DELIVERED order | 403: "Purchase required to review" |
| Rating outside 1–5 | 400: "Rating must be between 1 and 5" |
| Empty product name on create | 400: "Product name is required" |
| Register with existing email | 409: "Email already registered" |
| Checkout with empty cart | 400: "Cart is empty" |

### 4. Global Exception Handling
Create `GlobalExceptionHandler` or configure in `web.xml`:
```xml
<error-page>
  <error-code>404</error-code>
  <location>/error/404.jsp</location>
</error-page>
<error-page>
  <error-code>500</error-code>
  <location>/error/500.jsp</location>
</error-page>
```
- Error pages must NOT expose stack traces to the user
- Log full stack trace server-side with `logger.error("...", e)`

### 5. Input Validation — Complete Pass
In every `service` method, validate at the top:
- Null/blank checks on all required Strings
- Range checks on numbers (price > 0, quantity > 0, rating 1–5)
- Email format check (simple regex)
- Return `ValidationException` with field name + message
- Servlet catches it → sends HTTP 400 with JSON error envelope

### 6. End-to-End Manual Test Sheet
Create `docs/manual-test-cases.md` with test cases for:
- Register → Login → Browse → Add to Cart → Checkout → View Order
- Seller: Login → Create Listing → Edit → Delete
- Admin: Login → View Users → Remove Product
- Buyer: Order delivered → Submit review → Star rating appears on product
- All edge cases from the table above

Document: Test case ID, steps, expected result, actual result, pass/fail.

---

## Minimum Commits This Week (3)
- `feat: product reviews and star ratings (F8)`
- `fix: edge case handling — stock, role access, duplicate review`
- `docs: manual test case sheet`

## Definition of Done — Week 6
- [ ] Buyer can submit a review only after a DELIVERED order
- [ ] Duplicate review blocked (409)
- [ ] Average star rating shown on product detail and product cards
- [ ] All edge cases in table above handled correctly
- [ ] No stack trace exposed on error pages
- [ ] End-to-end manual test sheet complete and all cases pass
- [ ] All F1–F8 features now implemented
