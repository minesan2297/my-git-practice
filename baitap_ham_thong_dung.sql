-- ========================================================
-- [Bài tập] Luyện tập các hàm thông dụng trong SQL
-- Cơ sở dữ liệu: QuanLySinhVien
-- ========================================================

USE QuanLySinhVien;

-- 1. Hiển thị tất cả các thông tin môn học (bảng Subject) có credit lớn nhất.
-- Cách dùng subquery với MAX() để lấy đầy đủ cả các môn bằng điểm credit tối đa:
SELECT * 
FROM Subject 
WHERE Credit = (SELECT MAX(Credit) FROM Subject);


-- 2. Hiển thị các thông tin môn học có điểm thi lớn nhất.
-- Nối bảng Subject với Mark và lọc môn có điểm Mark bằng giá trị lớn nhất trong bảng Mark:
SELECT 
    sub.SubId, 
    sub.SubName, 
    sub.Credit, 
    sub.Status, 
    m.Mark
FROM Subject sub
JOIN Mark m ON sub.SubId = m.SubId
WHERE m.Mark = (SELECT MAX(Mark) FROM Mark);


-- 3. Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, 
-- xếp hạng theo thứ tự điểm giảm dần.
-- Sử dụng AVG() kết hợp GROUP BY, dùng LEFT JOIN để không bỏ sót sinh viên chưa có điểm (nếu có):
SELECT 
    s.StudentId, 
    s.StudentName, 
    s.Address, 
    s.Phone, 
    AVG(m.Mark) AS AvgMark
FROM Student s
LEFT JOIN Mark m ON s.StudentId = m.StudentId
GROUP BY s.StudentId, s.StudentName, s.Address, s.Phone
ORDER BY AvgMark DESC;
