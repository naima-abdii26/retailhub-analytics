-- ============================================
-- Query 1: Top 10 Customers by Total Spending
-- ============================================
-- Business question: Who are our highest-value customers?
-- Chains customers -> orders -> orderdetails to calculate real revenue per customer

SELECT c.CustomerID,CONCAT(c.FirstName,' ', c.LastName) AS FullName,c.CustomerSegment,
ROUND(SUM(od.Quantity*UnitPrice*(1-Discount)),2) AS TotalSpent
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
JOIN orderdetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.CustomerSegment
ORDER BY TotalSpent DESC
LIMIT 10;


-- ============================================
-- Query 2: Average Spending by Customer Segment
-- ============================================
-- Business question: Do Corporate/Small Business customers actually spend
-- more on average than Consumers, despite not dominating the top-10 list?


SELECT c.CustomerSegment,
COUNT(DISTINCT c.CustomerID) AS NumCustomers,
ROUND(SUM(od.Quantity*UnitPrice*(1-Discount)),2) AS TotalRevenue,
ROUND(SUM(od.Quantity*UnitPrice*(1-Discount))/COUNT(DISTINCT c.CustomerID),2) AS AvgSpendPerCustomer
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
JOIN orderdetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerSegment
ORDER BY AvgSpendPerCustomer DESC;
-- Finding: Unlike the common assumption that Corporate customers spend more,
-- all three segments average very similar spending per customer (~$27,700-$28,600).
-- Corporate customers do NOT stand out as bigger spenders in this dataset.





-- Data Check: JoinDate range (2022-01-01 to 2025-11-30) — used 
-- to set New/Established/Loyal buckets below

SELECT MIN(JoinDate)AS EarliestJoin, MAX(JoinDate) AS LatestJoin
FROM customers;



-- ============================================
-- Query 3: New vs. Established vs. Loyal Customers
-- ============================================
-- Business question: Do customers who joined longer ago spend more
-- than newer customers?
-- JoinDate range confirmed: 2022-01-01 to 2025-11-30

SELECT
  CASE
  WHEN c.JoinDate >= '2025-01-01' THEN 'New (2025)'
  WHEN c.JoinDate >= '2023-01-01' THEN 'Established (2023-2024)'
  ELSE 'Loyal (2022 or earlier)'
  END AS CustomerGroup,
  COUNT(DISTINCT c.customerID) AS NumCustomers,
  ROUND(SUM(od.Quantity*od.UnitPrice*(1-Discount)),2) AS TotalRevenue,
  ROUND(SUM(od.Quantity*UnitPrice*(1-Discount))/ COUNT(DISTINCT c.customerID),2) AS AvgSpendPerCustomer
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
JOIN orderdetails od ON o.OrderID = od.OrderID
GROUP BY  CustomerGroup
ORDER BY AvgSpendPerCustomer DESC;


-- ===================================================================
-- QUERY 4 PART A: Recency & Frequency Analysis
-- ===================================================================
-- Latest purchase date, earliest purchase date, and total orders per customer
-- Reveals active vs. dormant customers and long-term loyalty patterns


SELECT c.CustomerID, MAX(o.OrderDate) AS LatestPurchaseDate,
 MIN(o.OrderDate) AS  EarliestPurchaseDate,
 COUNT(o.OrderID) AS TotalOrder
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID;


SELECT c.CustomerID, MAX(o.OrderDate) AS LatestPurchaseDate,
 MIN(o.OrderDate) AS  EarliestPurchaseDate,
 COUNT(o.OrderID) AS TotalOrder
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalOrder;




SELECT c.CustomerID, MAX(o.OrderDate) AS LatestPurchaseDate,
 MIN(o.OrderDate) AS  EarliestPurchaseDate,
 COUNT(o.OrderID) AS TotalOrder
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
HAVING MAX(o.OrderDate)>= DATE_SUB('2025-12-31', INTERVAL 6 MONTH)
ORDER BY LatestPurchaseDate;



-- Check: What dates actually exist in your orders data?
SELECT DISTINCT OrderDate 
FROM orders 
ORDER BY OrderDate DESC 
LIMIT 20;



SELECT 
    c.CustomerID,
    MAX(o.OrderDate) AS LatestPurchaseDate,
    MIN(o.OrderDate) AS EarliestPurchaseDate,
    COUNT(o.OrderID) AS TotalOrders
FROM customers c
JOIN orders o 
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY LatestPurchaseDate DESC;




-- ===================================================================
-- QUERY 4 PART B: Recency & Frequency Analysis with Segmentation
-- ===================================================================
-- Categorize customers into recency segments: ACTIVE, AT-RISK, DORMANT

SELECT c.CustomerID, MAX(o.OrderDate) AS LatestPurchaseDate,
DATEDIFF('2025-12-31', MAX(o.OrderDate)) AS DaysSinceLastPurchase,
CASE 
WHEN DATEDIFF('2025-12-31', MAX(o.OrderDate)) <= 180 THEN 'Active'
WHEN DATEDIFF('2025-12-31', MAX(o.OrderDate)) <= 365 THEN 'At-Risk'
ELSE 'Dormant'
END AS RecencySegment,
COUNT(o.OrderID) AS TotalOrders
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
GROUP BY  c.CustomerID
ORDER BY LatestPurchaseDate DESC;



-- ===================================================================
-- QUERY 4 PART C: Monetary Analysis with Recency & Frequency
-- ===================================================================
-- Revenue, avg order value, recency, and frequency per customer - holistic VIP view


SELECT c.CustomerID, CONCAT(c.FirstName, '',c.LastName) AS FullName,
MAX(o.OrderDate) AS LatestPurchaseDate,
DATEDIFF('2025-12-30', MAX(o.OrderDate)) AS  SinceLastPurchase,
COUNT(DISTINCT o.OrderId) AS TotalOrders,
ROUND(SUM(od.Quantity*od.UnitPrice*(1-Discount)),2) AS TotalSpent,
ROUND(SUM(od.Quantity*od.UnitPrice*(1-Discount))/COUNT(DISTINCT o.OrderId),2) AS AvgOrderValue
FROM customers c 
JOIN orders o ON c.CustomerID = o.CustomerID
JOIN orderdetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.FirstName, c.LastName 
ORDER BY TotalSpent DESC ;


    

