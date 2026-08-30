-- Week 4 Migration: Add soft delete and performance indexes

-- Add is_deleted column to products table
ALTER TABLE products ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE;

-- Create indexes for common queries
CREATE INDEX idx_products_seller_id ON products(seller_id);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_orders_buyer_id ON orders(buyer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_cart_items_user_id ON cart_items(user_id);

-- Composite index for seller's products by category
CREATE INDEX idx_products_seller_category ON products(seller_id, category);

-- Make sure users.email is indexed (for login queries)
CREATE UNIQUE INDEX idx_users_email ON users(email);
