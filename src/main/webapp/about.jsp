<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - About Us</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Arial,sans-serif;background:#f0f0f0;}
.navbar{background:#1a0533;padding:15px 20px;display:flex;align-items:center;justify-content:space-between;}
.logo{color:white;font-size:22px;font-weight:bold;}
.logo span{color:#a78bfa;}
.nav-right a{color:white;text-decoration:none;margin-left:20px;font-size:13px;}
.hero{background:linear-gradient(135deg,#1a0533,#2d1b69);color:white;padding:80px 30px;text-align:center;}
.hero h1{font-size:42px;color:#a78bfa;margin-bottom:15px;}
.hero p{font-size:18px;color:#ccc;max-width:600px;margin:0 auto;}
.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:20px;padding:40px 30px;max-width:1000px;margin:0 auto;}
.stat{background:white;border-radius:12px;padding:25px;text-align:center;box-shadow:0 2px 10px rgba(0,0,0,0.08);}
.stat h2{font-size:36px;color:#7c3aed;font-weight:bold;}
.stat p{color:#666;font-size:14px;margin-top:5px;}
.section{padding:50px 30px;max-width:1000px;margin:0 auto;}
.section h2{font-size:28px;color:#1a0533;margin-bottom:20px;text-align:center;}
.cards{display:grid;grid-template-columns:repeat(3,1fr);gap:20px;}
.card{background:white;border-radius:12px;padding:25px;text-align:center;box-shadow:0 2px 10px rgba(0,0,0,0.08);}
.card .icon{font-size:40px;margin-bottom:15px;}
.card h3{color:#1a0533;margin-bottom:10px;}
.card p{color:#666;font-size:14px;line-height:1.6;}
.team{display:grid;grid-template-columns:repeat(3,1fr);gap:20px;margin-top:20px;}
.member{background:white;border-radius:12px;padding:25px;text-align:center;box-shadow:0 2px 10px rgba(0,0,0,0.08);}
.avatar{width:80px;height:80px;border-radius:50%;background:linear-gradient(135deg,#7c3aed,#1a0533);display:flex;align-items:center;justify-content:center;margin:0 auto 15px;font-size:30px;}
.member h3{color:#1a0533;margin-bottom:5px;}
.member p{color:#7c3aed;font-size:13px;}
footer{background:#1a0533;color:#ccc;text-align:center;padding:20px;margin-top:40px;}
footer span{color:#a78bfa;font-weight:bold;}
</style>
</head>
<body>
<div class="navbar">
  <div class="logo">&#128722; <span>Harisudhan</span>Mart</div>
  <div class="nav-right">
    <a href="home.jsp">Home</a>
    <a href="login.jsp">Login</a>
    <a href="register.jsp">Register</a>
  </div>
</div>
<div class="hero">
  <h1>About HarisudhanMart</h1>
  <p>Your one-stop marketplace for everything you need — electronics, fashion, books and more!</p>
</div>
<div class="stats">
  <div class="stat"><h2>12+</h2><p>Products</p></div>
  <div class="stat"><h2>1K+</h2><p>Happy Customers</p></div>
  <div class="stat"><h2>6+</h2><p>Categories</p></div>
  <div class="stat"><h2>24/7</h2><p>Support</p></div>
</div>
<div class="section">
  <h2>Why Choose Us?</h2>
  <div class="cards">
    <div class="card">
      <div class="icon">&#128666;</div>
      <h3>Fast Delivery</h3>
      <p>Get your orders delivered in 3-5 business days with free shipping above Rs.499.</p>
    </div>
    <div class="card">
      <div class="icon">&#128274;</div>
      <h3>Secure Payment</h3>
      <p>100% secure payments with SSL encryption. Pay by card, UPI or cash on delivery.</p>
    </div>
    <div class="card">
      <div class="icon">&#8617;</div>
      <h3>Easy Returns</h3>
      <p>30-day hassle-free returns. No questions asked. Free pickup from your door.</p>
    </div>
    <div class="card">
      <div class="icon">&#127881;</div>
      <h3>Best Deals</h3>
      <p>Save up to 50% on top brands. New offers every day!</p>
    </div>
    <div class="card">
      <div class="icon">&#129302;</div>
      <h3>AI Assistant</h3>
      <p>24/7 chatbot support to help you find products and answer your questions.</p>
    </div>
    <div class="card">
      <div class="icon">&#11088;</div>
      <h3>Top Quality</h3>
      <p>All products are verified and quality checked before listing.</p>
    </div>
  </div>
</div>
<div class="section">
  <h2>Our Team</h2>
  <div class="team">
    <div class="member">
      <div class="avatar">&#128104;&#8205;&#128187;</div>
      <h3>Harisudhan</h3>
      <p>Founder & Developer</p>
    </div>
    <div class="member">
      <div class="avatar">&#128104;&#8205;&#127979;</div>
      <h3>Project Guide</h3>
      <p>Mentor & Advisor</p>
    </div>
    <div class="member">
      <div class="avatar">&#127979;</div>
      <h3>JICET College</h3>
      <p>Institution</p>
    </div>
  </div>
</div>
<footer><span>HarisudhanMart</span><br>2026 HarisudhanMart - Your one-stop marketplace</footer>
</body>
</html>
