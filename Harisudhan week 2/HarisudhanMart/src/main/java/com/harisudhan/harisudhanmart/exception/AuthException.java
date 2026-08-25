package com.harisudhan.harisudhanmart.exception;

/** Thrown on login/authorization failure. Carries the HTTP status the servlet should return. */
public class AuthException extends Exception {

    private final int statusCode;

    public AuthException(String message, int statusCode) {
        super(message);
        this.statusCode = statusCode;
    }

    public int getStatusCode() {
        return statusCode;
    }
}
