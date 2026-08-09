/*
==============================================================
Project      : RetailHub Enterprise Retail Analysis
Phase        : Data Cleaning
Table        : Stores
File         : 10_Clean_Stores.sql
==============================================================
*/

-- ============================================
-- 1. Initial Preview
-- ============================================
SELECT * FROM stores;

-- ============================================
-- 2. Duplicate Check
-- ============================================
SELECT StoreID, COUNT(*) AS Duplicate_Count
FROM stores
GROUP BY StoreID
HAVING COUNT(*) > 1;
-- Findings: No duplicate StoreID records found.

-- ============================================
-- 3. City: Fix Spelling Errors
-- ============================================
SELECT DISTINCT City FROM stores ORDER BY City;

-- Fixed 3 misspelled cities identified through manual review
UPDATE stores SET City = 'Edinburgh' WHERE City = 'Edinburg';
UPDATE stores SET City = 'Newcastle' WHERE City = 'Newcastel';
UPDATE stores SET City = 'Leicester' WHERE City = 'Leicster';

-- Validation
SELECT * FROM stores WHERE City IN ('Edinburg', 'Newcastel', 'Leicster');

/* ==============================
   STORES TABLE — SUMMARY
================================
- No duplicate StoreID records found.
- Fixed 3 misspelled cities: Edinburg -> Edinburgh, Newcastel -> Newcastle,
  Leicster -> Leicester.
================================ */
