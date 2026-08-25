<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>My Orders - HarisudhanMart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
  <header>
    <h1><a href="${pageContext.request.contextPath}/index.jsp">HarisudhanMart</a></h1>
    <nav>
      <a href="${pageContext.request.contextPath}/products.jsp">Browse</a>
      <a href="${pageContext.request.contextPath}/cart.jsp">Cart</a>
    </nav>
  </header>
  <main>
    <h2>My Orders</h2>
    <div id="orderList"></div>
    <p id="message" class="error"></p>
  </main>
  <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
  <script>
    var ctx = '${pageContext.request.contextPath}';

    function loadOrders() {
      apiFetch(ctx + '/api/v1/orders')
        .then(renderOrders)
        .catch(function (err) { document.getElementById('message').textContent = err.message; });
    }

    function renderOrders(orders) {
      var list = document.getElementById('orderList');
      list.innerHTML = '';
      if (orders.length === 0) {
        list.textContent = 'No orders yet.';
        return;
      }
      orders.forEach(function (o) {
        var div = document.createElement('div');
        div.className = 'card';
        div.innerHTML = '<h3></h3><p>Status: <strong class="status"></strong></p><p class="total"></p>';
        div.querySelector('h3').textContent = 'Order #' + o.id;
        div.querySelector('.status').textContent = o.status;
        div.querySelector('.total').textContent = 'Total: ' + money(o.totalAmount);
        list.appendChild(div);
      });
    }

    loadOrders();
  </script>
</body>
</html>
