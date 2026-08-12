-- ============================================
-- RetailHub Ltd - Business Analysis
-- 01_Overall_Performance.sql
-- ============================================


-- --------------------------------------------
-- Section 1: Data Integrity Check
-- 750 orders exist in `orders` with no matching
-- rows in `orderdetails`. Documented here, not
-- removed, since it affects how Total_Orders
-- and Avg_Order_Value are calculated below.
-- --------------------------------------------

SELECT o.OrderID, o.OrderStatus
FROM orders o
LEFT JOIN orderdetails od
    ON o.OrderID = od.OrderID
WHERE od.OrderID IS NULL;

SELECT o.OrderStatus, COUNT(*) AS Count
FROM orders o
LEFT JOIN orderdetails od
    ON o.OrderID = od.OrderID
WHERE od.OrderID IS NULL
GROUP BY o.OrderStatus;


-- --------------------------------------------
-- Section 2: Basic Row Counts
-- --------------------------------------------

SELECT COUNT(*) FROM orders;

SELECT * FROM orderdetails;


-- --------------------------------------------
-- Section 3: Price Range Check
-- --------------------------------------------

SELECT MAX(UnitPrice), MIN(UnitPrice), AVG(UnitPrice)
FROM orderdetails;


-- --------------------------------------------
-- Section 4: Revenue & Order Value (orderdetails only)
-- Avg_Order_Value here only reflects orders that
-- actually have matching OrderDetails rows.
-- --------------------------------------------

SELECT
    SUM(Quantity * UnitPrice) AS Total_Revenue,
    COUNT(DISTINCT OrderID) AS Total_Orders,
    SUM(Quantity * UnitPrice) / COUNT(DISTINCT OrderID) AS Avg_Order_Value
FROM orderdetails;


-- --------------------------------------------
-- Section 5: Final Overall Metrics
-- Total_Orders pulled from `orders` (true total,
-- including the 750 with no details), Total_Revenue
-- and Avg_Order_Value calculated from `orderdetails`.
-- --------------------------------------------

SELECT
    (SELECT COUNT(*) FROM orders) AS Total_Orders,
    SUM(Quantity * UnitPrice) AS Total_Revenue,
    ROUND(SUM(Quantity * UnitPrice) / (SELECT COUNT(*) FROM orders), 2) AS Avg_Order_Value
FROM orderdetails;
