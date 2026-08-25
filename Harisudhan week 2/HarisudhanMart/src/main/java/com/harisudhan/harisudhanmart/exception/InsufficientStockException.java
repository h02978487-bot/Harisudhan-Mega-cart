package com.harisudhan.harisudhanmart.exception;

/** Thrown mid-checkout when a product no longer has enough stock; triggers a full rollback. */
public class InsufficientStockException extends Exception {
    public InsufficientStockException(String message) {
        super(message);
    }
}
