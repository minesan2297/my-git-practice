-- SQL Script for Permissions and Transaction Practice
USE demo;

-- 1. Tạo bảng Permission
CREATE TABLE IF NOT EXISTS permission (
    id INT(11) PRIMARY KEY,
    name VARCHAR(50)
);

-- 2. Tạo bảng trung gian User_Permission
CREATE TABLE IF NOT EXISTS user_permission (
    user_id INT(11),
    permission_id INT(11),
    PRIMARY KEY(user_id, permission_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permission(id) ON DELETE CASCADE
);

-- 3. Thêm một số dữ liệu mẫu cho bảng Permission
INSERT IGNORE INTO permission(id, name) VALUES (1, 'add');
INSERT IGNORE INTO permission(id, name) VALUES (2, 'edit');
INSERT IGNORE INTO permission(id, name) VALUES (3, 'delete');
INSERT IGNORE INTO permission(id, name) VALUES (4, 'view');
