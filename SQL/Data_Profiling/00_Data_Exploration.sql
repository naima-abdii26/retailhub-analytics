/*
=========================================================
Project      : RetailHub Enterprise Retail Analysis
File         : 00_Data_Exploration
Description  : Data Exploration
=========================================================
*/


-- =====================================================
-- STEP 1: Select the Database
-- Purpose: Ensure all queries run against the RetailHub database.
-- =====================================================

USE retailhub;

-- =====================================================
-- STEP 2: Display All Tables
-- Purpose: Verify that all tables were created successfully.
-- =====================================================

SHOW TABLES;


-- =====================================================
-- STEP 3: Count Records in Each Table
-- Purpose: Verify that all data was loaded correctly.
-- =====================================================
SELECT COUNT(*) AS Categories_Count
FROM categories;


SELECT COUNT(*) Customer_count
FROM customers;

SELECT COUNT(*) employee_count
FROM employees;

SELECT COUNT(*) Inventory_count
FROM inventory;

SELECT COUNT(*) AS Order_count
FROM orders;

SELECT COUNT(*) AS Suppliers_Count
FROM Suppliers;

SELECT COUNT(*) AS Products_Count
FROM Products;


SELECT COUNT(*) AS Stores_Count
FROM Stores;


SELECT COUNT(*) AS Promotions_Count
FROM Promotions;

SELECT COUNT(*) AS OrderDetails_Count
FROM OrderDetails;

SELECT COUNT(*) AS Shipments_Count
FROM Shipments;


SELECT COUNT(*) AS Returns_Count
FROM Returns;


