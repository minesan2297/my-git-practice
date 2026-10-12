-- ========================================================
-- [Thực hành] Truyền tham số vào Stored Procedure (IN, OUT, INOUT)
-- Cơ sở dữ liệu: classicmodels
-- ========================================================

USE classicmodels;

-- ========================================================
-- 1. THAM SỐ LOẠI IN (Tham số truyền vào để đọc dữ liệu)
-- ========================================================

DELIMITER //

DROP PROCEDURE IF EXISTS getCusById //

CREATE PROCEDURE getCusById(
    IN cusNum INT
)
BEGIN
    SELECT * FROM customers WHERE customerNumber = cusNum;
END //

DELIMITER ;

-- Gọi Stored Procedure với tham số IN:
CALL getCusById(175);


-- ========================================================
-- 2. THAM SỐ LOẠI OUT (Tham số trả về kết quả ra biến bên ngoài)
-- ========================================================

DELIMITER //

DROP PROCEDURE IF EXISTS GetCustomersCountByCity //

CREATE PROCEDURE GetCustomersCountByCity(
    IN in_city VARCHAR(50),
    OUT total INT
)
BEGIN
    SELECT COUNT(customerNumber)
    INTO total
    FROM customers
    WHERE city = in_city;
END //

DELIMITER ;

-- Gọi Stored Procedure với tham số OUT và xem kết quả lưu trong biến @total:
CALL GetCustomersCountByCity('Lyon', @total);
SELECT @total;


-- ========================================================
-- 3. THAM SỐ LOẠI INOUT (Vừa nhận giá trị truyền vào vừa trả kết quả ra ngoài)
-- ========================================================

DELIMITER //

DROP PROCEDURE IF EXISTS SetCounter //

CREATE PROCEDURE SetCounter(
    INOUT counter INT,
    IN inc INT
)
BEGIN
    SET counter = counter + inc;
END //

DELIMITER ;

-- Khởi tạo biến @counter và gọi Stored Procedure kiểm tra biến đổi giá trị:
SET @counter = 1;

CALL SetCounter(@counter, 1); -- @counter = 2
CALL SetCounter(@counter, 1); -- @counter = 3
CALL SetCounter(@counter, 5); -- @counter = 8

SELECT @counter; -- Kết quả: 8
