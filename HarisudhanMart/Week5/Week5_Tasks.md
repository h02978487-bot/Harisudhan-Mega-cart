# Week 5 — Aug 24 to Aug 30
## Goal: Search/Filter + Order Status Workflow

---

## Tasks

### 1. Search & Filter — Feature F3 (Complete)
If basic search was done in Week 2, now make it production-ready:

**ProductDAO** — improve `findByKeyword`:
```sql
SELECT * FROM products
WHERE (LOWER(name) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?))
  AND (? IS NULL OR category = ?)
ORDER BY created_at DESC
```
Parameters: `%keyword%`, `%keyword%`, `category`, `category`

**ProductServlet** (GET `/products`):
- Accept `keyword`, `category`, `minPrice`, `maxPrice` query params
- Pass all to service
- Return filtered product list

**products.jsp** — update UI:
- Search bar with keyword input
- Category dropdown populated from DB distinct values
- Price range inputs (min/max)
- Active filters shown as tags (e.g., "Category: Electronics ×")
- Result count shown ("Showing 5 results for 'phone'")

**AJAX Search** (optional but good):
- On input change → `fetch('/api/v1/products?keyword=...')` → re-render product grid
- No full page reload

### 2. Order Status Workflow — Optional Feature O2 (but expected)
This is listed as Optional in the spec but is part of Week 5's planned work.

**OrderDAO** (add):
- `updateStatus(long orderId, String newStatus)`
- `getOrderById(long id)`

**OrderService**:
- `updateOrderStatus(long orderId, String newStatus, long requestingUserId, String role)`:
  - Validate transition (PENDING → CONFIRMED → SHIPPED → DELIVERED)
  - CANCELLED allowed from PENDING or CONFIRMED only
  - Only seller or admin can update status
  - Only buyer can see their order

**SellerOrderServlet** (extend):
- POST `/seller/orders/{id}/status` → body: `{ "status": "CONFIRMED" }` → call service

**Buyer order-history.jsp** — show current status with colour badge:
- PENDING → grey
- CONFIRMED → blue
- SHIPPED → orange
- DELIVERED → green
- CANCELLED → red

### 3. Pagination (Important for Browse)
Add pagination to product listing:
- URL: `/products?page=1&size=12`
- **ProductDAO**: add `findAll(int offset, int limit)` and `countAll()`
- Show page numbers at bottom of products.jsp

### 4. Database Migration — V2
If you added any column or index this week, write:
`db/migrations/V2__add_order_status_index.sql`:
```sql
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_buyer ON orders(buyer_id);
CREATE INDEX idx_products_category ON products(category);
```

### 5. Structured Logging — MDC Setup
In `EncodingFilter` or a new `RequestLoggingFilter`:
```java
String requestId = UUID.randomUUID().toString().substring(0, 8);
MDC.put("requestId", requestId);
// after chain.doFilter:
MDC.clear();
```
`logback.xml` pattern: `%d [%X{requestId}] %-5level %logger - %msg%n`

---

## Minimum Commits This Week (3)
- `feat: improved product search and filter with price range`
- `feat: order status workflow PENDING to DELIVERED (O2)`
- `feat: product listing pagination`

## Definition of Done — Week 5
- [ ] Keyword search filters products correctly (case-insensitive)
- [ ] Category + price range filter work together
- [ ] Result count shown correctly
- [ ] Seller can update order status (PENDING → CONFIRMED → SHIPPED → DELIVERED)
- [ ] Status transitions validated (no skipping steps)
- [ ] Buyer order history shows live status with colour badge
- [ ] Pagination works on /products (page 1, 2, etc.)
- [ ] DB indexes added for status and buyer_id columns
