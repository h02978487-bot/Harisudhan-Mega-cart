<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - My Profile</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Arial,sans-serif;background:#f0f0f0;}
.navbar{background:#1a0533;padding:15px 20px;display:flex;align-items:center;justify-content:space-between;}
.logo{color:white;font-size:20px;font-weight:bold;}
.logo span{color:#a78bfa;}
.nav-right a{color:white;text-decoration:none;margin-left:20px;font-size:13px;}
.container{max-width:900px;margin:25px auto;padding:0 20px;display:grid;grid-template-columns:300px 1fr;gap:20px;}
.card{background:white;border-radius:12px;padding:25px;box-shadow:0 2px 8px rgba(0,0,0,0.08);}
.profile-pic{width:100px;height:100px;border-radius:50%;background:linear-gradient(135deg,#7c3aed,#1a0533);display:flex;align-items:center;justify-content:center;font-size:40px;margin:0 auto 15px;}
.profile-name{text-align:center;font-size:20px;font-weight:bold;color:#1a0533;margin-bottom:5px;}
.profile-email{text-align:center;font-size:13px;color:#888;margin-bottom:15px;}
.profile-badge{text-align:center;margin-bottom:20px;}
.badge{padding:5px 15px;background:#f3e8ff;color:#7c3aed;border-radius:20px;font-size:12px;font-weight:bold;}
.menu-item{display:flex;align-items:center;gap:10px;padding:12px;border-radius:8px;cursor:pointer;color:#333;font-size:14px;transition:all 0.2s;margin-bottom:5px;}
.menu-item:hover,.menu-item.active{background:#f3e8ff;color:#7c3aed;}
.menu-item span{font-size:18px;}
.stats{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin-bottom:20px;}
.stat{background:#f3e8ff;border-radius:10px;padding:15px;text-align:center;}
.stat h3{font-size:24px;color:#7c3aed;font-weight:bold;}
.stat p{font-size:12px;color:#666;margin-top:3px;}
.section-title{font-size:16px;color:#1a0533;font-weight:bold;margin-bottom:15px;border-bottom:2px solid #7c3aed;padding-bottom:8px;}
.form-group{margin-bottom:15px;}
.form-group label{display:block;font-size:12px;color:#666;margin-bottom:5px;font-weight:bold;}
.form-group input{width:100%;padding:10px 14px;border:2px solid #eee;border-radius:8px;font-size:14px;transition:all 0.3s;}
.form-group input:focus{outline:none;border-color:#7c3aed;}
.row{display:grid;grid-template-columns:1fr 1fr;gap:10px;}
.btn-save{padding:12px 25px;background:#7c3aed;color:white;border:none;border-radius:8px;font-size:14px;font-weight:bold;cursor:pointer;}
.btn-save:hover{background:#6d28d9;}
.btn-logout{width:100%;padding:12px;background:#fee2e2;color:#dc2626;border:none;border-radius:8px;font-size:14px;font-weight:bold;cursor:pointer;margin-top:10px;}
.address-card{border:2px solid #eee;border-radius:10px;padding:15px;margin-bottom:10px;position:relative;}
.address-card.default{border-color:#7c3aed;}
.default-badge{position:absolute;top:10px;right:10px;background:#7c3aed;color:white;padding:2px 8px;border-radius:10px;font-size:11px;}
.address-card h4{font-size:14px;color:#333;margin-bottom:5px;}
.address-card p{font-size:13px;color:#888;line-height:1.5;}
</style>
</head>
<body>
<div class="navbar">
  <div class="logo">&#128722; <span>Harisudhan</span>Mart</div>
  <div class="nav-right">
    <a href="home.jsp">&#127968; Home</a>
    <a href="orders.jsp">My Orders</a>
    <a href="cart.jsp">&#128722; Cart</a>
    <a href="login.jsp">Logout</a>
  </div>
</div>
<div class="container">
  <div>
    <div class="card" style="margin-bottom:20px;">
      <div class="profile-pic">&#128100;</div>
      <div class="profile-name">Harisudhan</div>
      <div class="profile-email">h02978487@gmail.com</div>
      <div class="profile-badge"><span class="badge">&#11088; Premium Buyer</span></div>
      <div class="menu-item active"><span>&#128100;</span> My Profile</div>
      <div class="menu-item" onclick="window.location.href='orders.jsp'"><span>&#128230;</span> My Orders</div>
      <div class="menu-item" onclick="window.location.href='cart.jsp'"><span>&#128722;</span> My Cart</div>
      <div class="menu-item"><span>&#128205;</span> My Addresses</div>
      <div class="menu-item"><span>&#10084;</span> Wishlist</div>
      <button class="btn-logout" onclick="window.location.href='login.jsp'">&#128682; Logout</button>
    </div>
  </div>
  <div>
    <div class="card" style="margin-bottom:20px;">
      <div class="stats">
        <div class="stat"><h3>3</h3><p>Orders</p></div>
        <div class="stat"><h3>1</h3><p>Wishlist</p></div>
        <div class="stat"><h3>4.8&#11088;</h3><p>My Rating</p></div>
      </div>
      <div class="section-title">&#128100; Personal Information</div>
      <div class="row">
        <div class="form-group">
          <label>First Name</label>
          <input type="text" value="Harisudhan">
        </div>
        <div class="form-group">
          <label>Last Name</label>
          <input type="text" value="M">
        </div>
      </div>
      <div class="form-group">
        <label>Email Address</label>
        <input type="email" value="h02978487@gmail.com">
      </div>
      <div class="form-group">
        <label>Phone Number</label>
        <input type="text" value="+91 9876543210">
      </div>
      <div class="form-group">
        <label>Date of Birth</label>
        <input type="date" value="2004-01-01">
      </div>
      <button class="btn-save" onclick="alert('Profile saved!')">&#10003; Save Changes</button>
    </div>
    <div class="card">
      <div class="section-title">&#128205; My Addresses</div>
      <div class="address-card default">
        <span class="default-badge">Default</span>
        <h4>&#127968; Home</h4>
        <p>123, Main Street<br>Chennai, Tamil Nadu - 600001<br>Phone: +91 9876543210</p>
      </div>
      <div class="address-card">
        <h4>&#127970; College</h4>
        <p>JICET College<br>Coimbatore, Tamil Nadu - 641001<br>Phone: +91 9876543210</p>
      </div>
      <button onclick="alert('Address added!')" style="padding:10px 20px;background:white;border:2px solid #7c3aed;color:#7c3aed;border-radius:8px;cursor:pointer;font-size:13px;font-weight:bold;margin-top:10px;">&#10133; Add New Address</button>
    </div>
  </div>
</div>
</body>
</html>
