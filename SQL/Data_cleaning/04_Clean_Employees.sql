/*
==============================================================
Project      : RetailHub Enterprise Retail Analysis
Phase        : Data Cleaning
Table        : Employees
File         : 04_Clean_Employees.sql
==============================================================
*/

-- ============================================
-- 1. Initial Preview
-- ============================================
DESCRIBE employees;
SELECT * FROM employees;

-- ============================================
-- 2. Name Casing Checks
-- ============================================
SELECT DISTINCT FirstName FROM employees WHERE FirstName LIKE '% %';
SELECT DISTINCT LastName FROM employees WHERE LastName LIKE '% %';

SELECT DISTINCT FirstName
FROM employees
WHERE BINARY LEFT(FirstName, 1) BETWEEN 'a' AND 'z';

SELECT DISTINCT LastName
FROM employees
WHERE BINARY LEFT(LastName, 1) BETWEEN 'a' AND 'z';

SELECT FirstName FROM employees WHERE FirstName <> TRIM(FirstName);
SELECT LastName FROM employees WHERE LastName <> TRIM(LastName);
-- Findings: No casing or whitespace issues found. No changes required.

-- ============================================
-- 3. Duplicate Check & Removal
-- ============================================
WITH Duplicate_Records AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY FirstName, LastName, JobTitle, StoreID, HireDate, Salary, Email
            ORDER BY EmployeeID
        ) AS rn
    FROM employees
)
SELECT * FROM Duplicate_Records WHERE rn > 1;

DELETE e
FROM employees e
JOIN (
    SELECT EmployeeID,
        ROW_NUMBER() OVER (
            PARTITION BY FirstName, LastName, JobTitle, StoreID, HireDate, Salary, Email
            ORDER BY EmployeeID
        ) AS rn
    FROM employees
) d ON e.EmployeeID = d.EmployeeID
WHERE d.rn > 1;
-- NOTE (fixed): original DELETE's inner ROW_NUMBER() had no ORDER BY, which
-- is non-deterministic — MySQL doesn't guarantee which duplicate "wins" and
-- re-running the query could delete a different row each time. Added
-- "ORDER BY EmployeeID" so the lowest EmployeeID is always kept.

-- Validation
SELECT EmployeeID, COUNT(*) AS Duplicate_Count
FROM employees
GROUP BY EmployeeID
HAVING COUNT(*) > 1;

-- ============================================
-- 4. Email: Standardize & Validate
-- ============================================
SELECT EmployeeID, Email
FROM employees
WHERE Email REGEXP '_at_';

UPDATE employees
SET Email = REPLACE(Email, '_at_', '@')
WHERE Email LIKE '%_at_%';

SELECT EmployeeID, Email
FROM employees
WHERE Email NOT REGEXP '^[a-z0-9._%+''-]+@[a-z0-9.-]+\\.[a-z]{2,}$';

-- Check duplicate emails (e.g. shared inbox, distinct employees)
SELECT Email, COUNT(*) AS Duplicate_Email_Count
FROM employees
GROUP BY Email
HAVING COUNT(*) > 1;
-- Findings: Duplicate emails found belong to different employee records
-- (e.g. graham.jackson@retailhub.co.uk). No action taken — this reflects
-- a shared/legacy mailbox rather than a data error.

-- ============================================
-- 5. Salary: Validate
-- ============================================
SELECT * FROM employees WHERE Salary IS NULL;
SELECT * FROM employees WHERE Salary <= 0;
SELECT Salary FROM employees ORDER BY Salary DESC;
SELECT Salary FROM employees ORDER BY Salary ASC;
-- Findings: Checked for missing, negative, zero, and unusual salary values.
-- No issues found.

-- ============================================
-- 6. JobTitle & StoreID: Validate
-- ============================================
SELECT DISTINCT JobTitle FROM employees ORDER BY JobTitle;
SELECT * FROM employees WHERE StoreID IS NULL;
SELECT * FROM employees WHERE StoreID <= 0;
-- Findings: No issues found.

-- ============================================
-- 7. HireDate: Validate
-- ============================================
SELECT * FROM employees WHERE HireDate IS NULL;
-- Missing HireDate values identified. Left as NULL because no reliable
-- source exists to determine the correct dates.

SELECT * FROM employees WHERE HireDate >= CURDATE();
-- Findings: No future-dated HireDate values found.

/* ==============================
   EMPLOYEES TABLE — SUMMARY
================================
- Duplicate records removed (kept lowest EmployeeID per duplicate group).
- Email: fixed "_at_" placeholder formatting; format validated.
- Duplicate emails checked — confirmed legitimate, different employees.
- Salary, JobTitle, StoreID: validated, no issues found.
- HireDate: missing values kept as NULL; no future dates found.
================================ */
