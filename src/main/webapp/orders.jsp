<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - My Orders</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Arial,sans-serif;background:#f0f0f0;}
.navbar{background:#1a0533;padding:15px 20px;display:flex;align-items:center;justify-content:space-between;}
.logo{color:white;font-size:20px;font-weight:bold;}
.logo span{color:#a78bfa;}
.nav-right a{color:white;text-decoration:none;margin-left:20px;font-size:13px;}
.container{max-width:900px;margin:25px auto;padding:0 20px;}
.page-title{font-size:24px;color:#1a0533;margin-bottom:20px;border-left:4px solid #7c3aed;padding-left:10px;}
.order-card{background:white;border-radius:12px;padding:20px;box-shadow:0 2px 8px rgba(0,0,0,0.08);margin-bottom:20px;}
.order-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:15px;padding-bottom:12px;border-bottom:1px solid #eee;}
.order-id{font-size:14px;color:#666;}
.order-id span{color:#7c3aed;font-weight:bold;}
.order-date{font-size:13px;color:#888;}
.order-amount{font-size:18px;color:#1a0533;font-weight:bold;}
.order-item{display:flex;gap:15px;align-items:center;margin-bottom:15px;}
.order-item img{width:70px;height:70px;object-fit:cover;border-radius:8px;}
.item-details h4{font-size:14px;color:#333;margin-bottom:4px;}
.item-details p{font-size:13px;color:#888;}
.tracking{margin-top:15px;padding-top:15px;border-top:1px solid #eee;}
.tracking h4{font-size:13px;color:#666;margin-bottom:15px;}
.steps{display:flex;align-items:center;justify-content:space-between;position:relative;}
.steps::before{content:'';position:absolute;top:20px;left:0;right:0;height:3px;background:#eee;z-index:0;}
.progress-line{position:absolute;top:20px;left:0;height:3px;background:#7c3aed;z-index:1;transition:width 0.5s;}
.step{display:flex;flex-direction:column;align-items:center;gap:8px;z-index:2;flex:1;}
.step-circle{width:40px;height:40px;border-radius:50%;background:#eee;display:flex;align-items:center;justify-content:center;font-size:18px;transition:all 0.3s;}
.step.done .step-circle{background:#7c3aed;color:white;}
.step.active .step-circle{background:#7c3aed;color:white;box-shadow:0 0 0 4px rgba(124,58,237,0.2);}
.step-label{font-size:11px;color:#888;text-align:center;}
.step.done .step-label,.step.active .step-label{color:#7c3aed;font-weight:bold;}
.step-date{font-size:10px;color:#aaa;text-align:center;}
.badge{padding:5px 12px;border-radius:20px;font-size:12px;font-weight:bold;}
.badge-delivered{background:#d1fae5;color:#065f46;}
.badge-shipped{background:#dbeafe;color:#1e40af;}
.badge-processing{background:#fef3c7;color:#92400e;}
.badge-ordered{background:#f3e8ff;color:#7c3aed;}
.btn-track{padding:8px 16px;background:#7c3aed;color:white;border:none;border-radius:8px;cursor:pointer;font-size:13px;}
.btn-reorder{padding:8px 16px;background:white;border:2px solid #7c3aed;color:#7c3aed;border-radius:8px;cursor:pointer;font-size:13px;}
.empty{text-align:center;padding:60px;color:#888;}
.empty div{font-size:60px;margin-bottom:15px;}
</style>
</head>
<body>
<div class="navbar">
  <div class="logo">&#128722; <span>Harisudhan</span>Mart</div>
  <div class="nav-right">
    <a href="home.jsp">&#127968; Home</a>
    <a href="cart.jsp">&#128722; Cart</a>
    <a href="login.jsp">Logout</a>
  </div>
</div>
<div class="container">
  <div class="page-title">&#128230; My Orders</div>
  <div class="order-card">
    <div class="order-header">
      <div>
        <div class="order-id">Order <span>#HM2026001</span></div>
        <div class="order-date">Placed on 08 Oct 2026</div>
      </div>
      <div style="text-align:right;">
        <div class="order-amount">Rs.15,999</div>
        <span class="badge badge-delivered">Delivered</span>
      </div>
    </div>
    <div class="order-item">
      <img src="https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=200">
      <div class="item-details">
        <h4>Smartphone Pro Max</h4>
        <p>Electronics • Qty: 1 • Rs.15,999</p>
      </div>
    </div>
    <div class="tracking">
      <h4>&#128205; Order Tracking</h4>
      <div class="steps">
        <div class="progress-line" style="width:100%"></div>
        <div class="step done">
          <div class="step-circle">&#9989;</div>
          <div class="step-label">Ordered</div>
          <div class="step-date">08 Oct</div>
        </div>
        <div class="step done">
          <div class="step-circle">&#9989;</div>
          <div class="step-label">Confirmed</div>
          <div class="step-date">08 Oct</div>
        </div>
        <div class="step done">
          <div class="step-circle">&#9989;</div>
          <div class="step-label">Shipped</div>
          <div class="step-date">09 Oct</div>
        </div>
        <div class="step done">
          <div class="step-circle">&#9989;</div>
          <div class="step-label">Out for Delivery</div>
          <div class="step-date">10 Oct</div>
        </div>
        <div class="step done">
          <div class="step-circle">&#9989;</div>
          <div class="step-label">Delivered</div>
          <div class="step-date">10 Oct</div>
        </div>
      </div>
    </div>
    <div style="display:flex;gap:10px;margin-top:15px;">
      <button class="btn-reorder" onclick="window.location.href='home.jsp'">&#128722; Reorder</button>
      <button class="btn-track">&#128269; View Invoice</button>
    </div>
  </div>
  <div class="order-card">
    <div class="order-header">
      <div>
        <div class="order-id">Order <span>#HM2026002</span></div>
        <div class="order-date">Placed on 10 Oct 2026</div>
      </div>
      <div style="text-align:right;">
        <div class="order-amount">Rs.2,999</div>
        <span class="badge badge-shipped">Shipped</span>
      </div>
    </div>
    <div class="order-item">
      <img src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=200">
      <div class="item-details">
        <h4>Wireless Headphones</h4>
        <p>Electronics • Qty: 1 • Rs.2,999</p>
      </div>
    </div>
    <div class="tracking">
      <h4>&#128205; Order Tracking</h4>
      <div class="steps">
        <div class="progress-line" style="width:60%"></div>
        <div class="step done">
          <div class="step-circle">&#9989;</div>
          <div class="step-label">Ordered</div>
          <div class="step-date">10 Oct</div>
        </div>
        <div class="step done">
          <div class="step-circle">&#9989;</div>
          <div class="step-label">Confirmed</div>
          <div class="step-date">10 Oct</div>
        </div>
        <div class="step active">
          <div class="step-circle">&#128666;</div>
          <div class="step-label">Shipped</div>
          <div class="step-date">11 Oct</div>
        </div>
        <div class="step">
          <div class="step-circle">&#128230;</div>
          <div class="step-label">Out for Delivery</div>
          <div class="step-date">--</div>
        </div>
        <div class="step">
          <div class="step-circle">&#127968;</div>
          <div class="step-label">Delivered</div>
          <div class="step-date">--</div>
        </div>
      </div>
    </div>
    <div style="display:flex;gap:10px;margin-top:15px;">
      <button class="btn-reorder" onclick="window.location.href='home.jsp'">&#128722; Reorder</button>
      <button class="btn-track">&#128269; Track Order</button>
    </div>
  </div>
  <div class="order-card">
    <div class="order-header">
      <div>
        <div class="order-id">Order <span>#HM2026003</span></div>
        <div class="order-date">Placed on 11 Oct 2026</div>
      </div>
      <div style="text-align:right;">
        <div class="order-amount">Rs.45,999</div>
        <span class="badge badge-processing">Processing</span>
      </div>
    </div>
    <div class="order-item">
      <img src="https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=200">
      <div class="item-details">
        <h4>Laptop Ultra Slim</h4>
        <p>Electronics • Qty: 1 • Rs.45,999</p>
      </div>
    </div>
    <div class="tracking">
      <h4>&#128205; Order Tracking</h4>
      <div class="steps">
        <div class="progress-line" style="width:25%"></div>
        <div class="step done">
          <div class="step-circle">&#9989;</div>
          <div class="step-label">Ordered</div>
          <div class="step-date">11 Oct</div>
        </div>
        <div class="step active">
          <div class="step-circle">&#9203;</div>
          <div class="step-label">Confirmed</div>
          <div class="step-date">Processing</div>
        </div>
        <div class="step">
          <div class="step-circle">&#128666;</div>
          <div class="step-label">Shipped</div>
          <div class="step-date">--</div>
        </div>
        <div class="step">
          <div class="step-circle">&#128230;</div>
          <div class="step-label">Out for Delivery</div>
          <div class="step-date">--</div>
        </div>
        <div class="step">
          <div class="step-circle">&#127968;</div>
          <div class="step-label">Delivered</div>
          <div class="step-date">--</div>
        </div>
      </div>
    </div>
    <div style="display:flex;gap:10px;margin-top:15px;">
      <button class="btn-reorder" onclick="window.location.href='home.jsp'">&#128722; Reorder</button>
      <button class="btn-track" style="background:#dc2626;">&#10006; Cancel Order</button>
    </div>
  </div>
</div>
</body>
</html>
