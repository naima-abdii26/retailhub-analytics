/*
==============================================================
Project      : RetailHub Enterprise Retail Analysis
Phase        : Data Cleaning
Table        : Orders
File         : 02_Clean_Orders.sql
==============================================================
*/

-- ============================================
-- 1. Initial Preview
-- ============================================
DESCRIBE orders;
SELECT * FROM orders;

-- ============================================
-- 2. Missing Values
-- ============================================
SELECT COUNT(*) AS Missing_OrderID FROM orders WHERE OrderID IS NULL;
SELECT COUNT(*) AS Missing_OrderDate FROM orders WHERE OrderDate IS NULL;
SELECT COUNT(*) AS Missing_StoreID FROM orders WHERE StoreID IS NULL;
SELECT COUNT(*) AS Missing_CustomerID FROM orders WHERE CustomerID IS NULL;
SELECT COUNT(*) AS Missing_OrderStatus FROM orders WHERE OrderStatus IS NULL;
SELECT COUNT(*) AS Missing_ShippingMethod FROM orders WHERE ShippingMethod IS NULL;

SELECT COUNT(*) AS Total_Orders FROM orders;
SELECT COUNT(*) AS Missing_PromotionID FROM orders WHERE PromotionID IS NULL;
-- Findings: 45,595 NULL values found in PromotionID.
-- NULL indicates no promotion was applied to that order. No changes required.

SELECT COUNT(*) AS Missing_PaymentMethod FROM orders WHERE PaymentMethod IS NULL;

SELECT OrderStatus, COUNT(*) AS Total_Orders
FROM orders
WHERE PaymentMethod IS NULL
GROUP BY OrderStatus;
-- Findings: 1,012 records with NULL PaymentMethod, spread across multiple
-- order statuses (Delivered, Shipped, Packed, Pending, Cancelled, Returned).
-- Since the correct payment method cannot be determined, NULLs were
-- retained to preserve data integrity rather than guessing a value.

-- ============================================
-- 3. OrderDate: Standardize & Validate
-- ============================================
SELECT DISTINCT OrderDate
FROM orders
WHERE STR_TO_DATE(OrderDate, '%Y-%m-%d') IS NULL;

SELECT COUNT(*) AS Invalid_Date
FROM orders
WHERE OrderDate = '2023-02-30';

-- 2023-02-30 does not exist (February has 28 days in 2023) — set to NULL
UPDATE orders
SET OrderDate = NULL
WHERE OrderDate = '2023-02-30';

SELECT COUNT(*) AS Records_With_Time_Component
FROM orders
WHERE OrderDate LIKE '%:%';

-- Strip time component so OrderDate is a clean date value
UPDATE orders
SET OrderDate = DATE(OrderDate)
WHERE OrderDate LIKE '%:%';

SELECT DISTINCT OrderDate FROM orders;

SELECT COUNT(*) AS Invalid_Dates
FROM orders
WHERE STR_TO_DATE(OrderDate, '%Y-%m-%d') IS NULL;

ALTER TABLE orders
MODIFY COLUMN  OrderDate date;


SELECT COUNT(*) AS Count_Null_Dates
FROM orders
WHERE OrderDate IS NULL;

-- Converted OrderDate from VARCHAR(20) to DATE (2026-08-06).
-- Verified 0 warnings and 0 duplicates on conversion; NULL count
-- unchanged (151) before and after, confirming no data was lost
-- or altered beyond the already-documented invalid dates above.

-- ============================================
-- 4. Duplicate Check
-- ============================================
SELECT OrderID, COUNT(*) AS Duplicate_Count
FROM orders
GROUP BY OrderID
HAVING COUNT(*) > 1;
-- Findings: Duplicate records were verified during data profiling.
-- No duplicate records found.

-- ============================================
-- 5. Categorical Fields: Consistency Check
-- ============================================
SELECT DISTINCT PaymentMethod FROM orders ORDER BY PaymentMethod;
SELECT DISTINCT ShippingMethod FROM orders ORDER BY ShippingMethod;
SELECT DISTINCT OrderStatus FROM orders ORDER BY OrderStatus;
-- Findings: PaymentMethod, ShippingMethod, and OrderStatus values are
-- already standardized. No changes required.




/* ==============================
   ORDERS TABLE — SUMMARY
================================
- PromotionID NULLs (45,595) retained — represents "no promotion applied."
- PaymentMethod NULLs (1,012) retained — correct value unrecoverable.
- OrderDate: standardized to YYYY-MM-DD, invalid date (2023-02-30, 151 rows)
  set to NULL.
- No duplicate OrderID records found.
- PaymentMethod, ShippingMethod, OrderStatus: validated, no changes needed.
================================ */
