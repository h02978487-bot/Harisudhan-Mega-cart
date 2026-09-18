# Week 3 — Aug 10 to Aug 16
## Goal: MVP Feedback + Seller Dashboard (Listing Management)

---

## Context
MVP Review was Aug 10. This week:
1. Address all reviewer feedback from the MVP demo
2. Start the Seller dashboard (product listing management)

---

## Tasks

### 1. Fix MVP Feedback
- List all issues raised in the Aug 10 review
- Create a GitHub Issue for each
- Fix and close them before moving to new features

### 2. Order History — Feature F6 (Buyer side)
**OrderDAO** (add if not done in Week 2):
- `getOrdersByBuyer(long buyerId)` — full order list with items
- `getOrderById(long id)`

**OrderHistoryServlet** (GET `/orders`):
- Get logged-in buyer's orders
- Forward to `order-history.jsp`

**order-history.jsp**:
- Table: Order ID, Date, Status, Total Amount
- Click row → show order detail (items, quantities, unit prices)

### 3. Seller — Product Listing Management — Feature F2
**ProductDAO** (add methods):
- `findBySeller(long sellerId)`
- `save(Product p)` — INSERT
- `update(Product p)` — UPDATE (only if seller_id matches)
- `delete(long productId, long sellerId)` — only seller's own products

**ProductService** (seller methods):
- `createListing(long sellerId, ProductDTO dto)` — validate, save
- `updateListing(long sellerId, long productId, ProductDTO dto)` — authorize, update
- `deleteListing(long sellerId, long productId)` — authorize, delete
- `getSellerListings(long sellerId)`

**SellerProductServlet** (mapped to `/seller/products`):
- GET → list seller's own products
- POST → create new product
- PUT → update product
- DELETE → remove product

**JSP Pages**:
- `seller/product-list.jsp` — table of seller's products with Edit/Delete buttons
- `seller/product-form.jsp` — form for create/edit: name, description, price, stock_qty, category, image URL

### 4. Seller Order View — Feature F6 (Seller side)
**OrderDAO** (add):
- `getOrdersBySeller(long sellerId)` — orders containing seller's products

**SellerOrderServlet** (GET `/seller/orders`):
- Show incoming orders for the seller's products

**seller/order-list.jsp**:
- Table: Order ID, Buyer (name), Products ordered, Quantity, Status, Date

### 5. AuthFilter — Role-Based Access
Extend AuthFilter (or create `RoleFilter`) to protect:
- `/seller/*` — only SELLER role allowed
- `/admin/*` — only ADMIN role allowed (will use in Week 4)
- `/buyer/*` or `/orders` — only BUYER role

Return 403 if wrong role.

### 6. Validation Improvements
In all service methods, validate at the top before any DAO call:
- Price > 0
- Stock quantity >= 0
- Name not blank
- Return HTTP 400 with field-level error message

---

## Minimum Commits This Week (3)
- `fix: address MVP review feedback`
- `feat: buyer order history page (F6 buyer side)`
- `feat: seller product listing management — create/edit/delete (F2)`

## Definition of Done — Week 3
- [ ] Buyer can view all past orders with status
- [ ] Seller can create a new product listing (appears in browse)
- [ ] Seller can edit their listing (price/stock/description updates)
- [ ] Seller can delete their listing (removed from browse)
- [ ] Seller cannot edit/delete another seller's product (403)
- [ ] Seller can see incoming orders for their products
- [ ] Role-based access working for /seller/* routes
