<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HarisudhanMart Chatbot</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
#chat-btn{position:fixed;bottom:30px;right:30px;width:60px;height:60px;background:#ff9900;border-radius:50%;border:none;cursor:pointer;font-size:28px;box-shadow:0 4px 15px rgba(255,153,0,0.5);z-index:1000;animation:pulse 2s infinite;}
@keyframes pulse{0%{box-shadow:0 0 0 0 rgba(255,153,0,0.5);}70%{box-shadow:0 0 0 15px rgba(255,153,0,0);}100%{box-shadow:0 0 0 0 rgba(255,153,0,0);}}
#chat-box{position:fixed;bottom:100px;right:30px;width:320px;height:420px;background:white;border-radius:15px;box-shadow:0 10px 40px rgba(0,0,0,0.2);z-index:1000;display:none;flex-direction:column;overflow:hidden;}
#chat-box.open{display:flex;}
#chat-header{background:#131921;color:white;padding:15px;display:flex;align-items:center;gap:10px;}
#chat-header .dot{width:10px;height:10px;background:#44ff44;border-radius:50%;animation:blink 1s infinite;}
@keyframes blink{0%,100%{opacity:1;}50%{opacity:0.3;};}
#chat-header h3{font-size:15px;}
#chat-header p{font-size:11px;color:#aaa;}
#messages{flex:1;overflow-y:auto;padding:15px;display:flex;flex-direction:column;gap:10px;}
.msg{max-width:80%;padding:10px 14px;border-radius:15px;font-size:13px;line-height:1.4;}
.bot-msg{background:#f0f0f0;color:#333;align-self:flex-start;border-bottom-left-radius:4px;}
.user-msg{background:#ff9900;color:white;align-self:flex-end;border-bottom-right-radius:4px;}
#quick-replies{padding:8px;display:flex;flex-wrap:wrap;gap:5px;border-top:1px solid #eee;}
.quick-btn{padding:5px 10px;background:white;border:1px solid #ff9900;border-radius:15px;cursor:pointer;font-size:11px;color:#ff9900;}
.quick-btn:hover{background:#ff9900;color:white;}
#chat-input{display:flex;padding:10px;border-top:1px solid #eee;gap:8px;}
#chat-input input{flex:1;padding:8px 12px;border:1px solid #ddd;border-radius:20px;font-size:13px;outline:none;}
#chat-input input:focus{border-color:#ff9900;}
#chat-input button{padding:8px 15px;background:#ff9900;border:none;border-radius:20px;color:white;cursor:pointer;font-weight:bold;}
</style>
</head>
<body>
<button id="chat-btn" onclick="toggleChat()">&#129302;</button>
<div id="chat-box">
  <div id="chat-header">
    <span class="dot"></span>
    <div>
      <h3>HarisudhanMart Bot</h3>
      <p>Always here to help!</p>
    </div>
  </div>
  <div id="messages"></div>
  <div id="quick-replies">
    <button class="quick-btn" onclick="ask('Products')">&#128722; Products</button>
    <button class="quick-btn" onclick="ask('Offers')">&#127881; Offers</button>
    <button class="quick-btn" onclick="ask('Payment')">&#128179; Payment</button>
    <button class="quick-btn" onclick="ask('Delivery')">&#128666; Delivery</button>
    <button class="quick-btn" onclick="ask('Return')">&#8617; Return</button>
    <button class="quick-btn" onclick="ask('Contact')">&#128222; Contact</button>
  </div>
  <div id="chat-input">
    <input type="text" id="userInput" placeholder="Type a message..." onkeypress="if(event.key==='Enter')sendMsg()">
    <button onclick="sendMsg()">Send</button>
  </div>
</div>
<script>
var responses={
  'hello':['Hi there! Welcome to HarisudhanMart! How can I help you today? 😊','Hello! Great to see you! What are you looking for today?'],
  'hi':['Hi! Welcome! How can I assist you? 😊','Hey there! How can I help?'],
  'products':['We have amazing products! 📱 Electronics, 👟 Fashion, 📚 Books, 🎮 Gaming, 🏠 Home & ⚽ Sports! Check our homepage for the best deals!'],
  'offers':['🔥 Amazing offers today!\n• Smartphones - 30% off\n• Headphones - 50% off\n• Running Shoes - 50% off\n• Smart Watch - 31% off\nShop now and save big!'],
  'payment':['💳 We accept:\n• Credit/Debit Cards\n• UPI (GPay, PhonePe)\n• Net Banking\n• Cash on Delivery\nAll payments are 100% secure!'],
  'delivery':['🚚 Delivery info:\n• Standard: 3-5 days (FREE above Rs.499)\n• Express: 1-2 days (Rs.99)\n• Same day available in select cities!'],
  'return':['↩️ Return Policy:\n• 30-day easy returns\n• No questions asked\n• Free pickup from your door\n• Refund in 3-5 business days'],
  'contact':['📞 Contact us:\n• Email: support@harisudhanmart.com\n• Phone: 1800-XXX-XXXX\n• Chat: Available 24/7\nWe are always here to help!'],
  'price':['We have products for every budget! From Rs.399 to Rs.45,999. Use filters to find what fits your budget! 💰'],
  'laptop':['💻 Our Laptop Ultra Slim is amazing!\n• Intel i7, 16GB RAM\n• 512GB SSD\n• Price: Rs.45,999\n• 30% off today!'],
  'phone':['📱 Smartphone Pro Max is our bestseller!\n• 5G enabled\n• 50MP camera\n• Price: Rs.15,999\n• 30% off!'],
  'headphone':['🎧 Wireless Headphones:\n• Noise cancellation\n• 30hr battery\n• Price: Rs.2,999\n• 50% off!'],
  'thanks':['You\'re welcome! 😊 Happy shopping at HarisudhanMart!','Glad I could help! Enjoy shopping! 🛍️'],
  'bye':['Goodbye! Thanks for visiting HarisudhanMart! 👋','See you soon! Happy shopping! 🛍️'],
  'default':['I\'m not sure about that, but I can help with products, offers, payment, delivery and returns! 😊','Try asking about our products, offers or delivery! I\'m here to help! 🤖']
};
function toggleChat(){
  var box=document.getElementById('chat-box');
  box.classList.toggle('open');
  if(box.classList.contains('open')&&document.getElementById('messages').children.length===0){
    setTimeout(function(){addMsg('bot','👋 Hi! Welcome to HarisudhanMart! I\'m your shopping assistant. How can I help you today?');},300);
  }
}
function addMsg(type,text){
  var div=document.createElement('div');
  div.className=type==='bot'?'msg bot-msg':'msg user-msg';
  div.textContent=text;
  var msgs=document.getElementById('messages');
  msgs.appendChild(div);
  msgs.scrollTop=msgs.scrollHeight;
}
function getResponse(input){
  input=input.toLowerCase();
  for(var key in responses){
    if(input.includes(key)){
      var arr=responses[key];
      return arr[Math.floor(Math.random()*arr.length)];
    }
  }
  var def=responses['default'];
  return def[Math.floor(Math.random()*def.length)];
}
function sendMsg(){
  var input=document.getElementById('userInput');
  var text=input.value.trim();
  if(!text)return;
  addMsg('user',text);
  input.value='';
  setTimeout(function(){addMsg('bot',getResponse(text));},600);
}
function ask(topic){
  addMsg('user',topic);
  setTimeout(function(){addMsg('bot',getResponse(topic));},600);
}
</script>
</body>
</html>
