-- ========================================================
-- [Bài tập] Thao tác với CSDL Quản lý bán hàng (QuanLyBanHang)
-- ========================================================

CREATE DATABASE IF NOT EXISTS QuanLyBanHang;
USE QuanLyBanHang;

-- 1. Tạo bảng Customer
CREATE TABLE IF NOT EXISTS Customer (
    cID INT PRIMARY KEY,
    cName VARCHAR(25) NOT NULL,
    cAge TINYINT
);

-- 2. Tạo bảng `Order`
CREATE TABLE IF NOT EXISTS `Order` (
    oID INT PRIMARY KEY,
    cID INT NOT NULL,
    oDate DATETIME NOT NULL,
    oTotalPrice INT,
    FOREIGN KEY (cID) REFERENCES Customer(cID)
);

-- 3. Tạo bảng Product
CREATE TABLE IF NOT EXISTS Product (
    pID INT PRIMARY KEY,
    pName VARCHAR(25) NOT NULL,
    pPrice INT NOT NULL
);

-- 4. Tạo bảng OrderDetail
CREATE TABLE IF NOT EXISTS OrderDetail (
    oID INT NOT NULL,
    pID INT NOT NULL,
    odQTY INT NOT NULL,
    PRIMARY KEY (oID, pID),
    FOREIGN KEY (oID) REFERENCES `Order`(oID),
    FOREIGN KEY (pID) REFERENCES Product(pID)
);

-- ========================================================
-- CHÈN DỮ LIỆU MẪU THEO YÊU CẦU ĐỀ BÀI
-- ========================================================

-- Chèn dữ liệu vào Customer
INSERT INTO Customer (cID, cName, cAge) VALUES
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50)
ON DUPLICATE KEY UPDATE cName = VALUES(cName), cAge = VALUES(cAge);

-- Chèn dữ liệu vào `Order`
INSERT INTO `Order` (oID, cID, oDate, oTotalPrice) VALUES
(1, 1, '2006-03-21', NULL),
(2, 2, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL)
ON DUPLICATE KEY UPDATE cID = VALUES(cID), oDate = VALUES(oDate), oTotalPrice = VALUES(oTotalPrice);

-- Chèn dữ liệu vào Product
INSERT INTO Product (pID, pName, pPrice) VALUES
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2)
ON DUPLICATE KEY UPDATE pName = VALUES(pName), pPrice = VALUES(pPrice);

-- Chèn dữ liệu vào OrderDetail
INSERT INTO OrderDetail (oID, pID, odQTY) VALUES
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3)
ON DUPLICATE KEY UPDATE odQTY = VALUES(odQTY);

-- ========================================================
-- CÁC CÂU LỆNH TRUY VẤN THEO YÊU CẦU
-- ========================================================

-- 1. Hiển thị các thông tin gồm oID, oDate, oTotalPrice của tất cả các hóa đơn trong bảng Order
SELECT oID, oDate, oTotalPrice 
FROM `Order`;

-- 2. Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách
SELECT 
    c.cName AS CustomerName, 
    p.pName AS ProductName
FROM Customer c
JOIN `Order` o ON c.cID = o.cID
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID;

-- 3. Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
-- (Sử dụng LEFT JOIN kết hợp WHERE IS NULL hoặc Subquery NOT IN)
SELECT 
    c.cID, 
    c.cName
FROM Customer c
LEFT JOIN `Order` o ON c.cID = o.cID
WHERE o.oID IS NULL;

-- 4. Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn
-- (Giá một hóa đơn = tổng giá bán của từng mặt hàng: SUM(od.odQTY * p.pPrice))
SELECT 
    o.oID, 
    o.oDate, 
    SUM(od.odQTY * p.pPrice) AS TotalPrice
FROM `Order` o
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID
GROUP BY o.oID, o.oDate;
