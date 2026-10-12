-- ========================================================
-- HỆ THỐNG PAYFLOW - TỐI ƯU HÓA BÁO CÁO TÀI CHÍNH
-- Vai trò: Database Performance Engineer
-- ========================================================

CREATE DATABASE IF NOT EXISTS payflow_db;
USE payflow_db;

-- 1. Khởi tạo cấu trúc bảng Transactions
CREATE TABLE IF NOT EXISTS Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(15,2),
    transaction_type VARCHAR(20), -- 'DEPOSIT', 'WITHDRAW', 'TRANSFER'
    created_at DATETIME
);

-- ========================================================
-- PHẦN 1: TRUY VẤN CŨ CỦA KẾ TOÁN (CHƯA TỐI ƯU - NON-SARGABLE)
-- Điểm nghẽn:
-- 1. Chưa có Index trên transaction_type hay created_at (type: ALL - Full Table Scan).
-- 2. Dùng hàm YEAR(created_at) và MONTH(created_at) bọc ngoài cột khiến
--    truy vấn bị Non-SARGable, MySQL bắt buộc phải tính hàm trên từng dòng của 5 triệu bản ghi.
-- ========================================================

-- EXPLAIN câu truy vấn cũ:
EXPLAIN SELECT SUM(amount) AS total_deposit 
FROM Transactions 
WHERE transaction_type = 'DEPOSIT' 
  AND YEAR(created_at) = 2026 
  AND MONTH(created_at) = 6;


-- ========================================================
-- PHẦN 2: THIẾT KẾ COMPOSITE INDEX PHÙ HỢP
-- Thứ tự cột trong Index: (transaction_type, created_at)
-- - transaction_type là điều kiện so sánh bằng (= 'DEPOSIT') -> đặt trước
-- - created_at là điều kiện so sánh khoảng (Range: >= và <) -> đặt sau
-- ========================================================

CREATE INDEX idx_type_date ON Transactions(transaction_type, created_at);


-- ========================================================
-- PHẦN 3: TRUY VẤN MỚI ĐÃ ĐƯỢC TỐI ƯU (SARGABLE QUERY)
-- Thay thế YEAR() và MONTH() bằng khoảng thời gian:
-- created_at >= '2026-06-01 00:00:00' AND created_at < '2026-07-01 00:00:00'
-- ========================================================

-- EXPLAIN câu truy vấn sau khi tối ưu:
EXPLAIN SELECT SUM(amount) AS total_deposit 
FROM Transactions 
WHERE transaction_type = 'DEPOSIT' 
  AND created_at >= '2026-06-01 00:00:00' 
  AND created_at < '2026-07-01 00:00:00';

-- Câu lệnh thực thi lấy kết quả:
SELECT SUM(amount) AS total_deposit 
FROM Transactions 
WHERE transaction_type = 'DEPOSIT' 
  AND created_at >= '2026-06-01 00:00:00' 
  AND created_at < '2026-07-01 00:00:00';
