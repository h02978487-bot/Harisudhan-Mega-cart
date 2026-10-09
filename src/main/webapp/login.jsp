<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart - Login</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{font-family:Arial,sans-serif;min-height:100vh;display:flex;align-items:center;justify-content:center;background:#131921;overflow:hidden;}
.particles{position:fixed;top:0;left:0;width:100%;height:100%;z-index:0;}
.particle{position:absolute;border-radius:50%;animation:float linear infinite;opacity:0.15;}
@keyframes float{0%{transform:translateY(100vh) rotate(0deg);opacity:0;}10%{opacity:0.15;}90%{opacity:0.15;}100%{transform:translateY(-100px) rotate(720deg);opacity:0;}}
.login-wrapper{position:relative;z-index:1;width:100%;max-width:420px;padding:20px;}
.login-box{background:rgba(255,255,255,0.05);backdrop-filter:blur(20px);border:1px solid rgba(255,153,0,0.3);border-radius:20px;padding:40px;box-shadow:0 0 40px rgba(255,153,0,0.1);animation:slideUp 0.6s ease;}
@keyframes slideUp{from{opacity:0;transform:translateY(40px);}to{opacity:1;transform:translateY(0);}}
.logo{text-align:center;margin-bottom:30px;}
.logo h1{font-size:28px;color:white;font-weight:bold;}
.logo h1 span{color:#ff9900;}
.logo p{color:#aaa;font-size:13px;margin-top:5px;}
.form-group{margin-bottom:20px;position:relative;}
.form-group label{display:block;color:#ccc;font-size:13px;margin-bottom:8px;font-weight:bold;}
.form-group input{width:100%;padding:14px 16px;background:rgba(255,255,255,0.08);border:2px solid rgba(255,255,255,0.1);border-radius:10px;color:white;font-size:14px;transition:all 0.3s;}
.form-group input::placeholder{color:#666;}
.form-group input:focus{outline:none;border-color:#ff9900;background:rgba(255,153,0,0.08);box-shadow:0 0 15px rgba(255,153,0,0.2);}
.btn-login{width:100%;padding:14px;background:linear-gradient(135deg,#ff9900,#e68900);color:white;border:none;border-radius:10px;font-size:16px;font-weight:bold;cursor:pointer;transition:all 0.3s;margin-top:5px;letter-spacing:1px;}
.btn-login:hover{transform:translateY(-2px);box-shadow:0 8px 25px rgba(255,153,0,0.4);}
.btn-login:active{transform:translateY(0);}
.register-link{text-align:center;margin-top:20px;color:#888;font-size:14px;}
.register-link a{color:#ff9900;text-decoration:none;font-weight:bold;}
.register-link a:hover{text-decoration:underline;}
.error-msg{background:rgba(192,57,43,0.2);border:1px solid #c0392b;color:#ff6b6b;padding:12px;border-radius:8px;margin-bottom:20px;font-size:13px;text-align:center;}
.divider{text-align:center;color:#555;margin:15px 0;font-size:12px;}
</style>
</head>
<body>
<canvas class="particles" id="canvas"></canvas>
<div class="login-wrapper">
  <div class="login-box">
    <div class="logo">
      <h1>&#128722; <span>Harisudhan</span>Mart</h1>
      <p>Your one-stop marketplace</p>
    </div>
    <% String error = (String) request.getAttribute("error");
       if (error != null) { %>
    <div class="error-msg">&#9888; <%= error %></div>
    <% } %>
    <form action="login" method="post">
      <div class="form-group">
        <label>&#9993; Email Address</label>
        <input type="email" name="email" placeholder="Enter your email" required />
      </div>
      <div class="form-group">
        <label>&#128274; Password</label>
        <input type="password" name="password" placeholder="Enter your password" required />
      </div>
      <button type="submit" class="btn-login">LOGIN &#8594;</button>
    </form>
    <div class="register-link">
      Don't have an account? <a href="register.jsp">Register here</a>
    </div>
  </div>
</div>
<script>
var canvas=document.getElementById('canvas');
var ctx=canvas.getContext('2d');
canvas.width=window.innerWidth;
canvas.height=window.innerHeight;
var particles=[];
for(var i=0;i<60;i++){
  particles.push({
    x:Math.random()*canvas.width,
    y:Math.random()*canvas.height,
    r:Math.random()*4+1,
    speed:Math.random()*1+0.5,
    color:Math.random()>0.5?'#ff9900':'#ffffff',
    opacity:Math.random()*0.3+0.05
  });
}
function animate(){
  ctx.clearRect(0,0,canvas.width,canvas.height);
  particles.forEach(function(p){
    ctx.beginPath();
    ctx.arc(p.x,p.y,p.r,0,Math.PI*2);
    ctx.fillStyle=p.color;
    ctx.globalAlpha=p.opacity;
    ctx.fill();
    p.y-=p.speed;
    if(p.y<-10){p.y=canvas.height+10;p.x=Math.random()*canvas.width;}
  });
  ctx.globalAlpha=1;
  requestAnimationFrame(animate);
}
animate();
window.addEventListener('resize',function(){canvas.width=window.innerWidth;canvas.height=window.innerHeight;});
</script>
</body>
</html>
