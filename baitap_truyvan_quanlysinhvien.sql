-- ========================================================
-- [Bài tập] Truy vấn dữ liệu nâng cao với CSDL Quản lý sinh viên
-- ========================================================

USE QuanLySinhVien;

-- 1. Hiển thị tất cả các sinh viên có tên bắt đầu bằng ký tự 'h' (hoặc 'H')
SELECT * 
FROM Student 
WHERE StudentName LIKE 'h%';

-- 2. Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12
SELECT * 
FROM Class 
WHERE MONTH(StartDate) = 12;

-- 3. Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3 đến 5
SELECT * 
FROM Subject 
WHERE Credit BETWEEN 3 AND 5;

-- 4. Thay đổi mã lớp (ClassID) của sinh viên có tên 'Hung' thành 2
-- Tắt chế độ safe update tạm thời nếu đang chạy trên MySQL Workbench:
-- SET SQL_SAFE_UPDATES = 0;
UPDATE Student 
SET ClassId = 2 
WHERE StudentName = 'Hung';
-- SET SQL_SAFE_UPDATES = 1;

-- 5. Hiển thị các thông tin: StudentName, SubName, Mark.
-- Dữ liệu sắp xếp theo điểm thi (Mark) giảm dần, nếu trùng sắp xếp theo tên (StudentName) tăng dần.
SELECT 
    s.StudentName, 
    sub.SubName, 
    m.Mark
FROM Student s
JOIN Mark m ON s.StudentId = m.StudentId
JOIN Subject sub ON m.SubId = sub.SubId
ORDER BY m.Mark DESC, s.StudentName ASC;
