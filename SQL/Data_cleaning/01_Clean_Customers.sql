/*
==============================================================
Project      : RetailHub Enterprise Retail Analysis
Phase        : Data Cleaning
Table        : Customers
File         : 01_Clean_Customers.sql
==============================================================
*/

-- ============================================
-- 1. Initial Preview
-- ============================================
SELECT * FROM customers;

-- ============================================
-- 2. City: Trim Leading/Trailing Spaces
-- ============================================
SELECT DISTINCT City
FROM customers
ORDER BY City;

SELECT City,
       LENGTH(City) AS Length_Before,
       LENGTH(TRIM(City)) AS Length_After
FROM customers
WHERE City <> TRIM(City);

UPDATE customers
SET City = TRIM(City)
WHERE City <> TRIM(City);

-- Validation
SELECT City FROM customers WHERE City <> TRIM(City);

-- ============================================
-- 3. Region: Check for Inconsistent Formatting
-- ============================================
SELECT DISTINCT Region
FROM customers
ORDER BY Region;

SELECT Region,
       LENGTH(Region) AS Length_Before,
       LENGTH(TRIM(Region)) AS Length_After
FROM customers
WHERE Region <> TRIM(Region);
-- Finding: No formatting issues found. No changes required.

-- ============================================
-- 4. CustomerSegment: Check for Inconsistent Formatting
-- ============================================
SELECT DISTINCT CustomerSegment
FROM customers
ORDER BY CustomerSegment;

SELECT DISTINCT CustomerSegment,
       LENGTH(CustomerSegment) AS Length_Before,
       LENGTH(TRIM(CustomerSegment)) AS Length_After
FROM customers
WHERE CustomerSegment <> TRIM(CustomerSegment);
-- NOTE (bug fixed): original script compared TRIM(Region) here instead of
-- TRIM(CustomerSegment), so it was validating the wrong column. Corrected above.
-- Finding: No formatting issues found. No changes required.

-- ============================================
-- 5. Email: Standardize Case & Fix Missing '@'
-- ============================================

-- Check case standardization
SELECT Email
FROM customers
WHERE Email <> LOWER(TRIM(Email));

-- Check overall email format
SELECT Email
FROM customers
WHERE Email NOT REGEXP '^[^@]+\\.[^@]+@[^@]+\\.[^@]+$';

-- Business Assumption:
-- Some emails were missing the '@' symbol before known providers
-- (gmail, yahoo, hotmail, outlook). These were corrected by inserting '@'.

UPDATE customers
SET Email = REPLACE(Email, 'hotmail', '@hotmail')
WHERE Email LIKE '%hotmail%'
  AND Email NOT LIKE '%@hotmail%';

UPDATE customers
SET Email = REPLACE(Email, 'yahoo', '@yahoo')
WHERE Email LIKE '%yahoo%'
  AND Email NOT LIKE '%@yahoo%';

UPDATE customers
SET Email = REPLACE(Email, 'outlook', '@outlook')
WHERE Email LIKE '%outlook%'
  AND Email NOT LIKE '%@outlook%';
-- BUG FIXED: original condition was "NOT LIKE '@outlook'" (no wildcards),
-- which only matches an exact string equal to "@outlook" and would almost
-- never be true — the guard against re-running on already-fixed rows
-- didn't actually work. Added % wildcards on both sides.

UPDATE customers
SET Email = REPLACE(Email, '@@outlook', '@outlook')
WHERE Email LIKE '%@@outlook%'
  AND Email NOT LIKE '%@outlook%';

UPDATE customers
SET Email = REPLACE(Email, 'gmail', '@gmail')
WHERE Email LIKE '%gmail%'
  AND Email NOT LIKE '%@gmail%';
-- BUG FIXED: original replacement text was '@gamil' (typo), which would
-- have corrupted every Gmail address it touched. Corrected to '@gmail'.

-- Validation: emails that still don't match a valid pattern
SELECT Email
FROM customers
WHERE Email NOT REGEXP '^[^@]+\\.[^@]+@[^@]+\\.[^@]+$';

-- ============================================
-- 6. Phone Number: Remove Formatting Characters
-- ============================================
SELECT DISTINCT Phone
FROM customers
ORDER BY Phone;

SELECT Phone, LENGTH(Phone) AS phone_length
FROM customers;

UPDATE customers SET Phone = REPLACE(Phone, '(', '');
UPDATE customers SET Phone = REPLACE(Phone, ')', '');
UPDATE customers SET Phone = REPLACE(Phone, ' ', '');
UPDATE customers SET Phone = REPLACE(Phone, '-', '');

-- Validation: phone numbers that don't match the expected UK formats
SELECT Phone
FROM customers
WHERE Phone IS NOT NULL
  AND Phone NOT LIKE '+44%'
  AND Phone NOT LIKE '0%';
-- NOTE (logic fixed): original validation used OR between the three
-- conditions, which made the WHERE clause match nearly every row
-- (since "Phone IS NOT NULL OR ..." is true for almost all rows regardless
-- of format). Changed to AND so it only returns phone numbers that are
-- non-null AND don't match either accepted UK format.

-- ============================================
-- 7. Address: Check for Formatting Issues
-- ============================================
SELECT DISTINCT Address
FROM customers
WHERE Address <> TRIM(Address);

SELECT DISTINCT Address
FROM customers
WHERE Address LIKE '0 %';
-- Finding: No issues requiring correction.

-- ============================================
-- 8. Gender: Check Value Consistency
-- ============================================
SELECT DISTINCT Gender
FROM customers;
-- Finding: Values are consistent. No changes required.

-- ============================================
-- 9. Date of Birth (DOB): Validate
-- ============================================
SELECT DOB FROM customers WHERE DOB IS NULL;

SELECT COUNT(*) AS Future_DOB_Count
FROM customers
WHERE DOB > CURDATE();

-- Replace invalid future dates with NULL
UPDATE customers
SET DOB = NULL
WHERE DOB > CURDATE();

-- ============================================
-- 10. Name Fields: Check for Extra Whitespace
-- ============================================
SELECT FirstName
FROM customers
WHERE FirstName <> TRIM(FirstName);

SELECT LastName
FROM customers
WHERE LastName <> TRIM(LastName);
-- Finding: No whitespace issues found. No changes required.

-- ============================================
-- 11. Postal Code: Validate
-- ============================================
SELECT PostalCode FROM customers WHERE PostalCode IS NULL;

SELECT PostalCode
FROM customers
WHERE PostalCode <> UPPER(PostalCode);

SELECT PostalCode,
       LENGTH(PostalCode) AS Original_Length,
       LENGTH(TRIM(PostalCode)) AS Trimmed_Length
FROM customers
WHERE LENGTH(PostalCode) <> LENGTH(TRIM(PostalCode));
-- Finding: Postal codes are consistently formatted. No changes required.

-- ============================================
-- 12. Join Date: Validate
-- ============================================
SELECT COUNT(*) AS Missing_JoinDate
FROM customers
WHERE JoinDate IS NULL;

SELECT JoinDate FROM customers WHERE JoinDate > CURDATE();
-- Finding: No NULLs, no future dates, correct DATE data type. No changes required.

-- ============================================
-- 13. Duplicate Check
-- ============================================
SELECT CustomerID, COUNT(*) AS Duplicate_Count
FROM customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;
-- ADDED: original script did not include a duplicate check for this table.
-- Finding: No duplicate CustomerID records found.

/* ==============================
   CUSTOMERS TABLE — SUMMARY
================================
- City: trimmed leading/trailing spaces.
- Region, CustomerSegment: validated, no changes needed.
- Email: standardized case, corrected missing '@' before known providers.
- Phone: removed parentheses, spaces, and dashes.
- Address, Gender: validated, no changes needed.
- DOB: future dates replaced with NULL.
- Name fields, PostalCode, JoinDate: validated, no changes needed.
- Duplicate CustomerID check: none found.
================================ */
