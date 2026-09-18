package com.harisudhan.harisudhanmart.exception;

/** Thrown when an authenticated user tries to act on a resource they don't own/control. */
public class ForbiddenException extends Exception {
    public ForbiddenException(String message) {
        super(message);
    }
}
