package com.yourname.yournamemart.dao;

/**
 * Small seam the ReviewService needs from your existing order data access
 * code, so a review can only be left on a DELIVERED order that actually
 * contains the product being reviewed (F8 requires reviews on "completed
 * orders" only).
 *
 * You almost certainly already have an OrderDAO / OrderItemDAO from earlier
 * weeks - either make those classes implement this interface, or delete this
 * file and call your existing DAOs directly from ReviewService instead.
 */
public interface OrderLookupForReview {

    /**
     * @return true if orderId belongs to buyerId, is in DELIVERED status,
     *         and its order_items include productId.
     */
    boolean isDeliveredOrderContainingProduct(long orderId, long buyerId, long productId);
}
