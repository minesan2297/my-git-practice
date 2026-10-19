-- Database script for Final Exam: Product Management
CREATE DATABASE IF NOT EXISTS product_management_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE product_management_db;

-- Tạo bảng products
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    price DOUBLE NOT NULL,
    quantity INT NOT NULL
);

-- Thêm dữ liệu mẫu ban đầu
INSERT INTO products (name, price, quantity) VALUES
('iPhone 15 Pro Max 256GB', 1199.99, 25),
('Samsung Galaxy S24 Ultra', 1299.50, 18),
('MacBook Pro M3 14-inch', 1999.00, 12),
('Tai nghe Sony WH-1000XM5', 399.00, 30),
('Chuột không dây Logitech MX Master 3S', 99.90, 50),
('Bàn phím cơ Keychron K2 Pro', 120.00, 35);
