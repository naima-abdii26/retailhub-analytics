-- =====================================================
-- File: 02_Sales_Trends.sql
-- Purpose: Analyze sales trends over time (monthly revenue, growth, seasonality)
-- Tables Used:
--   - orders        
--   - orderdetails 
-- =====================================================

-- Quick preview of table structure before analysis
SELECT * FROM orderdetails LIMIT 10;

SELECT * FROM orders LIMIT 10;

-- Check 1: Count orders with NULL OrderDate

SELECT COUNT(*) AS Count_OrderDate_Nuls
FROM orders
WHERE OrderDate IS NULL;
-- Result: 151 orders

-- Check 2: Confirm revenue tied to NULL OrderDate orders
SELECT SUM(Quantity*UnitPrice) AS Total_Revenue
FROM orderdetails od
JOIN orders o
ON od.OrderID = o.OrderID
WHERE OrderDate IS NULL;
-- Result: $617,660.68 — confirmed to match the NULL row from Query 1




-- =====================================================
-- Query 1: Monthly Revenue Trend
-- Purpose: Track total revenue by year and month to identify trends over time
-- Note: Excludes 151 orders with NULL OrderDate (total revenue $617,660.68)
--       These orders cannot be placed on a monthly timeline.
-- =====================================================


SELECT YEAR(OrderDate) AS OrderYear,
MONTH(OrderDate) AS OrderMonth,
SUM(Quantity*UnitPrice) AS Total_Revenue
FROM orderdetails od
JOIN orders o
ON od.OrderID = o.OrderID
WHERE OrderDate IS NOT NULL
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY OrderYear, OrderMonth;




-- =====================================================
-- Query 2: Month-over-Month Revenue Growth
-- Purpose: Compare each month's revenue to the previous month to track growth/decline
-- Note: Excludes 151 orders with NULL OrderDate (see data quality checks above)
--       Uses two CTEs: first calculates monthly revenue, second adds the 
--       previous month's revenue using LAG(), final SELECT calculates growth
-- =====================================================


WITH MonthlyRevenue AS
(
SELECT YEAR(OrderDate) AS OrderYear,
MONTH(OrderDate) AS OrderMonth,
SUM(Quantity*UnitPrice) AS Total_Revenue
FROM orderdetails od
JOIN orders o
ON od.OrderID = o.OrderID
WHERE OrderDate IS NOT NULL
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY OrderYear, OrderMonth

),
RevenueWithLag AS 
(
SELECT OrderYear, OrderMonth,Total_Revenue,
LAG(Total_Revenue,1) OVER (ORDER BY OrderYear, OrderMonth) AS Previous_Month_Revenue
FROM MonthlyRevenue 
)
SELECT  OrderYear, OrderMonth,Total_Revenue,Previous_Month_Revenue,
Total_Revenue- Previous_Month_Revenue AS Growth_Amount,
ROUND((Total_Revenue- Previous_Month_Revenue)/ Previous_Month_Revenue*100,2) AS Growth_Amount_Percent
FROM RevenueWithlag;





-- =====================================================
-- Query 3: Seasonal Patterns
-- Purpose: Identify months that are consistently strong or weak across all years,
--          to detect repeatable seasonal trends (not just single-year fluctuations)
-- Note: Excludes 151 orders with NULL OrderDate (see data quality checks above)
--       Data spans 2022-01-01 to 2025-12-31 (4 complete years), so every month
--       has equal representation, making SUM and AVG comparisons fair across months
-- =====================================================

SELECT MIN(OrderDate) AS Earliest_Date,
MAX(OrderDate) AS latest_Date
FROM orders
WHERE OrderDate IS NOT NULL;


WITH YearlyMonthlyRevenue AS 
(
SELECT YEAR(OrderDate) AS OrderYear,
MONTH(OrderDate) AS OrderMonth,
SUM(Quantity*UnitPrice) AS Total_Revenue
FROM orderdetails od
JOIN orders o
ON od.OrderID = o.OrderID
WHERE OrderDate IS NOT NULL
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY OrderYear, OrderMonth
)
SELECT OrderMonth,
SUM(Total_Revenue) AS Total_Revenue_All_Years,
ROUND(AVG(Total_Revenue),2)AS Average_Revenue_Per_Year
FROM YearlyMonthlyRevenue
GROUP BY OrderMonth
ORDER BY orderMonth;

























