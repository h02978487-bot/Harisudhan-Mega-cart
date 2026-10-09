<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - Home</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Arial,sans-serif;background:#f0f0f0;}
.navbar{background:#131921;padding:10px 20px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:100;}
.logo{color:white;font-size:22px;font-weight:bold;cursor:pointer;}
.logo span{color:#ff9900;}
.search-box{display:flex;flex:1;margin:0 20px;}
.search-box input{width:100%;padding:10px;font-size:14px;border:none;border-radius:4px 0 0 4px;}
.search-box button{padding:10px 15px;background:#ff9900;border:none;border-radius:0 4px 4px 0;cursor:pointer;font-size:18px;}
.nav-right{display:flex;gap:15px;align-items:center;}
.nav-right a{color:white;text-decoration:none;font-size:13px;}
.banner{background:linear-gradient(135deg,#131921,#232f3e);color:white;padding:40px 30px;}
.banner h1{font-size:36px;margin-bottom:10px;color:#ff9900;}
.banner p{font-size:16px;margin-bottom:20px;color:#ccc;}
.banner button{padding:12px 30px;background:#ff9900;border:none;border-radius:5px;font-size:16px;font-weight:bold;cursor:pointer;}
.categories{background:white;padding:12px 20px;display:flex;gap:10px;overflow-x:auto;border-bottom:1px solid #ddd;}
.cat-btn{padding:8px 16px;background:#f0f0f0;border:none;border-radius:20px;cursor:pointer;font-size:13px;white-space:nowrap;}
.cat-btn:hover,.cat-btn.active{background:#ff9900;color:white;}
.section{padding:20px;}
.section h2{font-size:22px;margin-bottom:15px;color:#333;border-left:4px solid #ff9900;padding-left:10px;}
.product-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:15px;}
.product-card{background:white;border-radius:8px;padding:15px;box-shadow:0 2px 8px rgba(0,0,0,0.08);cursor:pointer;transition:all 0.2s;}
.product-card:hover{transform:translateY(-5px);box-shadow:0 8px 20px rgba(0,0,0,0.15);}
.product-card img{width:100%;height:180px;object-fit:cover;border-radius:8px;margin-bottom:10px;}
.product-name{font-size:14px;font-weight:bold;color:#333;margin-bottom:5px;}
.product-category{font-size:12px;color:#888;margin-bottom:5px;}
.product-rating{color:#ff9900;font-size:13px;margin-bottom:8px;}
.product-price{font-size:20px;color:#b12704;font-weight:bold;margin-bottom:5px;}
.product-original{font-size:13px;color:#888;text-decoration:line-through;}
.product-discount{font-size:13px;color:green;font-weight:bold;}
.btn-add-cart{width:100%;padding:10px;background:#ff9900;border:none;border-radius:5px;font-size:14px;font-weight:bold;cursor:pointer;margin-top:10px;}
.btn-view{width:100%;padding:8px;background:white;border:2px solid #ff9900;border-radius:5px;font-size:13px;cursor:pointer;margin-top:5px;color:#ff9900;font-weight:bold;}
footer{background:#131921;color:#ccc;text-align:center;padding:20px;}
footer span{color:#ff9900;font-weight:bold;}
</style>
</head>
<body>
<div class="navbar">
  <div class="logo" onclick="location.href='index.jsp'">&#128722; <span>Harisudhan</span>Mart</div>
  <div class="search-box">
    <input type="text" id="searchInput" placeholder="Search products...">
    <button onclick="searchProducts()">&#128269;</button>
  </div>
  <div class="nav-right">
    <a href="login.jsp">Login</a>
    <a href="register.jsp">Register</a>
    <a href="orders.jsp">Orders</a>
    <a href="cart.jsp">&#128722; Cart</a>
  </div>
</div>
<div class="banner">
  <h1>Welcome to HarisudhanMart!</h1>
  <p>Shop the best products at amazing prices!</p>
  <button onclick="document.querySelector('.section').scrollIntoView()">Shop Now &#8594;</button>
</div>
<div class="categories">
  <button class="cat-btn active" onclick="filterCat(this,'all')">All</button>
  <button class="cat-btn" onclick="filterCat(this,'Electronics')">&#128241; Electronics</button>
  <button class="cat-btn" onclick="filterCat(this,'Fashion')">&#128095; Fashion</button>
  <button class="cat-btn" onclick="filterCat(this,'Home')">&#127968; Home</button>
  <button class="cat-btn" onclick="filterCat(this,'Books')">&#128218; Books</button>
  <button class="cat-btn" onclick="filterCat(this,'Sports')">&#9917; Sports</button>
  <button class="cat-btn" onclick="filterCat(this,'Gaming')">&#127918; Gaming</button>
</div>
<div class="section">
  <h2>&#128293; Featured Products</h2>
  <div class="product-grid" id="productGrid"></div>
</div>
<footer><span>HarisudhanMart</span><br>2026 HarisudhanMart - Your one-stop marketplace</footer>
<script>
const products=[
{id:1,name:"Smartphone Pro Max",category:"Electronics",price:15999,original:22999,rating:"★★★★★",reviews:245,desc:"Latest 5G smartphone with 128GB storage.",image:"https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&q=80"},
{id:2,name:"Laptop Ultra Slim",category:"Electronics",price:45999,original:65999,rating:"★★★★",reviews:189,desc:"Intel i7, 16GB RAM, 512GB SSD.",image:"https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&q=80"},
{id:3,name:"Wireless Headphones",category:"Electronics",price:2999,original:5999,rating:"★★★★★",reviews:567,desc:"Noise cancellation, 30hr battery.",image:"https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&q=80"},
{id:4,name:"Running Shoes",category:"Fashion",price:1499,original:2999,rating:"★★★★★",reviews:321,desc:"Lightweight air cushion sole.",image:"https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80"},
{id:5,name:"Java Book",category:"Books",price:499,original:899,rating:"★★★★★",reviews:98,desc:"Complete Java guide beginner to advanced.",image:"https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400&q=80"},
{id:6,name:"Smart Watch",category:"Electronics",price:8999,original:12999,rating:"★★★★★",reviews:432,desc:"Health monitoring GPS smart watch.",image:"https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&q=80"},
{id:7,name:"Gaming Controller",category:"Gaming",price:3499,original:4999,rating:"★★★★★",reviews:276,desc:"Wireless controller for PC and mobile.",image:"https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=400&q=80"},
{id:8,name:"DSLR Camera",category:"Electronics",price:32999,original:45999,rating:"★★★★★",reviews:154,desc:"24MP DSLR with 4K video recording.",image:"https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=400&q=80"},
{id:9,name:"Cotton T-Shirt",category:"Fashion",price:399,original:799,rating:"★★★★★",reviews:543,desc:"Premium cotton t-shirt.",image:"https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&q=80"},
{id:10,name:"Coffee Maker",category:"Home",price:2499,original:3999,rating:"★★★★★",reviews:234,desc:"12 cup coffee maker with timer.",image:"https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400&q=80"},
{id:11,name:"Football",category:"Sports",price:799,original:1299,rating:"★★★★★",reviews:187,desc:"Professional size 5 football.",image:"https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=400&q=80"},
{id:12,name:"Bluetooth Speaker",category:"Electronics",price:1999,original:3499,rating:"★★★★★",reviews:389,desc:"Waterproof portable speaker 12hr battery.",image:"https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400&q=80"}
];
function money(n){return 'Rs.'+n.toLocaleString();}
function disc(p,o){return Math.round((o-p)/o*100);}
function render(list){
  document.getElementById('productGrid').innerHTML=list.map(function(p){
    return '<div class="product-card">'+
      '<img src="'+p.image+'" alt="'+p.name+'" onerror="this.src=\'https://placehold.co/400x180?text='+encodeURIComponent(p.name)+'\'">'+
      '<div class="product-name">'+p.name+'</div>'+
      '<div class="product-category">'+p.category+'</div>'+
      '<div class="product-rating">'+p.rating+' ('+p.reviews+')</div>'+
      '<div class="product-price">'+money(p.price)+'</div>'+
      '<div><span class="product-original">'+money(p.original)+'</span> <span class="product-discount">'+disc(p.price,p.original)+'% off</span></div>'+
      '<button class="btn-add-cart" onclick="alert(\'Added to cart!\')">Add to Cart</button>'+
      '<button class="btn-view">View Details</button>'+
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
