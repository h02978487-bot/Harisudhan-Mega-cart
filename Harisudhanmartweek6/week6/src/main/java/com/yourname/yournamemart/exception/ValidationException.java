package com.yourname.yournamemart.exception;

/**
 * Thrown by the service layer when input fails validation, before any DAO
 * call is made (Section 13, rule 5). Carries the offending field so the
 * servlet can build a field-level VALIDATION_ERROR response.
 */
public class ValidationException extends RuntimeException {

    private final String field;

    public ValidationException(String field, String message) {
        super(message);
        this.field = field;
    }

    public String getField() {
        return field;
    }
}
