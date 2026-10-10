<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - Seller Dashboard</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Arial,sans-serif;background:#f0f0f0;}
.navbar{background:#1a0533;padding:15px 20px;display:flex;align-items:center;justify-content:space-between;}
.logo{color:white;font-size:20px;font-weight:bold;}
.logo span{color:#a78bfa;}
.nav-right{display:flex;gap:15px;align-items:center;}
.nav-right a{color:white;text-decoration:none;font-size:13px;}
.seller-badge{background:#7c3aed;color:white;padding:4px 12px;border-radius:20px;font-size:12px;}
.container{max-width:1100px;margin:25px auto;padding:0 20px;}
.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:15px;margin-bottom:25px;}
.stat{background:white;border-radius:12px;padding:20px;text-align:center;box-shadow:0 2px 8px rgba(0,0,0,0.08);}
.stat h2{font-size:32px;color:#7c3aed;font-weight:bold;}
.stat p{color:#666;font-size:13px;margin-top:5px;}
.grid{display:grid;grid-template-columns:1fr 1fr;gap:20px;}
.card{background:white;border-radius:12px;padding:25px;box-shadow:0 2px 8px rgba(0,0,0,0.08);}
.card h3{font-size:16px;color:#1a0533;margin-bottom:15px;border-bottom:2px solid #7c3aed;padding-bottom:8px;}
.form-group{margin-bottom:12px;}
.form-group label{display:block;font-size:12px;color:#666;margin-bottom:4px;font-weight:bold;}
.form-group input,.form-group select,.form-group textarea{width:100%;padding:10px;border:2px solid #eee;border-radius:8px;font-size:13px;transition:all 0.3s;}
.form-group input:focus,.form-group select:focus,.form-group textarea:focus{outline:none;border-color:#7c3aed;}
.row{display:grid;grid-template-columns:1fr 1fr;gap:10px;}
.btn-add{width:100%;padding:12px;background:#7c3aed;color:white;border:none;border-radius:8px;font-size:14px;font-weight:bold;cursor:pointer;margin-top:5px;}
.btn-add:hover{background:#6d28d9;}
.product-list{display:flex;flex-direction:column;gap:10px;max-height:400px;overflow-y:auto;}
.product-item{display:flex;align-items:center;gap:12px;padding:12px;border:1px solid #eee;border-radius:8px;}
.product-item img{width:50px;height:50px;object-fit:cover;border-radius:6px;}
.product-info{flex:1;}
.product-info h4{font-size:13px;color:#333;margin-bottom:3px;}
.product-info p{font-size:12px;color:#888;}
.badge{padding:3px 8px;border-radius:10px;font-size:11px;font-weight:bold;}
.badge-active{background:#d1fae5;color:#065f46;}
.badge-pending{background:#fef3c7;color:#92400e;}
.btn-edit{padding:5px 10px;background:#f0f0f0;border:none;border-radius:5px;cursor:pointer;font-size:12px;}
.btn-del{padding:5px 10px;background:#fee2e2;border:none;border-radius:5px;cursor:pointer;font-size:12px;color:#dc2626;}
</style>
</head>
<body>
<div class="navbar">
  <div class="logo">&#128722; <span>Harisudhan</span>Mart</div>
  <div class="nav-right">
    <span class="seller-badge">&#127978; Seller Panel</span>
    <a href="login.jsp">Logout</a>
  </div>
</div>
<div class="container">
  <div class="stats">
    <div class="stat"><h2 id="totalProducts">4</h2><p>My Products</p></div>
    <div class="stat"><h2>23</h2><p>Orders Today</p></div>
    <div class="stat"><h2>Rs.12,450</h2><p>Today Revenue</p></div>
    <div class="stat"><h2>4.8&#11088;</h2><p>My Rating</p></div>
  </div>
  <div class="grid">
    <div class="card">
      <h3>&#10133; Add New Product</h3>
      <div class="form-group">
        <label>Product Name</label>
        <input type="text" id="pname" placeholder="Enter product name">
      </div>
      <div class="row">
        <div class="form-group">
          <label>Price (Rs.)</label>
          <input type="number" id="pprice" placeholder="0">
        </div>
        <div class="form-group">
          <label>Original Price</label>
          <input type="number" id="porig" placeholder="0">
        </div>
      </div>
      <div class="row">
        <div class="form-group">
          <label>Category</label>
          <select id="pcat">
            <option>Electronics</option>
            <option>Fashion</option>
            <option>Books</option>
            <option>Home</option>
            <option>Sports</option>
            <option>Gaming</option>
          </select>
        </div>
        <div class="form-group">
          <label>Stock Quantity</label>
          <input type="number" id="pstock" placeholder="0">
        </div>
      </div>
      <div class="form-group">
        <label>Description</label>
        <textarea id="pdesc" rows="2" placeholder="Product description..."></textarea>
      </div>
      <div class="form-group">
        <label>Image URL</label>
        <input type="text" id="pimg" placeholder="https://...">
      </div>
      <button class="btn-add" onclick="addProduct()">&#10133; ADD PRODUCT</button>
    </div>
    <div class="card">
      <h3>&#128230; My Products</h3>
      <div class="product-list" id="productList">
        <div class="product-item">
          <img src="https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=100">
          <div class="product-info">
            <h4>Smartphone Pro Max</h4>
            <p>Electronics • Rs.15,999 • Stock: 45</p>
          </div>
          <span class="badge badge-active">Active</span>
          <button class="btn-edit">Edit</button>
          <button class="btn-del">Del</button>
        </div>
        <div class="product-item">
          <img src="https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=100">
          <div class="product-info">
            <h4>Laptop Ultra Slim</h4>
            <p>Electronics • Rs.45,999 • Stock: 12</p>
          </div>
          <span class="badge badge-active">Active</span>
          <button class="btn-edit">Edit</button>
          <button class="btn-del">Del</button>
        </div>
        <div class="product-item">
          <img src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=100">
          <div class="product-info">
            <h4>Wireless Headphones</h4>
            <p>Electronics • Rs.2,999 • Stock: 78</p>
          </div>
          <span class="badge badge-pending">Pending</span>
          <button class="btn-edit">Edit</button>
          <button class="btn-del">Del</button>
        </div>
        <div class="product-item">
          <img src="https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=100">
          <div class="product-info">
            <h4>Running Shoes</h4>
            <p>Fashion • Rs.1,499 • Stock: 33</p>
          </div>
          <span class="badge badge-active">Active</span>
          <button class="btn-edit">Edit</button>
          <button class="btn-del">Del</button>
        </div>
      </div>
    </div>
  </div>
</div>
<script>
function addProduct(){
  var name=document.getElementById('pname').value;
  var price=document.getElementById('pprice').value;
  var cat=document.getElementById('pcat').value;
  var stock=document.getElementById('pstock').value;
  var img=document.getElementById('pimg').value;
  if(!name||!price){alert('Please fill product name and price!');return;}
  var list=document.getElementById('productList');
  var item=document.createElement('div');
  item.className='product-item';
  item.innerHTML='<img src="'+(img||'https://via.placeholder.com/50')+'" onerror="this.src=\'https://via.placeholder.com/50\'">'
    +'<div class="product-info"><h4>'+name+'</h4><p>'+cat+' • Rs.'+price+' • Stock: '+(stock||0)+'</p></div>'
    +'<span class="badge badge-pending">Pending</span>'
    +'<button class="btn-edit">Edit</button>'
    +'<button class="btn-del" onclick="this.parentElement.remove()">Del</button>';
  list.appendChild(item);
  var total=document.getElementById('totalProducts');
  total.textContent=parseInt(total.textContent)+1;
  document.getElementById('pname').value='';
  document.getElementById('pprice').value='';
  document.getElementById('pstock').value='';
  document.getElementById('pdesc').value='';
  document.getElementById('pimg').value='';
  alert('Product added successfully!');
}
</script>
</body>
</html>
