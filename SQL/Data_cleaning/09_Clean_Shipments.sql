/*
==============================================================
Project      : RetailHub Enterprise Retail Analysis
Phase        : Data Cleaning
Table        : Shipments
File         : 09_Clean_Shipments.sql
==============================================================
*/

-- ============================================
-- 1. Initial Preview
-- ============================================
SELECT * FROM shipments;

-- ============================================
-- 2. Duplicate Check
-- ============================================
SELECT ShipmentID, COUNT(*) AS Duplicate_Count
FROM shipments
GROUP BY ShipmentID
HAVING COUNT(*) > 1;
-- Findings: No duplicate ShipmentID records found.

-- ============================================
-- 3. Missing Values
-- ============================================
SELECT COUNT(*) AS Total_Rows,
    SUM(CASE WHEN ShipmentID IS NULL THEN 1 ELSE 0 END) AS Missing_ShipmentID,
    SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) AS Missing_OrderID,
    SUM(CASE WHEN Carrier IS NULL OR TRIM(Carrier) = '' THEN 1 ELSE 0 END) AS Missing_Carrier,
    SUM(CASE WHEN ShipDate IS NULL THEN 1 ELSE 0 END) AS Missing_ShipDate,
    SUM(CASE WHEN DeliveryDate IS NULL THEN 1 ELSE 0 END) AS Missing_DeliveryDate
FROM shipments;

-- Fixed 500 missing Carrier values -> replaced with 'Unknown' to preserve
-- data integrity (rather than leaving blank/NULL).
UPDATE shipments
SET Carrier = 'Unknown'
WHERE Carrier IS NULL OR TRIM(Carrier) = '';

-- ============================================
-- 4. Date Logic: ShipDate vs DeliveryDate
-- ============================================
SELECT * FROM shipments WHERE ShipDate > DeliveryDate;

-- Fixed 500 rows where ShipDate and DeliveryDate were swapped
-- (delivery appeared to happen before shipping).
UPDATE shipments
SET ShipDate = (@temp := ShipDate),
    ShipDate = DeliveryDate,
    DeliveryDate = @temp
WHERE ShipDate > DeliveryDate;

-- Validation
SELECT * FROM shipments WHERE ShipDate > DeliveryDate;

-- ============================================
-- 5. OrderID: Check for Placeholder Values
-- ============================================
SELECT OrderID, COUNT(*) AS Shipment_Count
FROM shipments
GROUP BY OrderID
HAVING COUNT(*) > 1
ORDER BY OrderID DESC
LIMIT 10;

SELECT * FROM shipments WHERE OrderID = '555555';

-- Fixed 400 shipments incorrectly tagged with placeholder OrderID 555555.
-- Set OrderID to NULL since the true OrderID is unknown/unrecoverable.
UPDATE shipments
SET OrderID = NULL
WHERE OrderID = '555555';

-- Validation
SELECT * FROM shipments WHERE OrderID = '555555';

/* ==============================
   SHIPMENTS TABLE — SUMMARY
================================
- No duplicate ShipmentID records found.
- 500 missing Carrier values replaced with 'Unknown'.
- 500 rows with swapped ShipDate/DeliveryDate corrected.
- 400 shipments with placeholder OrderID (555555) set to NULL.
================================ */
