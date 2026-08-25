<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>HarisudhanMart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
  <header>
    <h1><a href="${pageContext.request.contextPath}/index.jsp">HarisudhanMart</a></h1>
    <nav>
      <a href="${pageContext.request.contextPath}/products.jsp">Browse</a>
      <a href="${pageContext.request.contextPath}/cart.jsp">Cart</a>
      <a href="${pageContext.request.contextPath}/orders.jsp">My Orders</a>
      <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
      <a href="${pageContext.request.contextPath}/register.jsp">Register</a>
    </nav>
  </header>
  <main>
    <p>Welcome to HarisudhanMart, a multi-seller marketplace. Sellers list products, buyers browse and buy.</p>
    <p><a href="${pageContext.request.contextPath}/products.jsp">Start browsing products &rarr;</a></p>
  </main>
</body>
</html>
