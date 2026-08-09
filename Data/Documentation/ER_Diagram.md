# RetailHub Ltd — Entity Relationship Diagram

This diagram uses [Mermaid](https://mermaid.js.org/) syntax and renders automatically
on GitHub. If you'd like a static image instead, paste this code block into the
[Mermaid Live Editor](https://mermaid.live) and export as PNG/SVG.

```mermaid
erDiagram
    CATEGORIES ||--o{ PRODUCTS : "categorizes"
    SUPPLIERS  ||--o{ PRODUCTS : "supplies"
    STORES     ||--o{ EMPLOYEES : "employs"
    EMPLOYEES  ||--o| STORES : "manages"
    STORES     ||--o{ ORDERS : "processes"
    EMPLOYEES  ||--o{ ORDERS : "handles"
    CUSTOMERS  ||--o{ ORDERS : "places"
    PROMOTIONS ||--o{ ORDERS : "applied to"
    ORDERS     ||--o{ ORDERDETAILS : "contains"
    PRODUCTS   ||--o{ ORDERDETAILS : "ordered in"
    STORES     ||--o{ INVENTORY : "stocks"
    PRODUCTS   ||--o{ INVENTORY : "tracked in"
    ORDERS     ||--o{ SHIPMENTS : "shipped via"
    ORDERS     ||--o{ RETURNS : "returned as"

    CATEGORIES {
        int CategoryID PK
        string CategoryName
        string Description
    }
    SUPPLIERS {
        int SupplierID PK
        string SupplierName
        string ContactName
        string Email
        string Phone
        string City
        string Country
    }
    PRODUCTS {
        int ProductID PK
        string SKU
        string ProductName
        string Brand
        int CategoryID FK
        int SupplierID FK
        decimal CostPrice
        decimal SellingPrice
        date LaunchDate
        string Status
    }
    STORES {
        int StoreID PK
        string StoreName
        string Address
        string City
        string Region
        int ManagerID FK
    }
    EMPLOYEES {
        int EmployeeID PK
        string FirstName
        string LastName
        string JobTitle
        int StoreID FK
        date HireDate
        decimal Salary
        string Email
    }
    CUSTOMERS {
        int CustomerID PK
        string FirstName
        string LastName
        string Gender
        date DOB
        string Email
        string Phone
        string Address
        string City
        string Region
        string PostalCode
        string CustomerSegment
        date JoinDate
    }
    PROMOTIONS {
        int PromotionID PK
        string CampaignName
        date StartDate
        date EndDate
        decimal DiscountPercent
    }
    ORDERS {
        int OrderID PK
        string OrderDate
        int CustomerID FK
        int StoreID FK
        int EmployeeID FK
        int PromotionID FK
        string PaymentMethod
        string ShippingMethod
        string OrderStatus
    }
    ORDERDETAILS {
        int OrderDetailID PK
        int OrderID FK
        int ProductID FK
        int Quantity
        decimal UnitPrice
        decimal Discount
        decimal Cost
        decimal Profit
    }
    INVENTORY {
        int InventoryID PK
        int StoreID FK
        int ProductID FK
        int StockQuantity
        int ReorderLevel
        date LastUpdated
    }
    SHIPMENTS {
        int ShipmentID PK
        int OrderID FK
        string Carrier
        date ShipDate
        date DeliveryDate
        decimal ShippingCost
    }
    RETURNS {
        int ReturnID PK
        int OrderID FK
        date ReturnDate
        string ReturnReason
        decimal RefundAmount
    }
```
