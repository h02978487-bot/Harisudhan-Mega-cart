<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - Home</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: Arial, sans-serif; background: #f0f0f0; }
.navbar { background: #131921; padding: 10px 20px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 100; }
.logo { color: white; font-size: 22px; font-weight: bold; cursor: pointer; }
.logo span { color: #ff9900; }
.search-box { display: flex; flex: 1; margin: 0 20px; }
.search-box input { width: 100%; padding: 10px; font-size: 14px; border: none; border-radius: 4px 0 0 4px; }
.search-box button { padding: 10px 15px; background: #ff9900; border: none; border-radius: 0 4px 4px 0; cursor: pointer; font-size: 18px; }
.nav-right { display: flex; gap: 15px; align-items: center; }
.nav-right a { color: white; text-decoration: none; font-size: 13px; }
.cart-icon { position: relative; cursor: pointer; color: white; font-size: 24px; }
.cart-count { position: absolute; top: -8px; right: -8px; background: #ff9900; color: white; border-radius: 50%; width: 20px; height: 20px; font-size: 12px; display: flex; align-items: center; justify-content: center; font-weight: bold; }
.banner { background: linear-gradient(135deg, #131921, #232f3e); color: white; padding: 40px 30px; display: flex; align-items: center; justify-content: space-between; }
.banner-text h1 { font-size: 36px; margin-bottom: 10px; color: #ff9900; }
.banner-text p { font-size: 16px; margin-bottom: 20px; color: #ccc; }
.banner-text button { padding: 12px 30px; background: #ff9900; border: none; border-radius: 5px; font-size: 16px; font-weight: bold; cursor: pointer; }
.banner-emoji { font-size: 100px; }
.categories { background: white; padding: 12px 20px; display: flex; gap: 10px; overflow-x: auto; border-bottom: 1px solid #ddd; }
.cat-btn { padding: 8px 16px; background: #f0f0f0; border: none; border-radius: 20px; cursor: pointer; font-size: 13px; white-space: nowrap; }
.cat-btn:hover, .cat-btn.active { background: #ff9900; color: white; }
.section { padding: 20px; }
.section h2 { font-size: 22px; margin-bottom: 15px; color: #333; border-left: 4px solid #ff9900; padding-left: 10px; }
.products-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 15px; }
.product-card { background: white; border-radius: 8px; padding: 15px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); cursor: pointer; transition: all 0.2s; }
.product-card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0,0,0,0.15); }
.product-emoji { font-size: 70px; text-align: center; padding: 10px 0; }
.product-name { font-size: 14px; font-weight: bold; color: #333; margin-bottom: 5px; }
.product-category { font-size: 12px; color: #888; margin-bottom: 5px; }
.product-rating { color: #ff9900; font-size: 13px; margin-bottom: 8px; }
.product-price { font-size: 20px; color: #b12704; font-weight: bold; margin-bottom: 5px; }
.product-original { font-size: 13px; color: #888; text-decoration: line-through; }
.product-discount { font-size: 13px; color: green; font-weight: bold; }
.btn-add-cart { width: 100%; padding: 10px; background: #ff9900; border: none; border-radius: 5px; font-size: 14px; font-weight: bold; cursor: pointer; margin-top: 10px; }
.btn-add-cart:hover { background: #e68900; }
.btn-view { width: 100%; padding: 8px; background: white; border: 2px solid #ff9900; border-radius: 5px; font-size: 13px; cursor: pointer; margin-top: 5px; color: #ff9900; font-weight: bold; }
.modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); z-index: 1000; justify-content: center; align-items: center; }
.modal-overlay.active { display: flex; }
.modal { background: white; border-radius: 10px; padding: 30px; max-width: 600px; width: 90%; position: relative; }
.modal-close { position: absolute; top: 15px; right: 15px; font-size: 24px; cursor: pointer; background: none; border: none; }
.modal-content { display: flex; gap: 20px; }
.modal-emoji { font-size: 100px; text-align: center; }
.modal-details h2 { font-size: 22px; margin-bottom: 10px; }
.modal-price { font-size: 28px; color: #b12704; font-weight: bold; margin-bottom: 10px; }
.modal-rating { color: #ff9900; font-size: 16px; margin-bottom: 10px; }
.modal-desc { font-size: 14px; color: #666; margin-bottom: 15px; line-height: 1.6; }
.modal-qty { display: flex; align-items: center; gap: 10px; margin-bottom: 15px; }
.qty-btn { width: 35px; height: 35px; background: #ff9900; border: none; border-radius: 5px; font-size: 20px; cursor: pointer; }
.qty-num { font-size: 18px; font-weight: bold; width: 30px; text-align: center; }
.btn-modal-cart { width: 100%; padding: 12px; background: #ff9900; border: none; border-radius: 5px; font-size: 16px; font-weight: bold; cursor: pointer; }
.cart-sidebar { position: fixed; right: -400px; top: 0; width: 380px; height: 100%; background: white; box-shadow: -5px 0 20px rgba(0,0,0,0.2); z-index: 2000; transition: right 0.3s; overflow-y: auto; }
.cart-sidebar.open { right: 0; }
.cart-header { background: #131921; color: white; padding: 20px; display: flex; justify-content: space-between; align-items: center; }
.cart-header h3 { font-size: 18px; }
.cart-close { background: none; border: none; color: white; font-size: 24px; cursor: pointer; }
.cart-items { padding: 15px; }
.cart-item { display: flex; gap: 10px; align-items: center; padding: 10px 0; border-bottom: 1px solid #eee; }
.cart-item-emoji { font-size: 40px; }
.cart-item-info { flex: 1; }
.cart-item-name { font-size: 14px; font-weight: bold; }
.cart-item-price { color: #b12704; font-weight: bold; }
.cart-item-qty { display: flex; align-items: center; gap: 8px; margin-top: 5px; }
.cart-qty-btn { width: 25px; height: 25px; background: #ff9900; border: none; border-radius: 3px; cursor: pointer; font-size: 14px; }
.cart-remove { background: none; border: none; color: #c0392b; cursor: pointer; font-size: 18px; }
.cart-empty { text-align: center; padding: 40px; color: #888; font-size: 16px; }
.cart-footer { padding: 15px; border-top: 2px solid #ddd; background: white; }
.cart-total { font-size: 20px; font-weight: bold; margin-bottom: 15px; display: flex; justify-content: space-between; }
.btn-checkout { width: 100%; padding: 15px; background: #ff9900; border: none; border-radius: 5px; font-size: 16px; font-weight: bold; cursor: pointer; }
.toast { position: fixed; bottom: 30px; left: 50%; transform: translateX(-50%); background: #131921; color: white; padding: 12px 25px; border-radius: 25px; font-size: 14px; z-index: 9999; display: none; }
.toast.show { display: block; }
.footer { background: #131921; color: #ccc; text-align: center; padding: 25px; margin-top: 30px; }
.footer h3 { color: #ff9900; margin-bottom: 10px; }
</style>
</head>
<body>
<div class="navbar">
    <div class="logo" onclick="window.location.href='index.jsp'">🛒 Harisudhan<span>Mart</span></div>
    <div class="search-box">
        <input type="text" id="searchInput" placeholder="Search products..." onkeyup="searchProducts()" />
        <button>🔍</button>
    </div>
    <div class="nav-right">
        <a href="login.jsp">👤 Login</a>
        <a href="register.jsp">📝 Register</a>
        <a href="orders.jsp">📋 Orders</a>
        <div class="cart-icon" onclick="toggleCart()">🛒 <span class="cart-count" id="cartCount">0</span></div>
    </div>
</div>
<div class="banner">
    <div class="banner-text">
        <h1>Welcome to HarisudhanMart!</h1>
        <p>Shop the best products at amazing prices!</p>
        <button onclick="document.getElementById('products').scrollIntoView()">Shop Now →</button>
    </div>
    <div class="banner-emoji">🛍️</div>
</div>
<div class="categories">
    <button class="cat-btn active" onclick="filterProducts('all',this)">All</button>
    <button class="cat-btn" onclick="filterProducts('Electronics',this)">📱 Electronics</button>
    <button class="cat-btn" onclick="filterProducts('Fashion',this)">👕 Fashion</button>
    <button class="cat-btn" onclick="filterProducts('Home',this)">🏠 Home</button>
    <button class="cat-btn" onclick="filterProducts('Books',this)">📚 Books</button>
    <button class="cat-btn" onclick="filterProducts('Sports',this)">⚽ Sports</button>
    <button class="cat-btn" onclick="filterProducts('Gaming',this)">🎮 Gaming</button>
</div>
<div class="section" id="products">
    <h2>🔥 Featured Products</h2>
    <div class="products-grid" id="productsGrid"></div>
</div>
<div class="modal-overlay" id="productModal">
    <div class="modal">
        <button class="modal-close" onclick="closeModal()">✕</button>
        <div class="modal-content">
            <div><div class="modal-emoji" id="modalEmoji"></div></div>
            <div class="modal-details">
                <h2 id="modalName"></h2>
                <div class="modal-rating" id="modalRating"></div>
                <div class="modal-price" id="modalPrice"></div>
                <div class="modal-desc" id="modalDesc"></div>
                <div class="modal-qty">
                    <button class="qty-btn" onclick="changeQty(-1)">-</button>
                    <span class="qty-num" id="modalQty">1</span>
                    <button class="qty-btn" onclick="changeQty(1)">+</button>
                </div>
                <button class="btn-modal-cart" onclick="addToCartFromModal()">Add to Cart</button>
            </div>
        </div>
    </div>
</div>
<div class="cart-sidebar" id="cartSidebar">
    <div class="cart-header">
        <h3>Your Cart</h3>
        <button class="cart-close" onclick="toggleCart()">X</button>
    </div>
    <div class="cart-items" id="cartItems"><div class="cart-empty">Cart is empty! Add products!</div></div>
    <div class="cart-footer" id="cartFooter" style="display:none">
        <div class="cart-total"><span>Total:</span><span id="cartTotal">0</span></div>
        <button class="btn-checkout" onclick="window.location.href='orders.jsp'">Checkout</button>
    </div>
</div>
<div class="toast" id="toast"></div>
<div class="footer"><h3>HarisudhanMart</h3><p>2026 HarisudhanMart - Your one-stop marketplace</p></div>
<script>
var products=[
{id:1,name:"Smartphone Pro Max",emoji:"📱",category:"Electronics",price:15999,original:22999,rating:"★★★★★",reviews:245,desc:"Latest 5G smartphone with 128GB storage and 50MP camera."},
{id:2,name:"Laptop Ultra Slim",emoji:"💻",category:"Electronics",price:45999,original:65999,rating:"★★★★☆",reviews:189,desc:"Intel i7, 16GB RAM, 512GB SSD laptop."},
{id:3,name:"Wireless Headphones",emoji:"🎧",category:"Electronics",price:2999,original:5999,rating:"★★★★★",reviews:567,desc:"Noise cancellation headphones with 30hr battery."},
{id:4,name:"Running Shoes",emoji:"👟",category:"Fashion",price:1499,original:2999,rating:"★★★★☆",reviews:321,desc:"Lightweight shoes with air cushion sole."},
{id:5,name:"Java Book",emoji:"📚",category:"Books",price:499,original:899,rating:"★★★★★",reviews:98,desc:"Complete Java guide from beginner to advanced."},
{id:6,name:"Smart Watch",emoji:"⌚",category:"Electronics",price:8999,original:12999,rating:"★★★★☆",reviews:432,desc:"Health monitoring GPS smart watch."},
{id:7,name:"Gaming Controller",emoji:"🎮",category:"Gaming",price:3499,original:4999,rating:"★★★★★",reviews:276,desc:"Wireless controller for PC and mobile."},
{id:8,name:"DSLR Camera",emoji:"📷",category:"Electronics",price:32999,original:45999,rating:"★★★★☆",reviews:154,desc:"24MP DSLR with 4K video recording."},
{id:9,name:"Cotton T-Shirt",emoji:"👕",category:"Fashion",price:399,original:799,rating:"★★★★☆",reviews:543,desc:"Premium cotton t-shirt in multiple colors."},
{id:10,name:"Coffee Maker",emoji:"☕",category:"Home",price:2499,original:3999,rating:"★★★★★",reviews:234,desc:"Automatic 12 cup coffee maker with timer."},
{id:11,name:"Football",emoji:"⚽",category:"Sports",price:799,original:1299,rating:"★★★★☆",reviews:187,desc:"Professional size 5 football."},
{id:12,name:"Bluetooth Speaker",emoji:"🔊",category:"Electronics",price:1999,original:3499,rating:"★★★★★",reviews:398,desc:"Waterproof portable speaker 12hr battery."}
];
var cart=[];
var currentProduct=null;
var currentQty=1;
function disc(p){return Math.round((p.original-p.price)/p.original*100);}
function renderProducts(list){
var g=document.getElementById('productsGrid');
g.innerHTML=list.map(function(p){return '<div class="product-card"><div class="product-emoji">'+p.emoji+'</div><div class="product-name">'+p.name+'</div><div class="product-category">'+p.category+'</div><div class="product-rating">'+p.rating+' ('+p.reviews+')</div><div class="product-price">Rs.'+p.price.toLocaleString()+'</div><div style="display:flex;gap:10px"><span class="product-original">Rs.'+p.original.toLocaleString()+'</span><span class="product-discount">'+disc(p)+'% off</span></div><button class="btn-add-cart" onclick="addToCart('+p.id+')">Add to Cart</button><button class="btn-view" onclick="viewProduct('+p.id+')">View Details</button></div>';}).join('');
}
function filterProducts(cat,btn){
document.querySelectorAll('.cat-btn').forEach(function(b){b.classList.remove('active');});
btn.classList.add('active');
renderProducts(cat==='all'?products:products.filter(function(p){return p.category===cat;}));
}
function searchProducts(){
var q=document.getElementById('searchInput').value.toLowerCase();
renderProducts(products.filter(function(p){return p.name.toLowerCase().indexOf(q)>=0||p.category.toLowerCase().indexOf(q)>=0;}));
}
function viewProduct(id){
currentProduct=products.filter(function(p){return p.id===id;})[0];
currentQty=1;
document.getElementById('modalEmoji').textContent=currentProduct.emoji;
document.getElementById('modalName').textContent=currentProduct.name;
document.getElementById('modalRating').textContent=currentProduct.rating+' ('+currentProduct.reviews+' reviews)';
document.getElementById('modalPrice').textContent='Rs.'+currentProduct.price.toLocaleString();
document.getElementById('modalDesc').textContent=currentProduct.desc;
document.getElementById('modalQty').textContent=1;
document.getElementById('productModal').classList.add('active');
}
function closeModal(){document.getElementById('productModal').classList.remove('active');}
function changeQty(n){currentQty=Math.max(1,currentQty+n);document.getElementById('modalQty').textContent=currentQty;}
function addToCartFromModal(){for(var i=0;i<currentQty;i++)addToCart(currentProduct.id);closeModal();}
function addToCart(id){
var p=products.filter(function(x){return x.id===id;})[0];
var e=cart.filter(function(x){return x.id===id;})[0];
if(e)e.qty++;else cart.push({id:p.id,name:p.name,emoji:p.emoji,price:p.price,qty:1});
updateCart();
showToast('Added to cart: '+p.name);
}
function removeFromCart(id){cart=cart.filter(function(x){return x.id!==id;});updateCart();}
function changeCartQty(id,n){
var item=cart.filter(function(x){return x.id===id;})[0];
if(item){item.qty+=n;if(item.qty<=0)removeFromCart(id);}
updateCart();
}
function updateCart(){
var total=cart.reduce(function(s,x){return s+x.price*x.qty;},0);
var count=cart.reduce(function(s,x){return s+x.qty;},0);
document.getElementById('cartCount').textContent=count;
var d=document.getElementById('cartItems');
var f=document.getElementById('cartFooter');
if(cart.length===0){d.innerHTML='<div class="cart-empty">Cart is empty! Add products!</div>';f.style.display='none';}
else{
d.innerHTML=cart.map(function(x){return '<div class="cart-item"><div class="cart-item-emoji">'+x.emoji+'</div><div class="cart-item-info"><div class="cart-item-name">'+x.name+'</div><div class="cart-item-price">Rs.'+(x.price*x.qty).toLocaleString()+'</div><div class="cart-item-qty"><button class="cart-qty-btn" onclick="changeCartQty('+x.id+',-1)">-</button><span>'+x.qty+'</span><button class="cart-qty-btn" onclick="changeCartQty('+x.id+',1)">+</button></div></div><button class="cart-remove" onclick="removeFromCart('+x.id+')">X</button></div>';}).join('');
document.getElementById('cartTotal').textContent='Rs.'+total.toLocaleString();
f.style.display='block';
}
}
function toggleCart(){document.getElementById('cartSidebar').classList.toggle('open');}
function showToast(msg){var t=document.getElementById('toast');t.textContent=msg;t.className='toast show';setTimeout(function(){t.className='toast';},2000);}
document.getElementById('productModal').addEventListener('click',function(e){if(e.target===this)closeModal();});
renderProducts(products);
</script>
</body>
</html>
