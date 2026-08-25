package com.harisudhan.harisudhanmart.exception;

/** Thrown when a requested entity (product, order, cart item...) does not exist. */
public class NotFoundException extends Exception {
    public NotFoundException(String message) {
        super(message);
    }
}
