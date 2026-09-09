# Week 7 Deliverable — YourNameMart

Scope (per Section 6, Week 7): **security requirements implemented + unit
and DAO test coverage completed.**

This ZIP is a **drop-in addition** to your existing Maven project, not a
full standalone app — I don't have your Weeks 1–6 codebase in this
conversation, so these files use the package name and class names from
your spec (`com.yourname.yournamemart`, `ProductDAO`, `OrderService`, etc.).
**Rename to match your actual classes before committing.**

## What's in here

```
src/main/java/com/yourname/yournamemart/
  filter/AuthFilter.java          -> session + role check on protected routes
  filter/EncodingFilter.java      -> forces UTF-8 on every request
  util/PasswordUtil.java          -> bcrypt hash/verify (jBCrypt)
  util/ValidationUtil.java        -> email/blank/positive checks + HTML escape

src/main/webapp/WEB-INF/
  web-fragment-week7.xml          -> <error-page> entries to merge into web.xml
  views/error/404.jsp
  views/error/500.jsp             -> no stack traces exposed

src/test/java/com/yourname/yournamemart/
  dao/ProductDAOTest.java         -> JUnit 5 against jdbc:h2:mem:test
  service/OrderServiceTest.java   -> JUnit 5 + Mockito, DAO mocked
  security/SecurityChecklistTest.java -> bcrypt + escaping unit checks

SECURITY_CHECKLIST_WEEK7.md       -> Section 9 checklist + manual test steps
```

## How to integrate (do this today, before pushing)

1. **Unzip into your existing project root** so the `src/` folders merge
   with your own (don't overwrite files with the same name — diff first).
2. **Rename** `com.yourname.yournamemart` to your actual package
   (e.g. `com.aditya.adityamart`) throughout — find/replace in your IDE.
3. **Fix imports**: if your project targets Tomcat 9 / Servlet 4.0
   (`javax.servlet.*`, as Section 3 specifies), change every
   `jakarta.servlet` import in `AuthFilter.java` and `EncodingFilter.java`
   to `javax.servlet`.
4. **Add the jBCrypt dependency** to `pom.xml` if it isn't already there
   (version shown in `PasswordUtil.java`'s Javadoc).
5. **Wire the tests to your real DAO/Service classes** — `ProductDAOTest`
   and `OrderServiceTest` are templates using placeholder types
   (`Product`, `ProductDAOImpl`, `CartDAO`, `OrderServiceImpl`); rename to
   match your actual `model`/`dao`/`service` classes and constructor
   signatures.
6. **Merge `web-fragment-week7.xml`'s `<error-page>` block** into your
   `web.xml` (skip if you're using annotation-based config exclusively —
   the filters self-register via `@WebFilter`).
7. Run `mvn -B clean verify` locally — fix compile errors from the
   renaming pass before committing.
8. Work through `SECURITY_CHECKLIST_WEEK7.md` and check off each item
   against your real app.

## Committing (Section 8 rules apply)

```bash
git checkout -b feature/week7-security-and-tests
# copy/merge the files above into your working tree
git add .
git commit -m "feat: add AuthFilter, PasswordUtil, error pages"
git commit -m "test: add DAO and service unit test coverage"
git commit -m "docs: add Week 7 security checklist"
git push origin feature/week7-security-and-tests
# open a self-reviewed PR into main per Section 15
```

That gets you to 3 commits for the week on this branch alone — keep going
if you have more real changes to make (aim for 3/week minimum, spread
across the week rather than all at once, since Section 7's Final Review
checkpoint checks commit history across the *whole* window, not just this
week).
