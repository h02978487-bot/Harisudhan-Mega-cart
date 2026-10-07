<%@ page contentType="text/html;charset=UTF-8" %>
<%
  String id = request.getParameter("id");
  String[][] products = {
    {"1","Smartphone Pro","15999","Fast processor, great camera, 5000mAh battery."},
    {"2","Laptop Ultra","45999","Slim, powerful laptop for work and study."},
    {"3","Headphones","2999","Clear sound with deep bass."},
    {"4","Smart Watch","8999","Tracks steps, heart rate and sleep."}
  };
  String[] p = null;
  for (String[] item : products) {
    if (item[0].equals(id)) p = item;
  }
%>
<html>
<head><title>HarisudhanMart</title></head>
<body style="font-family:Arial;padding:20px">
<% if (p == null) { %>
  <h2>Product not found</h2>
<% } else { %>
  <h1><%= p[1] %></h1>
  <h2>₹<%= p[2] %></h2>
  <p><%= p[3] %></p>
  <button>Add to Cart</button>
<% } %>
<br><a href="index.jsp">← Back to shop</a>
</body>
</html>