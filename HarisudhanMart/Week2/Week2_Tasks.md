# Week 2 — Aug 3 to Aug 9
## Goal: Core Flow — Browse → Add to Cart → Place Order

---

## Tasks

### 1. Product Browsing — Feature F3
**ProductDAO** (add methods):
- `findAll()` — returns all products
- `findByCategory(String category)`
- `findByKeyword(String keyword)` — SQL: `WHERE name LIKE ? OR description LIKE ?`
- `findById(long id)`

**ProductService**:
- `getAllProducts()`
- `searchProducts(String keyword, String category)`
- `getProductById(long id)`

**ProductServlet** (GET `/products`):
- Read `keyword` and `category` query params
- Call service
- Forward to `products.jsp`

**products.jsp**:
- Search bar (keyword input + category dropdown)
- Grid/list of products (name, price, category, stock)
- "Add to Cart" button per product (POST to `/cart`)
- Use `<c:forEach>` and `<c:out>` (JSTL)

**home.jsp**:
- Show featured/recent products
- Link to product list and search

### 2. Cart — Feature F4
**CartDAO**:
- `addItem(userId, productId, quantity)`
- `getCartItems(userId)` — joins with products table for name/price
- `updateQuantity(cartItemId, quantity)`
- `removeItem(cartItemId)`
- `clearCart(userId)`

**CartService**:
- `addToCart(userId, productId, quantity)` — check stock, merge if item exists
- `getCart(userId)`
- `updateItem(userId, cartItemId, quantity)`
- `removeItem(userId, cartItemId)`

**CartServlet** (mapped to `/cart`):
- GET → show cart page
- POST → add item
- PUT (AJAX) → update quantity
- DELETE (AJAX) → remove item

**cart.jsp**:
- List cart items: product name, unit price, quantity input, subtotal
- Running total
- "Checkout" button → links to `/checkout`
- "Remove" button per item (AJAX fetch → re-render)

### 3. Checkout & Order Placement — Feature F5
**OrderDAO**:
- `createOrder(Order order)` — returns generated ID
- `addOrderItem(OrderItem item)`
- `getOrdersByBuyer(long buyerId)`
- `getOrdersBySeller(long sellerId)`
- `getOrderById(long id)`

**OrderService**:
- `placeOrder(long buyerId)`:
  1. Get cart items
  2. Validate stock for each item
  3. Create Order record (status = PENDING)
  4. Create OrderItem records
  5. Reduce product stock_qty
  6. Clear cart
  7. Return order ID

**CheckoutServlet** (GET `/checkout`):
- Show order summary from cart
- Show mock payment form (card number placeholder — no real processing)
- POST `/checkout/confirm` → call `service.placeOrder` → redirect to order confirmation page

**order-confirmation.jsp**:
- Show order ID, items, total, status (PENDING)
- Link to order history

### 4. DTOs
Create:
- `CartItemDTO` (productId, productName, quantity, unitPrice, subtotal)
- `OrderDTO` (orderId, status, totalAmount, createdAt, items list)
- `OrderItemDTO` (productName, quantity, unitPrice)

### 5. JSON API Endpoints (for AJAX)
Under `/api/v1/`:
- `GET /api/v1/cart` → `{ "success": true, "data": { items: [...], total: 0.00 } }`
- `POST /api/v1/cart` → add item
- `DELETE /api/v1/cart/{itemId}` → remove item

All responses use the fixed envelope:
```json
{ "success": true, "data": { ... }, "error": null }
{ "success": false, "data": null, "error": { "code": "...", "message": "..." } }
```

### 6. DAO Tests
Write JUnit 5 tests for:
- `UserDAOImpl`: save user, find by email
- `ProductDAOImpl`: save product, find all, find by keyword
- `CartDAOImpl`: add item, get items, remove item
- Test DB URL: `jdbc:h2:mem:test;DB_CLOSE_DELAY=-1`
- Initialize schema from `schema.sql` before each test class

---

## Minimum Commits This Week (3)
- `feat: product listing, search, and filter (F3)`
- `feat: cart add/update/remove and cart page (F4)`
- `feat: checkout and order placement with mock payment (F5)`

## Definition of Done — Week 2
- [ ] Browse products at /products (all shown)
- [ ] Search by keyword and/or category filters correctly
- [ ] Add a product to cart → appears in cart with correct price
- [ ] Update quantity in cart → total updates
- [ ] Remove item from cart → gone
- [ ] Checkout → order created in DB → confirmation page shown
- [ ] Product stock_qty reduced after order
- [ ] Cart cleared after order placed
- [ ] DAO unit tests passing in CI

## NOTE — MVP Review is Aug 10
After Week 2, you need a working demo of:
- Register → Login → Browse → Add to Cart → Place Order
- Seed data populated
- Repository has minimum 6 commits total (3/week x 2 weeks)
- 2-slide summary: problem statement + architecture sketch + completed vs planned
