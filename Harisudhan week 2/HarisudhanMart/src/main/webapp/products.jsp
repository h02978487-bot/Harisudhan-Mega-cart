<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Products - HarisudhanMart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
  <header>
    <h1><a href="${pageContext.request.contextPath}/index.jsp">HarisudhanMart</a></h1>
    <nav>
      <a href="${pageContext.request.contextPath}/cart.jsp">Cart</a>
      <a href="${pageContext.request.contextPath}/orders.jsp">My Orders</a>
    </nav>
  </header>
  <main>
    <h2>Browse Products</h2>
    <form id="searchForm" class="inline-form">
      <input type="text" id="q" placeholder="Search products...">
      <input type="text" id="category" placeholder="Category">
      <button type="submit">Search</button>
    </form>
    <div id="productList" class="grid"></div>
    <p id="message" class="error"></p>
  </main>
  <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
  <script>
    var ctx = '${pageContext.request.contextPath}';

    function loadProducts() {
      var q = document.getElementById('q').value;
      var category = document.getElementById('category').value;
      var params = new URLSearchParams();
      if (q) { params.set('q', q); }
      if (category) { params.set('category', category); }
      apiFetch(ctx + '/api/v1/products?' + params.toString())
        .then(renderProducts)
        .catch(function (err) { document.getElementById('message').textContent = err.message; });
    }

    function renderProducts(products) {
      var list = document.getElementById('productList');
      list.innerHTML = '';
      if (products.length === 0) {
        list.textContent = 'No products found.';
        return;
      }
      products.forEach(function (p) {
        var card = document.createElement('div');
        card.className = 'card';
        card.innerHTML =
          '<h3></h3><p class="desc"></p>' +
          '<p><strong class="price"></strong> \u00b7 <span class="stock"></span> in stock</p>' +
          '<p class="muted category"></p>' +
          '<button>Add to cart</button>';
        card.querySelector('h3').textContent = p.name;
        card.querySelector('.desc').textContent = p.description || '';
        card.querySelector('.price').textContent = money(p.price);
        card.querySelector('.stock').textContent = p.stockQty;
        card.querySelector('.category').textContent = p.category || '';
        card.querySelector('button').addEventListener('click', function () { addToCart(p.id); });
        list.appendChild(card);
      });
    }

    function addToCart(productId) {
      var msg = document.getElementById('message');
      apiFetch(ctx + '/api/v1/cart/add', {
        method: 'POST',
        body: JSON.stringify({ productId: productId, quantity: 1 })
      }).then(function () {
        msg.textContent = 'Added to cart.';
        msg.classList.remove('error');
      }).catch(function (err) {
        msg.textContent = err.message;
        msg.classList.add('error');
      });
    }

    document.getElementById('searchForm').addEventListener('submit', function (e) {
      e.preventDefault();
      loadProducts();
    });

    loadProducts();
  </script>
</body>
</html>
