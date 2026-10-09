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
.login-wrapper{position:relative;z-index:1;width:100%;max-width:420px;padding:20px;}
.login-box{background:rgba(255,255,255,0.05);backdrop-filter:blur(20px);border:1px solid rgba(255,153,0,0.3);border-radius:20px;padding:40px;box-shadow:0 0 40px rgba(255,153,0,0.1);animation:slideUp 0.6s ease;}
@keyframes slideUp{from{opacity:0;transform:translateY(40px);}to{opacity:1;transform:translateY(0);}}
.logo{text-align:center;margin-bottom:30px;}
.logo h1{font-size:28px;color:white;font-weight:bold;}
.logo h1 span{color:#7c3aed;}
.logo p{color:#aaa;font-size:13px;margin-top:5px;}
.form-group{margin-bottom:20px;}
.form-group label{display:block;color:#ccc;font-size:13px;margin-bottom:8px;font-weight:bold;}
.form-group input{width:100%;padding:14px 16px;background:rgba(255,255,255,0.08);border:2px solid rgba(255,255,255,0.1);border-radius:10px;color:white;font-size:14px;transition:all 0.3s;}
.form-group input::placeholder{color:#666;}
.form-group input:focus{outline:none;border-color:#7c3aed;background:rgba(255,153,0,0.08);box-shadow:0 0 15px rgba(255,153,0,0.2);}
.btn-login{width:100%;padding:14px;background:linear-gradient(135deg,#7c3aed,#6d28d9);color:white;border:none;border-radius:10px;font-size:16px;font-weight:bold;cursor:pointer;transition:all 0.3s;margin-top:5px;letter-spacing:1px;}
.btn-login:hover{transform:translateY(-2px);box-shadow:0 8px 25px rgba(255,153,0,0.4);}
.register-link{text-align:center;margin-top:20px;color:#888;font-size:14px;}
.register-link a{color:#7c3aed;text-decoration:none;font-weight:bold;}
.error-msg{background:rgba(192,57,43,0.2);border:1px solid #c0392b;color:#ff6b6b;padding:12px;border-radius:8px;margin-bottom:20px;font-size:13px;text-align:center;}
</style>
</head>
<body>
<canvas id="canvas"></canvas>
<div class="login-wrapper">
  <div class="login-box">
    <div class="logo">
      <h1>&#128722; <span>Harisudhan</span>Mart</h1>
      <p>Your one-stop marketplace</p>
    </div>
    <div id="errMsg" class="error-msg" style="display:none"></div>
    <div class="form-group">
      <label>&#9993; Email Address</label>
      <input type="email" id="email" placeholder="Enter your email" required />
    </div>
    <div class="form-group">
      <label>&#128274; Password</label>
      <input type="password" id="password" placeholder="Enter your password" required />
    </div>
    <button class="btn-login" onclick="doLogin()">LOGIN &#8594;</button>
    <div class="register-link">
      Don't have an account? <a href="register.jsp">Register here</a>
    </div>
  </div>
</div>
<script>
function doLogin(){
  var e=document.getElementById('email').value;
  var p=document.getElementById('password').value;
  if(!e||!p){
    document.getElementById('errMsg').style.display='block';
    document.getElementById('errMsg').textContent='Please enter email and password!';
    return;
  }
  window.location.href='home.jsp';
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
