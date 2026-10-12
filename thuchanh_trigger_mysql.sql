-- ========================================================
-- [Thực hành] Trigger trong MySQL
-- Quản lý nhân viên công ty (Company Database)
-- ========================================================

CREATE DATABASE IF NOT EXISTS company;
USE company;

-- ========================================================
-- BƯỚC 1: TẠO BẢNG EMPLOYEES
-- ========================================================

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);

-- ========================================================
-- BƯỚC 2: TẠO TRIGGER BEFORE INSERT
-- Trigger tự động kiểm tra mức lương và phân loại phòng ban:
-- - salary >= 5000  -> 'Management'
-- - salary >= 3000  -> 'Sales'
-- - còn lại         -> 'Support'
-- ========================================================

DELIMITER //

DROP TRIGGER IF EXISTS update_department //

CREATE TRIGGER update_department
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary >= 5000 THEN
        SET NEW.department = 'Management';
    ELSEIF NEW.salary >= 3000 THEN
        SET NEW.department = 'Sales';
    ELSE
        SET NEW.department = 'Support';
    END IF;
END //

DELIMITER ;

-- ========================================================
-- BƯỚC 3: DEMO KIỂM TRA TRIGGER HOẠT ĐỘNG
-- Dù chèn dữ liệu ban đầu department là 'A', Trigger sẽ tự động sửa lại
-- ========================================================

INSERT INTO employees (name, department, salary) VALUES
('John Doe', 'A', 3500),       -- Kết quả mong đợi: department = 'Sales'
('Jane Smith', 'A', 2000),     -- Kết quả mong đợi: department = 'Support'
('David Johnson', 'A', 6000);  -- Kết quả mong đợi: department = 'Management'

-- Kiểm tra lại dữ liệu trong bảng employees
SELECT * FROM employees;
