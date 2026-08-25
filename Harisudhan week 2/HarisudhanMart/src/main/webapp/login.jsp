<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Login - HarisudhanMart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
  <header><h1><a href="${pageContext.request.contextPath}/index.jsp">HarisudhanMart</a></h1></header>
  <main>
    <h2>Login</h2>
    <form id="loginForm">
      <label>Email <input type="email" id="email" required></label>
      <label>Password <input type="password" id="password" required></label>
      <button type="submit">Login</button>
    </form>
    <p id="message" class="error"></p>
    <p>No account? <a href="${pageContext.request.contextPath}/register.jsp">Register</a></p>
  </main>
  <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
  <script>
    var ctx = '${pageContext.request.contextPath}';
    document.getElementById('loginForm').addEventListener('submit', function (e) {
      e.preventDefault();
      var email = document.getElementById('email').value;
      var password = document.getElementById('password').value;
      apiFetch(ctx + '/api/v1/auth/login', {
        method: 'POST',
        body: JSON.stringify({ email: email, password: password })
      }).then(function () {
        window.location.href = ctx + '/products.jsp';
      }).catch(function (err) {
        document.getElementById('message').textContent = err.message;
      });
    });
  </script>
</body>
</html>
