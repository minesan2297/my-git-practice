DROP DATABASE IF EXISTS autoride_db;
CREATE DATABASE autoride_db;
USE autoride_db;

CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME DEFAULT NULL,
    status ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED') DEFAULT 'BOOKED',
    security_deposit DECIMAL(10, 2) DEFAULT 0.00,
    late_fee DECIMAL(10, 2) DEFAULT 0.00,
    damage_fee DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (car_id) REFERENCES Cars(car_id)
);

CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT NOT NULL,
    inspector_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id)
);

-- Test case
INSERT INTO Cars (model_name, license_plate) 
VALUES ('Toyota Vios', '30A-123.45');

INSERT INTO Rentals (car_id, customer_name, rent_date, status, security_deposit)
VALUES (1, 'Nguyen Van A', NOW(), 'ACTIVE', 10000000);

INSERT INTO Inspections (rental_id, damage_description, inspector_name)
VALUES (1, 'Vo den pha trai', 'Tran Van Kiem');

UPDATE Rentals
SET status = 'COMPLETED',
    return_date = NOW(),
    late_fee = 0,
    damage_fee = 2000000
WHERE rental_id = 1;

-- Tinh tien hoan tra khach hang
SELECT 
    r.rental_id,
    r.customer_name,
    c.license_plate,
    r.security_deposit,
    r.late_fee,
    r.damage_fee,
    (r.security_deposit - r.late_fee - r.damage_fee) AS refund_amount,
    i.damage_description
FROM Rentals r
JOIN Cars c ON r.car_id = c.car_id
LEFT JOIN Inspections i ON r.rental_id = i.rental_id
WHERE r.rental_id = 1;