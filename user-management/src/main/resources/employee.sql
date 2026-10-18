-- SQL Script for Employee table (Testing without transaction)
USE demo;

CREATE TABLE IF NOT EXISTS Employee (
    id INT(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(120) NOT NULL,
    salary DECIMAL(15, 2) NOT NULL,
    created_Date DATETIME,
    PRIMARY KEY (id)
);
