package com.yourname.yournamemart.exception;

/**
 * Wraps SQLException so the service/controller layers never see raw JDBC
 * exceptions (Section 2 - DAO layer owns all SQL and its failure modes).
 */
public class DataAccessException extends RuntimeException {

    public DataAccessException(String message, Throwable cause) {
        super(message, cause);
    }
}
