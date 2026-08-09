-- ====================================================================
-- RetailHub Ltd -- Enterprise Retail Database
-- CREATE TABLE statements
-- Target: MySQL 8.0 / PostgreSQL 14+ compatible (minor dialect tweaks may be needed)
-- NOTE: Foreign keys are declared for documentation purposes. Because this
-- dataset intentionally contains ~1-3% orphaned foreign key values (for
-- data-cleaning practice), FK constraints are commented out by default.
-- Uncomment them once you've cleaned the orphaned rows.
-- ====================================================================

CREATE TABLE Categories (
    CategoryID   INT PRIMARY KEY,
    CategoryName VARCHAR(100),
    Description  VARCHAR(255)
);

CREATE TABLE Suppliers (
    SupplierID   INT PRIMARY KEY,
    SupplierName VARCHAR(150),
    ContactName  VARCHAR(100),
    Email        VARCHAR(150),
    Phone        VARCHAR(50),
    City         VARCHAR(100),
    Country      VARCHAR(100)
);

CREATE TABLE Products (
    ProductID    INT PRIMARY KEY,
    SKU          VARCHAR(30),
    ProductName  VARCHAR(150),
    Brand        VARCHAR(100),
    CategoryID   INT,
    SupplierID   INT,
    CostPrice    DECIMAL(10,2),
    SellingPrice DECIMAL(10,2),
    LaunchDate   DATE,
    Status       VARCHAR(30)
    -- ,FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
    -- ,FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Stores (
    StoreID    INT PRIMARY KEY,
    StoreName  VARCHAR(150),
    Address    VARCHAR(200),
    City       VARCHAR(100),
    Region     VARCHAR(100),
    ManagerID  INT
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName  VARCHAR(80),
    LastName   VARCHAR(80),
    JobTitle   VARCHAR(50),
    StoreID    INT,
    HireDate   DATE,
    Salary     DECIMAL(10,2),
    Email      VARCHAR(150)
    -- ,FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)
);

-- Stores.ManagerID -> Employees.EmployeeID (added after Employees exists)
-- ALTER TABLE Stores ADD FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID);

CREATE TABLE Customers (
    CustomerID      INT PRIMARY KEY,
    FirstName       VARCHAR(80),
    LastName        VARCHAR(80),
    Gender          VARCHAR(20),
    DOB             DATE,
    Email           VARCHAR(150),
    Phone           VARCHAR(50),
    Address         VARCHAR(200),
    City            VARCHAR(100),
    Region          VARCHAR(100),
    PostalCode      VARCHAR(20),
    CustomerSegment VARCHAR(30),
    JoinDate        DATE
);

CREATE TABLE Promotions (
    PromotionID     INT PRIMARY KEY,
    CampaignName    VARCHAR(100),
    StartDate       DATE,
    EndDate         DATE,
    DiscountPercent DECIMAL(5,2)
);

CREATE TABLE Orders (
    OrderID        INT PRIMARY KEY,
    OrderDate      VARCHAR(20), -- kept as text: a few rows contain intentionally invalid dates (e.g. '2023-02-30')
    CustomerID     INT,
    StoreID        INT,
    EmployeeID     INT,
    PromotionID    INT,
    PaymentMethod  VARCHAR(30),
    ShippingMethod VARCHAR(30),
    OrderStatus    VARCHAR(30)
    -- ,FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    -- ,FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)
    -- ,FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
    -- ,FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID       INT,
    ProductID     INT,
    Quantity      INT,
    UnitPrice     DECIMAL(10,2),
    Discount      DECIMAL(5,2),
    Cost          DECIMAL(10,2),
    Profit        DECIMAL(10,2)
    -- ,FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
    -- ,FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Inventory (
    InventoryID   INT PRIMARY KEY,
    StoreID       INT,
    ProductID     INT,
    StockQuantity INT,
    ReorderLevel  INT,
    LastUpdated   DATE
    -- ,FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)
    -- ,FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Shipments (
    ShipmentID   INT PRIMARY KEY,
    OrderID      INT,
    Carrier      VARCHAR(50),
    ShipDate     DATE,
    DeliveryDate DATE,
    ShippingCost DECIMAL(8,2)
    -- ,FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE Returns (
    ReturnID     INT PRIMARY KEY,
    OrderID      INT,
    ReturnDate   DATE,
    ReturnReason VARCHAR(50),
    RefundAmount DECIMAL(10,2)
    -- ,FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
