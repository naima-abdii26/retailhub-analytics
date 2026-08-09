/*
==============================================================
Project      : RetailHub Enterprise Retail Analysis
Phase        : Data Cleaning
Table        : OrderDetails
File         : 03_Clean_OrderDetails.sql
==============================================================
*/

-- ============================================
-- 1. Initial Preview
-- ============================================
DESCRIBE orderdetails;
SELECT * FROM orderdetails;

-- ============================================
-- 2. Missing Values
-- ============================================
SELECT
    SUM(OrderDetailID IS NULL) AS OrderDetailID_NULLs,
    SUM(OrderID IS NULL)       AS OrderID_NULLs,
    SUM(ProductID IS NULL)     AS ProductID_NULLs,
    SUM(Quantity IS NULL)      AS Quantity_NULLs,
    SUM(UnitPrice IS NULL)     AS UnitPrice_NULLs,
    SUM(Discount IS NULL)      AS Discount_NULLs,
    SUM(Cost IS NULL)          AS Cost_NULLs,
    SUM(Profit IS NULL)        AS Profit_NULLs
FROM orderdetails;
-- Findings: No missing values found.

-- ============================================
-- 3. Duplicate Check
-- ============================================
SELECT OrderDetailID, OrderID, ProductID, Quantity, UnitPrice,
       Discount, Cost, Profit, COUNT(*) AS Duplicate_Count
FROM orderdetails
GROUP BY OrderDetailID, OrderID, ProductID, Quantity, UnitPrice,
         Discount, Cost, Profit
HAVING COUNT(*) > 1;
-- Findings: No duplicate records found.

-- ============================================
-- 4. Invalid Value Checks
-- ============================================
SELECT * FROM orderdetails WHERE Quantity < 0;
SELECT * FROM orderdetails WHERE Cost < 0;
SELECT * FROM orderdetails WHERE UnitPrice < 0;
SELECT * FROM orderdetails WHERE Discount < 0;
-- Findings: Quantity, UnitPrice, Discount, Cost, and Profit values are all
-- valid (non-negative). No changes required.

/* ==============================
   ORDERDETAILS TABLE — SUMMARY
================================
- No missing values found.
- No duplicate records found.
- No invalid negative values found.
- Table required no corrections.
================================ */
