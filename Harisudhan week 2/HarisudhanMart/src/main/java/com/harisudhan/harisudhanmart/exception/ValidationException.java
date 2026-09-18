package com.harisudhan.harisudhanmart.exception;

/** Thrown when a service-layer validation rule fails before any DAO call is made. */
public class ValidationException extends Exception {

    private final String field;

    public ValidationException(String field, String message) {
        super(message);
        this.field = field;
    }

    public String getField() {
        return field;
    }

    public String getFieldErrorCode() {
        return "VALIDATION_ERROR";
    }
}
