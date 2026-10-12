-- ========================================================
-- [Thực hành] Stored Procedure trong MySQL
-- Cơ sở dữ liệu: classicmodels
-- ========================================================

USE classicmodels;

-- ========================================================
-- PHẦN 1: TẠO STORED PROCEDURE ĐẦU TIÊN
-- ========================================================

DELIMITER //

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers;
END //

DELIMITER ;

-- Gọi thực thi Stored Procedure:
CALL findAllCustomers();


-- ========================================================
-- PHẦN 2: SỬA (DROP VÀ TẠO LẠI) STORED PROCEDURE
-- Trong MySQL không có lệnh ALTER PROCEDURE để sửa nội dung thân thủ tục,
-- vì vậy ta dùng DROP PROCEDURE IF EXISTS rồi CREATE PROCEDURE lại.
-- ========================================================

DELIMITER //

DROP PROCEDURE IF EXISTS `findAllCustomers`//

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers WHERE customerNumber = 175;
END //

DELIMITER ;

-- Gọi lại thủ tục sau khi đã cập nhật:
CALL findAllCustomers();
