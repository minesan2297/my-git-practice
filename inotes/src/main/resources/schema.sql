-- MySQL Database Schema for iNotes
CREATE DATABASE IF NOT EXISTS inotes_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE inotes_db;

-- 1. Tạo bảng note_type
CREATE TABLE IF NOT EXISTS note_type (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

-- 2. Tạo bảng notes
CREATE TABLE IF NOT EXISTS notes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    type_id INT,
    FOREIGN KEY (type_id) REFERENCES note_type(id) ON DELETE CASCADE
);

-- 3. Dữ liệu mẫu cho bảng note_type
INSERT IGNORE INTO note_type (id, name, description) VALUES
(1, 'Cá nhân', 'Ghi chú cho các công việc, sinh hoạt đời sống cá nhân'),
(2, 'Công việc', 'Ghi chú cho công việc công ty, dự án, cuộc họp'),
(3, 'Học tập', 'Ghi chú tài liệu học tập, nghiên cứu công nghệ mới');

-- 4. Dữ liệu mẫu cho bảng notes
INSERT IGNORE INTO notes (id, title, content, type_id) VALUES
(1, 'Họp giao ban đầu tuần', 'Báo cáo tiến độ hoàn thành các bài thực hành JSP Servlet và phân chia công việc tuần mới.', 2),
(2, 'Ôn tập Design Pattern Servlet', 'Nghiên cứu áp dụng Strategy Pattern, Singleton Pattern và MVC Architecture.', 3),
(3, 'Kế hoạch cuối tuần', 'Đi mua sách lập trình và tập thể dục thể thao rèn luyện sức khoẻ.', 1);
