<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - Home</title>
</head>
<body style="font-family:Arial;background:#f0f0f0;margin:0">
<div style="background:#131921;padding:15px 20px;display:flex;justify-content:space-between;align-items:center">
<div style="color:white;font-size:24px;font-weight:bold">🛒 Harisudhan<span style="color:#ff9900">Mart</span></div>
<div style="display:flex;gap:15px">
<a href="login.jsp" style="color:white;text-decoration:none">👤 Login</a>
<a href="register.jsp" style="color:white;text-decoration:none">📝 Register</a>
<a href="cart.jsp" style="color:white;text-decoration:none">🛒 Cart</a>
<a href="orders.jsp" style="color:white;text-decoration:none">📋 Orders</a>
</div>
</div>
<div style="background:linear-gradient(135deg,#667eea,#764ba2);color:white;text-align:center;padding:50px">
<h1 style="font-size:36px;margin-bottom:15px">Welcome to HarisudhanMart! 🛒</h1>
<p style="font-size:18px;margin-bottom:25px">Your one-stop marketplace</p>
<button onclick="window.location.href='products.jsp'" style="padding:15px 40px;background:#ff9900;border:none;border-radius:5px;font-size:18px;font-weight:bold;cursor:pointer">Shop Now →</button>
</div>
<div style="padding:20px">
<h2 style="margin-bottom:20px">🔥 Featured Products</h2>
<div style="display:grid;grid-template-columns:repeat(4,1fr);gap:15px">
<div style="background:white;border-radius:8px;padding:15px;text-align:center;box-shadow:0 2px 8px rgba(0,0,0,0.1)">
<div style="font-size:60px">📱</div>
<a href="product.jsp?id=1" style="color:inherit;text-decoration:none">Smartphone Pro</a>
<div style="color:#b12704;font-size:18px;font-weight:bold">₹15,999</div>
<div style="color:#ff9900">★★★★★</div>
<button style="width:100%;padding:10px;background:#ff9900;border:none;border-radius:5px;font-weight:bold;cursor:pointer;margin-top:10px">Add to Cart 🛒</button>
</div>
<div style="background:white;border-radius:8px;padding:15px;text-align:center;box-shadow:0 2px 8px rgba(0,0,0,0.1)">
<div style="font-size:60px">💻</div>
<a href="product.jsp?id=2" style="color:inherit;text-decoration:none">Laptop Ultra</a>
<div style="color:#b12704;font-size:18px;font-weight:bold">₹45,999</div>
<div style="color:#ff9900">★★★★☆</div>
<button style="width:100%;padding:10px;background:#ff9900;border:none;border-radius:5px;font-weight:bold;cursor:pointer;margin-top:10px">Add to Cart 🛒</button>
</div>
<div style="background:white;border-radius:8px;padding:15px;text-align:center;box-shadow:0 2px 8px rgba(0,0,0,0.1)">
<div style="font-size:60px">🎧</div>
<a href="product.jsp?id=3" style="color:inherit;text-decoration:none">Headphones</a>
<div style="color:#b12704;font-size:18px;font-weight:bold">₹2,999</div>
<div style="color:#ff9900">★★★★★</div>
<button style="width:100%;padding:10px;background:#ff9900;border:none;border-radius:5px;font-weight:bold;cursor:pointer;margin-top:10px">Add to Cart 🛒</button>
</div>
<div style="background:white;border-radius:8px;padding:15px;text-align:center;box-shadow:0 2px 8px rgba(0,0,0,0.1)">
<div style="font-size:60px">⌚</div>
<a href="product.jsp?id=4" style="color:inherit;text-decoration:none">Smart Watch</a>
<div style="color:#b12704;font-size:18px;font-weight:bold">₹8,999</div>
<div style="color:#ff9900">★★★★☆</div>
<button style="width:100%;padding:10px;background:#ff9900;border:none;border-radius:5px;font-weight:bold;cursor:pointer;margin-top:10px">Add to Cart 🛒</button>
</div>
</div>
</div>
<div style="background:#131921;color:white;text-align:center;padding:20px;margin-top:30px">
<p>© 2026 HarisudhanMart ❤️</p>
</div>
</body>
</html>
