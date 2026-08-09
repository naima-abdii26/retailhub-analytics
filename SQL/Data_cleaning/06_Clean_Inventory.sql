/*
==============================================================
Project      : RetailHub Enterprise Retail Analysis
Phase        : Data Cleaning
Table        : Inventory
File         : 06_Clean_Inventory.sql
==============================================================
*/

-- ============================================
-- 1. Initial Preview
-- ============================================
SELECT * FROM inventory;

-- ============================================
-- 2. Missing Values
-- ============================================
SELECT * FROM inventory WHERE InventoryID IS NULL;
SELECT * FROM inventory WHERE StoreID IS NULL;
SELECT * FROM inventory WHERE ProductID IS NULL;
SELECT * FROM inventory WHERE StockQuantity IS NULL;
SELECT * FROM inventory WHERE ReorderLevel IS NULL;
-- Findings: No missing values found.

-- ============================================
-- 3. ReorderLevel & LastUpdated: Validate
-- ============================================
SELECT * FROM inventory WHERE ReorderLevel < 0;
SELECT * FROM inventory WHERE LastUpdated > CURDATE();
-- Findings: No issues found.

-- ============================================
-- 4. Negative Stock Quantity
-- ============================================
SELECT p.ProductID, p.ProductName, i.StockQuantity
FROM inventory i
JOIN products p ON i.ProductID = p.ProductID
WHERE i.StockQuantity <= 0;
-- Findings: Negative/zero stock quantities found.
-- No update performed because the correct stock levels are unknown —
-- retained for review rather than guessed.

-- ============================================
-- 5. Duplicate Check
-- ============================================
SELECT InventoryID, COUNT(*) AS Duplicate_Count
FROM inventory
GROUP BY InventoryID
HAVING COUNT(*) > 1;
-- Findings: No duplicate InventoryID records found.

SELECT StoreID, ProductID, COUNT(*) AS Record_Count
FROM inventory
GROUP BY StoreID, ProductID
HAVING COUNT(*) > 1;
-- Findings: Multiple records per StoreID/ProductID exist. Records retained
-- because the inventory table stores historical stock changes over time,
-- not just a current snapshot — this is expected, not a duplication error.

-- ============================================
-- 6. ReorderLevel: Range Review
-- ============================================
SELECT ReorderLevel FROM inventory ORDER BY ReorderLevel ASC;

/* ==============================
   INVENTORY TABLE — SUMMARY
================================
- No missing values found.
- Negative stock quantities identified and retained for review
  (correct values unknown).
- No duplicate InventoryID records found.
- Repeated StoreID/ProductID combinations retained — reflects legitimate
  inventory history, not duplication.
================================ */
