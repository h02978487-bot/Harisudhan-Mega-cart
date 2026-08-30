# Week 4: Seller Dashboard & Admin Panel

This package contains complete code scaffolding, database migrations, and documentation for **Week 4 (Aug 17–Aug 23)** of the HarisudhanMart capstone project.

## 📦 Contents

- **WEEK4_ROADMAP.md** — Detailed day-by-day breakdown with architecture, code snippets, and testing checklist
- **WEEK4_CHECKLIST.md** — Executable checklist for team members
- **db/migrations/V4__add_soft_delete_and_indexes.sql** — Database migration (soft delete + performance indexes)
- **src/snippets/** — Ready-to-use code templates:
  - ProductDAO additions
  - SellerService (complete implementation)
  - AdminService (skeleton)
  - SellerProductServlet (complete implementation)
  - seller-dashboard.jsp (complete JSP view)

## 🚀 Quick Start

1. **Copy snippets to your project:**
   ```bash
   # Copy service classes
   cp src/snippets/SellerService.java src/main/java/com/harisudhan/harisudhanmart/service/

   # Copy servlets
   cp src/snippets/SellerProductServlet.java src/main/java/com/harisudhan/harisudhanmart/controller/

   # Copy JSP
   cp src/snippets/seller-dashboard.jsp src/main/webapp/WEB-INF/

   # Run migration
   cat db/migrations/V4__add_soft_delete_and_indexes.sql | your-database-client
   ```

2. **Update ProductDAO interface** with methods from `src/snippets/ProductDAO_additions.java`

3. **Implement ProductDAOImpl** methods:
   - `findBySellerId()`
   - `findByCategory()`
   - `softDelete()`
   - `findAllPaginated()`
   - `count()`

4. **Follow the roadmap** in WEEK4_ROADMAP.md day by day.

## 📋 Key Milestones

- **Day 2 (Aug 18)**: SellerProductServlet + SellerService complete
- **Day 4 (Aug 20)**: Seller dashboard JSP fully functional
- **Day 6 (Aug 22)**: Admin panel endpoints + JSP skeleton
- **Day 7 (Aug 23)**: Full regression testing + live deployment

## 🔑 Key Features

### Seller Dashboard
- ✅ View own products in paginated table
- ✅ Create new product (modal form)
- ✅ Edit product details
- ✅ Delete product (soft delete in DB)
- ✅ View incoming orders for their products

### Admin Panel (Kickoff)
- ✅ View all users (paginated)
- ✅ View all orders (paginated)
- ✅ Soft-delete products (moderation)
- ✅ Role-based access control (403 for non-admin)

## ✅ Testing

Run the checklist in WEEK4_CHECKLIST.md daily. Minimum test cases:

- Seller can create/edit/delete own products
- Seller cannot access admin routes (403)
- Admin can view all users and orders
- Pagination works correctly
- Soft delete flag prevents deleted products from showing

## 🔐 Security Requirements

- ✅ All SQL uses PreparedStatement
- ✅ AuthFilter enforces role-based access
- ✅ Session ID regenerated on login
- ✅ User input escaped in JSP (JSTL `<c:out>`)
- ✅ No passwords logged

## 📊 Database Schema Changes

**New column:**
```sql
ALTER TABLE products ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE;
```

**New indexes:**
```sql
CREATE INDEX idx_products_seller_id ON products(seller_id);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_seller_category ON products(seller_id, category);
CREATE INDEX idx_orders_buyer_id ON orders(buyer_id);
```

## 📝 Git Commit Messages

Follow conventional commits:
```
feat: add SellerService for product management
feat: implement SellerProductServlet (CRUD)
feat: build seller dashboard JSP with modals
feat: add AdminService and admin endpoints
test: verify seller ↔ admin auth isolation
perf: add database indexes for performance
```

## 🐛 Common Issues

| Issue | Solution |
|-------|----------|
| Seller sees other sellers' products | Always filter by `seller_id` in queries |
| Modal not closing | Check `closeModal()` JavaScript; ensure `classList.remove("active")` runs |
| 403 Forbidden on admin routes | Verify AuthFilter checks `user.getRole().equals("ADMIN")` |
| Soft delete not working | Verify migration executed; check `is_deleted = true` in WHERE clause |
| Performance degradation | Add indexes on `seller_id`, `category`, `buyer_id` |

## 📞 Support

Refer to:
- **WEEK4_ROADMAP.md** for detailed architecture & design decisions
- **WEEK4_CHECKLIST.md** for daily execution plan
- Code snippets in `src/snippets/` for reference implementations

---

**Due: Aug 23, 2026 (EOD)**
