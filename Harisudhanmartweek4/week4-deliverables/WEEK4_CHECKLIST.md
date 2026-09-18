# Week 4 Execution Checklist
## Aug 17 – Aug 23

### Day 1-2: Backend Setup (Aug 17-18)
- [ ] Extend ProductDAO with findBySellerId(), findByCategory(), softDelete()
- [ ] Create SellerService class
- [ ] Implement SellerProductServlet (GET, POST, PUT, DELETE)
- [ ] Implement SellerOrderServlet for incoming orders
- [ ] Create migration: V4__add_soft_delete_and_indexes.sql
- [ ] Test ProductDAO methods locally with embedded H2
- [ ] Commit: `feat: seller product management endpoints`

### Day 3-4: Seller Dashboard Frontend (Aug 19-20)
- [ ] Create seller-dashboard.jsp
- [ ] Build product listing table UI
- [ ] Add modal for create/edit product
- [ ] Implement JavaScript fetch for CRUD operations
- [ ] Add delete confirmation dialog
- [ ] Style with CSS (flexbox/grid)
- [ ] Test on localhost: create → view → edit → delete flow
- [ ] Commit: `feat: seller dashboard JSP + modal forms`

### Day 5-6: Admin Panel (Aug 21-22)
- [ ] Extend UserDAO with findAll(), findAllPaginated(), count()
- [ ] Extend OrderDAO with findAll(), findAllPaginated(), count()
- [ ] Create AdminService
- [ ] Implement AdminUsersServlet (paginated list)
- [ ] Implement AdminOrdersServlet (paginated list)
- [ ] Implement AdminListingsServlet (view all, soft delete)
- [ ] Create admin-dashboard.jsp skeleton
- [ ] Create admin-users.jsp (paginated table)
- [ ] Create admin-orders.jsp (paginated table)
- [ ] Commit: `feat: admin panel user and order management`

### Day 7: Testing & Polish (Aug 23)
- [ ] Test seller CRUD against live URL
- [ ] Test admin routes (403 for non-admin users)
- [ ] Verify seller cannot see other sellers' products
- [ ] Verify admin can soft-delete products
- [ ] Run full regression: Auth → Browse → Cart → Order → Admin view
- [ ] Check logs for SQL errors or exception stack traces
- [ ] Deploy to production
- [ ] Commit: `test: week 4 regression and auth isolation`
- [ ] Commit: `perf: add database indexes for seller_id, category, buyer_id`

### Minimum Commits Required
```
feat: extend ProductDAO with seller queries
feat: add SellerService
feat: implement SellerProductServlet
feat: build seller dashboard JSP
feat: add AdminService
feat: implement admin user/order endpoints
feat: admin panel JSP views
test: seller and admin auth verification
perf: database indexes
```

### Code Quality Checklist
- [ ] All queries use PreparedStatement
- [ ] No stack traces in error responses
- [ ] All protected routes check session/role
- [ ] Passwords never logged
- [ ] JSON responses follow {success, data, error} envelope
- [ ] No magic strings (use constants)
- [ ] Javadoc on public service/DAO methods
- [ ] Checkstyle and SpotBugs pass

### Database Checklist
- [ ] is_deleted column added to products
- [ ] Indexes created on seller_id, category, buyer_id
- [ ] Migration file V4__add_soft_delete_and_indexes.sql checked in
- [ ] Schema updated on live deployment
- [ ] Seed data still loads correctly

### UI/UX Checklist
- [ ] Seller dashboard loads within 2 seconds
- [ ] Forms validate on client before submit
- [ ] Error messages are user-friendly
- [ ] Pagination works (admin pages)
- [ ] Mobile responsive (basic)
- [ ] No broken links

### Live URL Testing
- [ ] Seller login → dashboard loads
- [ ] Create product → appears in table
- [ ] Edit product → changes reflected
- [ ] Delete product → removed from table (soft deleted in DB)
- [ ] Admin login → user list loads
- [ ] Admin pagination works
- [ ] Admin can view all orders
- [ ] Non-admin cannot access /admin/* (403)
- [ ] Seller cannot access /admin/* (403)

---

**Success**: All checkboxes ticked by Aug 23 end-of-day.
