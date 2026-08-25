<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Register - HarisudhanMart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
  <header><h1><a href="${pageContext.request.contextPath}/index.jsp">HarisudhanMart</a></h1></header>
  <main>
    <h2>Register</h2>
    <form id="registerForm">
      <label>Name <input type="text" id="name" required></label>
      <label>Email <input type="email" id="email" required></label>
      <label>Password <input type="password" id="password" minlength="8" required></label>
      <label>Role
        <select id="role">
          <option value="BUYER">Buyer</option>
          <option value="SELLER">Seller</option>
        </select>
      </label>
      <button type="submit">Create account</button>
    </form>
    <p id="message" class="error"></p>
    <p>Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Login</a></p>
  </main>
  <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
  <script>
    var ctx = '${pageContext.request.contextPath}';
    document.getElementById('registerForm').addEventListener('submit', function (e) {
      e.preventDefault();
      var name = document.getElementById('name').value;
      var email = document.getElementById('email').value;
      var password = document.getElementById('password').value;
      var role = document.getElementById('role').value;
      apiFetch(ctx + '/api/v1/auth/register', {
        method: 'POST',
        body: JSON.stringify({ name: name, email: email, password: password, role: role })
      }).then(function () {
        window.location.href = ctx + '/login.jsp';
      }).catch(function (err) {
        document.getElementById('message').textContent = err.message;
      });
    });
  </script>
</body>
</html>
