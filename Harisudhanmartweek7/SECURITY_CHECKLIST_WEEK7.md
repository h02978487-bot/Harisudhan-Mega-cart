# Week 7 — Security Checklist (Section 9)

Complete before Sep 21 (Full Build + Deploy checkpoint). Check each box in
your own repo once verified against **your actual code**, not this template.

- [ ] Every query parameterized — run `grep -rn "Statement)" src/` and
      confirm every hit is `PreparedStatement`, none is a raw `Statement`.
- [ ] Passwords bcrypt-hashed via `PasswordUtil`, never logged anywhere
      (check Logback config doesn't log request bodies on the register/login
      endpoints).
- [ ] All protected servlets enforce session checks via `AuthFilter`
      (`/api/v1/cart/*`, `/api/v1/orders/*`, `/api/v1/seller/*`,
      `/api/v1/admin/*` — extend the `@WebFilter` url-patterns list if you
      have other protected prefixes).
- [ ] User-supplied input escaped before rendering — JSPs use `<c:out>` or
      `fn:escapeXml`; anything built as raw JSON strings by hand uses
      `ValidationUtil.escapeHtml()`.
- [ ] File upload (if implemented) validates type and size; never trusts a
      client-supplied filename. (Not required if you're using image URLs
      only, per F2.)
- [ ] Error pages (`404.jsp`, `500.jsp`) do not expose stack traces —
      verify by triggering a real exception and checking the rendered page.
- [ ] `config.properties` (DB credentials) excluded from version control —
      confirm it's listed in `.gitignore` and `git status` doesn't show it
      as tracked.

## Manual test pass (Section 9 table, "Security" row)

Run these against your **deployed or local** app, not just in your head:

1. **SQL injection**: try `' OR '1'='1` and `'; DROP TABLE users; --` in the
   login form and the product search box. Expect: login fails normally,
   search returns zero results — no error, no data leak.
2. **XSS**: create a product review with body
   `<script>alert(document.cookie)</script>`. Expect: the literal text
   renders on the page, no alert fires.
3. **Auth bypass**: while logged out (or logged in as a Buyer), call
   `/api/v1/seller/products` and `/api/v1/admin/users` directly (curl/Postman).
   Expect: 401 if logged out, 403 if logged in as the wrong role — never 200.
