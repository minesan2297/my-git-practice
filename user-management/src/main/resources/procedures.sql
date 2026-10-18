-- SQL Script for Stored Procedures in MySQL
USE demo;

-- 1. Tạo Stored Procedure để lấy thông tin User theo ID
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS get_user_by_id(IN user_id INT)
BEGIN
    SELECT users.name, users.email, users.country
    FROM users
    WHERE users.id = user_id;
END$$
DELIMITER ;

-- 2. Tạo Stored Procedure để thêm mới một User
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS insert_user(
    IN user_name VARCHAR(50),
    IN user_email VARCHAR(50),
    IN user_country VARCHAR(50)
)
BEGIN
    INSERT INTO users(name, email, country)
    VALUES(user_name, user_email, user_country);
END$$
DELIMITER ;

-- 3. Tạo Stored Procedure để hiển thị danh sách tất cả Users
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS get_all_users()
BEGIN
    SELECT id, name, email, country FROM users;
END$$
DELIMITER ;

-- 4. Tạo Stored Procedure để cập nhật/sửa thông tin User
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS update_user(
    IN user_id INT,
    IN user_name VARCHAR(120),
    IN user_email VARCHAR(220),
    IN user_country VARCHAR(120)
)
BEGIN
    UPDATE users
    SET name = user_name,
        email = user_email,
        country = user_country
    WHERE id = user_id;
END$$
DELIMITER ;

-- 5. Tạo Stored Procedure để xoá một User theo ID
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS delete_user(IN user_id INT)
BEGIN
    DELETE FROM users WHERE id = user_id;
END$$
DELIMITER ;
