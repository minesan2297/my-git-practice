-- ==========================================================
-- DDL: TÁI CẤU TRÚC HỆ THỐNG CƠ SỞ DỮ LIỆU HEALTHSYNC
-- ==========================================================

CREATE DATABASE IF NOT EXISTS healthsync_db;
USE healthsync_db;

-- 1. Bảng Bệnh nhân (Patients)
CREATE TABLE IF NOT EXISTS Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
);

-- 2. Bảng Bác sĩ (Doctors)
CREATE TABLE IF NOT EXISTS Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50)
);

-- 3. Bảng Lịch hẹn (Appointments) - Đã giải quyết triệt để lỗi cũ
CREATE TABLE IF NOT EXISTS Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    -- Dùng ENUM thay thế hoàn toàn cho BOOLEAN is_active để hỗ trợ quy trình 5 trạng thái
    status ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    -- Dùng DECIMAL cho tài chính để tránh lỗi làm tròn sai số (floating-point precision)
    deposit_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    penalty_fee DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    cancel_reason VARCHAR(255) NULL,
    CONSTRAINT fk_appointments_patient FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE RESTRICT,
    CONSTRAINT fk_appointments_doctor FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE RESTRICT
);

-- 4. Bảng Đơn thuốc (Prescriptions) - Khắc phục thiếu hụt bảng kê đơn
CREATE TABLE IF NOT EXISTS Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE, -- Quan hệ 1-1 với lịch hẹn hoàn tất
    medication_details TEXT NOT NULL,
    issued_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_prescriptions_appointment FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE
);

-- ==========================================================
-- DML: KỊCH BẢN KIỂM THỬ DỮ LIỆU THỰC TẾ
-- ==========================================================

-- Thêm dữ liệu mẫu ban đầu
INSERT INTO Patients (full_name, phone) VALUES 
('Nguyen Van A', '0901234567'),
('Tran Thi B', '0912345678');

INSERT INTO Doctors (full_name, specialty) VALUES 
('BS. Le Van C', 'Noi Tong Quat');

-- Kịch bản 1: Lịch hẹn hoàn tất khám và kê đơn thuốc thành công
-- 1.1 Tạo lịch hẹn PENDING, cọc 500.000 VNĐ
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (1, 1, '2026-10-10 08:30:00', 'PENDING', 500000.00);

-- 1.2 Bệnh nhân đến phòng khám -> CHECKED_IN
UPDATE Appointments 
SET status = 'CHECKED_IN' 
WHERE appointment_id = 1;

-- 1.3 Khám xong -> COMPLETED
UPDATE Appointments 
SET status = 'COMPLETED' 
WHERE appointment_id = 1;

-- 1.4 Bác sĩ kê đơn thuốc cho lịch hẹn 1
INSERT INTO Prescriptions (appointment_id, medication_details)
VALUES (1, 'Paracetamol 500mg (10 vien), Vitamin C 1000mg (10 vien)');


-- Kịch bản 2: Lịch hẹn bị hủy sau khi CONFIRMED và tính phạt tiền cọc
-- 2.1 Tạo lịch hẹn CONFIRMED, cọc 300.000 VNĐ
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (2, 1, '2026-10-11 14:00:00', 'CONFIRMED', 300000.00);

-- 2.2 Bệnh nhân báo hủy lịch -> CANCELLED, phạt 150.000 VNĐ
UPDATE Appointments 
SET status = 'CANCELLED',
    cancel_reason = 'Ban viec dot xuat',
    penalty_fee = 150000.00
WHERE appointment_id = 2;

-- Truy vấn kiểm tra dữ liệu dòng tiền và đơn thuốc
SELECT 
    a.appointment_id,
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    a.status,
    a.deposit_amount,
    a.penalty_fee,
    a.cancel_reason,
    pr.medication_details
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
LEFT JOIN Prescriptions pr ON a.appointment_id = pr.appointment_id;