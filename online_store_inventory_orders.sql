-- Creating the 'products' table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    stock_quantity INT
);

-- Creating the 'customers' table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

-- Creating the 'orders' table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Creating the 'order_items' table
CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Inserting data into the 'products' table
INSERT INTO products (product_name, price, stock_quantity)
VALUES 
    ('Laptop', 1500.00, 10),
    ('Smartphone', 800.00, 20),
    ('Headphones', 150.00, 50),
    ('Smartwatch', 300.00, 30),
    ('Tablet', 600.00, 15);

-- Inserting data into the 'customers' table
INSERT INTO customers (first_name, last_name, email)
VALUES 
    ('Alice', 'Johnson', 'alice.johnson@gmail.com'),
    ('Bob', 'Smith', 'bob.smith@gmail.com'),
    ('Charlie', 'Brown', 'charlie.brown@gmail.com'),
    ('Diana', 'Prince', 'diana.prince@gmail.com');

-- Inserting data into the 'orders' table
INSERT INTO orders (customer_id, order_date)
VALUES 
    (1, '2023-09-15'),
    (2, '2023-09-16'),
    (3, '2023-09-17'),
    (1, '2023-09-18'),
    (4, '2023-09-19');

-- Inserting data into the 'order_items' table
INSERT INTO order_items (order_id, product_id, quantity)
VALUES 
    (1, 1, 1),  -- Alice orders 1 Laptop
    (1, 3, 2),  -- Alice orders 2 Headphones
    (2, 2, 1),  -- Bob orders 1 Smartphone
    (2, 4, 1),  -- Bob orders 1 Smartwatch
    (3, 5, 2),  -- Charlie orders 2 Tablets
    (4, 1, 1),  -- Alice orders 1 Laptop again
    (4, 4, 1),  -- Alice orders 1 Smartwatch
    (5, 3, 3),  -- Diana orders 3 Headphones
    (5, 5, 1);  -- Diana orders 1 Tablet

-- 1. Retrieve the names and stock quantities of all products
SELECT product_name, stock_quantity
FROM products;

-- 2. Retrieve the product names and quantities for one of the orders placed (e.g., order ID = 1)
SELECT products.product_name, order_items.quantity
FROM order_items
JOIN products ON order_items.product_id = products.id
WHERE order_items.order_id = 1;

-- 3. Retrieve all orders placed by a specific customer (e.g., customer Alice Johnson, ID = 1), including product IDs and quantities
SELECT orders.id AS order_id, products.product_name, order_items.quantity
FROM orders
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id
WHERE orders.customer_id = 1;

-- Updating stock quantities after Alice's order (order ID = 1)
UPDATE products
SET stock_quantity = stock_quantity - order_items.quantity
FROM order_items
WHERE products.id = order_items.product_id
AND order_items.order_id = 1;

-- Deleting all order items related to order ID = 2
DELETE FROM order_items
WHERE order_id = 2;

-- Deleting the order itself (order ID = 2)
DELETE FROM orders
WHERE id = 2;
