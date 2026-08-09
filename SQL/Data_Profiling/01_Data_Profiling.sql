/*
=========================================================
Project      : RetailHub Enterprise Retail Analysis
File         : 01_Data_Profiling.sql
Description  : Data Profiling
=========================================================
*/

-- =====================================================
-- STEP 1: Check Table Structure
-- Purpose: View the structure of each table.
-- =====================================================

DESCRIBE Categories;
DESCRIBE Suppliers;
DESCRIBE Products;
DESCRIBE Stores;
DESCRIBE Employees;
DESCRIBE Customers;
DESCRIBE Promotions;
DESCRIBE Orders;
DESCRIBE OrderDetails;
DESCRIBE Inventory;
DESCRIBE Shipments;
DESCRIBE Returns;







-- =====================================================
-- STEP 2: Preview Data from Each Table
-- Purpose: Understand the structure and contents of each table before profiling.
-- =====================================================
SELECT *
FROM Categories
LIMIT 10;


SELECT *
FROM Suppliers
LIMIT 10;

SELECT *
FROM Stores
LIMIT 10;

SELECT *
FROM Employees
LIMIT 10;

SELECT *
FROM Customers
LIMIT 10;

SELECT *
FROM Promotions
LIMIT 10;

SELECT *
FROM Orders
LIMIT 10;

SELECT *
FROM Inventory
LIMIT 10;


SELECT *
FROM Shipments
LIMIT 10;


SELECT *
FROM Returns
LIMIT 10;



-- =====================================================
-- STEP 3: Check for Duplicate Records
-- Purpose: Identify exact duplicate records in each table
--          to ensure data quality before data cleaning
--          and analysis.
-- =====================================================



SELECT COUNT(*) AS total_rows
FROM customers;


SELECT COUNT(*) AS total_rows
FROM orders;

SELECT COUNT(*) AS total_rows
FROM products;

SELECT COUNT(*) AS total_rows
FROM promotions;

SELECT COUNT(*) AS total_rows
FROM suppliers;

SELECT COUNT(*) AS total_rows
FROM employees;

-- Check for duplicate records

SELECT OrderID, CustomerID, OrderDate, 
StoreID, EmployeeID,PaymentMethod,
ShippingMethod,OrderStatus, COUNT(*) AS duplicates
FROM orders 
GROUP BY OrderID, CustomerID, OrderDate, 
StoreID, EmployeeID,PaymentMethod,
ShippingMethod,OrderStatus
HAVING COUNT(*) >1;

-- Result:
-- No exact duplicate records were found in the Orders table.
-- The table passed the duplicate record quality check.

SELECT CustomerID,FirstName,LastName,
Gender,DOB, Email,Phone,Address,City,
Region,PostalCode,CustomerSegment,
JoinDate, COUNT(*) AS Duplicates
FROM customers
GROUP BY CustomerID,FirstName,LastName,
Gender,DOB, Email,Phone,Address,City,
Region,PostalCode,CustomerSegment,
JoinDate
HAVING COUNT(*)>1;
-- Result:
-- No exact duplicate records were found in the customers table.
-- The table passed the duplicate record quality check.

SELECT EmployeeID,FirstName,LastName,
JobTitle,StoreID,HireDate,Salary,Email, COUNT(*) AS Duplicates
FROM employees
GROUP BY EmployeeID,FirstName,LastName,
JobTitle,StoreID,HireDate,Salary,Email
HAVING COUNT(*)>1;

-- Result:
-- No exact duplicate records were found in the Employee table.
-- The table passed the duplicate record quality check.


SELECT ProductID,SKU,ProductName,
Brand,CategoryID,SupplierID,CostPrice
,SellingPrice,LaunchDate,
Status, COUNT(*)AS duplicates
FROM products
GROUP BY ProductID,SKU,ProductName,
Brand,CategoryID,SupplierID,CostPrice
,SellingPrice,LaunchDate
HAVING COUNT(*)>1;

-- Result:
-- No exact duplicate records were found in the Product table.
-- The table passed the duplicate record quality check.


SELECT InventoryID,StoreID, 
StockQuantity,ReorderLevel,LastUpdated,
COUNT(*) AS Duplicates
FROM inventory
GROUP BY InventoryID,StoreID, 
StockQuantity,ReorderLevel,LastUpdated
HAVING COUNT(*)>1;
-- Result:
-- No exact duplicate records were found in the Inventory table.
-- The table passed the duplicate record quality check.

SELECT StoreID, StoreName, Address,
City, Region,ManagerID, COUNT(*) AS  duplicates
FROM stores
GROUP BY StoreID, StoreName, Address,
City, Region,ManagerID
HAVING COUNT(*)>1;

-- Result:
-- No exact duplicate records were found in the Stores table.
-- The table passed the duplicate record quality check.


SELECT SupplierID,SupplierName,ContactName,
Email,Phone,City,Country, COUNT(*) AS duplicates
FROM suppliers
GROUP BY SupplierID,SupplierName,ContactName,
Email,Phone,City,Country
HAVING COUNT(*)>1;
-- Result:
-- No exact duplicate records were found in the Suppliers table.
-- The table passed the duplicate record quality check.

SELECT OrderDetailID, OrderID,ProductID,
Quantity,UnitPrice,Discount,Cost,Profit,
COUNT(*) AS duplicates
FROM orderdetails
GROUP BY OrderDetailID, OrderID,ProductID,
Quantity,UnitPrice,Discount,Cost,Profit
HAVING COUNT(*)>1;
-- Result:
-- No exact duplicate records were found in the Orderdetail table.
-- The table passed the duplicate record quality check.

SELECT PromotionID,CampaignName,StartDate
EndDate,DiscountPercent, COUNT(*)AS duplicates
FROM promotions
GROUP BY PromotionID,CampaignName,StartDate,
EndDate,DiscountPercent
HAVING COUNT(*)>1;
-- Result:
-- No exact duplicate records were found in the Promotions table.
-- The table passed the duplicate record quality check.

SELECT ReturnID,ReturnDate,ReturnDate,
RefundAmount,ReturnReason, COUNT(*) AS duplicates
FROM returns
GROUP BY ReturnID,ReturnDate,ReturnDate,
RefundAmount,ReturnReason
HAVING COUNT(*)>1;
-- Result:
-- No exact duplicate records were found in the returns table.
-- The table passed the duplicate record quality check.

SELECT ShipmentID,OrderID,Carrier,
ShipDate,DeliveryDate,ShippingCost,
COUNT(*) AS duplicates
FROM shipments
GROUP BY  ShipmentID,OrderID,Carrier,
ShipDate,DeliveryDate,ShippingCost
HAVING COUNT(*)>1;
-- Result:
-- No exact duplicate records were found in the Shippment table.
-- The table passed the duplicate record quality check.



-- =====================================================
-- STEP 4: Check for Missing (NULL & Empty) Values
-- Purpose: Identify missing values & Empty string in the all tables.
-- =====================================================

-- Check for Missing values records
SELECT COUNT(*) TotalRows,
SUM(CASE WHEN CustomerID IS NULL OR TRIM(CustomerID) = '' THEN 1 ELSE 0 END) AS CustomerID_Missing,
SUM(CASE WHEN FirstName IS NULL OR TRIM(firstName) = '' THEN 1 ELSE 0 END) AS FirstName_Missing,
SUM(CASE WHEN LastName IS NULL OR TRIM(LastName) = '' THEN 1 ELSE 0 END) AS Last_Missing,
SUM(CASE WHEN Gender IS NULL OR TRIM(Gender) = '' THEN 1 ELSE 0 END) AS Gender_Missing,
SUM(CASE WHEN DOB IS NULL  THEN 1 ELSE 0 END) AS DOB_Missing,
SUM(CASE WHEN Email IS NULL  OR TRIM(Email)= '' THEN 1 ELSE 0 END) AS Email_Missing,
SUM(CASE WHEN Phone IS NULL OR TRIM(Phone)= '' THEN 1 ELSE 0 END) AS Phone_Missing,
SUM(CASE WHEN Address IS NULL OR TRIM(Address)= '' THEN 1 ELSE 0 END) AS Address_Missing,
SUM(CASE WHEN City IS NULL OR TRIM(City)= '' THEN 1 ELSE 0 END) AS City_Missing
FROM customers;


SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) AS OrderID_Missing,
    SUM(CASE WHEN CustomerID IS NULL OR TRIM(CustomerID) = '' THEN 1 ELSE 0 END) AS CustomerID_Missing,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS OrderDate_Missing,
    SUM(CASE WHEN StoreID IS NULL OR TRIM(StoreID) = '' THEN 1 ELSE 0 END) AS StoreID_Missing,
    SUM(CASE WHEN EmployeeID IS NULL OR TRIM(EmployeeID) = '' THEN 1 ELSE 0 END) AS EmployeeID_Missing,
    SUM(CASE WHEN PaymentMethod IS NULL OR TRIM(PaymentMethod) = '' THEN 1 ELSE 0 END) AS PaymentMethod_Missing,
    SUM(CASE WHEN ShippingMethod IS NULL OR TRIM(ShippingMethod) = '' THEN 1 ELSE 0 END) AS ShippingMethod_Missing,
    SUM(CASE WHEN OrderStatus IS NULL OR TRIM(OrderStatus) = '' THEN 1 ELSE 0 END) AS OrderStatus_Missing
FROM orders;


SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN CategoryID  IS NULL THEN 1 ELSE 0 END) AS CategoryID_Missing,
    SUM(CASE WHEN  CategoryName IS NULL OR TRIM(CategoryName) = '' THEN 1 ELSE 0 END) AS CategoryName_Missing,
    SUM(CASE WHEN Description IS NULL OR TRIM(Description) = '' THEN 1 ELSE 0 END) AS Description_Missing
FROM categories;


SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS ProductID_Missing,
    SUM(CASE WHEN SKU IS NULL OR TRIM(SKU) = '' THEN 1 ELSE 0 END) AS SKU_Missing,
    SUM(CASE WHEN ProductName IS NULL OR TRIM(ProductName) = '' THEN 1 ELSE 0 END) AS ProductName_Missing,
    SUM(CASE WHEN Brand IS NULL OR TRIM(Brand) = '' THEN 1 ELSE 0 END) AS Brand_Missing,
    SUM(CASE WHEN CategoryID IS NULL THEN 1 ELSE 0 END) AS CategoryID_Missing,
    SUM(CASE WHEN SupplierID IS NULL THEN 1 ELSE 0 END) AS SupplierID_Missing,
    SUM(CASE WHEN CostPrice IS NULL THEN 1 ELSE 0 END) AS CostPrice_Missing,
    SUM(CASE WHEN SellingPrice IS NULL THEN 1 ELSE 0 END) AS SellingPrice_Missing,
    SUM(CASE WHEN LaunchDate IS NULL THEN 1 ELSE 0 END) AS LaunchDate_Missing,
    SUM(CASE WHEN Status IS NULL OR TRIM(Status) = '' THEN 1 ELSE 0 END) AS Status_Missing
FROM products;


SELECT
    COUNT(*) AS TotalRows,

    SUM(CASE WHEN SupplierID IS NULL THEN 1 ELSE 0 END) AS SupplierID_Missing,
    SUM(CASE WHEN SupplierName IS NULL OR TRIM(SupplierName) = '' THEN 1 ELSE 0 END) AS SupplierName_Missing,
    SUM(CASE WHEN ContactName IS NULL OR TRIM(ContactName) = '' THEN 1 ELSE 0 END) AS ContactName_Missing,
    SUM(CASE WHEN Email IS NULL OR TRIM(Email) = '' THEN 1 ELSE 0 END) AS Email_Missing,
    SUM(CASE WHEN Phone IS NULL OR TRIM(Phone) = '' THEN 1 ELSE 0 END) AS Phone_Missing,
    SUM(CASE WHEN City IS NULL OR TRIM(City) = '' THEN 1 ELSE 0 END) AS City_Missing,
    SUM(CASE WHEN Country IS NULL OR TRIM(Country) = '' THEN 1 ELSE 0 END) AS Country_Missing
FROM suppliers;




SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN EmployeeID IS NULL THEN 1 ELSE 0 END) AS EmployeeID_Missing,
    SUM(CASE WHEN FirstName IS NULL OR TRIM(FirstName) = '' THEN 1 ELSE 0 END) AS FirstName_Missing,
    SUM(CASE WHEN LastName IS NULL OR TRIM(LastName) = '' THEN 1 ELSE 0 END) AS LastName_Missing,
    SUM(CASE WHEN JobTitle IS NULL OR TRIM(JobTitle) = '' THEN 1 ELSE 0 END) AS JobTitle_Missing,
    SUM(CASE WHEN StoreID IS NULL THEN 1 ELSE 0 END) AS StoreID_Missing,
    SUM(CASE WHEN HireDate IS NULL THEN 1 ELSE 0 END) AS HireDate_Missing,
    SUM(CASE WHEN Salary IS NULL THEN 1 ELSE 0 END) AS Salary_Missing,
    SUM(CASE WHEN Email IS NULL OR TRIM(Email) = '' THEN 1 ELSE 0 END) AS Email_Missing
FROM employees;


SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN ShipmentID IS NULL THEN 1 ELSE 0 END) AS ShipmentID_Missing,
    SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) AS OrderID_Missing,
    SUM(CASE WHEN Carrier IS NULL OR TRIM(Carrier) = '' THEN 1 ELSE 0 END) AS Carrier_Missing,
    SUM(CASE WHEN ShipDate IS NULL THEN 1 ELSE 0 END) AS ShipDate_Missing,
    SUM(CASE WHEN DeliveryDate IS NULL THEN 1 ELSE 0 END) AS DeliveryDate_Missing,
    SUM(CASE WHEN ShippingCost IS NULL THEN 1 ELSE 0 END) AS ShippingCost_Missing
FROM shipments;


SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN StoreID IS NULL THEN 1 ELSE 0 END) AS StoreID_Missing,
    SUM(CASE WHEN StoreName IS NULL OR TRIM(StoreName) = '' THEN 1 ELSE 0 END) AS StoreName_Missing,
    SUM(CASE WHEN Address IS NULL OR TRIM(Address) = '' THEN 1 ELSE 0 END) AS Address_Missing,
    SUM(CASE WHEN City IS NULL OR TRIM(City) = '' THEN 1 ELSE 0 END) AS City_Missing,
    SUM(CASE WHEN Region IS NULL OR TRIM(Region) = '' THEN 1 ELSE 0 END) AS Region_Missing,
    SUM(CASE WHEN ManagerID IS NULL THEN 1 ELSE 0 END) AS ManagerID_Missing
FROM stores;


SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN CategoryID IS NULL THEN 1 ELSE 0 END) AS CategoryID_Missing,
    SUM(CASE WHEN CategoryName IS NULL OR TRIM(CategoryName) = '' THEN 1 ELSE 0 END) AS CategoryName_Missing,
    SUM(CASE WHEN Description IS NULL OR TRIM(Description) = '' THEN 1 ELSE 0 END) AS Description_Missing
FROM categories;

SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN PromotionID IS NULL THEN 1 ELSE 0 END) AS PromotionID_Missing,
    SUM(CASE WHEN CampaignName IS NULL OR TRIM(CampaignName) = '' THEN 1 ELSE 0 END) AS CampaignName_Missing,
    SUM(CASE WHEN StartDate IS NULL THEN 1 ELSE 0 END) AS StartDate_Missing,
    SUM(CASE WHEN EndDate IS NULL THEN 1 ELSE 0 END) AS EndDate_Missing,
    SUM(CASE WHEN DiscountPercent IS NULL THEN 1 ELSE 0 END) AS DiscountPercent_Missing
FROM promotions;



SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN OrderDetailID IS NULL THEN 1 ELSE 0 END) AS OrderDetailID_Missing,
    SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) AS OrderID_Missing,
    SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS ProductID_Missing,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Quantity_Missing,
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS UnitPrice_Missing,
    SUM(CASE WHEN Discount IS NULL THEN 1 ELSE 0 END) AS Discount_Missing,
    SUM(CASE WHEN Cost IS NULL THEN 1 ELSE 0 END) AS Cost_Missing,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS Profit_Missing
FROM orderdetails;



SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN InventoryID IS NULL THEN 1 ELSE 0 END) AS InventoryID_Missing,
    SUM(CASE WHEN StoreID IS NULL THEN 1 ELSE 0 END) AS StoreID_Missing,
    SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS ProductID_Missing,
    SUM(CASE WHEN StockQuantity IS NULL THEN 1 ELSE 0 END) AS StockQuantity_Missing,
    SUM(CASE WHEN ReorderLevel IS NULL THEN 1 ELSE 0 END) AS ReorderLevel_Missing,
    SUM(CASE WHEN LastUpdated IS NULL THEN 1 ELSE 0 END) AS LastUpdated_Missing
FROM inventory;


SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN ReturnID IS NULL THEN 1 ELSE 0 END) AS ReturnID_Missing,
    SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) AS OrderID_Missing,
    SUM(CASE WHEN ReturnDate IS NULL THEN 1 ELSE 0 END) AS ReturnDate_Missing,
    SUM(CASE WHEN ReturnReason IS NULL OR TRIM(ReturnReason) = '' THEN 1 ELSE 0 END) AS ReturnReason_Missing,
    SUM(CASE WHEN RefundAmount IS NULL THEN 1 ELSE 0 END) AS RefundAmount_Missing
FROM returns;



-- =====================================================
-- STEP 5: Check Data Consistency
-- Purpose: Identify inconsistent values, formatting issues,
--          and business rule violations across the dataset.
-- =====================================================

SELECT DISTINCT Status
FROM products
ORDER BY Status;


SELECT DISTINCT PaymentMethod
FROM orders
ORDER BY PaymentMethod;


SELECT DISTINCT ShippingMethod
FROM orders
ORDER BY ShippingMethod;



SELECT DISTINCT Carrier
FROM shipments
ORDER BY Carrier;

SELECT DISTINCT JobTitle
FROM employees
ORDER BY JobTitle;

SELECT DISTINCT CustomerSegment
FROM customers
ORDER BY CustomerSegment;



-- =====================================================
-- STEP 6: Check Data Validity (Business Rules)
-- Purpose: Validate that data follows expected business
--          rules and logical relationships.
-- =====================================================


-- =====================================================
-- STEP 6.1: Validate Product Prices
-- Purpose: Ensure that the SellingPrice is not less than
--          the CostPrice.
-- =====================================================
SELECT*
FROM products
WHERE SellingPrice < CostPrice;

-- =====================================================
-- STEP 6.2: Validate Shipment Dates
-- Purpose: Ensure that the DeliveryDate is not earlier
--          than the ShipDate.
-- =====================================================
SELECT*
FROM shipments
WHERE DeliveryDate < ShipDate;


-- =====================================================
-- STEP 6.3: Validate Promotion Dates
-- Purpose: Ensure that the EndDate is not earlier than
--          the StartDate.
-- =====================================================

SELECT*
FROM promotions
WHERE StartDate>EndDate;


-- =====================================================
-- STEP 6.4: Validate Employee Salary
-- Purpose: Ensure that all employee salaries are greater
--          than zero and identify invalid salary values.
-- =====================================================

SELECT*
FROM employees
WHERE Salary<=0;




-- =====================================================
-- STEP 6.5: Validate Discount Percentage
-- Purpose: Ensure DiscountPercent is between 0 and 100.
-- =====================================================


SELECT DISTINCT DiscountPercent
FROM  promotions
ORDER BY  DiscountPercent ASC;


SELECT*
FROM promotions
WHERE DiscountPercent<0 OR DiscountPercent>1;


-- =====================================================
-- STEP 6.6: Validate Inventory Stock Quantity
-- Purpose: Ensure that stock quantities and reorder levels
--          are not negative.
-- =====================================================

SELECT*
FROM inventory
WHERE ReorderLevel>StockQuantity;


SELECT*
FROM inventory
WHERE StockQuantity<0 OR ReorderLevel<0;


-- =====================================================
-- STEP 6.7: Validate Customer Join Dates
-- Purpose: Ensure that JoinDate is not in the future.
-- =====================================================
SELECT*
FROM  customers
WHERE JoinDate> CURDATE();


-- =====================================================
-- STEP 6.8: Validate Order Dates
-- Purpose: Ensure that OrderDate is not in the future.
-- =====================================================

SELECT*
FROM orders
WHERE OrderDate>CURDATE();


-- =====================================================
-- STEP 6.9: Validate Product Launch Dates
-- Purpose: Ensure that LaunchDate is not in the future.
-- =====================================================

SELECT *
FROM products
WHERE LaunchDate > CURDATE();


-- =====================================================
-- STEP 6.10: Validate Reorder Levels
-- Purpose: Ensure that ReorderLevel is not negative.
-- =====================================================

SELECT
    InventoryID,
    ProductID,
    StoreID,
    StockQuantity,
    ReorderLevel
FROM inventory
WHERE ReorderLevel < 0;

-- =====================================================
-- STEP 6.11: Validate Shipping Costs
-- Purpose: Ensure that ShippingCost is not negative.
-- =====================================================

SELECT*
FROM shipments
WHERE ShippingCost<0;

-- =====================================================
-- STEP 6.12: Validate Refund Amounts
-- Purpose: Ensure that RefundAmount is not negative.
-- =====================================================

SELECT
    ReturnID,
    OrderID,
    RefundAmount
FROM returns
WHERE RefundAmount < 0;

-- =====================================================
-- STEP 6.13: Validate Order Quantities
-- Purpose: Ensure that Quantity is greater than zero.
-- =====================================================

SELECT
    OrderDetailID,
    OrderID,
    ProductID,
    Quantity
FROM orderdetails
WHERE Quantity <= 0;


-- =====================================================
-- STEP 6.14: Validate Unit Prices
-- Purpose: Ensure that UnitPrice is greater than zero.
-- =====================================================

SELECT
    OrderDetailID,
    OrderID,
    ProductID,
    UnitPrice
FROM orderdetails
WHERE UnitPrice <= 0;
 


