<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - Payment</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Arial,sans-serif;background:#0d0d1a;}
.navbar{background:rgba(26,5,51,0.95);padding:12px 20px;display:flex;align-items:center;justify-content:space-between;border-bottom:1px solid rgba(124,58,237,0.3);}
.logo{color:white;font-size:20px;font-weight:bold;}
.logo span{color:#a78bfa;}
.container{max-width:900px;margin:25px auto;padding:0 20px;display:grid;grid-template-columns:1fr 350px;gap:20px;}
.card{background:rgba(255,255,255,0.05);border:1px solid rgba(124,58,237,0.2);border-radius:12px;padding:25px;}
.card h2{font-size:16px;color:white;margin-bottom:20px;border-bottom:2px solid #7c3aed;padding-bottom:8px;}
.methods{display:flex;flex-direction:column;gap:10px;margin-bottom:20px;}
.method{display:flex;align-items:center;gap:12px;padding:12px;border:2px solid rgba(255,255,255,0.1);border-radius:8px;cursor:pointer;transition:all 0.2s;}
.method:hover,.method.active{border-color:#7c3aed;background:rgba(124,58,237,0.1);}
.method input{accent-color:#7c3aed;}
.method label{cursor:pointer;font-size:14px;font-weight:bold;color:white;}
.method span{font-size:20px;}
.form-group{margin-bottom:15px;}
.form-group label{display:block;font-size:12px;color:#aaa;margin-bottom:5px;font-weight:bold;}
.form-group input{width:100%;padding:12px;background:rgba(255,255,255,0.08);border:2px solid rgba(255,255,255,0.1);border-radius:8px;color:white;font-size:14px;transition:all 0.3s;}
.form-group input:focus{outline:none;border-color:#7c3aed;}
.form-group input::placeholder{color:#666;}
.row{display:grid;grid-template-columns:1fr 1fr;gap:10px;}
.coupon-box{display:flex;gap:10px;margin-bottom:20px;}
.coupon-box input{flex:1;padding:12px;background:rgba(255,255,255,0.08);border:2px solid rgba(255,255,255,0.1);border-radius:8px;color:white;font-size:14px;}
.coupon-box input:focus{outline:none;border-color:#7c3aed;}
.coupon-box input::placeholder{color:#666;}
.btn-coupon{padding:12px 20px;background:#7c3aed;color:white;border:none;border-radius:8px;cursor:pointer;font-weight:bold;font-size:14px;}
.coupon-msg{font-size:13px;margin-bottom:10px;padding:8px 12px;border-radius:8px;display:none;}
.coupon-success{background:rgba(52,211,153,0.2);color:#34d399;border:1px solid #34d399;}
.coupon-error{background:rgba(220,38,38,0.2);color:#f87171;border:1px solid #dc2626;}
.btn-pay{width:100%;padding:15px;background:linear-gradient(135deg,#7c3aed,#6d28d9);color:white;border:none;border-radius:10px;font-size:16px;font-weight:bold;cursor:pointer;margin-top:10px;transition:all 0.3s;}
.btn-pay:hover{transform:translateY(-2px);box-shadow:0 8px 25px rgba(124,58,237,0.4);}
.secure{text-align:center;color:#666;font-size:12px;margin-top:10px;}
.order-item{display:flex;justify-content:space-between;padding:10px 0;border-bottom:1px solid rgba(255,255,255,0.1);font-size:14px;color:#ccc;}
.summary-row{display:flex;justify-content:space-between;padding:8px 0;font-size:14px;color:#aaa;}
.summary-total{display:flex;justify-content:space-between;padding:12px 0;font-size:18px;font-weight:bold;color:#a78bfa;border-top:2px solid rgba(124,58,237,0.3);margin-top:5px;}
.savings{background:rgba(52,211,153,0.1);border:1px solid rgba(52,211,153,0.3);padding:12px;border-radius:8px;color:#34d399;font-size:13px;text-align:center;margin-top:10px;}
.success-overlay{display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.85);z-index:1000;justify-content:center;align-items:center;}
.success-overlay.active{display:flex;}
.success-box{background:#1a0533;border:1px solid rgba(124,58,237,0.4);border-radius:20px;padding:40px;text-align:center;max-width:400px;width:90%;}
.success-box h2{color:#a78bfa;margin:15px 0;}
.success-box p{color:#aaa;margin-bottom:20px;}
</style>
</head>
<body>
<div class="navbar">
  <div class="logo">&#128722; <span>Harisudhan</span>Mart — Secure Checkout</div>
</div>
<div class="container">
  <div>
    <div class="card" style="margin-bottom:20px;">
      <h2>&#128179; Payment Method</h2>
      <div class="methods">
        <div class="method active" onclick="selectMethod(this,'card')">
          <input type="radio" name="method" checked>
          <span>&#128179;</span><label>Credit / Debit Card</label>
        </div>
        <div class="method" onclick="selectMethod(this,'upi')">
          <input type="radio" name="method">
          <span>&#128241;</span><label>UPI (GPay / PhonePe)</label>
        </div>
        <div class="method" onclick="selectMethod(this,'netbanking')">
          <input type="radio" name="method">
          <span>&#127981;</span><label>Net Banking</label>
        </div>
        <div class="method" onclick="selectMethod(this,'cod')">
          <input type="radio" name="method">
          <span>&#128176;</span><label>Cash on Delivery</label>
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
          <div class="form-group"><label>Expiry</label><input type="text" placeholder="MM/YY" maxlength="5"></div>
          <div class="form-group"><label>CVV</label><input type="password" placeholder="***" maxlength="3"></div>
        </div>
      </div>
      <div id="upiForm" style="display:none;">
        <div class="form-group"><label>UPI ID</label><input type="text" placeholder="yourname@upi"></div>
      </div>
      <div id="codForm" style="display:none;">
        <p style="color:#aaa;font-size:14px;padding:15px;background:rgba(255,255,255,0.05);border-radius:8px;">&#9989; Pay when your order arrives. Available for orders below Rs.10,000.</p>
      </div>
    </div>
    <div class="card">
      <h2>&#127881; Apply Coupon</h2>
      <div class="coupon-box">
        <input type="text" id="couponInput" placeholder="Enter coupon code (e.g. DIWALI50)">
        <button class="btn-coupon" onclick="applyCoupon()">Apply</button>
      </div>
      <div class="coupon-msg" id="couponMsg"></div>
      <div style="display:flex;flex-wrap:wrap;gap:8px;">
        <span onclick="document.getElementById('couponInput').value='DIWALI50'" style="padding:5px 12px;background:rgba(124,58,237,0.2);border:1px solid #7c3aed;border-radius:20px;color:#a78bfa;font-size:12px;cursor:pointer;">DIWALI50</span>
        <span onclick="document.getElementById('couponInput').value='SAVE20'" style="padding:5px 12px;background:rgba(124,58,237,0.2);border:1px solid #7c3aed;border-radius:20px;color:#a78bfa;font-size:12px;cursor:pointer;">SAVE20</span>
        <span onclick="document.getElementById('couponInput').value='FIRST10'" style="padding:5px 12px;background:rgba(124,58,237,0.2);border:1px solid #7c3aed;border-radius:20px;color:#a78bfa;font-size:12px;cursor:pointer;">FIRST10</span>
      </div>
    </div>
  </div>
  <div>
    <div class="card">
      <h2>&#128233; Order Summary</h2>
      <div class="order-item"><span>Smartphone Pro Max</span><span>Rs.15,999</span></div>
      <div class="order-item"><span>Wireless Headphones</span><span>Rs.2,999</span></div>
      <div class="summary-row"><span>Subtotal</span><span>Rs.18,998</span></div>
      <div class="summary-row"><span>Discount</span><span style="color:#34d399;">- Rs.5,699</span></div>
      <div class="summary-row" id="couponRow" style="display:none;"><span>Coupon Discount</span><span style="color:#34d399;" id="couponDiscount">- Rs.0</span></div>
      <div class="summary-row"><span>Delivery</span><span style="color:#34d399;">FREE</span></div>
      <div class="summary-total"><span>Total</span><span id="totalAmt">Rs.13,299</span></div>
      <button class="btn-pay" onclick="pay()">&#128274; PAY SECURELY</button>
      <div class="secure">&#128274; 256-bit SSL Encrypted | 100% Secure</div>
      <div class="savings" id="savingsBox">&#127881; You save Rs.5,699 on this order!</div>
    </div>
  </div>
</div>
<div class="success-overlay" id="successOverlay">
  <div class="success-box">
    <div style="font-size:70px;">&#9989;</div>
    <h2>Payment Successful!</h2>
    <p>Order #HM2026001 confirmed!<br>Delivery in 3-5 business days.</p>
    <button onclick="window.location.href='home.jsp'" style="padding:12px 30px;background:#7c3aed;color:white;border:none;border-radius:8px;cursor:pointer;font-size:15px;font-weight:bold;">Continue Shopping</button>
  </div>
</div>
<script>
var baseTotal=13299;
var discount=0;
var coupons={
  'DIWALI50':{percent:50,label:'50% Diwali Discount'},
  'SAVE20':{percent:20,label:'20% Savings'},
  'FIRST10':{percent:10,label:'10% First Order Discount'},
  'HARISUDHAN':{percent:30,label:'30% Special Discount'}
};
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
  input.value=input.value.replace(/\D/g,'').replace(/(.{4})/g,'$1 ').trim();
}
function applyCoupon(){
  var code=document.getElementById('couponInput').value.trim().toUpperCase();
  var msg=document.getElementById('couponMsg');
  var row=document.getElementById('couponRow');
  if(coupons[code]){
    var c=coupons[code];
    discount=Math.round(baseTotal*c.percent/100);
    var newTotal=baseTotal-discount;
    document.getElementById('couponDiscount').textContent='- Rs.'+discount.toLocaleString();
    document.getElementById('totalAmt').textContent='Rs.'+newTotal.toLocaleString();
    document.getElementById('savingsBox').textContent='🎉 You save Rs.'+(5699+discount).toLocaleString()+' on this order!';
    row.style.display='flex';
    msg.className='coupon-msg coupon-success';
    msg.textContent='✅ Coupon "'+code+'" applied! '+c.label;
    msg.style.display='block';
  } else {
    msg.className='coupon-msg coupon-error';
    msg.textContent='❌ Invalid coupon code! Try DIWALI50';
    msg.style.display='block';
    row.style.display='none';
    discount=0;
    document.getElementById('totalAmt').textContent='Rs.'+baseTotal.toLocaleString();
  }
}
function pay(){
  document.getElementById('successOverlay').classList.add('active');
}
</script>
</body>
</html>
