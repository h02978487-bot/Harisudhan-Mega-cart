package com.yourname.yournamemart.util;

import java.util.regex.Pattern;

/**
 * Input validation + output escaping helpers.
 *
 * Section 2 rule 4 requires escaping user-supplied output before rendering
 * (JSTL <c:out> / fn:escapeXml in JSPs). Use escapeHtml() here only for the
 * cases where you're building JSON or plain strings by hand outside JSTL
 * (e.g. inside ChatServlet responses or Gson DTOs that get echoed back).
 */
public final class ValidationUtil {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[\\w.+-]+@[\\w-]+\\.[a-zA-Z]{2,}$");

    private ValidationUtil() {}

    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email).matches();
    }

    public static boolean isNonBlank(String value) {
        return value != null && !value.isBlank();
    }

    public static boolean isPositive(java.math.BigDecimal value) {
        return value != null && value.signum() > 0;
    }

    public static boolean isNonNegativeInt(int value) {
        return value >= 0;
    }

    /**
     * Manual HTML-escape fallback for contexts JSTL doesn't cover
     * (e.g. hand-built JSON strings, chatbot replies rendered via innerText
     * substitutes). Prefer <c:out>/fn:escapeXml in JSPs themselves.
     */
    public static String escapeHtml(String input) {
        if (input == null) return "";
        return input
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
}
