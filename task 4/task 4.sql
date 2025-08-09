CREATE DATABASE Ecommerce_SQL_Database;
USE Ecommerce_SQL_Database;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    country VARCHAR(50)
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers (first_name, last_name, email, country) VALUES
('John', 'Smith', 'john@example.com', 'USA'),
('Emma', 'Johnson', 'emma@example.com', 'UK'),
('Liam', 'Brown', 'liam@example.com', 'Canada');

INSERT INTO products (product_name, category, price) VALUES
('T-Shirt', 'Clothing', 50.00),
('Jeans', 'Clothing', 30.00),
('Laptop Bag', 'Accessories', 150.00);

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-05-01', 250.00),
(2, '2024-05-03', 150.00),
(1, '2024-05-10', 300.00);

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 50.00),
(1, 2, 3, 30.00),
(2, 3, 1, 150.00);

-- 1. SELECT, WHERE, ORDER BY
SELECT customer_id, first_name, last_name, country
FROM customers
WHERE country = 'USA'
ORDER BY last_name ASC;

-- 2. GROUP BY + Aggregate
SELECT c.customer_id, c.first_name, c.last_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- 3. INNER JOIN
SELECT o.order_id, o.order_date, c.first_name, c.last_name, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- 4. LEFT JOIN
SELECT c.customer_id, c.first_name, o.order_id, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- 5. RIGHT JOIN
SELECT o.order_id, o.total_amount, c.first_name
FROM orders o
RIGHT JOIN customers c ON o.customer_id = c.customer_id;

-- 6. Subquery
SELECT customer_id, first_name, last_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) > (
        SELECT AVG(total_amount) FROM orders
    )
);

-- 7. Aggregate Functions
SELECT AVG(total_amount) AS avg_order,
       MIN(total_amount) AS min_order,
       MAX(total_amount) AS max_order
FROM orders;

-- 8. Create View
CREATE VIEW top_customers AS
SELECT c.customer_id, c.first_name, c.last_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(o.total_amount) > 200;
SELECT * FROM top_customers;


-- 9. Index for Optimization
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_products_category ON products(category);
SHOW INDEXES FROM orders;
SHOW INDEXES FROM products;
