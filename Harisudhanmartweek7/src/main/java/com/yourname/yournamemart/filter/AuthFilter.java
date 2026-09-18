package com.yourname.yournamemart.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

/**
 * Enforces session-based authentication on protected routes.
 *
 * NOTE: If your project still uses javax.servlet.* (Tomcat 9 / Servlet 4.0,
 * as the spec's Section 3 tech stack lists), change every "jakarta.servlet"
 * import above to "javax.servlet" instead. Jakarta imports are for Tomcat 10+.
 *
 * Rule enforced (Section 2, engineering rule 3):
 *   - Session ID is regenerated on login (see LoginServlet, not this filter).
 *   - Unauthenticated requests to protected paths are rejected with 401
 *     rather than silently redirected, matching Section 13 API contract
 *     status codes for JSON endpoints. Adjust the response body if any of
 *     your endpoints are JSP-rendered instead of JSON.
 */
@WebFilter(urlPatterns = {
        "/api/v1/cart/*",
        "/api/v1/orders/*",
        "/api/v1/seller/*",
        "/api/v1/admin/*"
})
public class AuthFilter implements Filter {

    // Paths within the protected prefixes above that should remain public.
    private static final Set<String> PUBLIC_EXCEPTIONS = Set.of(
            // e.g. "/api/v1/products/search" if you mount search under a
            // protected prefix by mistake — otherwise leave this empty.
    );

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getRequestURI().substring(request.getContextPath().length());

        if (PUBLIC_EXCEPTIONS.contains(path)) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        Object userId = (session != null) ? session.getAttribute("userId") : null;

        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write(
                "{\"success\":false,\"data\":null,\"error\":{\"code\":\"UNAUTHENTICATED\",\"message\":\"Login required.\"}}"
            );
            return;
        }

        // Role-based restriction for /admin/* and /seller/* — adapt attribute
        // name ("role") to whatever your session actually stores.
        if (path.startsWith("/api/v1/admin/") && !"ADMIN".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write(
                "{\"success\":false,\"data\":null,\"error\":{\"code\":\"FORBIDDEN\",\"message\":\"Admin access required.\"}}"
            );
            return;
        }

        if (path.startsWith("/api/v1/seller/") && !"SELLER".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write(
                "{\"success\":false,\"data\":null,\"error\":{\"code\":\"FORBIDDEN\",\"message\":\"Seller access required.\"}}"
            );
            return;
        }

        chain.doFilter(req, res);
    }
}
