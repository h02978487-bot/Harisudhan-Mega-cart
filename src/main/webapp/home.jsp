<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - Home</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Arial,sans-serif;background:#f0f0f0;}
.navbar{background:#1a0533;padding:10px 20px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:100;}
.logo{color:white;font-size:22px;font-weight:bold;}
.logo span{color:#7c3aed;}
.search-box{display:flex;flex:1;margin:0 20px;}
.search-box input{width:100%;padding:10px;font-size:14px;border:none;border-radius:4px 0 0 4px;}
.search-box button{padding:10px 15px;background:#7c3aed;border:none;cursor:pointer;color:white;border-radius:0 4px 4px 0;}
.nav-right{display:flex;gap:15px;align-items:center;}
.nav-right a{color:white;text-decoration:none;font-size:13px;}
.banner{background:linear-gradient(135deg,#1a0533,#2d1b69);color:white;padding:40px 30px;}
.banner h1{font-size:36px;margin-bottom:10px;color:#a78bfa;}
.banner p{font-size:16px;margin-bottom:20px;color:#ccc;}
.banner button{padding:12px 30px;background:#7c3aed;border:none;border-radius:5px;font-size:16px;font-weight:bold;cursor:pointer;color:white;}
.categories{background:white;padding:12px 20px;display:flex;gap:10px;overflow-x:auto;border-bottom:1px solid #ddd;}
.cat-btn{padding:8px 16px;background:#f0f0f0;border:none;border-radius:20px;cursor:pointer;font-size:13px;white-space:nowrap;}
.cat-btn:hover,.cat-btn.active{background:#7c3aed;color:white;}
.section{padding:20px;}
.section h2{font-size:22px;margin-bottom:15px;color:#333;border-left:4px solid #7c3aed;padding-left:10px;}
.product-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:15px;}
.product-card{animation:fadeIn 0.5s ease;background:white;border-radius:8px;padding:15px;box-shadow:0 2px 8px rgba(0,0,0,0.08);cursor:pointer;transition:all 0.2s;}
.product-card:hover{transform:translateY(-5px);box-shadow:0 8px 20px rgba(124,58,237,0.2);}
.product-card img{width:100%;height:180px;object-fit:cover;border-radius:8px;margin-bottom:10px;}
.product-name{font-size:14px;font-weight:bold;color:#333;margin-bottom:5px;}
.product-category{font-size:12px;color:#888;margin-bottom:5px;}
.product-rating{color:#7c3aed;font-size:13px;margin-bottom:8px;}
.product-price{font-size:20px;color:#b12704;font-weight:bold;margin-bottom:5px;}
.product-original{font-size:13px;color:#888;text-decoration:line-through;}
.product-discount{font-size:13px;color:green;font-weight:bold;}
.btn-add-cart{width:100%;padding:10px;background:#7c3aed;border:none;border-radius:5px;font-size:14px;font-weight:bold;cursor:pointer;margin-top:10px;color:white;}
.btn-view{width:100%;padding:8px;background:white;border:2px solid #7c3aed;border-radius:5px;font-size:13px;cursor:pointer;margin-top:5px;color:#7c3aed;font-weight:bold;}
@keyframes fadeIn{from{opacity:0;transform:translateY(20px);}to{opacity:1;transform:translateY(0);}}
footer{background:#1a0533;color:#ccc;text-align:center;padding:20px;}
footer span{color:#7c3aed;font-weight:bold;}
.overlay{display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.8);z-index:1000;justify-content:center;align-items:center;}
.overlay.active{display:flex;}
.detail-box{background:white;border-radius:20px;padding:30px;max-width:500px;width:90%;position:relative;}
.detail-box img{width:100%;height:220px;object-fit:cover;border-radius:12px;margin-bottom:15px;}
.close-btn{position:absolute;top:15px;right:15px;background:none;border:none;font-size:24px;cursor:pointer;}
.detail-actions{display:flex;gap:10px;margin-top:15px;}
.detail-actions button{flex:1;padding:12px;border-radius:8px;font-weight:bold;cursor:pointer;font-size:14px;}
.btn-cart2{background:#f0f0f0;border:2px solid #7c3aed;color:#7c3aed;}
.btn-buy{background:#7c3aed;border:none;color:white;}
#chatBtn{position:fixed;bottom:30px;right:30px;width:60px;height:60px;background:#7c3aed;border-radius:50%;border:none;cursor:pointer;font-size:28px;box-shadow:0 4px 15px rgba(124,58,237,0.5);z-index:999;}
</style>
</head>
<body>
<div class="navbar">
  <div class="logo">&#128722; <span>Harisudhan</span>Mart</div>
  <div class="search-box">
    <input type="text" id="searchInput" placeholder="Search products...">
    <button onclick="searchProducts()">&#128269;</button>
  </div>
  <div class="nav-right">
    <a href="about.jsp">About</a><a href="cart.jsp"><a href="cart.jsp">&#128722; Cart</a>#128722; Cart</a>
    <a href="orders.jsp">Orders</a>
    <a href="login.jsp">Logout</a>
  </div>
</div>
<div class="banner">
  <h1>Welcome to HarisudhanMart!</h1>
  <p>Shop the best products at amazing prices!</p>
  <button>Shop Now &#8594;</button>
</div>
<div class="categories">
  <button class="cat-btn active" onclick="filterCat(this,'all')">All</button>
  <button class="cat-btn" onclick="filterCat(this,'Electronics')">Electronics</button>
  <button class="cat-btn" onclick="filterCat(this,'Fashion')">Fashion</button>
  <button class="cat-btn" onclick="filterCat(this,'Home')">Home</button>
  <button class="cat-btn" onclick="filterCat(this,'Books')">Books</button>
  <button class="cat-btn" onclick="filterCat(this,'Sports')">Sports</button>
  <button class="cat-btn" onclick="filterCat(this,'Gaming')">Gaming</button>
</div>
<div class="section">
  <h2>&#128293; Featured Products</h2>
  <div class="product-grid" id="productGrid"></div>
</div>
<footer><span>HarisudhanMart</span><br>2026 HarisudhanMart - Your one-stop marketplace</footer>
<div class="overlay" id="detailOverlay">
  <div class="detail-box">
    <button class="close-btn" onclick="document.getElementById('detailOverlay').classList.remove('active')">&#10005;</button>
    <img id="dImg" src="" alt="">
    <h2 id="dName" style="color:#333;margin-bottom:5px;"></h2>
    <p id="dCat" style="color:#888;font-size:13px;margin-bottom:8px;"></p>
    <p id="dRating" style="color:#7c3aed;margin-bottom:8px;"></p>
    <div style="display:flex;gap:10px;align-items:center;margin-bottom:10px;">
      <span id="dPrice" style="font-size:24px;color:#b12704;font-weight:bold;"></span>
      <span id="dOrig" style="color:#888;text-decoration:line-through;font-size:14px;"></span>
      <span id="dDisc" style="color:green;font-weight:bold;font-size:14px;"></span>
    </div>
    <p id="dDesc" style="color:#666;font-size:14px;margin-bottom:15px;"></p>
    <div class="detail-actions">
      <button class="btn-cart2" onclick="alert('Added to cart!')">&#128722; Add to Cart</button>
      <button class="btn-buy" onclick="window.location.href='payment.jsp'">Buy Now &#8594;</button>
    </div>
  </div>
</div>
<button id="chatBtn" onclick="window.location.href='chatbot.jsp'">&#129302;</button>
<script>
const products=[
{id:1,name:"Smartphone Pro Max",category:"Electronics",price:15999,original:22999,rating:"★★★★★",reviews:245,desc:"Latest 5G smartphone with 128GB storage and 50MP camera.",image:"https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&q=80"},
{id:2,name:"Laptop Ultra Slim",category:"Electronics",price:45999,original:65999,rating:"★★★★",reviews:189,desc:"Intel i7, 16GB RAM, 512GB SSD laptop.",image:"https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&q=80"},
{id:3,name:"Wireless Headphones",category:"Electronics",price:2999,original:5999,rating:"★★★★★",reviews:567,desc:"Noise cancellation headphones with 30hr battery.",image:"https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&q=80"},
{id:4,name:"Running Shoes",category:"Fashion",price:1499,original:2999,rating:"★★★★★",reviews:321,desc:"Lightweight shoes with air cushion sole.",image:"https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80"},
{id:5,name:"Java Book",category:"Books",price:499,original:899,rating:"★★★★★",reviews:98,desc:"Complete Java guide from beginner to advanced.",image:"https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400&q=80"},
{id:6,name:"Smart Watch",category:"Electronics",price:8999,original:12999,rating:"★★★★★",reviews:432,desc:"Health monitoring GPS smart watch.",image:"https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&q=80"},
{id:7,name:"Gaming Controller",category:"Gaming",price:3499,original:4999,rating:"★★★★★",reviews:276,desc:"Wireless controller for PC and mobile.",image:"https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=400&q=80"},
{id:8,name:"DSLR Camera",category:"Electronics",price:32999,original:45999,rating:"★★★★★",reviews:154,desc:"24MP DSLR with 4K video recording.",image:"https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=400&q=80"},
{id:9,name:"Cotton T-Shirt",category:"Fashion",price:399,original:799,rating:"★★★★★",reviews:543,desc:"Premium cotton t-shirt in multiple colors.",image:"https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&q=80"},
{id:10,name:"Coffee Maker",category:"Home",price:2499,original:3999,rating:"★★★★★",reviews:234,desc:"Automatic 12 cup coffee maker with timer.",image:"https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400&q=80"},
{id:11,name:"Football",category:"Sports",price:799,original:1299,rating:"★★★★★",reviews:187,desc:"Professional size 5 football.",image:"https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=400&q=80"},
{id:12,name:"Bluetooth Speaker",category:"Electronics",price:1999,original:3499,rating:"★★★★★",reviews:389,desc:"Waterproof portable speaker 12hr battery.",image:"https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400&q=80"}
];
function money(n){return 'Rs.'+n.toLocaleString();}
function disc(p,o){return Math.round((o-p)/o*100);}
function showDetail(idx){
  var p=products[idx];
  document.getElementById('dImg').src=p.image;
  document.getElementById('dName').textContent=p.name;
  document.getElementById('dCat').textContent=p.category;
  document.getElementById('dRating').textContent=p.rating+' ('+p.reviews+' reviews)';
  document.getElementById('dPrice').textContent=money(p.price);
  document.getElementById('dOrig').textContent=money(p.original);
  document.getElementById('dDisc').textContent=disc(p.price,p.original)+'% off';
  document.getElementById('dDesc').textContent=p.desc;
  document.getElementById('detailOverlay').classList.add('active');
}
function render(list){
  document.getElementById('productGrid').innerHTML=list.map(function(p,i){
    return '<div class="product-card" onclick="showDetail('+products.indexOf(p)+')">' +
      '<img src="'+p.image+'" alt="'+p.name+'">' +
      '<div class="product-name">'+p.name+'</div>' +
      '<div class="product-category">'+p.category+'</div>' +
      '<div class="product-rating">'+p.rating+' ('+p.reviews+')</div>' +
      '<div class="product-price">'+money(p.price)+'</div>' +
      '<div><span class="product-original">'+money(p.original)+'</span> <span class="product-discount">'+disc(p.price,p.original)+'% off</span></div>' +
      '<button class="btn-add-cart" onclick="event.stopPropagation();alert(\'Added to cart!\')">Add to Cart</button>' +
      '<button class="btn-view" onclick="event.stopPropagation();showDetail('+products.indexOf(p)+')">View Details</button>' +
      '</div>';
  }).join('');
}
function filterCat(el,cat){
  document.querySelectorAll('.cat-btn').forEach(function(b){b.classList.remove('active');});
  el.classList.add('active');
  render(cat==='all'?products:products.filter(function(p){return p.category===cat;}));
}
function searchProducts(){
  var q=document.getElementById('searchInput').value.toLowerCase();
  render(products.filter(function(p){return p.name.toLowerCase().includes(q)||p.category.toLowerCase().includes(q);}));
}
document.getElementById('searchInput').addEventListener('keypress',function(e){if(e.key==='Enter')searchProducts();});
render(products);
</script>
</body>
</html>
