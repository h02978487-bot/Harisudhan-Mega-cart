# Week 5 Integration Guide: Search/Filter + Order Status Workflow

## Files to Add/Update

### 1. **DAO Layer Updates**
- **ProductDAO.java** (interface): Add methods from `Week5_ProductDAOExtension.java`
- **ProductDAOImpl.java** (implementation): Add implementations from `Week5_ProductDAOExtension.java`
- **OrderDAO.java** (interface): Add methods from `Week5_OrderDAOExtension.java`
- **OrderDAOImpl.java** (implementation): Add implementations from `Week5_OrderDAOExtension.java`

### 2. **Service Layer Updates**
- **ProductService.java**: Add methods from `Week5_ProductServiceExtension.java`
- **OrderService.java**: Add methods from `Week5_OrderServiceExtension.java`
  - **Note**: Add the status transition map and validation methods

### 3. **Controller Layer (New Files)**
- **SearchServlet.java**: Copy entire file `Week5_SearchServlet.java` → `src/main/java/com/yourname/yournamemart/controller/`
- **OrderStatusServlet.java**: Copy entire file `Week5_OrderStatusServlet.java` → `src/main/java/com/yourname/yournamemart/controller/`

### 4. **Database Migrations**
- Copy `V5__week5_search_and_order_workflow.sql` → `db/migrations/`
  - Ensure it runs after your existing V1-V4 migrations
  - If using Flyway, it will auto-execute on startup

### 5. **Tests (New Files)**
- **ProductServiceTest.java**: Copy to `src/test/java/com/yourname/yournamemart/service/`
- **OrderServiceTest.java**: Copy to `src/test/java/com/yourname/yournamemart/service/`

---

## API Endpoints

### Search & Categories
```
GET /api/v1/search?keyword=laptop
GET /api/v1/search?category=Electronics
GET /api/v1/search?keyword=laptop&category=Electronics
GET /api/v1/categories
```

Response:
```json
{ "success": true, "data": [...], "error": null }
```

### Order Status Update
```
PUT /api/v1/orders/{orderId}/status
Body: { "status": "CONFIRMED" }
```

Required: Authentication (SELLER or ADMIN role)
Valid transitions: PENDING→CONFIRMED, CONFIRMED→SHIPPED, SHIPPED→DELIVERED, X→CANCELLED

---

## Front-End: Search UI Component

Add to your product browse page (e.g., `browse.jsp`):

```html
<!-- Search & Filter Component -->
<div class="search-filter-container">
  <h2>Search & Filter</h2>
  
  <form id="searchForm">
    <input 
      type="text" 
      id="keyword" 
      name="keyword" 
      placeholder="Search products..."
      maxlength="100"
    />
    
    <select id="category" name="category">
      <option value="">All Categories</option>
      <!-- Categories loaded via JS -->
    </select>
    
    <button type="submit">Search</button>
    <button type="button" onclick="clearFilters()">Clear</button>
  </form>
</div>

<div id="results" class="product-grid">
  <!-- Results rendered here -->
</div>

<script>
// Load categories on page load
document.addEventListener('DOMContentLoaded', function() {
    loadCategories();
});

// Load available categories
async function loadCategories() {
    try {
        const response = await fetch('/api/v1/categories');
        const json = await response.json();
        if (json.success) {
            const categorySelect = document.getElementById('category');
            json.data.forEach(cat => {
                const option = document.createElement('option');
                option.value = cat;
                option.textContent = cat;
                categorySelect.appendChild(option);
            });
        }
    } catch (error) {
        console.error('Error loading categories:', error);
    }
}

// Handle search form submission
document.getElementById('searchForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const keyword = document.getElementById('keyword').value.trim();
    const category = document.getElementById('category').value;
    
    if (!keyword && !category) {
        alert('Please enter a search term or select a category');
        return;
    }
    
    let url = '/api/v1/search?';
    if (keyword) url += 'keyword=' + encodeURIComponent(keyword);
    if (keyword && category) url += '&';
    if (category) url += 'category=' + encodeURIComponent(category);
    
    try {
        const response = await fetch(url);
        const json = await response.json();
        
        if (json.success) {
            displayResults(json.data);
        } else {
            alert('Search failed: ' + json.error.message);
        }
    } catch (error) {
        console.error('Search error:', error);
        alert('Search failed. Please try again.');
    }
});

function displayResults(products) {
    const resultsDiv = document.getElementById('results');
    resultsDiv.innerHTML = '';
    
    if (products.length === 0) {
        resultsDiv.innerHTML = '<p>No products found.</p>';
        return;
    }
    
    products.forEach(product => {
        const card = document.createElement('div');
        card.className = 'product-card';
        card.innerHTML = `
            <h3>${escapeHtml(product.name)}</h3>
            <p>${escapeHtml(product.description)}</p>
            <p class="price">$${product.price}</p>
            <p class="stock">Stock: ${product.stock_qty}</p>
            <button onclick="addToCart(${product.id})">Add to Cart</button>
        `;
        resultsDiv.appendChild(card);
    });
}

function clearFilters() {
    document.getElementById('searchForm').reset();
    document.getElementById('results').innerHTML = '';
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
</script>
```

---

## Front-End: Order Status Display (Seller Dashboard)

Add to seller order management page:

```html
<!-- Order Status Section -->
<div id="ordersByStatus">
  <!-- Pending Orders -->
  <div class="order-status-group">
    <h3>Pending Orders</h3>
    <div id="pendingOrders"></div>
  </div>
  
  <!-- Confirmed Orders -->
  <div class="order-status-group">
    <h3>Confirmed Orders</h3>
    <div id="confirmedOrders"></div>
  </div>
  
  <!-- Shipped Orders -->
  <div class="order-status-group">
    <h3>Shipped Orders</h3>
    <div id="shippedOrders"></div>
  </div>
</div>

<script>
async function loadOrdersByStatus() {
    const statuses = ['PENDING', 'CONFIRMED', 'SHIPPED'];
    
    for (let status of statuses) {
        try {
            const response = await fetch(`/api/v1/orders?status=${status}`);
            const json = await response.json();
            
            if (json.success) {
                displayOrdersByStatus(status, json.data);
            }
        } catch (error) {
            console.error(`Error loading ${status} orders:`, error);
        }
    }
}

function displayOrdersByStatus(status, orders) {
    const containerId = status.toLowerCase() + 'Orders';
    const container = document.getElementById(containerId);
    
    if (!container) return;
    container.innerHTML = '';
    
    if (orders.length === 0) {
        container.innerHTML = '<p>No orders in this status.</p>';
        return;
    }
    
    orders.forEach(order => {
        const orderCard = document.createElement('div');
        orderCard.className = 'order-card';
        orderCard.innerHTML = `
            <p><strong>Order #${order.id}</strong></p>
            <p>Total: $${order.total_amount}</p>
            <p>Status: ${order.status}</p>
            <select onchange="updateOrderStatus(${order.id}, this.value)">
                <option value="">Update Status...</option>
                ${getValidTransitions(order.status)}
            </select>
        `;
        container.appendChild(orderCard);
    });
}

function getValidTransitions(currentStatus) {
    const transitions = {
        'PENDING': ['CONFIRMED', 'CANCELLED'],
        'CONFIRMED': ['SHIPPED', 'CANCELLED'],
        'SHIPPED': ['DELIVERED'],
        'DELIVERED': [],
        'CANCELLED': []
    };
    
    return (transitions[currentStatus] || [])
        .map(status => `<option value="${status}">${status}</option>`)
        .join('');
}

async function updateOrderStatus(orderId, newStatus) {
    if (!newStatus) return;
    
    try {
        const response = await fetch(`/api/v1/orders/${orderId}/status`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ status: newStatus })
        });
        
        const json = await response.json();
        if (json.success) {
            alert('Order status updated!');
            loadOrdersByStatus();
        } else {
            alert('Update failed: ' + json.error.message);
        }
    } catch (error) {
        console.error('Error updating status:', error);
        alert('Update failed');
    }
}

// Load on page load
document.addEventListener('DOMContentLoaded', loadOrdersByStatus);
</script>
```

---

## Testing Checklist

Run tests before pushing:
```bash
mvn clean test
```

Key test classes:
- `ProductServiceTest.java` (6 tests)
- `OrderServiceTest.java` (8 tests)

---

## Integration Steps

1. **Copy all .java files** to their respective package directories
2. **Copy migration SQL** to `db/migrations/`
3. **Update web.xml** if needed (servlet mappings should auto-detect via `@WebServlet`)
4. **Copy HTML snippets** to your JSP pages
5. **Run `mvn clean compile`** — no errors
6. **Run `mvn test`** — all tests pass
7. **Deploy to Tomcat** and verify:
   - GET `/api/v1/categories` returns list
   - GET `/api/v1/search?keyword=test` returns products
   - PUT `/api/v1/orders/1/status` updates order (auth required)
8. **Commit to GitHub** with message: `feat: Week 5 - search/filter and order status workflow`

---

## Git Commit Message
```
feat: Week 5 - search/filter and order status workflow

- Add ProductDAO search/filter methods (searchByKeyword, filterByCategory, getAllCategories)
- Add OrderDAO status workflow methods (updateOrderStatus, getOrdersByStatus, getOrdersBySellerAndStatus)
- Implement SearchServlet (GET /api/v1/search, /api/v1/categories)
- Implement OrderStatusServlet (PUT /api/v1/orders/{id}/status)
- Add service layer validation and state machine for order status transitions
- Add front-end search UI component with category dropdown
- Add front-end order status management for sellers
- Add database indexes for search/filter performance
- Add comprehensive unit tests (ProductServiceTest, OrderServiceTest)
- Database migration: V5__week5_search_and_order_workflow.sql
```

---

## Known Considerations

- **Search case-insensitive**: Keyword search converts to lowercase
- **Status transitions enforced**: Invalid transitions rejected at service layer
- **Seller-only status updates**: Only SELLER and ADMIN roles can update order status
- **No pagination yet**: Week 6 can add LIMIT/OFFSET for large result sets
- **No async notifications**: Status changes are synchronous; email/SMS optional for future phases
