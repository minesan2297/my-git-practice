-- ========================================================
-- [Thực hành] Tạo CSDL Quản lý sinh viên & Truy vấn dữ liệu
-- ========================================================

CREATE DATABASE IF NOT EXISTS QuanLySinhVien;
USE QuanLySinhVien;

-- 1. Tạo bảng Class (Lớp học)
CREATE TABLE IF NOT EXISTS Class (
    ClassID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(60) NOT NULL,
    StartDate DATETIME NOT NULL,
    Status BIT
);

-- 2. Tạo bảng Student (Học viên)
CREATE TABLE IF NOT EXISTS Student (
    StudentId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(30) NOT NULL,
    Address VARCHAR(50),
    Phone VARCHAR(20),
    Status BIT,
    ClassId INT NOT NULL,
    FOREIGN KEY (ClassId) REFERENCES Class (ClassID)
);

-- 3. Tạo bảng Subject (Môn học)
CREATE TABLE IF NOT EXISTS Subject (
    SubId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SubName VARCHAR(30) NOT NULL,
    Credit TINYINT NOT NULL DEFAULT 1 CHECK (Credit >= 1),
    Status BIT DEFAULT 1
);

-- 4. Tạo bảng Mark (Điểm số)
CREATE TABLE IF NOT EXISTS Mark (
    MarkId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SubId INT NOT NULL,
    StudentId INT NOT NULL,
    Mark FLOAT DEFAULT 0 CHECK (Mark BETWEEN 0 AND 100),
    ExamTimes TINYINT DEFAULT 1,
    UNIQUE (SubId, StudentId),
    FOREIGN KEY (SubId) REFERENCES Subject (SubId),
    FOREIGN KEY (StudentId) REFERENCES Student (StudentId)
);

-- 5. Thêm dữ liệu mẫu vào các bảng
INSERT INTO Class (ClassName, StartDate, Status) VALUES 
('A1', '2008-12-20', 1),
('A2', '2008-12-22', 1),
('B3', current_date(), 0);

INSERT INTO Student (StudentName, Address, Phone, Status, ClassId) VALUES 
('Hung', 'Ha Noi', '0912113113', 1, 1),
('Hoa', 'Hai phong', NULL, 1, 1),
('Manh', 'HCM', '0123123123', 0, 2);

INSERT INTO Subject (SubName, Credit, Status) VALUES 
('CF', 5, 1),
('C', 6, 1),
('HDJ', 5, 1),
('RDBMS', 10, 1);

INSERT INTO Mark (SubId, StudentId, Mark, ExamTimes) VALUES 
(1, 1, 8, 1),
(1, 2, 10, 2),
(2, 1, 12, 1);

-- ========================================================
-- CÁC CÂU LỆNH TRUY VẤN THEO YÊU CẦU BÀI THỰC HÀNH
-- ========================================================

-- Bước 1: Sử dụng cơ sở dữ liệu
USE QuanLySinhVien;

-- Bước 2: Hiển thị danh sách tất cả các học viên
SELECT * FROM Student;

-- Bước 3: Hiển thị danh sách các học viên đang theo học (Status = true/1)
SELECT * FROM Student 
WHERE Status = true;

-- Bước 4: Hiển thị danh sách các môn học có thời gian học (Credit) nhỏ hơn 10
SELECT * FROM Subject 
WHERE Credit < 10;

-- Bước 5: Hiển thị danh sách học viên lớp A1
SELECT S.StudentId, S.StudentName, C.ClassName 
FROM Student S 
JOIN Class C ON S.ClassId = C.ClassID 
WHERE C.ClassName = 'A1';

-- Bước 6: Hiển thị điểm môn CF của các học viên
-- Hiển thị tất cả các điểm đang có của học viên:
-- SELECT S.StudentId, S.StudentName, Sub.SubName, M.Mark 
-- FROM Student S 
-- JOIN Mark M ON S.StudentId = M.StudentId 
-- JOIN Subject Sub ON M.SubId = Sub.SubId;

-- Hiển thị điểm môn CF của các học viên:
SELECT S.StudentId, S.StudentName, Sub.SubName, M.Mark 
FROM Student S 
JOIN Mark M ON S.StudentId = M.StudentId 
JOIN Subject Sub ON M.SubId = Sub.SubId 
WHERE Sub.SubName = 'CF';
