<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Listing - HarisudhanMart</title>
</head>
<body>
<h1>Edit Listing</h1>
<form action="${pageContext.request.contextPath}/seller/products" method="post">
    <input type="hidden" name="action" value="update"/>
    <input type="hidden" name="id" value="${product.id}"/>
    <label>Name <input type="text" name="name" value="${fn:escapeXml(product.name)}" required/></label><br/>
    <label>Description <textarea name="description"><c:out value="${product.description}"/></textarea></label><br/>
    <label>Price <input type="number" step="0.01" min="0.01" name="price" value="${product.price}" required/></label><br/>
    <label>Stock Qty <input type="number" min="0" name="stockQty" value="${product.stockQty}" required/></label><br/>
    <label>Category <input type="text" name="category" value="${fn:escapeXml(product.category)}"/></label><br/>
    <label>Image URL <input type="url" name="imageUrl" value="${fn:escapeXml(product.imageUrl)}"/></label><br/>
    <button type="submit">Save Changes</button>
</form>
<a href="${pageContext.request.contextPath}/seller/products">Back to dashboard</a>
</body>
</html>
