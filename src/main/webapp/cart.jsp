<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - Cart</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Arial,sans-serif;background:#f0f0f0;}
.navbar{background:#1a0533;padding:15px 20px;display:flex;align-items:center;justify-content:space-between;}
.logo{color:white;font-size:20px;font-weight:bold;}
.logo span{color:#a78bfa;}
.nav-right a{color:white;text-decoration:none;margin-left:20px;font-size:13px;}
.container{max-width:900px;margin:25px auto;padding:0 20px;display:grid;grid-template-columns:1fr 350px;gap:20px;}
.card{background:white;border-radius:12px;padding:20px;box-shadow:0 2px 8px rgba(0,0,0,0.08);}
.card h2{font-size:18px;color:#1a0533;margin-bottom:15px;border-bottom:2px solid #7c3aed;padding-bottom:8px;}
.cart-item{display:flex;gap:15px;padding:15px 0;border-bottom:1px solid #eee;align-items:center;}
.cart-item img{width:80px;height:80px;object-fit:cover;border-radius:8px;}
.item-info{flex:1;}
.item-info h4{font-size:14px;color:#333;margin-bottom:5px;}
.item-info p{font-size:13px;color:#888;}
.item-price{font-size:18px;color:#b12704;font-weight:bold;}
.qty-box{display:flex;align-items:center;gap:8px;margin-top:8px;}
.qty-btn{width:28px;height:28px;border:1px solid #ddd;background:white;border-radius:4px;cursor:pointer;font-size:16px;}
.qty-num{font-size:14px;font-weight:bold;width:30px;text-align:center;}
.btn-remove{padding:5px 10px;background:#fee2e2;border:none;border-radius:5px;cursor:pointer;font-size:12px;color:#dc2626;}
.summary-row{display:flex;justify-content:space-between;padding:8px 0;font-size:14px;}
.summary-total{display:flex;justify-content:space-between;padding:12px 0;font-size:18px;font-weight:bold;color:#7c3aed;border-top:2px solid #eee;margin-top:5px;}
.btn-checkout{width:100%;padding:14px;background:#7c3aed;color:white;border:none;border-radius:10px;font-size:16px;font-weight:bold;cursor:pointer;margin-top:10px;}
.btn-checkout:hover{background:#6d28d9;}
.empty{text-align:center;padding:40px;color:#888;}
.empty div{font-size:50px;margin-bottom:15px;}
</style>
</head>
<body>
<div class="navbar">
  <div class="logo">&#128722; <span>Harisudhan</span>Mart</div>
  <div class="nav-right">
    <a href="home.jsp">&#127968; Home</a>
    <a href="orders.jsp">My Orders</a>
    <a href="login.jsp">Logout</a>
  </div>
</div>
<div class="container">
  <div class="card">
    <h2>&#128722; My Cart (<span id="cartCount">0</span> items)</h2>
    <div id="cartItems"></div>
  </div>
  <div class="card" style="height:fit-content;">
    <h2>&#128233; Order Summary</h2>
    <div class="summary-row"><span>Subtotal</span><span id="subtotal">Rs.0</span></div>
    <div class="summary-row"><span>Discount</span><span style="color:green" id="discount">- Rs.0</span></div>
    <div class="summary-row"><span>Delivery</span><span style="color:green">FREE</span></div>
    <div class="summary-total"><span>Total</span><span id="total">Rs.0</span></div>
    <button class="btn-checkout" onclick="window.location.href='payment.jsp'">&#128274; Proceed to Payment</button>
    <button onclick="window.location.href='home.jsp'" style="width:100%;padding:10px;background:white;border:2px solid #7c3aed;border-radius:10px;color:#7c3aed;font-weight:bold;cursor:pointer;margin-top:8px;">Continue Shopping</button>
  </div>
</div>
<script>
var cart=JSON.parse(localStorage.getItem('hmCart')||'[]');
function money(n){return 'Rs.'+parseInt(n).toLocaleString();}
function saveCart(){localStorage.setItem('hmCart',JSON.stringify(cart));}
function renderCart(){
  var items=document.getElementById('cartItems');
  var count=document.getElementById('cartCount');
  if(cart.length===0){
    items.innerHTML='<div class="empty"><div>&#128722;</div><p>Your cart is empty!</p><br><button onclick="window.location.href=\'home.jsp\'" style="padding:10px 20px;background:#7c3aed;color:white;border:none;border-radius:8px;cursor:pointer;">Shop Now</button></div>';
    count.textContent=0;
    document.getElementById('subtotal').textContent='Rs.0';
    document.getElementById('discount').textContent='- Rs.0';
    document.getElementById('total').textContent='Rs.0';
    return;
  }
  count.textContent=cart.reduce(function(a,b){return a+b.qty;},0);
  items.innerHTML=cart.map(function(item,i){
    return '<div class="cart-item">'+
      '<img src="'+item.image+'" alt="'+item.name+'">'+
      '<div class="item-info">'+
        '<h4>'+item.name+'</h4>'+
        '<p>'+item.category+'</p>'+
        '<div class="qty-box">'+
          '<button class="qty-btn" onclick="changeQty('+i+',-1)">-</button>'+
          '<span class="qty-num">'+item.qty+'</span>'+
          '<button class="qty-btn" onclick="changeQty('+i+',1)">+</button>'+
          '<button class="btn-remove" onclick="removeItem('+i+')">Remove</button>'+
        '</div>'+
      '</div>'+
      '<div class="item-price">'+money(item.price*item.qty)+'</div>'+
    '</div>';
  }).join('');
  var subtotal=cart.reduce(function(a,b){return a+b.price*b.qty;},0);
  var origTotal=cart.reduce(function(a,b){return a+b.original*b.qty;},0);
  var discount=origTotal-subtotal;
  document.getElementById('subtotal').textContent=money(origTotal);
  document.getElementById('discount').textContent='- '+money(discount);
  document.getElementById('total').textContent=money(subtotal);
}
function changeQty(i,d){
  cart[i].qty+=d;
  if(cart[i].qty<=0)cart.splice(i,1);
  saveCart();renderCart();
}
function removeItem(i){
  cart.splice(i,1);
  saveCart();renderCart();
}
renderCart();
</script>
</body>
</html>
