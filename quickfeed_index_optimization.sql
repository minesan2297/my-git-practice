-- ========================================================
-- HỆ THỐNG MẠNG XÃ HỘI QUICKFEED - DỌN DẸP & TỐI ƯU HÓA INDEX
-- Vai trò: Database Administrator (DBA)
-- ========================================================

CREATE DATABASE IF NOT EXISTS quickfeed_db;
USE quickfeed_db;

-- 1. Tạo cấu trúc bảng Posts
DROP TABLE IF EXISTS Posts;

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    post_type VARCHAR(10),     -- Chứa 3 giá trị: 'TEXT', 'IMAGE', 'VIDEO'
    is_visible BOOLEAN DEFAULT 1, -- Chứa 2 giá trị: 1 (Hiện), 0 (Ẩn)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ========================================================
-- PHẦN 1: TÌNH TRẠNG LẠM DỤNG INDEX (OVER-INDEXING BAN ĐẦU)
-- ========================================================
CREATE INDEX idx_user_id ON Posts(user_id);
CREATE INDEX idx_content ON Posts(content(255));
CREATE INDEX idx_post_type ON Posts(post_type);
CREATE INDEX idx_is_visible ON Posts(is_visible);
CREATE INDEX idx_created_at ON Posts(created_at);

-- ========================================================
-- PHẦN 2: TRUY VẤN ĐO LƯỜNG DUNG LƯỢNG DATA VÀ INDEX TRƯỚC TỐI ƯU
-- Sử dụng information_schema.TABLES để tính dung lượng theo MB
-- ========================================================

-- Cách 1: Sử dụng SHOW TABLE STATUS
SHOW TABLE STATUS LIKE 'Posts';

-- Cách 2: Truy vấn chi tiết từ information_schema.TABLES
SELECT 
    table_name AS `Table`,
    ROUND(((data_length) / (1024 * 1024)), 2) AS `Data_Size_MB`,
    ROUND(((index_length) / (1024 * 1024)), 2) AS `Index_Size_MB`,
    ROUND(((data_length + index_length) / (1024 * 1024)), 2) AS `Total_Size_MB`
FROM information_schema.TABLES 
WHERE table_schema = 'quickfeed_db' 
  AND table_name = 'Posts';


-- ========================================================
-- PHẦN 3: TIẾN HÀNH "PHẪU THUẬT" DROP 3 INDEX GÂY LÃNG PHÍ
-- - idx_content: Cột TEXT kích thước lớn, làm phình to B-Tree, không hỗ trợ tìm kiếm linh hoạt (nên dùng FULLTEXT sau này nếu cần).
-- - idx_post_type: Cardinality cực thấp (chỉ 3 giá trị), Optimizer hầu như luôn bỏ qua.
-- - idx_is_visible: Cardinality siêu thấp (BOOLEAN chỉ 0 và 1), hoàn toàn vô dụng.
--
-- GIỮ LẠI:
-- + idx_user_id: Cardinality cao, lọc trang cá nhân của từng user.
-- + idx_created_at: Hỗ trợ ORDER BY load Newsfeed theo bài viết mới nhất.
-- ========================================================

ALTER TABLE Posts DROP INDEX idx_content;
ALTER TABLE Posts DROP INDEX idx_post_type;
ALTER TABLE Posts DROP INDEX idx_is_visible;


-- ========================================================
-- PHẦN 4: ĐO LƯỜNG LẠI DUNG LƯỢNG SAU KHI DỌN DẸP
-- ========================================================

SHOW TABLE STATUS LIKE 'Posts';

SELECT 
    table_name AS `Table`,
    ROUND(((data_length) / (1024 * 1024)), 2) AS `Data_Size_MB`,
    ROUND(((index_length) / (1024 * 1024)), 2) AS `Index_Size_MB`,
    ROUND(((data_length + index_length) / (1024 * 1024)), 2) AS `Total_Size_MB`
FROM information_schema.TABLES 
WHERE table_schema = 'quickfeed_db' 
  AND table_name = 'Posts';
