package com.yourname.yournamemart.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Password hashing per Section 2, rule 2 and Section 9 checklist:
 * bcrypt only, no plaintext, no MD5/SHA1-only hashing.
 *
 * Maven dependency (add to pom.xml if not already present):
 *
 * <dependency>
 *   <groupId>org.mindrot</groupId>
 *   <artifactId>jbcrypt</artifactId>
 *   <version>0.4</version>
 * </dependency>
 */
public final class PasswordUtil {

    private static final int WORK_FACTOR = 12;

    private PasswordUtil() {}

    /** Hash a plaintext password for storage. Never log the input or output. */
    public static String hash(String plaintextPassword) {
        if (plaintextPassword == null || plaintextPassword.isBlank()) {
            throw new IllegalArgumentException("Password must not be blank.");
        }
        return BCrypt.hashpw(plaintextPassword, BCrypt.gensalt(WORK_FACTOR));
    }

    /** Verify a login attempt against the stored bcrypt hash. */
    public static boolean verify(String plaintextPassword, String storedHash) {
        if (plaintextPassword == null || storedHash == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(plaintextPassword, storedHash);
        } catch (IllegalArgumentException e) {
            // storedHash wasn't a valid bcrypt hash (e.g. legacy/plaintext row)
            return false;
        }
    }
}
