-- ========================================================
-- HỆ THỐNG IOT SMARTFACTORY - CÂN BẰNG HIỆU NĂNG READ/WRITE & STORAGE
-- Vai trò: Database Optimization Expert
-- ========================================================

CREATE DATABASE IF NOT EXISTS smartfactory_db;
USE smartfactory_db;

-- 1. Tạo cấu trúc bảng SensorLogs
DROP TABLE IF EXISTS SensorLogs;

CREATE TABLE SensorLogs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    recorded_at DATETIME NOT NULL,
    temperature DECIMAL(5,2),
    humidity DECIMAL(5,2),
    status VARCHAR(20) -- 'NORMAL', 'WARNING', 'CRITICAL'
);

-- ========================================================
-- PHẦN 1: TÌNH TRẠNG FAT COVERING INDEX BAN ĐẦU
-- ========================================================
CREATE INDEX idx_fat_covering ON SensorLogs(sensor_id, recorded_at, temperature, humidity, status);

-- Khảo sát kích thước bảng và index ban đầu:
SHOW TABLE STATUS LIKE 'SensorLogs';

SELECT 
    table_name,
    ROUND(data_length / (1024 * 1024), 2) AS Data_Size_MB,
    ROUND(index_length / (1024 * 1024), 2) AS Index_Size_MB
FROM information_schema.TABLES
WHERE table_schema = 'smartfactory_db' AND table_name = 'SensorLogs';

-- EXPLAIN truy vấn Dashboard với Fat Covering Index:
-- Kết quả: Extra có "Using index" (Covering Index - không cần chạm vào Table, nhưng chi phí Write/Storage cực kỳ nặng nề)
EXPLAIN SELECT temperature, humidity, status 
FROM SensorLogs 
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20 00:00:00';


-- ========================================================
-- PHẦN 2: THỰC THI CHUYỂN ĐỔI: DROP FAT INDEX & TẠO LEAN INDEX
-- ========================================================

-- Xóa Index cồng kềnh:
ALTER TABLE SensorLogs DROP INDEX idx_fat_covering;

-- Tạo Lean Index chỉ chứa 2 cột phục vụ lọc và định vị khoảng (WHERE sensor_id = ... AND recorded_at >= ...):
CREATE INDEX idx_lean_search ON SensorLogs(sensor_id, recorded_at);


-- ========================================================
-- PHẦN 3: VẬN HÀNH & ĐỐI CHIẾU KẾ HOẠCH THỰC THI (EXPLAIN)
-- ========================================================

-- Kiểm tra lại dung lượng sau khi tối ưu Lean Index:
SHOW TABLE STATUS LIKE 'SensorLogs';

SELECT 
    table_name,
    ROUND(data_length / (1024 * 1024), 2) AS Data_Size_MB,
    ROUND(index_length / (1024 * 1024), 2) AS Index_Size_MB
FROM information_schema.TABLES
WHERE table_schema = 'smartfactory_db' AND table_name = 'SensorLogs';

-- EXPLAIN truy vấn Dashboard với Lean Index:
-- Kết quả:
-- - key: idx_lean_search
-- - type: range (vẫn cực kỳ tối ưu, lọc chính xác theo dải thời gian của cảm biến)
-- - Extra: không còn "Using index" mà thực hiện Row Lookup về Clustered Index (Table) để lấy các cột temperature, humidity, status.
EXPLAIN SELECT temperature, humidity, status 
FROM SensorLogs 
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20 00:00:00';
