<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - Login</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Arial,sans-serif;min-height:100vh;display:flex;align-items:center;justify-content:center;background:#1a0533;overflow:hidden;}
canvas{position:fixed;top:0;left:0;z-index:0;}
.wrapper{position:relative;z-index:1;width:100%;max-width:450px;padding:20px;}
.box{background:rgba(255,255,255,0.05);backdrop-filter:blur(20px);border:1px solid rgba(124,58,237,0.3);border-radius:20px;padding:35px;box-shadow:0 0 40px rgba(124,58,237,0.1);animation:slideUp 0.6s ease;}
@keyframes slideUp{from{opacity:0;transform:translateY(40px);}to{opacity:1;transform:translateY(0);}}
.logo{text-align:center;margin-bottom:25px;}
.logo h1{font-size:26px;color:white;font-weight:bold;}
.logo h1 span{color:#a78bfa;}
.logo p{color:#aaa;font-size:13px;margin-top:5px;}
.role-tabs{display:flex;gap:10px;margin-bottom:25px;}
.role-tab{flex:1;padding:12px;border:2px solid rgba(255,255,255,0.1);border-radius:10px;background:transparent;color:#aaa;cursor:pointer;font-size:13px;font-weight:bold;transition:all 0.3s;text-align:center;}
.role-tab:hover{border-color:#7c3aed;color:white;}
.role-tab.active{border-color:#7c3aed;background:#7c3aed;color:white;}
.role-tab span{display:block;font-size:20px;margin-bottom:4px;}
.form-group{margin-bottom:15px;}
.form-group label{display:block;color:#ccc;font-size:13px;margin-bottom:6px;font-weight:bold;}
.form-group input{width:100%;padding:12px 16px;background:rgba(255,255,255,0.08);border:2px solid rgba(255,255,255,0.1);border-radius:10px;color:white;font-size:14px;transition:all 0.3s;}
.form-group input::placeholder{color:#666;}
.form-group input:focus{outline:none;border-color:#7c3aed;background:rgba(124,58,237,0.08);}
.btn-login{width:100%;padding:14px;background:linear-gradient(135deg,#7c3aed,#6d28d9);color:white;border:none;border-radius:10px;font-size:16px;font-weight:bold;cursor:pointer;margin-top:5px;letter-spacing:1px;transition:all 0.3s;}
.btn-login:hover{transform:translateY(-2px);box-shadow:0 8px 25px rgba(124,58,237,0.4);}
.register-link{text-align:center;margin-top:15px;color:#888;font-size:14px;}
.register-link a{color:#a78bfa;text-decoration:none;font-weight:bold;}
.error-msg{background:rgba(192,57,43,0.2);border:1px solid #c0392b;color:#ff6b6b;padding:10px;border-radius:8px;margin-bottom:15px;font-size:13px;text-align:center;display:none;}
</style>
</head>
<body>
<canvas id="canvas"></canvas>
<div class="wrapper">
  <div class="box">
    <div class="logo">
      <h1>&#128722; <span>Harisudhan</span>Mart</h1>
      <p>Your one-stop marketplace</p>
    </div>
    <div class="role-tabs">
      <div class="role-tab active" onclick="setRole('buyer',this)">
        <span>&#128722;</span>Buyer
      </div>
      <div class="role-tab" onclick="setRole('seller',this)">
        <span>&#127978;</span>Seller
      </div>
      <div class="role-tab" onclick="setRole('admin',this)">
        <span>&#128737;</span>Admin
      </div>
    </div>
    <div id="errMsg" class="error-msg"></div>
    <div class="form-group">
      <label>&#9993; Email Address</label>
      <input type="email" id="email" placeholder="Enter your email" required/>
    </div>
    <div class="form-group">
      <label>&#128274; Password</label>
      <input type="password" id="password" placeholder="Enter your password" required/>
    </div>
    <button class="btn-login" onclick="doLogin()">LOGIN &#8594;</button>
    <div class="register-link">
      Don't have an account? <a href="register.jsp">Register here</a>
    </div>
  </div>
</div>
<script>
var currentRole='buyer';
function setRole(role,el){
  currentRole=role;
  document.querySelectorAll('.role-tab').forEach(function(t){t.classList.remove('active');});
  el.classList.add('active');
}
function doLogin(){
  var e=document.getElementById('email').value;
  var p=document.getElementById('password').value;
  var err=document.getElementById('errMsg');
  if(!e||!p){
    err.style.display='block';
    err.textContent='Please enter email and password!';
    return;
  }
  if(currentRole==='buyer') window.location.href='home.jsp';
  else if(currentRole==='seller') window.location.href='seller.jsp';
  else if(currentRole==='admin') window.location.href='admin.jsp';
}
var canvas=document.getElementById('canvas');
var ctx=canvas.getContext('2d');
canvas.width=window.innerWidth;canvas.height=window.innerHeight;
var pts=[];
for(var i=0;i<60;i++)pts.push({x:Math.random()*canvas.width,y:Math.random()*canvas.height,r:Math.random()*3+1,s:Math.random()*1+0.3,c:Math.random()>0.5?'#7c3aed':'#ffffff',o:Math.random()*0.2+0.05});
function draw(){
  ctx.clearRect(0,0,canvas.width,canvas.height);
  pts.forEach(function(p){ctx.beginPath();ctx.arc(p.x,p.y,p.r,0,Math.PI*2);ctx.fillStyle=p.c;ctx.globalAlpha=p.o;ctx.fill();p.y-=p.s;if(p.y<-10){p.y=canvas.height;p.x=Math.random()*canvas.width;}});
  ctx.globalAlpha=1;requestAnimationFrame(draw);
}
draw();
</script>
</body>
</html>
