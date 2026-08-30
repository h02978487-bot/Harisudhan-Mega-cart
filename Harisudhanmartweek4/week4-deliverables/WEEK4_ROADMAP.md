# Week 4 Roadmap: Aug 17 – Aug 23
## Seller Dashboard Complete + Admin Panel Start

---

## 📋 What Week 4 Deliverables Are

By **Aug 23 end-of-day**, you must have:

✅ **Seller Dashboard (Complete)**
- Seller can view their own product listings in a table
- Create new product (form on dashboard)
- Edit product (name, description, price, stock, category)
- Delete product (with confirmation)
- View incoming orders for their products (order count, status, total revenue)
- Search/filter their products by category or name

✅ **Admin Panel (Kickoff)**
- Admin-only routes protected (403 if not ADMIN role)
- View all users in the system (paginated)
- View all orders in the system (paginated)
- Moderate/remove listings (soft delete flag on products)
- Dashboard skeleton showing summary stats

---

## 🏗️ Architecture Overview (Week 4 Focus)

```
Controller Layer:
  SellerProductServlet    → GET (list my products) / POST (create) / PUT (edit)
  SellerOrderServlet      → GET (my incoming orders)
  AdminUsersServlet       → GET (all users, paginated)
  AdminOrdersServlet      → GET (all orders, paginated)
  AdminListingsServlet    → GET/DELETE (moderate products)

Service Layer:
  SellerService           → business logic for product management, incoming orders
  AdminService            → user lookup, order lookup, moderation logic

DAO Layer:
  ProductDAO              → add methods: findBySellerId(), findByCategory(), softDelete()
  OrderDAO                → add methods: findBySellerId(), findAll()
  UserDAO                 → add methods: findAll(), findById()
```

---

## 📅 Week 4 Daily Breakdown

### Days 1–2 (Aug 17–18): Seller Dashboard — Backend
**Tasks:**
1. Extend **ProductDAO** with seller-specific methods
2. Create **SellerService** with business logic
3. Build **SellerProductServlet** (GET list, POST create, PUT edit)
4. Build **SellerOrderServlet** (incoming orders for seller's products)

**Commits:**
- `feat: add seller product management endpoints`
- `feat: add seller order view servlet`

---

### Days 3–4 (Aug 19–20): Seller Dashboard — Frontend + Polish
**Tasks:**
1. Create `seller-dashboard.jsp` (product listing + create/edit forms)
2. Add JavaScript: edit modal, delete confirmation, create product form
3. Style with CSS grid/flexbox for table view
4. Test end-to-end: seller login → create product → see it listed → edit → delete

**Commits:**
- `feat: seller dashboard JSP + AJAX form handling`
- `test: seller flow manual verification`

---

### Days 5–6 (Aug 21–22): Admin Panel — Backend + Start Frontend
**Tasks:**
1. Extend **UserDAO** / **OrderDAO** with find-all methods
2. Create **AdminService** with moderation logic
3. Build **AdminUsersServlet** (list all users, paginated)
4. Build **AdminOrdersServlet** (list all orders, paginated)
5. Build **AdminListingsServlet** (view + delete products, soft delete flag)
6. Create `admin-dashboard.jsp` skeleton

**Commits:**
- `feat: admin user and order management endpoints`
- `feat: admin dashboard skeleton with pagination`

---

### Day 7 (Aug 23): Regression + Polish
**Tasks:**
1. Test all Week 4 routes against live deployment
2. Verify seller ↔ admin permissions (auth filter correctly blocks cross-role access)
3. Fix any edge cases (e.g., seller viewing another seller's products, etc.)
4. Add index on `products.seller_id` for query performance

**Commits:**
- `test: week 4 auth and permission tests`
- `perf: add seller_id index to products table`

---

## 🛠️ Code Snippets

### 1. Extend ProductDAO

```java
// ProductDAO.java
public interface ProductDAO {
    void create(Product p) throws SQLException;
    Product findById(int id) throws SQLException;
    List<Product> findAll() throws SQLException;
    List<Product> findBySellerId(int sellerId) throws SQLException; // NEW
    List<Product> findByCategory(String category) throws SQLException; // NEW
    void update(Product p) throws SQLException;
    void softDelete(int productId) throws SQLException; // NEW (set is_deleted = true)
}
```

```java
// ProductDAOImpl.java
@Override
public List<Product> findBySellerId(int sellerId) throws SQLException {
    String sql = "SELECT * FROM products WHERE seller_id = ? AND is_deleted = false ORDER BY created_at DESC";
    try (Connection conn = dataSource.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, sellerId);
        List<Product> list = new ArrayList<>();
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }
}

@Override
public void softDelete(int productId) throws SQLException {
    String sql = "UPDATE products SET is_deleted = true WHERE id = ?";
    try (Connection conn = dataSource.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, productId);
        ps.executeUpdate();
    }
}
```

**Schema change (migration):**
```sql
-- db/migrations/V4__add_soft_delete_and_indexes.sql
ALTER TABLE products ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE;
CREATE INDEX idx_products_seller_id ON products(seller_id);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_orders_buyer_id ON orders(buyer_id);
```

---

### 2. SellerService

```java
public class SellerService {
    private ProductDAO productDAO;
    private OrderDAO orderDAO;

    public SellerService(ProductDAO productDAO, OrderDAO orderDAO) {
        this.productDAO = productDAO;
        this.orderDAO = orderDAO;
    }

    // Create a product
    public ProductResponseDTO createProduct(CreateProductRequest req, int sellerId) {
        // Validate
        if (req.getName() == null || req.getName().trim().isEmpty()) {
            throw new ValidationException("Product name required");
        }
        if (req.getPrice() <= 0) {
            throw new ValidationException("Price must be > 0");
        }
        
        Product p = new Product();
        p.setSellerId(sellerId);
        p.setName(req.getName());
        p.setDescription(req.getDescription());
        p.setPrice(req.getPrice());
        p.setStockQty(req.getStockQty());
        p.setCategory(req.getCategory());
        
        productDAO.create(p);
        return mapToDTO(p);
    }

    // Edit a product (seller can only edit their own)
    public ProductResponseDTO editProduct(int productId, EditProductRequest req, int sellerId) {
        Product p = productDAO.findById(productId);
        if (p == null) throw new NotFoundException("Product not found");
        if (p.getSellerId() != sellerId) {
            throw new AuthorizationException("Cannot edit another seller's product");
        }

        p.setName(req.getName());
        p.setDescription(req.getDescription());
        p.setPrice(req.getPrice());
        p.setStockQty(req.getStockQty());
        p.setCategory(req.getCategory());
        
        productDAO.update(p);
        return mapToDTO(p);
    }

    // Get seller's products
    public List<ProductResponseDTO> getMyProducts(int sellerId) {
        return productDAO.findBySellerId(sellerId).stream()
            .map(this::mapToDTO)
            .collect(Collectors.toList());
    }

    // Get incoming orders for seller's products
    public List<OrderWithItemsDTO> getIncomingOrders(int sellerId) {
        // Query: orders that contain items from seller's products
        // This may require a custom SQL query joining orders → order_items → products
        return orderDAO.findBySellerIdWithItems(sellerId);
    }

    private ProductResponseDTO mapToDTO(Product p) {
        ProductResponseDTO dto = new ProductResponseDTO();
        dto.setId(p.getId());
        dto.setName(p.getName());
        dto.setPrice(p.getPrice());
        dto.setStockQty(p.getStockQty());
        return dto;
    }
}
```

---

### 3. SellerProductServlet

```java
@WebServlet("/seller/products")
public class SellerProductServlet extends HttpServlet {
    private SellerService sellerService;

    @Override
    public void init() {
        this.sellerService = new SellerService(
            new ProductDAOImpl(getDataSource()),
            new OrderDAOImpl(getDataSource())
        );
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        User seller = (User) req.getSession().getAttribute("user");
        if (seller == null || !seller.getRole().equals("SELLER")) {
            resp.sendError(403);
            return;
        }

        // GET /seller/products → list my products (JSP view)
        List<ProductResponseDTO> myProducts = sellerService.getMyProducts(seller.getId());
        req.setAttribute("products", myProducts);
        req.getRequestDispatcher("/WEB-INF/seller-dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        User seller = (User) req.getSession().getAttribute("user");
        if (seller == null || !seller.getRole().equals("SELLER")) {
            resp.sendError(403);
            return;
        }

        resp.setContentType("application/json");
        try {
            CreateProductRequest createReq = gson.fromJson(
                req.getReader(), CreateProductRequest.class
            );
            ProductResponseDTO created = sellerService.createProduct(createReq, seller.getId());
            
            resp.getWriter().write(gson.toJson(
                new ApiResponse(true, created, null)
            ));
        } catch (ValidationException e) {
            resp.setStatus(400);
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, new ErrorDetail("VALIDATION_ERROR", e.getMessage()))
            ));
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        User seller = (User) req.getSession().getAttribute("user");
        if (seller == null || !seller.getRole().equals("SELLER")) {
            resp.sendError(403);
            return;
        }

        resp.setContentType("application/json");
        int productId = Integer.parseInt(req.getParameter("id"));
        
        try {
            EditProductRequest editReq = gson.fromJson(
                req.getReader(), EditProductRequest.class
            );
            ProductResponseDTO updated = sellerService.editProduct(productId, editReq, seller.getId());
            resp.getWriter().write(gson.toJson(
                new ApiResponse(true, updated, null)
            ));
        } catch (AuthorizationException e) {
            resp.setStatus(403);
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, new ErrorDetail("FORBIDDEN", e.getMessage()))
            ));
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        User seller = (User) req.getSession().getAttribute("user");
        if (seller == null || !seller.getRole().equals("SELLER")) {
            resp.sendError(403);
            return;
        }

        int productId = Integer.parseInt(req.getParameter("id"));
        
        try {
            sellerService.deleteProduct(productId, seller.getId());
            resp.getWriter().write(gson.toJson(
                new ApiResponse(true, null, null)
            ));
        } catch (AuthorizationException e) {
            resp.setStatus(403);
            resp.getWriter().write(gson.toJson(
                new ApiResponse(false, null, new ErrorDetail("FORBIDDEN", e.getMessage()))
            ));
        }
    }

    private DataSource getDataSource() {
        ServletContext ctx = getServletContext();
        return (DataSource) ctx.getAttribute("dataSource");
    }
}
```

---

### 4. Seller Dashboard JSP (`seller-dashboard.jsp`)

```jsp
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <title>Seller Dashboard - HarisudhanMart</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 1000px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .btn-primary { background: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; }
        .btn-primary:hover { background: #0056b3; }
        .btn-danger { background: #dc3545; color: white; padding: 5px 10px; border: none; border-radius: 3px; cursor: pointer; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #f5f5f5; font-weight: bold; }
        tr:hover { background: #f9f9f9; }
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1; }
        .modal.active { display: flex; align-items: center; justify-content: center; }
        .modal-content { background: white; padding: 30px; border-radius: 8px; width: 90%; max-width: 500px; }
        .modal-close { float: right; cursor: pointer; font-size: 24px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input, textarea, select { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>My Products</h1>
        <div>
            <button class="btn-primary" onclick="openCreateModal()">+ Add Product</button>
            <a href="/harisudhanmart/logout" style="margin-left: 10px;">Logout</a>
        </div>
    </div>

    <!-- Products Table -->
    <table>
        <thead>
            <tr>
                <th>Product Name</th>
                <th>Price</th>
                <th>Stock</th>
                <th>Category</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${empty products}">
                <tr><td colspan="5" style="text-align: center; color: #999;">No products yet. Create one to get started!</td></tr>
            </c:if>
            <c:forEach var="p" items="${products}">
                <tr>
                    <td><c:out value="${p.name}"/></td>
                    <td>₹<c:out value="${p.price}"/></td>
                    <td><c:out value="${p.stockQty}"/></td>
                    <td><c:out value="${p.category}"/></td>
                    <td>
                        <button onclick="editProduct(${p.id}, '<c:out value="${p.name}"/>', ${p.price})">Edit</button>
                        <button class="btn-danger" onclick="deleteProduct(${p.id})">Delete</button>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Create/Edit Modal -->
<div id="productModal" class="modal">
    <div class="modal-content">
        <span class="modal-close" onclick="closeModal()">&times;</span>
        <h2 id="modalTitle">Add New Product</h2>
        <form id="productForm" onsubmit="handleFormSubmit(event)">
            <div class="form-group">
                <label>Product Name *</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label>Description</label>
                <textarea id="description" name="description" rows="3"></textarea>
            </div>
            <div class="form-group">
                <label>Price (₹) *</label>
                <input type="number" id="price" name="price" step="0.01" min="0.01" required>
            </div>
            <div class="form-group">
                <label>Stock Quantity *</label>
                <input type="number" id="stockQty" name="stockQty" min="0" required>
            </div>
            <div class="form-group">
                <label>Category *</label>
                <select id="category" name="category" required>
                    <option value="">-- Select --</option>
                    <option value="Electronics">Electronics</option>
                    <option value="Clothing">Clothing</option>
                    <option value="Books">Books</option>
                    <option value="Home">Home & Garden</option>
                </select>
            </div>
            <button type="submit" class="btn-primary">Save Product</button>
        </form>
    </div>
</div>

<script>
    let currentEditId = null;

    function openCreateModal() {
        currentEditId = null;
        document.getElementById("modalTitle").innerText = "Add New Product";
        document.getElementById("productForm").reset();
        document.getElementById("productModal").classList.add("active");
    }

    function editProduct(id, name, price) {
        currentEditId = id;
        document.getElementById("modalTitle").innerText = "Edit Product";
        document.getElementById("name").value = name;
        document.getElementById("price").value = price;
        document.getElementById("productModal").classList.add("active");
    }

    function closeModal() {
        document.getElementById("productModal").classList.remove("active");
    }

    function handleFormSubmit(event) {
        event.preventDefault();
        
        const formData = {
            name: document.getElementById("name").value,
            description: document.getElementById("description").value,
            price: parseFloat(document.getElementById("price").value),
            stockQty: parseInt(document.getElementById("stockQty").value),
            category: document.getElementById("category").value
        };

        const url = currentEditId ? `/harisudhanmart/seller/products?id=${currentEditId}` : "/harisudhanmart/seller/products";
        const method = currentEditId ? "PUT" : "POST";

        fetch(url, {
            method: method,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(formData)
        })
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                alert(currentEditId ? "Product updated!" : "Product created!");
                closeModal();
                location.reload();
            } else {
                alert("Error: " + data.error.message);
            }
        })
        .catch(err => console.error(err));
    }

    function deleteProduct(id) {
        if (!confirm("Are you sure?")) return;
        
        fetch(`/harisudhanmart/seller/products?id=${id}`, {
            method: "DELETE"
        })
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                alert("Product deleted!");
                location.reload();
            } else {
                alert("Error: " + data.error.message);
            }
        })
        .catch(err => console.error(err));
    }
</script>
</body>
</html>
```

---

### 5. AdminService (Skeleton)

```java
public class AdminService {
    private UserDAO userDAO;
    private OrderDAO orderDAO;
    private ProductDAO productDAO;

    // Get all users (paginated)
    public Page<UserResponseDTO> getAllUsers(int pageNum, int pageSize) {
        int offset = (pageNum - 1) * pageSize;
        List<User> users = userDAO.findAllPaginated(offset, pageSize);
        int total = userDAO.count();
        
        return new Page<>(
            users.stream().map(this::userToDTO).collect(Collectors.toList()),
            pageNum, pageSize, total
        );
    }

    // Get all orders (paginated)
    public Page<OrderResponseDTO> getAllOrders(int pageNum, int pageSize) {
        int offset = (pageNum - 1) * pageSize;
        List<Order> orders = orderDAO.findAllPaginated(offset, pageSize);
        int total = orderDAO.count();
        
        return new Page<>(
            orders.stream().map(this::orderToDTO).collect(Collectors.toList()),
            pageNum, pageSize, total
        );
    }

    // Soft-delete a product
    public void removeProduct(int productId) {
        productDAO.softDelete(productId);
    }
}
```

---

## 📊 Testing Checklist for Week 4

- [ ] Seller can create a product from dashboard
- [ ] Seller can edit their own product
- [ ] Seller cannot edit another seller's product (403)
- [ ] Seller can delete their own product
- [ ] Seller sees only their own products on dashboard
- [ ] Seller can view incoming orders for their products
- [ ] Admin can view all users (paginated)
- [ ] Admin can view all orders (paginated)
- [ ] Admin can soft-delete a product
- [ ] Seller cannot access `/admin/*` routes (403)
- [ ] Admin cannot access `/seller/*` routes (403)
- [ ] All new endpoints return proper JSON envelope
- [ ] AuthFilter blocks unauthorized access
- [ ] No SQL errors in logs

---

## 🚀 Git Commits Expected (Week 4)

```
feat: extend ProductDAO with seller-specific queries
feat: add SellerService for product & order management
feat: implement SellerProductServlet (CRUD)
feat: build seller dashboard JSP with modals
feat: add AdminService skeleton
feat: implement AdminUsersServlet (list + paginate)
feat: implement AdminOrdersServlet (list + paginate)
feat: add soft-delete to products table
test: verify seller ↔ admin auth isolation
perf: index seller_id and category on products table
```

**Minimum: 6–8 commits by end of week.**

---

## ⚠️ Common Pitfalls Week 4

1. **Seller sees other sellers' products** → Always filter by `seller_id` in queries
2. **No soft delete** → Use a flag on products, don't physically delete (audit trail)
3. **Admin endpoints accessible to sellers** → Enforce auth in every servlet `doGet/doPut/doDelete`
4. **Pagination missing** → Add LIMIT/OFFSET queries now; REQUIRED for admin panel
5. **No index on seller_id** → Queries will slow down as test data grows
6. **Modal form validation** → Validate on client AND server before DAO call

---

## 🎯 Success Criteria (End of Week 4)

By **Aug 23 evening**:

✅ Seller dashboard fully functional (create/edit/delete products)  
✅ Admin panel with user & order views (paginated)  
✅ Auth isolation: seller ↔ admin roles are separate  
✅ All SQL soft-delete + indexing in place  
✅ Zero 500 errors in logs  
✅ Live deployment tested; seller/admin flows verified  
✅ Minimum 6–8 commits pushed to GitHub  

Good luck! Push your changes daily. 🚀
