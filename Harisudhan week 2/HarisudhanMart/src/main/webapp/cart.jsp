<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Cart - HarisudhanMart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
  <header>
    <h1><a href="${pageContext.request.contextPath}/index.jsp">HarisudhanMart</a></h1>
    <nav>
      <a href="${pageContext.request.contextPath}/products.jsp">Browse</a>
      <a href="${pageContext.request.contextPath}/orders.jsp">My Orders</a>
    </nav>
  </header>
  <main>
    <h2>Your Cart</h2>
    <table id="cartTable">
      <thead><tr><th>Product</th><th>Price</th><th>Qty</th><th>Subtotal</th><th></th></tr></thead>
      <tbody></tbody>
    </table>
    <p>Total: <strong id="cartTotal"></strong></p>
    <button id="checkoutBtn">Checkout (mock payment)</button>
    <p id="message" class="error"></p>
  </main>
  <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
  <script>
    var ctx = '${pageContext.request.contextPath}';

    function loadCart() {
      apiFetch(ctx + '/api/v1/cart/view')
        .then(renderCart)
        .catch(function (err) { document.getElementById('message').textContent = err.message; });
    }

    function renderCart(cart) {
      var tbody = document.querySelector('#cartTable tbody');
      tbody.innerHTML = '';
      cart.items.forEach(function (item) {
        var row = document.createElement('tr');
        row.innerHTML =
          '<td class="name"></td><td class="price"></td>' +
          '<td><input type="number" min="1" class="qtyInput"></td>' +
          '<td class="subtotal"></td><td><button class="removeBtn">Remove</button></td>';
        row.querySelector('.name').textContent = item.productName;
        row.querySelector('.price').textContent = money(item.unitPrice);
        row.querySelector('.subtotal').textContent = money(item.subtotal);
        var qtyInput = row.querySelector('.qtyInput');
        qtyInput.value = item.quantity;
        qtyInput.addEventListener('change', function () { updateQty(item.productId, qtyInput.value); });
        row.querySelector('.removeBtn').addEventListener('click', function () { removeItem(item.productId); });
        tbody.appendChild(row);
      });
      document.getElementById('cartTotal').textContent = money(cart.total);
    }

    function updateQty(productId, quantity) {
      apiFetch(ctx + '/api/v1/cart/update', {
        method: 'POST',
        body: JSON.stringify({ productId: Number(productId), quantity: Number(quantity) })
      }).then(renderCart).catch(function (err) { document.getElementById('message').textContent = err.message; });
    }

    function removeItem(productId) {
      apiFetch(ctx + '/api/v1/cart/remove', {
        method: 'POST',
        body: JSON.stringify({ productId: Number(productId) })
      }).then(renderCart).catch(function (err) { document.getElementById('message').textContent = err.message; });
    }

    document.getElementById('checkoutBtn').addEventListener('click', function () {
      if (!confirm('Confirm mock payment and place order?')) { return; }
      apiFetch(ctx + '/api/v1/orders/checkout', {
        method: 'POST',
        body: JSON.stringify({ mockPaymentConfirmed: true })
      }).then(function () {
        window.location.href = ctx + '/orders.jsp';
      }).catch(function (err) { document.getElementById('message').textContent = err.message; });
    });

    loadCart();
  </script>
</body>
</html>
