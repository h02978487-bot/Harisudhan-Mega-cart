<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - Wishlist</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Arial,sans-serif;background:#0d0d1a;}
.navbar{background:rgba(26,5,51,0.95);backdrop-filter:blur(10px);padding:12px 20px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:100;border-bottom:1px solid rgba(124,58,237,0.3);}
.logo{color:white;font-size:22px;font-weight:bold;}
.logo span{color:#a78bfa;}
.nav-right a{color:white;text-decoration:none;margin-left:20px;font-size:13px;}
.container{max-width:1100px;margin:25px auto;padding:0 20px;}
.page-title{font-size:24px;color:white;margin-bottom:20px;border-left:4px solid #7c3aed;padding-left:10px;}
.product-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:20px;}
.product-card{background:rgba(255,255,255,0.05);border:1px solid rgba(124,58,237,0.2);border-radius:12px;padding:15px;cursor:pointer;transition:all 0.3s;position:relative;}
.product-card:hover{transform:translateY(-5px);border-color:#7c3aed;box-shadow:0 10px 30px rgba(124,58,237,0.3);}
.product-card img{width:100%;height:180px;object-fit:cover;border-radius:8px;margin-bottom:10px;}
.product-name{font-size:14px;font-weight:bold;color:white;margin-bottom:5px;}
.product-category{font-size:12px;color:#a78bfa;margin-bottom:5px;}
.product-price{font-size:18px;color:#f87171;font-weight:bold;margin-bottom:10px;}
.btn-cart{width:100%;padding:10px;background:#7c3aed;border:none;border-radius:8px;font-size:13px;font-weight:bold;cursor:pointer;color:white;margin-bottom:5px;}
.btn-remove{width:100%;padding:8px;background:transparent;border:1px solid #dc2626;border-radius:8px;font-size:13px;cursor:pointer;color:#f87171;}
.heart{position:absolute;top:10px;right:10px;font-size:22px;color:#dc2626;}
.empty{text-align:center;padding:80px;color:#888;}
.empty div{font-size:60px;margin-bottom:15px;}
.empty p{font-size:16px;margin-bottom:20px;}
.empty button{padding:12px 25px;background:#7c3aed;color:white;border:none;border-radius:8px;cursor:pointer;font-size:14px;}
</style>
</head>
<body>
<div class="navbar">
  <div class="logo">&#128722; <span>Harisudhan</span>Mart</div>
  <div class="nav-right">
    <a href="home.jsp">&#127968; Home</a>
    <a href="cart.jsp">&#128722; Cart</a>
    <a href="orders.jsp">Orders</a>
    <a href="login.jsp">Logout</a>
  </div>
</div>
<div class="container">
  <div class="page-title">&#10084; My Wishlist (<span id="wishCount">0</span> items)</div>
  <div class="product-grid" id="wishGrid"></div>
</div>
<script>
var wishlist=JSON.parse(localStorage.getItem('hmWish')||'[]');
function money(n){return 'Rs.'+parseInt(n).toLocaleString();}
function removeWish(id){
  wishlist=wishlist.filter(function(p){return p.id!==id;});
  localStorage.setItem('hmWish',JSON.stringify(wishlist));
  renderWish();
}
function addToCart(p){
  var cart=JSON.parse(localStorage.getItem('hmCart')||'[]');
  var existing=cart.find(function(i){return i.id===p.id;});
  if(existing){existing.qty++;}
  else{cart.push({id:p.id,name:p.name,price:p.price,original:p.original,category:p.category,image:p.image,qty:1});}
  localStorage.setItem('hmCart',JSON.stringify(cart));
  alert('Added to cart!');
}
function renderWish(){
  var grid=document.getElementById('wishGrid');
  document.getElementById('wishCount').textContent=wishlist.length;
  if(wishlist.length===0){
    grid.innerHTML='<div class="empty" style="grid-column:1/-1"><div>&#10084;</div><p style="color:#888;">Your wishlist is empty!</p><button onclick="window.location.href=\'home.jsp\'">Shop Now</button></div>';
    return;
  }
  grid.innerHTML=wishlist.map(function(p){
    return '<div class="product-card">'+
      '<span class="heart">&#10084;</span>'+
      '<img src="'+p.image+'" alt="'+p.name+'">'+
      '<div class="product-name">'+p.name+'</div>'+
      '<div class="product-category">'+p.category+'</div>'+
      '<div class="product-price">'+money(p.price)+'</div>'+
      '<button class="btn-cart" onclick=\'addToCart('+JSON.stringify(p)+')\'>&#128722; Add to Cart</button>'+
      '<button class="btn-remove" onclick="removeWish('+p.id+')">&#10005; Remove</button>'+
      '</div>';
  }).join('');
}
renderWish();
</script>
</body>
</html>
