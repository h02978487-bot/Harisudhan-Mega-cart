// Add these methods to your existing OrderService
// File: src/main/java/com/yourname/yournamemart/service/OrderService.java

private static final String[] VALID_STATUSES = {"PENDING", "CONFIRMED", "SHIPPED", "DELIVERED", "CANCELLED"};
private static final Map<String, Set<String>> ALLOWED_TRANSITIONS = Map.ofEntries(
    Map.entry("PENDING", Set.of("CONFIRMED", "CANCELLED")),
    Map.entry("CONFIRMED", Set.of("SHIPPED", "CANCELLED")),
    Map.entry("SHIPPED", Set.of("DELIVERED")),
    Map.entry("DELIVERED", Set.of()),
    Map.entry("CANCELLED", Set.of())
);

@Override
public Order updateOrderStatus(long orderId, String newStatus) {
    // Validation: check if status is valid enum value
    if (!isValidStatus(newStatus)) {
        throw new ValidationException("Invalid status: " + newStatus);
    }

    // Get current order
    Order order = orderDAO.findById(orderId);
    if (order == null) {
        throw new ValidationException("Order not found");
    }

    // Check if transition is allowed
    if (!isTransitionAllowed(order.getStatus(), newStatus)) {
        throw new ValidationException(
            String.format("Cannot transition from %s to %s", order.getStatus(), newStatus)
        );
    }

    // Perform transition
    Order updated = orderDAO.updateOrderStatus(orderId, newStatus);
    logger.info("Order {} status updated: {} -> {}", orderId, order.getStatus(), newStatus);
    return updated;
}

@Override
public List<Order> getOrdersByStatus(String status) {
    if (!isValidStatus(status)) {
        throw new ValidationException("Invalid status: " + status);
    }
    return orderDAO.getOrdersByStatus(status);
}

@Override
public List<Order> getSellerOrdersByStatus(long sellerId, String status) {
    if (!isValidStatus(status)) {
        throw new ValidationException("Invalid status: " + status);
    }
    return orderDAO.getOrdersBySellerAndStatus(sellerId, status);
}

private boolean isValidStatus(String status) {
    if (status == null) return false;
    for (String valid : VALID_STATUSES) {
        if (valid.equals(status)) return true;
    }
    return false;
}

private boolean isTransitionAllowed(String currentStatus, String newStatus) {
    Set<String> allowed = ALLOWED_TRANSITIONS.get(currentStatus);
    return allowed != null && allowed.contains(newStatus);
}
