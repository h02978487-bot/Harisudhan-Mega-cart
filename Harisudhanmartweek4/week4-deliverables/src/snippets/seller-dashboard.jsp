<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <title>Seller Dashboard - HarisudhanMart</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; background: white; border-radius: 8px; padding: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; border-bottom: 2px solid #007bff; padding-bottom: 20px; }
        h1 { color: #333; }
        .header-right { display: flex; gap: 10px; }
        .btn-primary { background: #007bff; color: white; padding: 12px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .btn-primary:hover { background: #0056b3; }
        .btn-danger { background: #dc3545; color: white; padding: 8px 12px; border: none; border-radius: 3px; cursor: pointer; }
        .btn-danger:hover { background: #c82333; }
        .btn-secondary { background: #6c757d; color: white; padding: 8px 12px; border: none; border-radius: 3px; cursor: pointer; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #f8f9fa; font-weight: bold; color: #333; }
        tr:hover { background: #f9f9f9; }
        .empty-state { text-align: center; color: #999; padding: 40px; }
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 999; }
        .modal.active { display: flex; align-items: center; justify-content: center; }
        .modal-content { background: white; padding: 40px; border-radius: 8px; width: 90%; max-width: 500px; }
        .modal-close { float: right; cursor: pointer; font-size: 28px; color: #999; }
        .modal-close:hover { color: #333; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: bold; color: #333; }
        input, textarea, select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
        textarea { resize: vertical; min-height: 100px; }
        .form-actions { display: flex; gap: 10px; margin-top: 20px; }
        .form-actions button { flex: 1; padding: 12px; font-size: 16px; }
        .logout { text-decoration: none; color: #007bff; }
        .logout:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <div>
            <h1>📦 Seller Dashboard</h1>
            <p style="color: #666; margin-top: 5px;">Manage your products and orders</p>
        </div>
        <div class="header-right">
            <button class="btn-primary" onclick="openCreateModal()">+ Add Product</button>
            <a class="logout" href="/harisudhanmart/logout">Logout</a>
        </div>
    </div>

    <!-- Products Table -->
    <c:if test="${empty products}">
        <div class="empty-state">
            <p>No products yet.</p>
            <p style="margin-top: 10px;">Create your first product to get started!</p>
        </div>
    </c:if>

    <c:if test="${not empty products}">
        <table>
            <thead>
                <tr>
                    <th>Product Name</th>
                    <th>Price (₹)</th>
                    <th>Stock</th>
                    <th>Category</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${products}">
                    <tr>
                        <td><c:out value="${p.name}"/></td>
                        <td><c:out value="${p.price}"/></td>
                        <td><c:out value="${p.stockQty}"/></td>
                        <td><c:out value="${p.category}"/></td>
                        <td>
                            <button class="btn-secondary" onclick="editProduct(${p.id}, '<c:out value="${p.name}"/>', ${p.price})">Edit</button>
                            <button class="btn-danger" onclick="deleteProduct(${p.id})">Delete</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
</div>

<!-- Create/Edit Modal -->
<div id="productModal" class="modal">
    <div class="modal-content">
        <span class="modal-close" onclick="closeModal()">&times;</span>
        <h2 id="modalTitle" style="margin-bottom: 20px;">Add New Product</h2>
        <form id="productForm" onsubmit="handleFormSubmit(event)">
            <div class="form-group">
                <label for="name">Product Name *</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description"></textarea>
            </div>
            <div class="form-group">
                <label for="price">Price (₹) *</label>
                <input type="number" id="price" name="price" step="0.01" min="0.01" required>
            </div>
            <div class="form-group">
                <label for="stockQty">Stock Quantity *</label>
                <input type="number" id="stockQty" name="stockQty" min="0" required>
            </div>
            <div class="form-group">
                <label for="category">Category *</label>
                <select id="category" name="category" required>
                    <option value="">-- Select Category --</option>
                    <option value="Electronics">Electronics</option>
                    <option value="Clothing">Clothing</option>
                    <option value="Books">Books</option>
                    <option value="Home">Home & Garden</option>
                    <option value="Sports">Sports & Outdoors</option>
                </select>
            </div>
            <div class="form-actions">
                <button type="button" class="btn-secondary" onclick="closeModal()">Cancel</button>
                <button type="submit" class="btn-primary">Save Product</button>
            </div>
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

        const url = currentEditId 
            ? `/harisudhanmart/seller/products?id=${currentEditId}` 
            : "/harisudhanmart/seller/products";
        const method = currentEditId ? "PUT" : "POST";

        fetch(url, {
            method: method,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(formData)
        })
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                alert(currentEditId ? "✓ Product updated!" : "✓ Product created!");
                closeModal();
                location.reload();
            } else {
                alert("✗ Error: " + (data.error?.message || "Unknown error"));
            }
        })
        .catch(err => {
            console.error(err);
            alert("✗ Network error. Please try again.");
        });
    }

    function deleteProduct(id) {
        if (!confirm("Delete this product? This cannot be undone.")) return;

        fetch(`/harisudhanmart/seller/products?id=${id}`, {
            method: "DELETE"
        })
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                alert("✓ Product deleted!");
                location.reload();
            } else {
                alert("✗ Error: " + (data.error?.message || "Unknown error"));
            }
        })
        .catch(err => {
            console.error(err);
            alert("✗ Network error. Please try again.");
        });
    }

    // Close modal when clicking outside
    document.getElementById("productModal").addEventListener("click", (e) => {
        if (e.target.id === "productModal") closeModal();
    });
</script>
</body>
</html>
