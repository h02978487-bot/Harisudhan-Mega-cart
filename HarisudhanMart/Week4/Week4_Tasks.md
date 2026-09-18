# Week 4 — Aug 17 to Aug 23
## Goal: Seller Dashboard Complete + Admin Panel Started

---

## Tasks

### 1. Complete Seller Dashboard
If anything from Week 3 seller features is incomplete, finish it first.

**Seller Dashboard home page** (`/seller/dashboard`):
- Summary cards: Total listings, Total orders received, Total revenue (sum of order_items for seller's products)
- Link to product list, order list

### 2. Admin Panel — Feature F7
**AdminDAO**:
- `getAllUsers()` — returns all users with role
- `getAllOrders()` — returns all orders with buyer name and status
- `getAllProducts()` — returns all products with seller name

**AdminService**:
- `listAllUsers()`
- `listAllOrders()`
- `removeProduct(long productId)` — hard delete or mark inactive

**AdminServlet** (mapped to `/admin`):
- GET `/admin/users` → list all users
- GET `/admin/orders` → list all orders
- GET `/admin/products` → list all products
- POST `/admin/products/remove` → remove a listing

**JSP Pages**:
- `admin/dashboard.jsp` — links to users, orders, products views
- `admin/users.jsp` — table: ID, name, email, role, registered date
- `admin/orders.jsp` — table: ID, buyer, status, total, date
- `admin/products.jsp` — table: ID, name, seller, price, stock, category + Remove button

### 3. HTTP Status Codes — Fix All Endpoints
Audit every servlet. Ensure:
- 200/201 for success
- 400 for bad input (validation failure)
- 401 for unauthenticated (no session)
- 403 for forbidden (wrong role)
- 404 for not found
- 409 for conflict (e.g., email already registered)
- 500 for server error
- **Never return HTTP 200 for error responses**

### 4. API Response Envelope — Apply Everywhere
All `/api/v1/` endpoints must use:
```json
{ "success": true, "data": { ... }, "error": null }
{ "success": false, "data": null, "error": { "code": "VALIDATION_ERROR", "message": "..." } }
```
Create `JsonUtil.success(Object data)` and `JsonUtil.error(String code, String message)` helper methods.

### 5. Service Layer Tests (Mockito)
Write JUnit 5 + Mockito tests for:
- `UserService`: register with duplicate email → exception, register success
- `ProductService`: createListing with invalid price → 400, success case
- `OrderService`: placeOrder when stock insufficient → exception
- Mock all DAO interfaces

### 6. GitHub Project Board
Set up GitHub Projects Kanban:
- Columns: Backlog → In Progress → In Review → Done
- Add all remaining features (F6 seller, F7, F8, O2, O3, O4) as Issues
- Move current week's issues to In Progress

---

## Minimum Commits This Week (3)
- `feat: seller dashboard with revenue summary`
- `feat: admin panel — user/order/product views (F7)`
- `test: service layer unit tests with Mockito`

## Definition of Done — Week 4
- [ ] Admin can view all users, all orders, all products
- [ ] Admin can remove any product listing
- [ ] /admin/* routes blocked for non-admin roles (403)
- [ ] All servlets return correct HTTP status codes
- [ ] All /api/v1/ endpoints use response envelope
- [ ] Service layer tests passing in CI
