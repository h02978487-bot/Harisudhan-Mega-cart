# Week 1 — Jul 27 to Aug 2
## Goal: Authentication + Base DAO Layer + Project Skeleton

---

## Tasks

### 1. Maven + Tomcat Project Setup
- Create Maven web project structure
- Add dependencies in `pom.xml`:
  - `javax.servlet-api` (Tomcat 9, Servlet 3.1)
  - `com.h2database:h2`
  - `com.zaxxer:HikariCP`
  - `org.mindrot:jbcrypt`
  - `com.google.code.gson:gson`
  - `javax.servlet:jstl`
  - `org.slf4j:slf4j-api` + `ch.qos.logback:logback-classic`
  - `org.junit.jupiter:junit-jupiter` + `org.mockito:mockito-core`
  - Checkstyle + SpotBugs Maven plugins
- Configure `web.xml` (Servlet 3.1, custom error pages for 404/500)
- Confirm project builds and deploys to local Tomcat 9.0.x

### 2. Database Schema
Create `db/migrations/V1__init_schema.sql`:

```sql
CREATE TABLE users (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('BUYER','SELLER','ADMIN') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  seller_id BIGINT NOT NULL REFERENCES users(id),
  name VARCHAR(200) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  stock_qty INT NOT NULL,
  category VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  buyer_id BIGINT NOT NULL REFERENCES users(id),
  status ENUM('PENDING','CONFIRMED','SHIPPED','DELIVERED','CANCELLED') DEFAULT 'PENDING',
  total_amount DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL REFERENCES orders(id),
  product_id BIGINT NOT NULL REFERENCES products(id),
  quantity INT NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL
);

CREATE TABLE cart_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id),
  product_id BIGINT NOT NULL REFERENCES products(id),
  quantity INT NOT NULL
);

CREATE TABLE reviews (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT NOT NULL REFERENCES products(id),
  user_id BIGINT NOT NULL REFERENCES users(id),
  rating INT NOT NULL,
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Create `db/seed.sql`: 1 admin, 2 sellers, 2 buyers, 5 sample products.

### 3. Package Structure
Under `com.harisudhan.harisudhanmart`, create:
- `controller` — Servlets (thin, no SQL, no business logic)
- `service` — Business rules
- `dao` — Interfaces + JDBC implementations
- `model` — POJOs: User, Product, Order, OrderItem, CartItem, Review
- `dto` — UserResponseDTO (no passwordHash), ProductDTO, OrderDTO
- `filter` — AuthFilter, EncodingFilter
- `listener` — AppContextListener
- `util` — PasswordUtil, ValidationUtil, JsonUtil
- `exception` — Custom exceptions

### 4. HikariCP Listener
`AppContextListener implements ServletContextListener`:
- `contextInitialized` → create HikariDataSource, store in `ServletContext`
- `contextDestroyed` → close pool
- Local JDBC URL: `jdbc:h2:./data/harisudhanmart`

### 5. Model POJOs
Create with all fields + getters/setters + Javadoc:
`User`, `Product`, `Order`, `OrderItem`, `CartItem`, `Review`

### 6. DAO Layer (this week: User + Product)
- Interfaces: `UserDAO`, `ProductDAO`
- Implementations: `UserDAOImpl`, `ProductDAOImpl`
- Rules: PreparedStatement only, try-with-resources on every Connection/Statement/ResultSet

### 7. Authentication — Feature F1
**PasswordUtil**: `hashPassword(plain)` and `checkPassword(plain, hash)` using jBCrypt

**UserService**:
- `register(name, email, password, role)` — validate, hash password, call DAO
- `login(email, password)` — fetch user by email, verify hash, return User

**Servlets**:
- `RegisterServlet` (POST `/register`) → validate → service.register → redirect to login
- `LoginServlet` (POST `/login`) → service.login → `request.getSession(false).invalidate()` → `request.getSession(true)` → store user in session → redirect to home
- `LogoutServlet` (GET `/logout`) → `session.invalidate()` → redirect to login

**AuthFilter**:
- Protects all URLs except `/login`, `/register`, `/static/*`
- If no valid session → redirect to `/login`

### 8. JSP Pages (Week 1)
- `register.jsp` — form: name, email, password, role (BUYER/SELLER)
- `login.jsp` — form: email, password
- Use `<c:out value="${...}"/>` for all user-supplied output (JSTL)

### 9. GitHub Actions CI
`.github/workflows/build.yml`:
```yaml
name: build-and-test
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with: { java-version: '17', distribution: 'temurin' }
      - run: mvn -B clean verify
```

---

## Minimum Commits This Week (3)
- `feat: initialize maven project and pom.xml dependencies`
- `feat: add V1 schema.sql and seed.sql`
- `feat: implement user registration, login, and AuthFilter`

## Definition of Done — Week 1
- [ ] Register a new BUYER/SELLER → stored in H2 with bcrypt hash
- [ ] Login → HttpSession created with new session ID → redirect home
- [ ] Logout → session invalidated → redirect login
- [ ] Unauthenticated request to protected URL → redirected to /login
- [ ] CI pipeline green on GitHub push
