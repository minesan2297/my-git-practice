-- ========================================================
-- [Thực hành] View trong MySQL
-- Cơ sở dữ liệu: classicmodels
-- ========================================================

USE classicmodels;

-- ========================================================
-- PHẦN 1: TẠO VIEW ĐẦU TIÊN
-- Tạo bảng ảo customer_views chứa thông tin cơ bản của khách hàng
-- ========================================================

CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName, phone
FROM customers;

-- Truy vấn dữ liệu từ bảng ảo (view):
SELECT * FROM customer_views;


-- ========================================================
-- PHẦN 2: CẬP NHẬT VIEW (CREATE OR REPLACE VIEW)
-- Thay đổi cấu trúc view để bổ sung thêm họ tên liên hệ và lọc theo thành phố Nantes
-- ========================================================

CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName, contactFirstName, contactLastName, phone
FROM customers
WHERE city = 'Nantes';

-- Truy vấn kiểm tra lại dữ liệu sau khi cập nhật view:
SELECT * FROM customer_views;


-- ========================================================
-- PHẦN 3: XÓA VIEW (DROP VIEW)
-- ========================================================

-- Xóa view customer_views khi không còn sử dụng:
DROP VIEW IF EXISTS customer_views;
