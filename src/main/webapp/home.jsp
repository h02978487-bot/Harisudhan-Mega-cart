<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - Home</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Arial,sans-serif;background:#0d0d1a;}
canvas{position:fixed;top:0;left:0;z-index:0;pointer-events:none;}
.navbar{background:rgba(26,5,51,0.95);backdrop-filter:blur(10px);padding:12px 20px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:100;border-bottom:1px solid rgba(124,58,237,0.3);}
.logo{color:white;font-size:22px;font-weight:bold;}
.logo span{color:#a78bfa;}
.search-box{display:flex;flex:1;margin:0 20px;}
.search-box input{width:100%;padding:10px;font-size:14px;border:none;border-radius:4px 0 0 4px;background:rgba(255,255,255,0.1);color:white;}
.search-box input::placeholder{color:#aaa;}
.search-box button{padding:10px 15px;background:#7c3aed;border:none;cursor:pointer;color:white;border-radius:0 4px 4px 0;}
.nav-right{display:flex;gap:15px;align-items:center;}
.nav-right a{color:white;text-decoration:none;font-size:13px;}
.nav-right a:hover{color:#a78bfa;}
.diwali{position:relative;z-index:1;background:linear-gradient(135deg,#ff6b00,#ffd700);padding:10px;text-align:center;}
.diwali strong{color:#1a0533;font-size:15px;}
.diwali .code{background:#1a0533;color:#ffd700;padding:3px 12px;border-radius:20px;font-size:13px;margin-left:10px;font-weight:bold;}
.hero{position:relative;z-index:1;min-height:300px;display:flex;align-items:center;padding:50px 30px;background:linear-gradient(135deg,rgba(26,5,51,0.95),rgba(45,27,105,0.85));}
.hero h1{font-size:44px;color:white;margin-bottom:12px;}
.hero h1 span{color:#a78bfa;}
.hero p{font-size:16px;color:#ccc;margin-bottom:20px;}
.hero button{padding:12px 30px;background:#7c3aed;color:white;border:none;border-radius:30px;font-size:15px;font-weight:bold;cursor:pointer;box-shadow:0 0 20px rgba(124,58,237,0.5);}
.ads{position:relative;z-index:1;padding:15px 20px;}
.ad-box{border-radius:15px;overflow:hidden;position:relative;height:110px;}
.ad-slide{display:none;align-items:center;justify-content:space-between;padding:20px 30px;height:110px;}
.ad-slide.active{display:flex;}
.ad-title{color:white;font-size:22px;font-weight:bold;margin-bottom:5px;}
.ad-sub{color:#ccc;font-size:13px;}
.ad-label{color:#ffd700;font-size:11px;font-weight:bold;margin-bottom:5px;}
.ad-icon{font-size:55px;}
.categories{position:relative;z-index:1;background:rgba(26,5,51,0.8);padding:12px 20px;display:flex;gap:10px;overflow-x:auto;border-bottom:1px solid rgba(124,58,237,0.2);}
.cat-btn{padding:8px 16px;background:rgba(255,255,255,0.05);border:1px solid rgba(124,58,237,0.3);border-radius:20px;cursor:pointer;font-size:13px;white-space:nowrap;color:white;transition:all 0.3s;}
.cat-btn:hover,.cat-btn.active{background:#7c3aed;border-color:#7c3aed;}
.section{position:relative;z-index:1;padding:25px 20px;}
.section h2{font-size:22px;margin-bottom:15px;color:white;border-left:4px solid #7c3aed;padding-left:10px;}
.product-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:15px;}
.product-card{background:rgba(255,255,255,0.05);border:1px solid rgba(124,58,237,0.2);border-radius:12px;padding:15px;cursor:pointer;transition:all 0.3s;opacity:0;transform:translateY(30px);}
.product-card.show{opacity:1;transform:translateY(0);}
.product-card:hover{transform:translateY(-8px);border-color:#7c3aed;box-shadow:0 10px 30px rgba(124,58,237,0.3);}
.product-card img{width:100%;height:170px;object-fit:cover;border-radius:8px;margin-bottom:10px;}
.product-name{font-size:14px;font-weight:bold;color:white;margin-bottom:4px;}
.product-category{font-size:12px;color:#a78bfa;margin-bottom:4px;}
.product-rating{color:#fbbf24;font-size:12px;margin-bottom:6px;}
.product-price{font-size:18px;color:#f87171;font-weight:bold;margin-bottom:4px;}
.product-original{font-size:12px;color:#666;text-decoration:line-through;}
.product-discount{font-size:12px;color:#34d399;font-weight:bold;}
.btn-add-cart{width:100%;padding:9px;background:#7c3aed;border:none;border-radius:8px;font-size:13px;font-weight:bold;cursor:pointer;margin-top:8px;color:white;}
.btn-wish{width:100%;padding:7px;background:transparent;border:1px solid #dc2626;border-radius:8px;font-size:12px;cursor:pointer;margin-top:4px;color:#f87171;}
.btn-view{width:100%;padding:7px;background:transparent;border:1px solid #7c3aed;border-radius:8px;font-size:12px;cursor:pointer;margin-top:4px;color:#a78bfa;}
footer{position:relative;z-index:1;background:rgba(26,5,51,0.9);color:#aaa;text-align:center;padding:20px;border-top:1px solid rgba(124,58,237,0.2);}
footer span{color:#a78bfa;font-weight:bold;}
.overlay{display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.85);z-index:1000;justify-content:center;align-items:center;}
.overlay.active{display:flex;}
.detail-box{background:#1a0533;border:1px solid rgba(124,58,237,0.4);border-radius:20px;padding:25px;max-width:480px;width:90%;position:relative;}
.detail-box img{width:100%;height:200px;object-fit:cover;border-radius:12px;margin-bottom:15px;}
.close-btn{position:absolute;top:12px;right:12px;background:rgba(124,58,237,0.3);border:none;font-size:18px;cursor:pointer;color:white;width:32px;height:32px;border-radius:50%;}
.detail-actions{display:flex;gap:10px;margin-top:12px;}
.detail-actions button{flex:1;padding:11px;border-radius:8px;font-weight:bold;cursor:pointer;font-size:13px;}
.btn-cart2{background:transparent;border:2px solid #7c3aed;color:#a78bfa;}
.btn-buy{background:#7c3aed;border:none;color:white;}
#toast{position:fixed;bottom:90px;right:20px;padding:14px 22px;border-radius:12px;color:white;font-size:14px;font-weight:bold;z-index:9999;display:none;}
#toast.show{display:block;animation:toastIn 0.3s ease;}
@keyframes toastIn{from{opacity:0;transform:translateX(100px);}to{opacity:1;transform:translateX(0);}}
#chatBtn{position:fixed;bottom:25px;right:25px;width:58px;height:58px;background:#7c3aed;border-radius:50%;border:none;cursor:pointer;font-size:26px;box-shadow:0 0 20px rgba(124,58,237,0.6);z-index:999;animation:pulse 2s infinite;}
@keyframes pulse{0%{box-shadow:0 0 0 0 rgba(124,58,237,0.6);}70%{box-shadow:0 0 0 15px rgba(124,58,237,0);}100%{box-shadow:0 0 0 0 rgba(124,58,237,0);}}
</style>
</head>
<body>
<canvas id="canvas"></canvas>
<div class="navbar">
  <div class="logo">&#128722; <span>Harisudhan</span>Mart</div>
  <div class="search-box">
    <input type="text" id="searchInput" placeholder="Search products...">
    <button onclick="searchProducts()">&#128269;</button>
  </div>
  <div class="nav-right">
    <a href="about.jsp">About</a>
    <a href="wishlist.jsp">&#10084; Wishlist</a>
    <a href="cart.jsp">&#128722; Cart</a>
    <a href="orders.jsp">Orders</a>
    <a href="profile.jsp">&#128100; Profile</a>
    <a href="login.jsp">Logout</a>
  </div>
</div>
<div class="diwali">
  &#127866; <strong>DIWALI MEGA SALE! Up to 50% OFF on all products!</strong>
  <span class="code">USE CODE: DIWALI50</span> &#127866;
</div>
<div class="hero">
  <div>
    <h1>Shop Smart with<br><span>HarisudhanMart</span></h1>
    <p>Discover amazing products at unbeatable prices!</p>
    <button onclick="document.querySelector('.section').scrollIntoView({behavior:'smooth'})">Explore Now &#8594;</button>
  </div>
</div>
<div class="ads">
  <div class="ad-box">
    <div class="ad-slide active" style="background:linear-gradient(135deg,#1a0533,#7c3aed);">
      <div>
        <div class="ad-label">&#128252; ADVERTISEMENT</div>
        <div class="ad-title">Harisudhan Textiles</div>
        <div class="ad-sub">Premium fabrics at best prices!</div>
      </div>
      <div class="ad-icon">&#128255;</div>
    </div>
    <div class="ad-slide" style="background:linear-gradient(135deg,#0d1117,#1e3a5f);">
      <div>
        <div class="ad-label">&#9889; ADVERTISEMENT</div>
        <div class="ad-title">Harisudhan Electronics</div>
        <div class="ad-sub">Latest gadgets at lowest prices!</div>
      </div>
      <div class="ad-icon">&#128241;</div>
    </div>
    <div class="ad-slide" style="background:linear-gradient(135deg,#1a3a1a,#2d6a2d);">
      <div>
        <div class="ad-label">&#128218; ADVERTISEMENT</div>
        <div class="ad-title">Harisudhan Books</div>
        <div class="ad-sub">Knowledge at your fingertips!</div>
      </div>
      <div class="ad-icon">&#128214;</div>
    </div>
    <div class="ad-slide" style="background:linear-gradient(135deg,#3a1a00,#6a3d00);">
      <div>
        <div class="ad-label">&#127869; ADVERTISEMENT</div>
        <div class="ad-title">Harisudhan Foods</div>
        <div class="ad-sub">Fresh & healthy food delivered!</div>
      </div>
      <div class="ad-icon">&#127871;</div>
    </div>
  </div>
</div>
<div class="categories">
  <button class="cat-btn active" onclick="filterCat(this,'all')">&#11088; All</button>
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
<div class="overlay" id="detailOverlay">
  <div class="detail-box">
    <button class="close-btn" onclick="document.getElementById('detailOverlay').classList.remove('active')">&#10005;</button>
    <img id="dImg" src="" alt="">
    <h2 id="dName" style="color:white;margin-bottom:5px;"></h2>
    <p id="dCat" style="color:#a78bfa;font-size:13px;margin-bottom:6px;"></p>
    <p id="dRating" style="color:#fbbf24;margin-bottom:6px;"></p>
    <div style="display:flex;gap:10px;align-items:center;margin-bottom:8px;">
      <span id="dPrice" style="font-size:22px;color:#f87171;font-weight:bold;"></span>
      <span id="dOrig" style="color:#666;text-decoration:line-through;font-size:13px;"></span>
      <span id="dDisc" style="color:#34d399;font-weight:bold;font-size:13px;"></span>
    </div>
    <p id="dDesc" style="color:#ccc;font-size:13px;margin-bottom:12px;"></p>
    <div class="detail-actions">
      <button class="btn-cart2" onclick="addToCartLS(currentIdx);document.getElementById('detailOverlay').classList.remove('active')">&#128722; Add to Cart</button>
      <button class="btn-buy" onclick="window.location.href='payment.jsp'">Buy Now &#8594;</button>
    </div>
  </div>
</div>
<div id="toast"></div>
<button id="chatBtn" onclick="window.location.href='chatbot.jsp'">&#129302;</button>
<script>
var canvas=document.getElementById('canvas');
var ctx=canvas.getContext('2d');
canvas.width=window.innerWidth;canvas.height=window.innerHeight;
var pts=[];
for(var i=0;i<80;i++){pts.push({x:Math.random()*canvas.width,y:Math.random()*canvas.height,r:Math.random()*2+0.5,vx:(Math.random()-0.5)*0.5,vy:(Math.random()-0.5)*0.5,c:Math.random()>0.5?'#7c3aed':'#a78bfa',o:Math.random()*0.3+0.1});}
function drawCanvas(){
  ctx.clearRect(0,0,canvas.width,canvas.height);
  pts.forEach(function(p,i){
    ctx.beginPath();ctx.arc(p.x,p.y,p.r,0,Math.PI*2);ctx.fillStyle=p.c;ctx.globalAlpha=p.o;ctx.fill();
    p.x+=p.vx;p.y+=p.vy;
    if(p.x<0||p.x>canvas.width)p.vx*=-1;
    if(p.y<0||p.y>canvas.height)p.vy*=-1;
    pts.forEach(function(q,j){if(i!==j){var dx=p.x-q.x,dy=p.y-q.y,d=Math.sqrt(dx*dx+dy*dy);if(d<120){ctx.beginPath();ctx.moveTo(p.x,p.y);ctx.lineTo(q.x,q.y);ctx.strokeStyle='#7c3aed';ctx.globalAlpha=(1-d/120)*0.12;ctx.lineWidth=0.5;ctx.stroke();}}});
  });
  ctx.globalAlpha=1;requestAnimationFrame(drawCanvas);
}
drawCanvas();
window.addEventListener('resize',function(){canvas.width=window.innerWidth;canvas.height=window.innerHeight;});
var adIdx=0;
var adSlides=document.querySelectorAll('.ad-slide');
setInterval(function(){
  adSlides[adIdx].classList.remove('active');
  adIdx=(adIdx+1)%adSlides.length;
  adSlides[adIdx].classList.add('active');
},3000);
function showToast(msg,type){
  var t=document.getElementById('toast');
  t.innerHTML=msg;
  t.style.background=type==='wish'?'linear-gradient(135deg,#dc2626,#db2777)':type==='error'?'linear-gradient(135deg,#dc2626,#b91c1c)':'linear-gradient(135deg,#7c3aed,#6d28d9)';
  t.classList.add('show');
  setTimeout(function(){t.classList.remove('show');},3000);
}
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
var currentIdx=0;
function money(n){return 'Rs.'+n.toLocaleString();}
function disc(p,o){return Math.round((o-p)/o*100);}
function addToCartLS(idx){
  var p=products[idx];
  var cart=JSON.parse(localStorage.getItem('hmCart')||'[]');
  var ex=cart.find(function(i){return i.id===p.id;});
  if(ex){ex.qty++;}else{cart.push({id:p.id,name:p.name,price:p.price,original:p.original,category:p.category,image:p.image,qty:1});}
  localStorage.setItem('hmCart',JSON.stringify(cart));
  showToast('&#128722; Added to cart!','success');
}
function addToWish(idx){
  var p=products[idx];
  var wish=JSON.parse(localStorage.getItem('hmWish')||'[]');
  if(!wish.find(function(i){return i.id===p.id;})){wish.push(p);localStorage.setItem('hmWish',JSON.stringify(wish));showToast('&#10084; Added to wishlist!','wish');}
  else{showToast('Already in wishlist!','error');}
}
function showDetail(idx){
  currentIdx=idx;var p=products[idx];
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
  document.getElementById('productGrid').innerHTML=list.map(function(p){
    var idx=products.indexOf(p);
    return '<div class="product-card" onclick="showDetail('+idx+')">'+
      '<img src="'+p.image+'" alt="'+p.name+'">'+
      '<div class="product-name">'+p.name+'</div>'+
      '<div class="product-category">'+p.category+'</div>'+
      '<div class="product-rating">'+p.rating+' ('+p.reviews+')</div>'+
      '<div class="product-price">'+money(p.price)+'</div>'+
      '<div><span class="product-original">'+money(p.original)+'</span> <span class="product-discount"> '+disc(p.price,p.original)+'% off</span></div>'+
      '<button class="btn-add-cart" onclick="event.stopPropagation();addToCartLS('+idx+')">&#128722; Add to Cart</button>'+
      '<button class="btn-wish" onclick="event.stopPropagation();addToWish('+idx+')">&#10084; Wishlist</button>'+
      '<button class="btn-view" onclick="event.stopPropagation();showDetail('+idx+')">View Details</button>'+
      '</div>';
  }).join('');
  document.querySelectorAll('.product-card').forEach(function(card,i){setTimeout(function(){card.classList.add('show');},i*100);});
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
