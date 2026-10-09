<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - Register</title>
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
.form-group{margin-bottom:15px;}
.form-group label{display:block;color:#ccc;font-size:13px;margin-bottom:6px;font-weight:bold;}
.form-group input{width:100%;padding:12px 16px;background:rgba(255,255,255,0.08);border:2px solid rgba(255,255,255,0.1);border-radius:10px;color:white;font-size:14px;transition:all 0.3s;}
.form-group input::placeholder{color:#666;}
.form-group input:focus{outline:none;border-color:#7c3aed;background:rgba(124,58,237,0.08);box-shadow:0 0 15px rgba(124,58,237,0.2);}
.row{display:grid;grid-template-columns:1fr 1fr;gap:10px;}
.btn-register{width:100%;padding:14px;background:linear-gradient(135deg,#7c3aed,#6d28d9);color:white;border:none;border-radius:10px;font-size:16px;font-weight:bold;cursor:pointer;margin-top:5px;letter-spacing:1px;transition:all 0.3s;}
.btn-register:hover{transform:translateY(-2px);box-shadow:0 8px 25px rgba(124,58,237,0.4);}
.login-link{text-align:center;margin-top:15px;color:#888;font-size:14px;}
.login-link a{color:#a78bfa;text-decoration:none;font-weight:bold;}
.success{display:none;text-align:center;padding:20px;}
.success h2{color:#a78bfa;margin:15px 0;}
</style>
</head>
<body>
<canvas id="canvas"></canvas>
<div class="wrapper">
  <div class="box">
    <div class="logo">
      <h1>&#128722; <span>Harisudhan</span>Mart</h1>
      <p>Create your account</p>
    </div>
    <div id="regForm">
      <div class="row">
        <div class="form-group">
          <label>&#128100; First Name</label>
          <input type="text" id="fname" placeholder="First name" required>
        </div>
        <div class="form-group">
          <label>&#128100; Last Name</label>
          <input type="text" id="lname" placeholder="Last name" required>
        </div>
      </div>
      <div class="form-group">
        <label>&#9993; Email Address</label>
        <input type="email" id="email" placeholder="Enter your email" required>
      </div>
      <div class="form-group">
        <label>&#128241; Phone Number</label>
        <input type="text" id="phone" placeholder="Enter phone number" maxlength="10">
      </div>
      <div class="form-group">
        <label>&#128274; Password</label>
        <input type="password" id="pass" placeholder="Create password" required>
      </div>
      <div class="form-group">
        <label>&#128274; Confirm Password</label>
        <input type="password" id="cpass" placeholder="Confirm password" required>
      </div>
      <button class="btn-register" onclick="register()">CREATE ACCOUNT &#8594;</button>
      <div class="login-link">Already have an account? <a href="login.jsp">Login here</a></div>
    </div>
    <div class="success" id="successMsg">
      <div style="font-size:60px;">&#9989;</div>
      <h2>Account Created!</h2>
      <p style="color:#aaa;margin-bottom:20px;">Welcome to HarisudhanMart!</p>
      <button onclick="window.location.href='login.jsp'" style="padding:12px 30px;background:#7c3aed;color:white;border:none;border-radius:8px;cursor:pointer;font-size:15px;">Go to Login</button>
    </div>
  </div>
</div>
<script>
function register(){
  var fname=document.getElementById('fname').value;
  var email=document.getElementById('email').value;
  var pass=document.getElementById('pass').value;
  var cpass=document.getElementById('cpass').value;
  if(!fname||!email||!pass){alert('Please fill all fields!');return;}
  if(pass!==cpass){alert('Passwords do not match!');return;}
  if(pass.length<6){alert('Password must be at least 6 characters!');return;}
  document.getElementById('regForm').style.display='none';
  document.getElementById('successMsg').style.display='block';
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
