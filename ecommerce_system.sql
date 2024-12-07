
-- Step 1: Create the database
CREATE DATABASE ecommerce;

USE ecommerce;

-- Step 2: Create the customers table
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL
);

-- Insert data into customers table
INSERT INTO customers (name, email, address) VALUES
('Alice Johnson', 'alice.johnson@example.com', '123 Maple Drive, Atlanta, GA'),
('Bob Carter', 'bob.carter@example.com', '456 Oak Street, Phoenix, AZ'),
('Catherine Brooks', 'catherine.brooks@example.com', '789 Pine Avenue, Dallas, TX'),
('David Stone', 'david.stone@example.com', '101 Birch Lane, Chicago, IL'),
('Eva Green', 'eva.green@example.com', '202 Cedar Road, Orlando, FL'),
('Frank Miller', 'frank.miller@example.com', '303 Walnut Way, Seattle, WA'),
('Grace Hall', 'grace.hall@example.com', '404 Elm Boulevard, Boston, MA'),
('Henry Lee', 'henry.lee@example.com', '505 Willow Circle, Miami, FL'),
('Isla Turner', 'isla.turner@example.com', '606 Aspen Drive, Denver, CO'),
('Jack Wilson', 'jack.wilson@example.com', '707 Fir Path, San Francisco, CA');

-- Step 3: Create the products table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DOUBLE(10,2) NOT NULL,
    description VARCHAR(255),
    discount DOUBLE(10,2) DEFAULT 0.00
);

-- Insert data into products table
INSERT INTO products (name, price, description) VALUES
('Laptop Pro', 1200.00, '16-inch laptop with M1 chip and 512GB storage'),
('Wireless Earbuds', 150.00, 'Noise-cancelling wireless earbuds with 8-hour battery'),
('Smart Watch', 300.00, 'GPS-enabled smartwatch with heart rate monitor'),
('Gaming Console X', 500.00, 'Next-gen gaming console with 8K support'),
('4K Monitor', 350.00, '32-inch 4K UHD monitor with HDR10 support'),
('Mechanical Keyboard', 100.00, 'RGB mechanical keyboard with blue switches'),
('Bluetooth Speaker XL', 250.00, 'Premium portable speaker with surround sound'),
('Smart Home Hub', 200.00, 'Smart home controller with voice assistant'),
('Drone Mini', 500.00, 'Compact drone with 4K camera and GPS tracking'),
('Electric Bike', 800.00, 'Folding electric bike with 50-mile range');

-- Step 4: Create the orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Insert data into orders table
INSERT INTO orders (customer_id, order_date) VALUES
(1, '2024-12-01'),
(2, '2024-12-02'),
(3, '2024-12-03'),
(4, '2024-12-04'),
(5, '2024-12-05'),
(6, '2024-12-06'),
(7, '2024-12-07'),
(8, '2024-12-08'),
(9, '2024-12-09'),
(10, '2024-12-10');

-- Step 5: Create the order_items table
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    total_amount DOUBLE(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Insert data into order_items table
INSERT INTO order_items (order_id, product_id, quantity, total_amount) VALUES
(1, 1, 1, 1200.00), -- Alice ordered Laptop Pro
(2, 2, 2, 300.00),  -- Bob ordered 2 Wireless Earbuds
(3, 3, 1, 300.00),  -- Catherine ordered Smart Watch
(4, 4, 4, 500.00),  -- David ordered Gaming Console X
(5, 5, 5, 350.00),  -- Eva ordered 4K Monitor
(6, 6, 6, 100.00),  -- Frank ordered Mechanical Keyboard
(7, 7, 7, 500.00),  -- Grace ordered Bluetooth Speaker XL
(8, 8, 1, 200.00),  -- Henry ordered Smart Home Hub
(9, 9, 9, 500.00),  -- Isla ordered Drone Mini
(10, 10, 10, 800.00); -- Jack ordered Electric Bike

-- Queries

-- 1. Retrieve all customers who have placed an order in the last 30 days
SELECT DISTINCT c.id, c.name, c.email, c.address
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY;

-- 2. Get the total amount of all orders placed by each customer
SELECT c.name, SUM(oi.total_amount) AS total_order_amount
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
GROUP BY c.id, c.name;

-- 3. Update the price of Wireless Earbuds to 120.00
UPDATE products
SET price = 120.00
WHERE name = 'Wireless Earbuds';

-- 4. Add a new column discount to the products table
ALTER TABLE products
ADD discount DOUBLE(10,2);

-- 5. Retrieve the top 3 products with the highest price
SELECT * 
FROM products 
ORDER BY price DESC 
LIMIT 3;

-- 6. Get the names of customers who have ordered the Laptop Pro
SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE p.name = 'Laptop Pro';

-- 7. Join the orders and customers tables to retrieve the customer's name and order date
SELECT c.name, o.order_date
FROM customers c
JOIN orders o ON c.id = o.customer_id;

-- 8. Retrieve the orders with a total amount greater than 300.00
SELECT o.id, SUM(oi.total_amount) AS total_order_amount
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id
HAVING total_order_amount > 300.00;

-- 9. Retrieve the average total of all orders
SELECT AVG(total_amount) AS average_order_total
FROM order_items;
