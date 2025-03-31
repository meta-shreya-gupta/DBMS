-- Orders
CREATE INDEX idx_order_user ON Orders (User_id);
CREATE INDEX idx_order_date ON orders (Order_Date);

-- Product
CREATE INDEX idx_product_name ON Product (Product_Title);
CREATE INDEX idx_product_price ON Product (Price);

-- Category
CREATE INDEX idx_category_parent ON Category (Parent_Category);