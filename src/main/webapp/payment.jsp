<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - Payment</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Arial,sans-serif;background:#f0f0f0;min-height:100vh;}
.navbar{background:#1a0533;padding:15px 20px;color:white;font-size:20px;font-weight:bold;}
.navbar span{color:#7c3aed;}
.container{max-width:900px;margin:30px auto;padding:0 20px;display:grid;grid-template-columns:1fr 1fr;gap:20px;}
.card{background:white;border-radius:12px;padding:25px;box-shadow:0 2px 10px rgba(0,0,0,0.08);}
.card h2{font-size:18px;margin-bottom:20px;color:#333;border-bottom:2px solid #7c3aed;padding-bottom:10px;}
.methods{display:flex;flex-direction:column;gap:10px;margin-bottom:20px;}
.method{display:flex;align-items:center;gap:12px;padding:12px;border:2px solid #eee;border-radius:8px;cursor:pointer;transition:all 0.2s;}
.method:hover,.method.active{border-color:#7c3aed;background:#f5f0ff;}
.method input{accent-color:#7c3aed;}
.method label{cursor:pointer;font-size:14px;font-weight:bold;}
.method span{font-size:20px;}
.form-group{margin-bottom:15px;}
.form-group label{display:block;font-size:13px;color:#666;margin-bottom:5px;font-weight:bold;}
.form-group input{width:100%;padding:12px;border:2px solid #eee;border-radius:8px;font-size:14px;transition:all 0.3s;}
.form-group input:focus{outline:none;border-color:#7c3aed;}
.row{display:grid;grid-template-columns:1fr 1fr;gap:10px;}
.btn-pay{width:100%;padding:15px;background:linear-gradient(135deg,#7c3aed,#6d28d9);color:white;border:none;border-radius:10px;font-size:16px;font-weight:bold;cursor:pointer;margin-top:10px;transition:all 0.3s;}
.btn-pay:hover{transform:translateY(-2px);box-shadow:0 8px 25px rgba(124,58,237,0.4);}
.order-item{display:flex;justify-content:space-between;padding:10px 0;border-bottom:1px solid #eee;font-size:14px;}
.total{display:flex;justify-content:space-between;padding:15px 0;font-size:18px;font-weight:bold;color:#7c3aed;}
.secure{text-align:center;color:#888;font-size:12px;margin-top:10px;}
.success{display:none;text-align:center;padding:30px;}
.success h2{color:#7c3aed;font-size:24px;margin:15px 0;}
.success p{color:#666;}
.tick{font-size:60px;animation:pop 0.5s ease;}
@keyframes pop{0%{transform:scale(0);}80%{transform:scale(1.2);}100%{transform:scale(1);}}
</style>
</head>
<body>
<div class="navbar">&#128722; <span>Harisudhan</span>Mart — Secure Checkout</div>
<div class="container">
  <div class="card">
    <h2>&#128179; Payment Method</h2>
    <div class="methods">
      <div class="method active" onclick="selectMethod(this,'card')">
        <input type="radio" name="method" checked>
        <span>&#128179;</span>
        <label>Credit / Debit Card</label>
      </div>
      <div class="method" onclick="selectMethod(this,'upi')">
        <input type="radio" name="method">
        <span>&#128241;</span>
        <label>UPI (GPay / PhonePe)</label>
      </div>
      <div class="method" onclick="selectMethod(this,'netbanking')">
        <input type="radio" name="method">
        <span>&#127981;</span>
        <label>Net Banking</label>
      </div>
      <div class="method" onclick="selectMethod(this,'cod')">
        <input type="radio" name="method">
        <span>&#128176;</span>
        <label>Cash on Delivery</label>
      </div>
    </div>
    <div id="cardForm">
      <div class="form-group">
        <label>Card Number</label>
        <input type="text" placeholder="1234 5678 9012 3456" maxlength="19" oninput="formatCard(this)">
      </div>
      <div class="form-group">
        <label>Cardholder Name</label>
        <input type="text" placeholder="Your Name">
      </div>
      <div class="row">
        <div class="form-group">
          <label>Expiry Date</label>
          <input type="text" placeholder="MM/YY" maxlength="5">
        </div>
        <div class="form-group">
          <label>CVV</label>
          <input type="password" placeholder="***" maxlength="3">
        </div>
      </div>
    </div>
    <div id="upiForm" style="display:none">
      <div class="form-group">
        <label>UPI ID</label>
        <input type="text" placeholder="yourname@upi">
      </div>
    </div>
    <div id="codForm" style="display:none">
      <p style="color:#666;font-size:14px;padding:15px;background:#f9f9f9;border-radius:8px;">&#9989; Pay when your order arrives at your door. Available for orders below Rs.10,000.</p>
    </div>
    <button class="btn-pay" onclick="pay()">&#128274; PAY SECURELY</button>
    <div class="secure">&#128274; 256-bit SSL Encrypted | 100% Secure Payment</div>
  </div>
  <div class="card">
    <h2>&#128233; Order Summary</h2>
    <div class="order-item"><span>Smartphone Pro Max</span><span>Rs.15,999</span></div>
    <div class="order-item"><span>Wireless Headphones</span><span>Rs.2,999</span></div>
    <div class="order-item" style="color:green"><span>Discount (30% off)</span><span>- Rs.5,699</span></div>
    <div class="order-item"><span>Delivery</span><span style="color:green">FREE</span></div>
    <div class="total"><span>Total Amount</span><span>Rs.13,299</span></div>
    <div style="background:#f5f0ff;padding:15px;border-radius:8px;font-size:13px;color:#7c3aed;">
      &#127881; You save Rs.5,699 on this order!
    </div>
  </div>
</div>
<div id="successOverlay" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.7);z-index:1000;justify-content:center;align-items:center;">
  <div style="background:white;border-radius:20px;padding:50px;text-align:center;max-width:400px;">
    <div style="font-size:80px;">&#9989;</div>
    <h2 style="color:#7c3aed;margin:20px 0;">Payment Successful!</h2>
    <p style="color:#666;margin-bottom:20px;">Order #HM2026001 confirmed!<br>Delivery in 3-5 business days.</p>
    <button onclick="window.location.href='home.jsp'" style="padding:12px 30px;background:#7c3aed;color:white;border:none;border-radius:8px;cursor:pointer;font-size:16px;">Continue Shopping</button>
  </div>
</div>
<script>
function selectMethod(el,type){
  document.querySelectorAll('.method').forEach(function(m){m.classList.remove('active');});
  el.classList.add('active');
  el.querySelector('input').checked=true;
  document.getElementById('cardForm').style.display='none';
  document.getElementById('upiForm').style.display='none';
  document.getElementById('codForm').style.display='none';
  if(type==='card')document.getElementById('cardForm').style.display='block';
  if(type==='upi')document.getElementById('upiForm').style.display='block';
  if(type==='cod')document.getElementById('codForm').style.display='block';
}
function formatCard(input){
  var val=input.value.replace(/\D/g,'').replace(/(.{4})/g,'$1 ').trim();
  input.value=val;
}
function pay(){
  var overlay=document.getElementById('successOverlay');
  overlay.style.display='flex';
}
</script>
</body>
</html>
