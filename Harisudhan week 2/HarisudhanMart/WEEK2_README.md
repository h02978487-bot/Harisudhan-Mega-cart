# HarisudhanMart — Week 2 Upload (Aug 3–9)

Spec target for this window: **"Core flow: browse → add to cart → place order."**
This delivers F2 (seller product CRUD), F3 (buyer browse/search), F4 (cart), and F5/F6
(checkout + order history).

## How to use this
This folder mirrors your repo's structure. Copy it over your existing project root
(it will only add new files/folders, nothing here overwrites your Week 1 auth code)
then commit and push.

```
cp -r HarisudhanMart/src YOUR_REPO/
cp -r HarisudhanMart/db YOUR_REPO/
cd YOUR_REPO
git add .
git commit -m "feat: product catalog, cart, and checkout (Week 2 core flow)"
git push
```

## What's included

**model/** — `Product`, `CartItem`, `Order`, `OrderItem`, `Review` (Review is a stub
model only — full F8 logic is Week 6).

**dao/** — `ProductDAO(Impl)`, `CartDAO(Impl)`, `OrderDAO(Impl)`, `ReviewDAO(Impl)`.
Every SQL statement is a `PreparedStatement` (spec Section 2, rule 1). `OrderDAOImpl.placeOrder()`
is the important one: it runs the order insert, order_items insert, stock decrement, and
cart clear on **one JDBC connection with `autoCommit=false`**, so checkout is fully atomic —
if stock runs out mid-order it rolls everything back and throws `InsufficientStockException`.

**service/** — `ProductService`, `CartService`, `OrderService`. No JDBC in this layer
(spec Section 2) — validation and orchestration only.

**controller/** — `ProductServlet`, `CartServlet`, `OrderServlet`, plus `BaseServlet`
(shared JSON envelope writer per spec Section 13).

**dto/** — request/response shapes kept separate from entities, plus `ApiResponse`/`ApiError`
(the `{ success, data, error }` envelope) and `UserResponseDTO`.

**exception/** — `ValidationException`, `NotFoundException`, `ForbiddenException`,
`InsufficientStockException`, `AuthException`.

**util/** — `ValidationUtil`.

**webapp/** — `index.jsp`, `login.jsp`, `register.jsp`, `products.jsp`, `cart.jsp`,
`orders.jsp`, shared `assets/css/style.css` and `assets/js/app.js`, and
`WEB-INF/jsp/error.jsp`. Pages are plain JSP shells that call the JSON API via `fetch()`
per the spec's view-layer rule — not styled beyond function.

**db/migrations/V2__product_cart_order_extensions.sql** — adds `image_url` and `active`
to `products`, adds `created_at` to `cart_items`/`order_items` (mandatory rule 4 requires
it on every table but the Section 4 minimal schema omitted it there), and adds the FK
indexes (mandatory rule 1). Run this after your existing `V1__init_schema.sql`.

## One thing to flag
`BaseServlet`, the exception classes, `ApiResponse`/`UserResponseDTO`, and `ValidationUtil`
were already referenced by your Week 1 `AuthServlet`/`AuthService`/`DAOFactory` code but
weren't in the Week 1 file set — so without them the project wouldn't have compiled. They're
included here now. If you already created versions of these yourself, keep yours and just
skip those specific files from this folder.

## New API endpoints (all under `/api/v1/...`, JSON envelope per spec Section 13)

| Method | Path | Auth | Notes |
|---|---|---|---|
| GET | `/products?q=&category=` | public | search/list |
| GET | `/products/{id}` | public | detail |
| POST | `/products/create` | seller | |
| POST | `/products/update` | seller, owner | |
| POST | `/products/delete` | seller, owner | soft delete |
| GET | `/cart/view` | login | |
| POST | `/cart/add` | login | `{productId, quantity}` |
| POST | `/cart/update` | login | `{productId, quantity}` |
| POST | `/cart/remove` | login | `{productId}` |
| GET | `/orders` | login | buyer's own history |
| GET | `/orders/seller` | login | seller's incoming orders |
| POST | `/orders/checkout` | login | `{mockPaymentConfirmed: true}` |

## Not in this drop (later weeks per Section 6)
Admin panel (F7, Week 4), search/filter polish and order status workflow (Week 5),
reviews/ratings (F8, Week 6) — `ReviewDAO` is stubbed just enough to compile.

## Before you push
- 3+ commits this week (spec Section 8) — split this into a few commits instead of one
  giant commit if you can (e.g. `feat: product CRUD`, `feat: cart`, `feat: checkout flow`).
- Update your README's "completed vs planned" section for the Aug 10 MVP review slide.
