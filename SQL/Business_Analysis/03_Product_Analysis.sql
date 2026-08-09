-- ============================================
-- Data Exploration: Checking Discount column format
-- ============================================

SELECT MAX(Discount) AS Max_discount, 
MIN(Discount) AS Min_discount
FROM orderdetails;


-- ============================================
-- Query 1A: Top 10 Products by Revenue
-- ============================================
-- Business question: Which products generate the most revenue?
-- Revenue = Quantity * UnitPrice * (1 - Discount)
-- Discount confirmed as decimal fraction (0.00 - 0.40)

SELECT p.ProductID, p.ProductName,
SUM(Quantity) AS TotalQuantity,
ROUND(SUM(Quantity*UnitPrice*(1-Discount)),2) AS TotalRevenue
FROM orderdetails od
JOIN products p
ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalRevenue DESC
LIMIT 10;



-- ============================================
-- Query 1B: Top 10 Products by Units Sold
-- ============================================
-- Business question: Which products sell the most units (volume)?
-- Compare against Query 1A to see if revenue leaders and volume leaders differ


SELECT p.ProductID,p.ProductName,
SUM(Quantity) AS TotalQuantity,
ROUND(SUM(Quantity*UnitPrice*(1-Discount)),2) AS TotalRevenue
FROM orderdetails od
JOIN products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID,p.ProductName
ORDER BY TotalQuantity DESC
LIMIT 10;




-- ============================================
-- Data Check: Verify Cost/Profit columns have no NULLs
-- ============================================
-- Confirms orderdetails.Cost and orderdetails.Profit are complete
-- before relying on them in Query 2

SELECT COUNT(*) AS Total_rows,
SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END),
SUM(CASE WHEN Cost IS NULL THEN 1 ELSE 0 END)
FROM orderdetails;


-- ============================================
-- Query 2: Revenue & Profit by Category
-- ============================================
-- Business question: Which categories generate the most revenue,
-- and which are actually the most profitable?
-- Added ProfitMargin% to compare efficiency, not just totals —
-- a category can earn more total profit but still be less efficient
-- than a smaller category (e.g. Kitchen Appliances vs Stationery)
SELECT c.CategoryID, c.CategoryName,
SUM(Quantity) AS TotalQuantity,
ROUND(SUM(od.Quantity*od.UnitPrice*(1-od.Discount)), 2) AS TotalRevenue,
SUM(od.Profit) AS TotalProfit,
ROUND(SUM(od.Profit)/(SUM(od.Quantity*od.UnitPrice*(1-od.Discount)))*100, 2) AS ProfitMarginPct
FROM orderdetails od
JOIN products p ON od.ProductID = p.ProductID
JOIN categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY TotalRevenue DESC;



-- ============================================
-- Query 3: Product Ranking Within Category (Top 3 per Category)
-- ============================================
-- Business question: Who are the top 3 performing products in each category?
-- DENSE_RANK() calculated in the inner query, then filtered in the outer query
-- (window functions can't be filtered directly in WHERE)

SELECT*
FROM (
SELECT c.CategoryName, p.ProductID, p.ProductName,
ROUND(SUM(od.Quantity*od.unitPrice*(1-Discount)), 2) AS ProductRevenue,
DENSE_RANK() OVER(PARTITION BY c.CategoryID ORDER BY 
SUM(od.Quantity*UnitPrice*(1-Discount)) DESC) AS RevenueRankInCategory
FROM orderdetails od
JOIN products p  ON od.ProductID = p.ProductID
JOIN categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryID,c.CategoryName,p.ProductID, p.ProductName
) AS RankedProducts
WHERE RevenueRankInCategory <= 3
ORDER BY CategoryName, RevenueRankInCategory;





SELECT DISTINCT Status
FROM products
