/*
==============================================================
Project      : RetailHub Enterprise Retail Analysis
Phase        : Data Cleaning
Table        : Returns
File         : 12_Clean_Returns.sql
==============================================================
*/

-- ============================================
-- 1. Initial Preview
-- ============================================
SELECT * FROM returns;
SELECT * FROM returns ORDER BY OrderID DESC;

-- ============================================
-- 2. OrderID: Identify Placeholder Values
-- ============================================
SELECT * FROM returns WHERE OrderID = 444444;
-- Findings: 48 records share the same OrderID (444444), which falls far
-- outside the normal OrderID range (~9 to ~48,000). A single order cannot
-- have 48 separate returns, so this is a placeholder/error value rather
-- than a real order reference.

-- Add a flag column to mark these records without deleting the rest of
-- the row's valid data (ReturnReason, RefundAmount, ReturnDate).
ALTER TABLE returns
ADD COLUMN IsValidOrder VARCHAR(3) AFTER OrderID;

UPDATE returns
SET IsValidOrder = CASE
    WHEN OrderID = 444444 THEN 'No'
    ELSE 'Yes'
END;

-- Validation
SELECT COUNT(*) AS Flagged_Invalid_Orders
FROM returns
WHERE IsValidOrder = 'No';

/* ==============================
   RETURNS TABLE — SUMMARY
================================
- 48 records with placeholder OrderID (444444) identified and flagged via
  new IsValidOrder column ('Yes'/'No'), rather than deleted — preserves
  ReturnReason, RefundAmount, and ReturnDate for reason/amount-level
  analysis while excluding them from any order-level joins.
================================ */
