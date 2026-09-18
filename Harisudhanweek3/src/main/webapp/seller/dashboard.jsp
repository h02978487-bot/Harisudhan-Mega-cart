<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Seller Dashboard - HarisudhanMart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<h1>Seller Dashboard</h1>

<c:if test="${not empty errorMessage}">
    <p class="error"><c:out value="${errorMessage}"/></p>
</c:if>

<h2>Add New Listing</h2>
<form action="${pageContext.request.contextPath}/seller/products" method="post">
    <input type="hidden" name="action" value="create"/>
    <label>Name <input type="text" name="name" required maxlength="150"/></label><br/>
    <label>Description <textarea name="description" maxlength="2000"></textarea></label><br/>
    <label>Price <input type="number" step="0.01" min="0.01" name="price" required/></label><br/>
    <label>Stock Qty <input type="number" min="0" name="stockQty" required/></label><br/>
    <label>Category <input type="text" name="category" maxlength="80"/></label><br/>
    <label>Image URL <input type="url" name="imageUrl" maxlength="500"/></label><br/>
    <button type="submit">Add Listing</button>
</form>

<h2>Your Listings</h2>
<table border="1">
    <tr>
        <th>Name</th><th>Category</th><th>Price</th><th>Stock</th><th>Actions</th>
    </tr>
    <c:forEach var="item" items="${listings}">
        <tr>
            <td><c:out value="${item.name}"/></td>
            <td><c:out value="${item.category}"/></td>
            <td><c:out value="${item.price}"/></td>
            <td><c:out value="${item.stockQty}"/></td>
            <td>
                <a href="${pageContext.request.contextPath}/seller/products?action=edit&id=${item.id}">Edit</a>
                <form action="${pageContext.request.contextPath}/seller/products" method="post"
                      style="display:inline" onsubmit="return confirm('Delete this listing?');">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="id" value="${item.id}"/>
                    <button type="submit">Delete</button>
                </form>
            </td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
