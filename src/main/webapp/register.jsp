<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>Register - HarisudhanMart</title></head>
<body style="font-family:Arial;background:#f0f0f0;margin:0">
<div style="background:#111;padding:15px 20px;font-size:22px;font-weight:bold">
  <a href="index.jsp" style="color:white;text-decoration:none">Harisudhan<span style="color:#ff9900">Mart</span></a>
</div>
<div style="max-width:380px;margin:40px auto;background:white;padding:25px;border-radius:8px;box-shadow:0 2px 8px #ccc">
  <h2>Create Account</h2>
  <input id="name" placeholder="Your name" style="width:100%;padding:10px;margin:8px 0;box-sizing:border-box">
  <input id="email" type="email" placeholder="Email" style="width:100%;padding:10px;margin:8px 0;box-sizing:border-box">
  <input id="pass" type="password" placeholder="Password (6 or more letters)" style="width:100%;padding:10px;margin:8px 0;box-sizing:border-box">
  <button onclick="register()" style="width:100%;padding:12px;background:#ff9900;border:none;border-radius:5px;font-weight:bold;cursor:pointer">Register</button>
  <p>Already have an account? <a href="login.jsp">Login</a></p>
</div>
<script>
function register() {
  var n = document.getElementById('name').value;
  var e = document.getElementById('email').value;
  var p = document.getElementById('pass').value;
  if (n == '' || e == '' || p.length < 6) {
    alert('Please fill all boxes. Password needs 6 or more letters.');
    return;
  }
  alert('Registered successfully! Please login.');
  window.location.href = 'login.jsp';
}
</script>
</body>
</html>