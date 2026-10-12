-- ========================================================
-- HỆ THỐNG FLASHMART - BÁO CÁO CHIẾN DỊCH SIÊU SALE
-- Sinh viên thực hiện: Data Engineer
-- ========================================================

CREATE DATABASE IF NOT EXISTS flashmart_db;
USE flashmart_db;

-- 1. Tạo bảng và chèn dữ liệu mẫu
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Chèn dữ liệu mẫu
INSERT INTO Customers VALUES 
(1, 'Alice'), 
(2, 'Bob'), 
(3, 'Charlie'); -- Charlie chưa từng mua hàng

INSERT INTO Products VALUES 
(101, 'Laptop'), 
(102, 'Mouse'), 
(103, 'Keyboard'); -- Keyboard chưa từng được ai mua

INSERT INTO Orders VALUES 
(1001, 1, 101), 
(1002, 1, 102), 
(1003, 2, 101);

-- ========================================================
-- YÊU CẦU 1: Báo cáo Marketing
-- Lấy danh sách TẤT CẢ khách hàng kèm số lượng đơn đã mua.
-- Khách chưa mua phải có số lượng là 0 (để tặng Voucher 50%).
--
-- [Giải pháp]:
-- Dùng LEFT JOIN để giữ lại toàn bộ khách hàng từ bảng Customers.
-- Sử dụng COUNT(o.order_id) thay vì COUNT(*) để khi o.order_id là NULL 
-- (khách chưa mua) thì hàm COUNT sẽ trả về đúng bằng 0.
-- ========================================================

SELECT 
    c.customer_id, 
    c.name, 
    COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- ========================================================
-- YÊU CẦU 2: Báo cáo Kho vận (Sản phẩm tồn kho / ế)
-- Tìm các sản phẩm chưa từng phát sinh đơn hàng nào để thanh lý.
--
-- [Giải pháp]:
-- Áp dụng kỹ thuật Anti-Join: Dùng LEFT JOIN giữa Products và Orders,
-- sau đó thêm điều kiện WHERE o.order_id IS NULL để lọc ra các sản phẩm
-- không có bản ghi khớp bên bảng Orders.
-- ========================================================

SELECT 
    p.product_id, 
    p.product_name
FROM Products p
LEFT JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;
