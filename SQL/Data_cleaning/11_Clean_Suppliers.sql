/*
==============================================================
Project      : RetailHub Enterprise Retail Analysis
Phase        : Data Cleaning
Table        : Suppliers
File         : 11_Clean_Suppliers.sql
==============================================================
*/

-- ============================================
-- 1. Initial Preview
-- ============================================
SELECT * FROM suppliers;

-- ============================================
-- 2. Missing Values
-- ============================================
SELECT COUNT(*) AS Count_Rows,
    SUM(CASE WHEN SupplierID IS NULL THEN 1 ELSE 0 END) AS Missing_SupplierID,
    SUM(CASE WHEN SupplierName IS NULL OR SupplierName = '' THEN 1 ELSE 0 END) AS Missing_SupplierName,
    SUM(CASE WHEN ContactName IS NULL OR ContactName = '' THEN 1 ELSE 0 END) AS Missing_ContactName,
    SUM(CASE WHEN Email IS NULL OR Email = '' THEN 1 ELSE 0 END) AS Missing_Email,
    SUM(CASE WHEN Phone IS NULL OR Phone = '' THEN 1 ELSE 0 END) AS Missing_Phone,
    SUM(CASE WHEN City IS NULL OR City = '' THEN 1 ELSE 0 END) AS Missing_City,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Missing_Country
FROM suppliers;
-- NOTE (fixed): original query checked "SupplierID = ''" inside the
-- Missing_SupplierName calculation instead of "SupplierName = ''" —
-- meaning SupplierName was never actually being checked. Corrected.

SELECT * FROM suppliers
WHERE Email IS NULL OR Email = '' OR Phone IS NULL OR Phone = '';

-- ============================================
-- 3. Duplicate Check
-- ============================================
-- Check for true duplicate supplier records (same contact details repeated)
SELECT ContactName, Email, Phone, City, Country, COUNT(*) AS Duplicate_Count
FROM suppliers
GROUP BY ContactName, Email, Phone, City, Country
HAVING COUNT(*) > 1;
-- NOTE: grouping by SupplierID alone (as in the original draft) can never
-- find duplicates since SupplierID is the primary key and unique by
-- definition. Grouping by contact attributes instead correctly surfaces
-- suppliers that were entered more than once under different IDs.

-- Inspect the confirmed duplicate pairs found
SELECT * FROM suppliers WHERE SupplierID IN (104, 121);
SELECT * FROM suppliers WHERE ContactName = 'Irene Hussain';
SELECT * FROM suppliers WHERE ContactName = 'Mrs Cheryl Parsons';

-- Confirm no foreign key dependencies before deleting duplicate records
SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE REFERENCED_TABLE_NAME = 'suppliers'
  AND TABLE_SCHEMA = 'retailhub';

-- Remove confirmed duplicate supplier records
DELETE FROM suppliers WHERE SupplierID = '122';
DELETE FROM suppliers WHERE SupplierID = '121';

-- ============================================
-- 4. Email Format Validation
-- ============================================
SELECT SupplierID, Email
FROM suppliers
WHERE Email IS NOT NULL
  AND Email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$';
-- Findings: All non-null emails match a valid format.

-- ============================================
-- 5. Phone Number Validation
-- ============================================
SELECT SupplierID, Phone FROM suppliers WHERE Phone IS NULL;

SELECT SupplierID, Phone
FROM suppliers
WHERE Phone REGEXP '[^0-9+()\\- ]';

SELECT SupplierID, Phone
FROM suppliers
WHERE Phone REGEXP '[A-Za-z]';

SELECT SupplierID, Phone,
       LENGTH(REGEXP_REPLACE(Phone, '[^0-9]', '')) AS Digit_Count
FROM suppliers
ORDER BY Digit_Count ASC;
-- Findings: Phone formats reviewed for stray characters and digit counts
-- outside the expected range. No corrections required after review.

-- ============================================
-- 6. City: Trim & Standardize Casing
-- ============================================
SELECT * FROM suppliers WHERE City <> TRIM(City);

UPDATE suppliers
SET City = TRIM(City)
WHERE City <> TRIM(City);

SELECT SupplierID, City
FROM suppliers
WHERE BINARY City <> CONCAT(UPPER(LEFT(City, 1)), LOWER(SUBSTRING(City, 2)));

-- Fixed inconsistent casing found during review
UPDATE suppliers SET City = 'Bristol' WHERE City = 'BRISTOL';
UPDATE suppliers SET City = 'Nottingham' WHERE City = 'nottingham';

/* ==============================
   SUPPLIERS TABLE — SUMMARY
================================
- No missing SupplierID, SupplierName, Email, City, or Country values found.
- 2 duplicate supplier records removed (SupplierID 121, 122) after
  confirming no foreign key dependencies existed.
- Email formats validated - no issues found.
- Phone numbers reviewed for invalid characters/lengths - no issues found.
- City: trimmed whitespace and standardized casing (Bristol, Nottingham).
================================ */
