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


-- ============================================
-- Data Check: Distinct Status values in products
-- ============================================

SELECT DISTINCT Status
FROM products;


-- ============================================
-- Query 4A: Products with Zero Sales (Full List, All Statuses)
-- ============================================
-- Business question: Which products have never sold, across all statuses?
-- Uses LEFT JOIN so products with NO matching orderdetails still appear
-- (a regular JOIN would silently exclude them).
-- COALESCE turns NULL (no matching sales) into 0 for a clean, readable result.
-- HAVING is used (not WHERE) because we're filtering on an aggregated value.

SELECT 
    p.ProductID,
    p.ProductName,
    p.Status,
    COALESCE(SUM(od.Quantity), 0) AS TotalUnitsSold
FROM products p
LEFT JOIN orderdetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName, p.Status
HAVING TotalUnitsSold = 0
ORDER BY p.Status, p.ProductName;

-- Result: 0 rows returned.


-- ============================================
-- Query 4B: Active Products with Zero Sales (Actionable List)
-- ============================================
-- Business question: Of products we're currently supposed to be selling,
-- which ones aren't moving at all? This is the list worth investigating,
-- since Discontinued/Out of Stock products having low sales is expected.

SELECT 
    p.ProductID,
    p.ProductName,
    p.CategoryID,
    COALESCE(SUM(od.Quantity), 0) AS TotalUnitsSold
FROM products p
LEFT JOIN orderdetails od ON p.ProductID = od.ProductID
WHERE p.Status = 'Active'
GROUP BY p.ProductID, p.ProductName, p.CategoryID
HAVING TotalUnitsSold = 0
ORDER BY p.ProductName;

-- Result: 0 rows returned.


-- ============================================
-- Data Check: Lowest 20 products by units sold (by category)
-- ============================================
-- Since zero-sales queries returned nothing, checked the real distribution
-- of the lowest sellers to see if any products are unusually weak.

SELECT p.ProductID, c.CategoryName, p.ProductName,
SUM(od.Quantity) AS TotalUnitSold
FROM products p
JOIN orderdetails od ON p.ProductID = od.ProductID
JOIN categories c ON p.CategoryID = c.CategoryID
GROUP BY p.ProductID, c.CategoryName, p.ProductName
ORDER BY TotalUnitSold ASC
LIMIT 20;

-- Finding: Unlike typical real-world retail data, this synthetic dataset shows
-- no true dead stock — even the lowest-performing products sold 500+ units,
-- with no single category underperforming disproportionately. This suggests
-- the data generation process distributed sales fairly evenly across the catalog.


-- ============================================
-- Query 5A: Profit Margin by Product (Highest First)
-- ============================================
-- Business question: Which individual products are the most profitable
-- to sell, regardless of category?

SELECT 
    p.ProductID,
    p.ProductName,
    ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) AS TotalRevenue,
    SUM(od.Profit) AS TotalProfit,
    ROUND((SUM(od.Profit) / SUM(od.Quantity * od.UnitPrice * (1 - od.Discount))) * 100, 2) AS ProfitMarginPct
FROM orderdetails od
JOIN products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY ProfitMarginPct DESC
LIMIT 10;


-- ============================================
-- Query 5B: Profit Margin by Product (Lowest First)
-- ============================================
-- Business question: Which individual products are the LEAST profitable
-- to sell, even if they might sell in good volume?

SELECT 
    p.ProductID,
    p.ProductName,
    ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) AS TotalRevenue,
    SUM(od.Profit) AS TotalProfit,
    ROUND((SUM(od.Profit) / SUM(od.Quantity * od.UnitPrice * (1 - od.Discount))) * 100, 2) AS ProfitMarginPct
FROM orderdetails od
JOIN products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY ProfitMarginPct ASC
LIMIT 10;

-- Finding: Profit margin varies a lot by product. The best (Epson Printer)
-- earns ~53.58% margin, the worst (Opti Resistance Bands) only ~15.72% —
-- over 3x difference. Worth checking why low-margin products cost so much
-- or are priced so low.
