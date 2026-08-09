/*
==============================================================
Project      : RetailHub Enterprise Retail Analysis
Phase        : Data Cleaning
Table        : Products
File         : 07_Clean_Products.sql
==============================================================
*/

-- ============================================
-- 1. Initial Preview
-- ============================================
SELECT * FROM products;

-- ============================================
-- 2. Duplicate Check
-- ============================================
SELECT ProductID, COUNT(*) AS Duplicate_Count
FROM products
GROUP BY ProductID
HAVING COUNT(*) > 1;
-- Findings: No duplicate ProductID (primary key is unique by definition).

SELECT SKU, COUNT(*) AS Duplicate_Count
FROM products
GROUP BY SKU
HAVING COUNT(*) > 1;

SELECT ProductName, COUNT(*) AS Duplicate_Count
FROM products
GROUP BY ProductName
HAVING COUNT(*) > 1;

-- Confirm true duplicates: same SKU, name, and all other attributes
WITH Duplicate_Check AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY SKU, ProductName, Brand, CategoryID, SupplierID,
                         CostPrice, SellingPrice, LaunchDate, Status
            ORDER BY ProductID
        ) AS Row_Num
    FROM products
)
SELECT * FROM Duplicate_Check WHERE Row_Num > 1;

-- Remove confirmed true duplicates (keep lowest ProductID per group)
WITH Duplicate_Check AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY SKU, ProductName, Brand, CategoryID, SupplierID,
                         CostPrice, SellingPrice, LaunchDate, Status
            ORDER BY ProductID
        ) AS Row_Num
    FROM products
)
DELETE p
FROM products p
JOIN Duplicate_Check d ON p.ProductID = d.ProductID
WHERE d.Row_Num > 1;
-- NOTE: original script repeated SupplierID twice in the PARTITION BY list
-- (harmless but redundant) — removed the duplicate reference here.

-- Validation
SELECT * FROM products;

-- ============================================
-- 3. Missing / Blank Values
-- ============================================
SELECT * FROM products
WHERE TRIM(SKU) = ''
   OR TRIM(ProductName) = ''
   OR TRIM(Brand) = ''
   OR TRIM(Status) = '';

SELECT
    SUM(ProductID IS NULL) AS ProductID_NULLs,
    SUM(SKU IS NULL) AS SKU_NULLs,
    SUM(ProductName IS NULL) AS ProductName_NULLs,
    SUM(Brand IS NULL) AS Brand_NULLs,
    SUM(CategoryID IS NULL) AS CategoryID_NULLs,
    SUM(SupplierID IS NULL) AS SupplierID_NULLs,
    SUM(CostPrice IS NULL) AS CostPrice_NULLs,
    SUM(SellingPrice IS NULL) AS SellingPrice_NULLs,
    SUM(LaunchDate IS NULL) AS LaunchDate_NULLs,
    SUM(Status IS NULL) AS Status_NULLs
FROM products;
-- Findings: No missing values found.

-- ============================================
-- 4. Date & Price Validation
-- ============================================
SELECT * FROM products WHERE LaunchDate > CURDATE();
SELECT DISTINCT Status FROM products ORDER BY Status;
SELECT SellingPrice, CostPrice FROM products WHERE SellingPrice < CostPrice;
-- Findings: No future LaunchDate values, Status values consistent,
-- no products sold below cost. No changes required.



SELECT LaunchDate FROM products
LIMIT 5;

SELECT LaunchDate
FROM products
WHERE LaunchDate IS  NULL;

SELECT COUNT(*) AS IvalidLaunchDate
FROM products
WHERE LaunchDate IS NOT NULL 
AND STR_TO_DATE(LaunchDate,'%Y-%m-%d');


SELECT COUNT(*) AS IvalidLaunchDate
FROM products
WHERE LaunchDate IS NOT NULL 
AND STR_TO_DATE(LaunchDate,'%Y-%m-%d') IS NULL;


ALTER TABLE products
MODIFY  COLUMN LaunchDate DATE;


SELECT COUNT(*) FROM products;

SELECT COUNT(*) FROM products WHERE LaunchDate IS NULL;


/* ============================================
   PRODUCTS TABLE — SUMMARY
   ============================================
   - No missing values; true duplicates removed.
   - LaunchDate, Status, and pricing validated.
   - LaunchDate converted TEXT -> DATE (2026-08-06):
     0 unconvertible values, 0 NULLs — before and after.
   ============================================ */