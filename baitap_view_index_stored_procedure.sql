-- ========================================================
-- [Bài tập] View, Index, Stored Procedure tổng hợp
-- Cơ sở dữ liệu: demo
-- ========================================================

-- ========================================================
-- BƯỚC 1: TẠO CƠ SỞ DỮ LIỆU DEMO
-- ========================================================
CREATE DATABASE IF NOT EXISTS demo;
USE demo;

-- ========================================================
-- BƯỚC 2: TẠO BẢNG PRODUCTS VÀ CHÈN DỮ LIỆU MẪU
-- ========================================================
DROP TABLE IF EXISTS Products;

CREATE TABLE Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(20) NOT NULL,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(10,2) NOT NULL,
    productAmount INT NOT NULL,
    productDescription TEXT,
    productStatus VARCHAR(20) DEFAULT 'Available'
);

-- Chèn dữ liệu mẫu vào bảng Products
INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus) VALUES
('P001', 'iPhone 15 Pro', 999.00, 50, 'Apple smartphone 128GB', 'Available'),
('P002', 'Samsung Galaxy S24', 899.00, 40, 'Samsung flagship phone', 'Available'),
('P003', 'MacBook Air M2', 1199.00, 30, 'Apple 13-inch laptop', 'Available'),
('P004', 'Sony WH-1000XM5', 399.00, 60, 'Wireless noise canceling headphones', 'Available'),
('P005', 'iPad Air 5', 599.00, 25, 'Apple tablet 64GB', 'Out of Stock');


-- ========================================================
-- BƯỚC 3: THỰC HÀNH TẠO INDEX VÀ KHẢO SÁT BẰNG EXPLAIN
-- ========================================================

-- Khảo sát trước khi tạo index (kết quả: type = ALL - Full Table Scan):
EXPLAIN SELECT * FROM Products WHERE productCode = 'P003';
EXPLAIN SELECT * FROM Products WHERE productName = 'iPhone 15 Pro' AND productPrice = 999.00;

-- 1. Tạo Unique Index trên cột productCode:
CREATE UNIQUE INDEX idx_productCode ON Products(productCode);

-- 2. Tạo Composite Index trên 2 cột productName và productPrice:
CREATE INDEX idx_name_price ON Products(productName, productPrice);

-- Khảo sát sau khi tạo index:
-- - Truy vấn theo productCode: type chuyển sang 'const', rows = 1 (do Unique Index)
EXPLAIN SELECT * FROM Products WHERE productCode = 'P003';

-- - Truy vấn theo productName và productPrice: type chuyển sang 'ref', sử dụng idx_name_price
EXPLAIN SELECT * FROM Products WHERE productName = 'iPhone 15 Pro' AND productPrice = 999.00;


-- ========================================================
-- BƯỚC 4: THỰC HÀNH VIEW (TẠO, SỬA ĐỔI, XOÁ)
-- ========================================================

-- 1. Tạo view lấy về các thông tin: productCode, productName, productPrice, productStatus
CREATE OR REPLACE VIEW view_products AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;

-- Truy vấn dữ liệu từ view:
SELECT * FROM view_products;

-- 2. Tiến hành sửa đổi view (thêm cột productAmount và lọc chỉ sản phẩm còn hàng)
CREATE OR REPLACE VIEW view_products AS
SELECT productCode, productName, productPrice, productAmount, productStatus
FROM Products
WHERE productStatus = 'Available';

-- Kiểm tra lại view sau khi sửa đổi:
SELECT * FROM view_products;

-- 3. Tiến hành xoá view
DROP VIEW IF EXISTS view_products;


-- ========================================================
-- BƯỚC 5: THỰC HÀNH STORED PROCEDURE (CRUD CƠ BẢN)
-- ========================================================

-- 1. Stored Procedure lấy tất cả thông tin của tất cả sản phẩm
DELIMITER //

DROP PROCEDURE IF EXISTS getAllProducts //

CREATE PROCEDURE getAllProducts()
BEGIN
    SELECT * FROM Products;
END //

DELIMITER ;

-- Gọi thủ tục lấy tất cả sản phẩm:
CALL getAllProducts();


-- 2. Stored Procedure thêm một sản phẩm mới
DELIMITER //

DROP PROCEDURE IF EXISTS addProduct //

CREATE PROCEDURE addProduct(
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10,2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status VARCHAR(20)
)
BEGIN
    INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
    VALUES (p_code, p_name, p_price, p_amount, p_desc, p_status);
END //

DELIMITER ;

-- Gọi thủ tục thêm sản phẩm:
CALL addProduct('P006', 'Dell XPS 13', 1299.00, 15, 'Dell Ultrabook 16GB RAM', 'Available');
CALL getAllProducts();


-- 3. Stored Procedure sửa thông tin sản phẩm theo Id
DELIMITER //

DROP PROCEDURE IF EXISTS updateProductById //

CREATE PROCEDURE updateProductById(
    IN p_id INT,
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10,2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE Products 
    SET productCode = p_code,
        productName = p_name,
        productPrice = p_price,
        productAmount = p_amount,
        productDescription = p_desc,
        productStatus = p_status
    WHERE Id = p_id;
END //

DELIMITER ;

-- Gọi thủ tục cập nhật sản phẩm có Id = 1:
CALL updateProductById(1, 'P001', 'iPhone 15 Pro Max', 1099.00, 45, 'Updated 256GB version', 'Available');
CALL getAllProducts();


-- 4. Stored Procedure xoá sản phẩm theo Id
DELIMITER //

DROP PROCEDURE IF EXISTS deleteProductById //

CREATE PROCEDURE deleteProductById(
    IN p_id INT
)
BEGIN
    DELETE FROM Products WHERE Id = p_id;
END //

DELIMITER ;

-- Gọi thủ tục xóa sản phẩm vừa thêm (ví dụ Id = 6 hoặc sản phẩm tương ứng):
CALL deleteProductById(6);
CALL getAllProducts();
