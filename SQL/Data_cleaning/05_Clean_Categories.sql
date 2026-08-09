/*
==============================================================
Project      : RetailHub Enterprise Retail Analysis
Phase        : Data Cleaning
Table        : Categories
File         : 05_Clean_Categories.sql
==============================================================
*/

-- ============================================
-- 1. Initial Preview
-- ============================================
DESCRIBE categories;
SELECT * FROM categories;

-- ============================================
-- 2. Missing Values
-- ============================================
SELECT * FROM categories WHERE CategoryID IS NULL;
SELECT * FROM categories WHERE CategoryName IS NULL OR TRIM(CategoryName) = '';
SELECT * FROM categories WHERE Description IS NULL OR TRIM(Description) = '';
-- Findings: No missing values found.

-- ============================================
-- 3. Duplicate Check
-- ============================================
SELECT CategoryID, CategoryName, Description, COUNT(*) AS Duplicate_Count
FROM categories
GROUP BY CategoryID, CategoryName, Description
HAVING COUNT(*) > 1;
-- Findings: No duplicates found.

-- ============================================
-- 4. Standardize CategoryName & Description
-- ============================================
SELECT CategoryID,
       CONCAT('|', CategoryName, '|') AS Original,
       CONCAT('|', TRIM(CategoryName), '|') AS Trimmed
FROM categories
WHERE CategoryName <> TRIM(CategoryName);

UPDATE categories
SET CategoryName = TRIM(CategoryName)
WHERE CategoryName <> TRIM(CategoryName);

-- Validation
SELECT * FROM categories WHERE CategoryName <> TRIM(CategoryName);
SELECT * FROM categories WHERE Description <> TRIM(Description);

/* ==============================
   CATEGORIES TABLE — SUMMARY
================================
- No missing values found.
- No duplicate records found.
- Standardized CategoryName (removed extra whitespace).
- Description validated, no changes required.
================================ */
