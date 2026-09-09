package com.yourname.yournamemart.security;

import com.yourname.yournamemart.util.PasswordUtil;
import com.yourname.yournamemart.util.ValidationUtil;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Automates the parts of the Section 9 security checklist that CAN be
 * expressed as unit tests. SQL-injection-at-the-DB-layer and auth-bypass
 * on live protected routes still need the manual/Postman pass described
 * in Section 9 — this class covers the util-layer guarantees.
 */
class SecurityChecklistTest {

    @Test
    void passwordsAreBcryptHashedNotPlaintext() {
        String hash = PasswordUtil.hash("correct horse battery staple");

        assertNotEquals("correct horse battery staple", hash);
        assertTrue(hash.startsWith("$2a$") || hash.startsWith("$2b$"));
        assertTrue(PasswordUtil.verify("correct horse battery staple", hash));
        assertFalse(PasswordUtil.verify("wrong password", hash));
    }

    @Test
    void htmlEscapeNeutralizesScriptTagXssPayload() {
        String payload = "<script>alert('xss')</script>";
        String escaped = ValidationUtil.escapeHtml(payload);

        assertFalse(escaped.contains("<script>"));
        assertTrue(escaped.contains("&lt;script&gt;"));
    }

    @Test
    void htmlEscapeNeutralizesAttributeBreakoutPayload() {
        String payload = "\" onmouseover=\"alert(1)";
        String escaped = ValidationUtil.escapeHtml(payload);

        assertFalse(escaped.contains("\""));
    }

    @Test
    void emailValidationRejectsSqlInjectionStylePayload() {
        String payload = "' OR '1'='1";
        assertFalse(ValidationUtil.isValidEmail(payload));
    }
}
