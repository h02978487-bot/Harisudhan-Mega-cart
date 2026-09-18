# Week 7 — Sep 7 to Sep 13
## Goal: Security Checklist + Unit/DAO Test Coverage Complete

---

## Tasks

### 1. Security Checklist (Must complete before Sep 21)

Run each check and document the result:

#### SQL Injection Prevention
```bash
grep -rn "Statement)" src/
# Every result must be PreparedStatement — no Statement or createStatement
```
- Fix any found plain `Statement` usage immediately
- Never concatenate user input into SQL

#### Password Security
- Passwords are bcrypt-hashed via jBCrypt — verify in `PasswordUtil`
- Passwords are never logged (search `logger` calls for "password")
- No MD5/SHA1 anywhere: `grep -rn "MD5\|SHA1\|MessageDigest" src/`

#### Session Security
- `request.getSession(false).invalidate()` called before login
- `request.getSession(true)` creates new session after login
- `session.setMaxInactiveInterval(1800)` (30 minutes) set on login
- `session.getAttribute("user")` checked in AuthFilter for every protected route

#### XSS Prevention
- All user-supplied output wrapped in `<c:out value="${...}"/>` in every JSP
- No raw `${param.something}` or `<%= ... %>` with user input
- Check: `grep -rn "\${param\." src/main/webapp/`

#### Auth Bypass Check
- Visit `/seller/products` without logging in → must redirect to /login (not show page)
- Visit `/admin/users` as BUYER → must return 403
- Visit `/api/v1/cart` without session → must return 401

#### Config Security
- `config.properties` (with DB credentials) is in `.gitignore`
- `.env.example` committed with placeholder values only
- `grep -rn "password" src/` — no hardcoded passwords in Java source

#### Error Pages
- Trigger a 500 error (e.g., pass bad data) → custom error page shown, no stack trace

### 2. Complete Test Coverage

#### DAO Tests (JUnit 5, H2 in-memory)
Test DB URL: `jdbc:h2:mem:test;DB_CLOSE_DELAY=-1`
Initialize from `schema.sql` in `@BeforeAll`.

Required test classes:
- `UserDAOTest`: save, findByEmail, duplicate email throws
- `ProductDAOTest`: save, findAll, findBySeller, findByKeyword, delete
- `CartDAOTest`: addItem, getItems, updateQuantity, removeItem, clearCart
- `OrderDAOTest`: createOrder, addOrderItem, getOrdersByBuyer, updateStatus
- `ReviewDAOTest`: addReview, getReviewsByProduct, hasReviewed, getAvgRating

#### Service Tests (JUnit 5 + Mockito)
Mock all DAOs. Test:
- `UserServiceTest`: register success, register duplicate email, login wrong password
- `ProductServiceTest`: create valid listing, create with blank name (throws), unauthorized delete
- `OrderServiceTest`: placeOrder success, placeOrder insufficient stock, invalid status transition
- `ReviewServiceTest`: submit review success, submit without DELIVERED order (throws), duplicate (throws)

#### Servlet Tests (Mockito mocks)
- Mock `HttpServletRequest`, `HttpServletResponse`, `HttpSession`
- Test: LoginServlet valid credentials → 302 redirect, invalid → 401
- Test: CartServlet add item → 200, unauthenticated → 401

### 3. Load Test
Using Apache JMeter or `ab` (Apache Benchmark):
```bash
ab -n 100 -c 10 -t 60 http://localhost:8080/harisudhanmart/products
```
- Minimum: 10 concurrent users, 60 seconds
- Record results in `docs/load-test-results.md`: requests/sec, avg response time, errors

### 4. CI Verification
Confirm `.github/workflows/build.yml` runs:
- Checkstyle → zero major violations
- SpotBugs → zero high-priority bugs
- All unit + DAO tests pass
- Check CI logs on GitHub Actions — must be fully green

### 5. README Update
`README.md` must include (for Sep 21 review):
- Problem statement (2–3 sentences)
- Architecture diagram (D3 sequence diagram or link)
- Tech stack table
- Setup instructions (clone → mvn clean package → deploy to Tomcat)
- Deployed live URL
- Screenshots: home page, product list, cart, checkout, seller dashboard, admin panel

### 6. API Documentation
`docs/api.md` — document every endpoint:
```
GET /api/v1/products?keyword=&category=
  Auth: optional
  Response: { success, data: { products: [...], total: N } }

POST /api/v1/cart
  Auth: BUYER session required
  Body: { productId, quantity }
  Response: { success, data: { cartItem } }
  Errors: 400 out of stock, 401 unauthenticated
```
(document all /api/v1/* routes)

---

## Minimum Commits This Week (3)
- `test: complete DAO and service test coverage`
- `security: implement full security checklist`
- `docs: update README, API docs, load test results`

## Definition of Done — Week 7
- [ ] Security checklist 100% complete (document each item pass/fail)
- [ ] All DAO tests passing against H2 in-memory
- [ ] All service tests passing with Mockito mocks
- [ ] CI fully green (Checkstyle, SpotBugs, tests)
- [ ] Load test run and results documented
- [ ] README complete with live URL, screenshots, setup instructions
- [ ] API documentation complete

---

## NEXT: Sep 21 Full Build Review Requirements
After Week 7, you move to deployment (Week 8). By Sep 21 you need:
- All F1–F8 working on a live public URL
- Security checklist done (this week)
- Test suite passing in CI (this week)
- README complete (this week)
- Deploy link submitted by Sep 21
