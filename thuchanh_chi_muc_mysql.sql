-- ========================================================
-- [Thực hành] Chỉ mục trong MySQL (MySQL Indexes)
-- Cơ sở dữ liệu: classicmodels
-- ========================================================

USE classicmodels;

-- ========================================================
-- PHẦN 1: KHẢO SÁT KHI CHƯA CÓ INDEX
-- ========================================================

-- Tìm thông tin khách hàng có tên là 'Land of Toys Inc.'
SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';

-- Sử dụng EXPLAIN để kiểm tra kế hoạch thực thi khi chưa đánh index:
-- Kết quả dự kiến: type = ALL (Full Table Scan), possible_keys = NULL, rows duyệt qua toàn bộ bảng.
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';


-- ========================================================
-- PHẦN 2: THÊM CHỈ MỤC ĐƠN (SINGLE-COLUMN INDEX)
-- ========================================================

-- Thêm chỉ mục cho cột customerName:
ALTER TABLE customers ADD INDEX idx_customerName(customerName);

-- Kiểm tra lại kế hoạch thực thi sau khi tạo index:
-- Kết quả dự kiến: type = ref, key = idx_customerName, rows giảm xuống chỉ còn 1 hoặc rất ít.
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';


-- ========================================================
-- PHẦN 3: THÊM CHỈ MỤC TỔ HỢP (COMPOSITE INDEX)
-- ========================================================

-- Thêm chỉ mục theo cặp trên 2 cột contactFirstName và contactLastName:
ALTER TABLE customers ADD INDEX idx_full_name(contactFirstName, contactLastName);

-- Kiểm tra kế hoạch thực thi với điều kiện tìm kiếm:
EXPLAIN SELECT * FROM customers 
WHERE contactFirstName = 'Jean' OR contactFirstName = 'King';


-- ========================================================
-- PHẦN 4: XÓA CHỈ MỤC (DROP INDEX)
-- ========================================================

-- Xóa chỉ mục tổ hợp vừa tạo:
ALTER TABLE customers DROP INDEX idx_full_name;

-- (Tùy chọn) Xóa chỉ mục đơn:
-- ALTER TABLE customers DROP INDEX idx_customerName;
