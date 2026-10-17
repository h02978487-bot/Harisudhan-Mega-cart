<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - Reviews</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Arial,sans-serif;background:#0d0d1a;}
.navbar{background:rgba(26,5,51,0.95);padding:12px 20px;display:flex;align-items:center;justify-content:space-between;border-bottom:1px solid rgba(124,58,237,0.3);}
.logo{color:white;font-size:20px;font-weight:bold;}
.logo span{color:#a78bfa;}
.nav-right a{color:white;text-decoration:none;margin-left:20px;font-size:13px;}
.container{max-width:800px;margin:25px auto;padding:0 20px;}
.page-title{font-size:24px;color:white;margin-bottom:20px;border-left:4px solid #7c3aed;padding-left:10px;}
.rating-summary{background:rgba(255,255,255,0.05);border:1px solid rgba(124,58,237,0.2);border-radius:12px;padding:25px;margin-bottom:20px;display:flex;gap:30px;align-items:center;}
.big-rating{text-align:center;}
.big-rating h1{font-size:64px;color:white;font-weight:bold;}
.big-rating .stars{color:#fbbf24;font-size:24px;}
.big-rating p{color:#aaa;font-size:13px;}
.rating-bars{flex:1;}
.bar-row{display:flex;align-items:center;gap:10px;margin-bottom:8px;}
.bar-row span{color:#aaa;font-size:13px;width:40px;}
.bar-bg{flex:1;background:rgba(255,255,255,0.1);border-radius:10px;height:8px;}
.bar-fill{height:8px;border-radius:10px;background:#fbbf24;transition:width 0.5s;}
.bar-count{color:#aaa;font-size:12px;width:30px;}
.write-review{background:rgba(255,255,255,0.05);border:1px solid rgba(124,58,237,0.2);border-radius:12px;padding:25px;margin-bottom:20px;}
.write-review h3{color:white;font-size:16px;margin-bottom:15px;}
.star-select{display:flex;gap:8px;margin-bottom:15px;}
.star-select span{font-size:32px;cursor:pointer;color:#444;transition:all 0.2s;}
.star-select span.active,.star-select span:hover{color:#fbbf24;transform:scale(1.2);}
.form-group{margin-bottom:15px;}
.form-group label{display:block;font-size:12px;color:#aaa;margin-bottom:5px;}
.form-group input,.form-group textarea{width:100%;padding:12px;background:rgba(255,255,255,0.08);border:2px solid rgba(255,255,255,0.1);border-radius:8px;color:white;font-size:14px;}
.form-group input:focus,.form-group textarea:focus{outline:none;border-color:#7c3aed;}
.form-group input::placeholder,.form-group textarea::placeholder{color:#666;}
.btn-submit{padding:12px 25px;background:#7c3aed;color:white;border:none;border-radius:8px;font-size:14px;font-weight:bold;cursor:pointer;}
.review-card{background:rgba(255,255,255,0.05);border:1px solid rgba(124,58,237,0.2);border-radius:12px;padding:20px;margin-bottom:15px;}
.review-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;}
.reviewer{display:flex;align-items:center;gap:10px;}
.avatar{width:40px;height:40px;border-radius:50%;background:linear-gradient(135deg,#7c3aed,#1a0533);display:flex;align-items:center;justify-content:center;color:white;font-weight:bold;font-size:16px;}
.reviewer-name{color:white;font-size:14px;font-weight:bold;}
.reviewer-date{color:#666;font-size:12px;}
.review-stars{color:#fbbf24;font-size:16px;}
.review-title{color:white;font-size:14px;font-weight:bold;margin-bottom:6px;}
.review-text{color:#aaa;font-size:13px;line-height:1.6;}
.verified{color:#34d399;font-size:11px;margin-top:8px;}
.helpful{color:#666;font-size:12px;margin-top:8px;cursor:pointer;}
.helpful:hover{color:#a78bfa;}
</style>
</head>
<body>
<div class="navbar">
  <div class="logo">&#128722; <span>Harisudhan</span>Mart</div>
  <div class="nav-right">
    <a href="home.jsp">&#127968; Home</a>
    <a href="cart.jsp">&#128722; Cart</a>
    <a href="login.jsp">Logout</a>
  </div>
</div>
<div class="container">
  <div class="page-title">⭐ Product Reviews</div>
  <div class="rating-summary">
    <div class="big-rating">
      <h1>4.5</h1>
      <div class="stars">★★★★½</div>
      <p>Based on 245 reviews</p>
    </div>
    <div class="rating-bars">
      <div class="bar-row"><span>5 ★</span><div class="bar-bg"><div class="bar-fill" style="width:65%"></div></div><span class="bar-count">159</span></div>
      <div class="bar-row"><span>4 ★</span><div class="bar-bg"><div class="bar-fill" style="width:20%"></div></div><span class="bar-count">49</span></div>
      <div class="bar-row"><span>3 ★</span><div class="bar-bg"><div class="bar-fill" style="width:8%"></div></div><span class="bar-count">20</span></div>
      <div class="bar-row"><span>2 ★</span><div class="bar-bg"><div class="bar-fill" style="width:4%"></div></div><span class="bar-count">10</span></div>
      <div class="bar-row"><span>1 ★</span><div class="bar-bg"><div class="bar-fill" style="width:3%"></div></div><span class="bar-count">7</span></div>
    </div>
  </div>
  <div class="write-review">
    <h3>✍️ Write a Review</h3>
    <div class="star-select" id="starSelect">
      <span onclick="setRating(1)">★</span>
      <span onclick="setRating(2)">★</span>
      <span onclick="setRating(3)">★</span>
      <span onclick="setRating(4)">★</span>
      <span onclick="setRating(5)">★</span>
    </div>
    <div class="form-group">
      <label>Your Name</label>
      <input type="text" id="rName" placeholder="Enter your name">
    </div>
    <div class="form-group">
      <label>Review Title</label>
      <input type="text" id="rTitle" placeholder="Summarize your review">
    </div>
    <div class="form-group">
      <label>Your Review</label>
      <textarea id="rText" rows="4" placeholder="Share your experience..."></textarea>
    </div>
    <button class="btn-submit" onclick="submitReview()">Submit Review &#8594;</button>
  </div>
  <div id="reviewList"></div>
</div>
<script>
var rating=0;
var reviews=[
  {name:"Ravi Kumar",initial:"R",rating:5,title:"Excellent product!",text:"Really amazing quality. Fast delivery and exactly as described. Will buy again!",date:"10 Oct 2026",helpful:24},
  {name:"Priya S",initial:"P",rating:4,title:"Good value for money",text:"Product is good but packaging could be better. Overall satisfied with the purchase.",date:"08 Oct 2026",helpful:15},
  {name:"Arun M",initial:"A",rating:5,title:"Superb! Highly recommended",text:"Best purchase I made this year. Quality is top notch and price is very reasonable.",date:"05 Oct 2026",helpful:31},
  {name:"Kavya R",initial:"K",rating:3,title:"Average product",text:"Product is okay but not as good as expected. Customer service was helpful though.",date:"02 Oct 2026",helpful:8},
  {name:"Harisudhan",initial:"H",rating:5,title:"Perfect! Love it",text:"Outstanding quality! Exactly what I needed. Fast delivery and great packaging!",date:"01 Oct 2026",helpful:42}
];
function setRating(r){
  rating=r;
  var stars=document.querySelectorAll('#starSelect span');
  stars.forEach(function(s,i){s.classList.toggle('active',i<r);});
}
function submitReview(){
  var name=document.getElementById('rName').value;
  var title=document.getElementById('rTitle').value;
  var text=document.getElementById('rText').value;
  if(!name||!title||!text||rating===0){alert('Please fill all fields and select rating!');return;}
  reviews.unshift({name:name,initial:name[0].toUpperCase(),rating:rating,title:title,text:text,date:'Today',helpful:0});
  document.getElementById('rName').value='';
  document.getElementById('rTitle').value='';
  document.getElementById('rText').value='';
  rating=0;
  document.querySelectorAll('#starSelect span').forEach(function(s){s.classList.remove('active');});
  renderReviews();
  alert('Review submitted! Thank you!');
}
function renderReviews(){
  document.getElementById('reviewList').innerHTML=reviews.map(function(r){
    var stars='★'.repeat(r.rating)+'☆'.repeat(5-r.rating);
    return '<div class="review-card">'+
      '<div class="review-header">'+
        '<div class="reviewer">'+
          '<div class="avatar">'+r.initial+'</div>'+
          '<div><div class="reviewer-name">'+r.name+'</div><div class="reviewer-date">'+r.date+'</div></div>'+
        '</div>'+
        '<div class="review-stars">'+stars+'</div>'+
      '</div>'+
      '<div class="review-title">'+r.title+'</div>'+
      '<div class="review-text">'+r.text+'</div>'+
      '<div class="verified">✅ Verified Purchase</div>'+
      '<div class="helpful">👍 '+r.helpful+' people found this helpful</div>'+
    '</div>';
  }).join('');
}
renderReviews();
</script>
</body>
</html>
