<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - Admin Panel</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Arial,sans-serif;background:#f0f0f0;display:flex;}
.sidebar{width:220px;background:#1a0533;min-height:100vh;padding:20px 0;position:fixed;}
.sidebar-logo{color:white;font-size:16px;font-weight:bold;padding:0 20px 20px;border-bottom:1px solid rgba(255,255,255,0.1);}
.sidebar-logo span{color:#a78bfa;}
.sidebar-menu{margin-top:15px;}
.menu-item{padding:12px 20px;color:#aaa;cursor:pointer;display:flex;align-items:center;gap:10px;font-size:13px;transition:all 0.2s;}
.menu-item:hover,.menu-item.active{background:rgba(124,58,237,0.3);color:white;border-left:3px solid #7c3aed;}
.main{margin-left:220px;flex:1;padding:25px;}
.topbar{background:white;border-radius:12px;padding:15px 20px;display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;box-shadow:0 2px 8px rgba(0,0,0,0.08);}
.topbar h2{color:#1a0533;font-size:18px;}
.admin-badge{background:#7c3aed;color:white;padding:5px 15px;border-radius:20px;font-size:12px;}
.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:15px;margin-bottom:20px;}
.stat{background:white;border-radius:12px;padding:20px;box-shadow:0 2px 8px rgba(0,0,0,0.08);}
.stat-icon{font-size:30px;margin-bottom:10px;}
.stat h2{font-size:28px;color:#7c3aed;font-weight:bold;}
.stat p{color:#666;font-size:12px;margin-top:3px;}
.stat .trend{font-size:11px;color:green;margin-top:5px;}
.grid{display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:20px;}
.card{background:white;border-radius:12px;padding:20px;box-shadow:0 2px 8px rgba(0,0,0,0.08);}
.card h3{font-size:15px;color:#1a0533;margin-bottom:15px;border-bottom:2px solid #7c3aed;padding-bottom:8px;}
table{width:100%;border-collapse:collapse;font-size:13px;}
th{background:#f5f0ff;color:#7c3aed;padding:10px;text-align:left;font-size:12px;}
td{padding:10px;border-bottom:1px solid #eee;color:#333;}
tr:hover{background:#fafafa;}
.badge{padding:3px 8px;border-radius:10px;font-size:11px;font-weight:bold;}
.badge-active{background:#d1fae5;color:#065f46;}
.badge-pending{background:#fef3c7;color:#92400e;}
.badge-delivered{background:#dbeafe;color:#1e40af;}
.badge-cancelled{background:#fee2e2;color:#dc2626;}
.btn-sm{padding:4px 10px;border:none;border-radius:5px;cursor:pointer;font-size:11px;font-weight:bold;}
.btn-approve{background:#d1fae5;color:#065f46;}
.btn-block{background:#fee2e2;color:#dc2626;}
.chart-bar{display:flex;align-items:flex-end;gap:8px;height:120px;margin-top:10px;}
.bar{flex:1;background:linear-gradient(to top,#7c3aed,#a78bfa);border-radius:4px 4px 0 0;position:relative;}
.bar-label{text-align:center;font-size:10px;color:#666;margin-top:5px;}
</style>
</head>
<body>
<div class="sidebar">
  <div class="sidebar-logo">&#128722; <span>Harisudhan</span>Mart</div>
  <div class="sidebar-menu">
    <div class="menu-item active">&#128202; Dashboard</div>
    <div class="menu-item">&#128722; Products</div>
    <div class="menu-item">&#128101; Users</div>
    <div class="menu-item">&#128230; Orders</div>
    <div class="menu-item">&#127978; Sellers</div>
    <div class="menu-item">&#128179; Payments</div>
    <div class="menu-item">&#128270; Reports</div>
    <div class="menu-item" onclick="window.location.href='login.jsp'">&#128682; Logout</div>
  </div>
</div>
<div class="main">
  <div class="topbar">
    <h2>&#128202; Admin Dashboard</h2>
    <span class="admin-badge">&#128737; Admin Panel</span>
  </div>
  <div class="stats">
    <div class="stat">
      <div class="stat-icon">&#128101;</div>
      <h2>1,245</h2>
      <p>Total Users</p>
      <div class="trend">&#8593; 12% this week</div>
    </div>
    <div class="stat">
      <div class="stat-icon">&#128722;</div>
      <h2>48</h2>
      <p>Total Products</p>
      <div class="trend">&#8593; 5 new today</div>
    </div>
    <div class="stat">
      <div class="stat-icon">&#128230;</div>
      <h2>328</h2>
      <p>Total Orders</p>
      <div class="trend">&#8593; 23 today</div>
    </div>
    <div class="stat">
      <div class="stat-icon">&#128176;</div>
      <h2>Rs.2.4L</h2>
      <p>Total Revenue</p>
      <div class="trend">&#8593; 18% this month</div>
    </div>
  </div>
  <div class="grid">
    <div class="card">
      <h3>&#128230; Recent Orders</h3>
      <table>
        <tr><th>Order ID</th><th>Customer</th><th>Amount</th><th>Status</th></tr>
        <tr><td>#HM001</td><td>Harisudhan</td><td>Rs.15,999</td><td><span class="badge badge-delivered">Delivered</span></td></tr>
        <tr><td>#HM002</td><td>Ravi Kumar</td><td>Rs.2,999</td><td><span class="badge badge-active">Shipped</span></td></tr>
        <tr><td>#HM003</td><td>Priya S</td><td>Rs.45,999</td><td><span class="badge badge-pending">Pending</span></td></tr>
        <tr><td>#HM004</td><td>Arun M</td><td>Rs.8,999</td><td><span class="badge badge-active">Shipped</span></td></tr>
        <tr><td>#HM005</td><td>Kavya R</td><td>Rs.399</td><td><span class="badge badge-cancelled">Cancelled</span></td></tr>
      </table>
    </div>
    <div class="card">
      <h3>&#127978; Seller Requests</h3>
      <table>
        <tr><th>Seller</th><th>Products</th><th>Status</th><th>Action</th></tr>
        <tr><td>Ram Stores</td><td>12</td><td><span class="badge badge-pending">Pending</span></td><td><button class="btn-sm btn-approve">Approve</button></td></tr>
        <tr><td>Tech Hub</td><td>8</td><td><span class="badge badge-active">Active</span></td><td><button class="btn-sm btn-block">Block</button></td></tr>
        <tr><td>Fashion World</td><td>23</td><td><span class="badge badge-active">Active</span></td><td><button class="btn-sm btn-block">Block</button></td></tr>
        <tr><td>Book Palace</td><td>5</td><td><span class="badge badge-pending">Pending</span></td><td><button class="btn-sm btn-approve">Approve</button></td></tr>
      </table>
    </div>
  </div>
  <div class="card">
    <h3>&#128101; Recent Users</h3>
    <table>
      <tr><th>Name</th><th>Email</th><th>Role</th><th>Joined</th><th>Status</th><th>Action</th></tr>
      <tr><td>Harisudhan</td><td>h02978487@gmail.com</td><td>Buyer</td><td>01-Oct-2026</td><td><span class="badge badge-active">Active</span></td><td><button class="btn-sm btn-block">Block</button></td></tr>
      <tr><td>Ravi Kumar</td><td>ravi@gmail.com</td><td>Buyer</td><td>03-Oct-2026</td><td><span class="badge badge-active">Active</span></td><td><button class="btn-sm btn-block">Block</button></td></tr>
      <tr><td>Ram Stores</td><td>ram@stores.com</td><td>Seller</td><td>05-Oct-2026</td><td><span class="badge badge-pending">Pending</span></td><td><button class="btn-sm btn-approve">Approve</button></td></tr>
      <tr><td>Priya S</td><td>priya@gmail.com</td><td>Buyer</td><td>07-Oct-2026</td><td><span class="badge badge-active">Active</span></td><td><button class="btn-sm btn-block">Block</button></td></tr>
    </table>
  </div>
</div>
</body>
</html>
