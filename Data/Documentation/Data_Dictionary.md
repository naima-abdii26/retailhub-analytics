# RetailHub Ltd — Data Dictionary

This document describes every table and column in the RetailHub Ltd retail database.
Row counts reflect the **final** (messy) dataset, which is slightly higher than the
original target in several tables because intentional duplicate records were appended
for data-cleaning practice.

---

## Categories (18 rows)
| Column | Type | Description |
|---|---|---|
| CategoryID | INT (PK) | Unique category identifier |
| CategoryName | VARCHAR | Sub-category name (e.g. "Laptops & Computers") |
| Description | VARCHAR | Short description of the category |

**Known issues:** a handful of rows have inconsistent casing/spacing in `CategoryName`.

---

## Suppliers (122 rows)
| Column | Type | Description |
|---|---|---|
| SupplierID | INT (PK) | Unique supplier identifier |
| SupplierName | VARCHAR | Company name |
| ContactName | VARCHAR | Primary contact person |
| Email | VARCHAR | Contact email (some missing) |
| Phone | VARCHAR | Contact phone (some missing) |
| City | VARCHAR | Supplier city (some case/spacing issues) |
| Country | VARCHAR | Supplier country |

**Known issues:** ~5% missing email or phone; ~2% duplicate supplier records (new IDs).

---

## Products (459 rows)
| Column | Type | Description |
|---|---|---|
| ProductID | INT (PK) | Unique product identifier |
| SKU | VARCHAR | Stock keeping unit code |
| ProductName | VARCHAR | Product name (brand + model) |
| Brand | VARCHAR | Brand name |
| CategoryID | INT (FK → Categories) | Product category |
| SupplierID | INT (FK → Suppliers) | Supplying vendor |
| CostPrice | DECIMAL | Wholesale cost price (a few intentionally negative) |
| SellingPrice | DECIMAL | Retail selling price (some missing) |
| LaunchDate | DATE | Date product was first listed |
| Status | VARCHAR | Active / Discontinued / Out of Stock |

**Known issues:** ~1% negative CostPrice, ~1.5% missing SellingPrice, ~3% misspelled
ProductName, ~1% SupplierID pointing to a non-existent supplier (9999), ~2% duplicates.

---

## Stores (30 rows)
| Column | Type | Description |
|---|---|---|
| StoreID | INT (PK) | Unique store identifier |
| StoreName | VARCHAR | Store name |
| Address | VARCHAR | Street address |
| City | VARCHAR | City (some misspelled, e.g. "Manchestor") |
| Region | VARCHAR | UK region |
| ManagerID | INT (FK → Employees) | Employee ID of the store manager |

---

## Employees (357 rows)
| Column | Type | Description |
|---|---|---|
| EmployeeID | INT (PK) | Unique employee identifier |
| FirstName | VARCHAR | First name |
| LastName | VARCHAR | Last name |
| JobTitle | VARCHAR | Store Manager / Assistant Manager / Cashier / Sales Associate / Inventory Clerk |
| StoreID | INT (FK → Stores) | Assigned store |
| HireDate | DATE | Date hired (some missing) |
| Salary | DECIMAL | Annual salary (GBP) |
| Email | VARCHAR | Company email (a few malformed, e.g. "_at_" instead of "@") |

**Known issues:** ~3% missing HireDate, ~2% malformed Email, ~2% duplicates.

---

## Customers (7,650 rows)
| Column | Type | Description |
|---|---|---|
| CustomerID | INT (PK) | Unique customer identifier |
| FirstName | VARCHAR | First name |
| LastName | VARCHAR | Last name |
| Gender | VARCHAR | Male / Female |
| DOB | DATE | Date of birth (a few impossible future dates) |
| Email | VARCHAR | Email (some missing/invalid) |
| Phone | VARCHAR | Phone number (some missing/invalid, "N/A") |
| Address | VARCHAR | Street address (some missing) |
| City | VARCHAR | City (some case/spacing issues) |
| Region | VARCHAR | UK region |
| PostalCode | VARCHAR | Postcode |
| CustomerSegment | VARCHAR | Consumer / Corporate / Small Business |
| JoinDate | DATE | Date customer registered |

**Known issues:** ~2% missing email, ~2% missing phone, ~1% missing address, ~1.5%
invalid email format, ~1% invalid phone, ~0.5% impossible DOB, ~2% duplicates.

---

## Promotions (40 rows)
| Column | Type | Description |
|---|---|---|
| PromotionID | INT (PK) | Unique promotion identifier |
| CampaignName | VARCHAR | e.g. "Black Friday 2024" |
| StartDate | DATE | Campaign start date |
| EndDate | DATE | Campaign end date |
| DiscountPercent | DECIMAL | Discount as a fraction (0.15 = 15%). A few rows intentionally exceed 1.0 (>100%) for cleaning practice. |

---

## Orders (50,750 rows)
| Column | Type | Description |
|---|---|---|
| OrderID | INT (PK) | Unique order identifier |
| OrderDate | VARCHAR* | Order date. Stored as text because a small number of rows contain intentionally invalid dates (e.g. "2023-02-30") |
| CustomerID | INT (FK → Customers) | Ordering customer (a few point to non-existent ID 999999) |
| StoreID | INT (FK → Stores) | Store/channel the order was placed through (a few point to non-existent ID 9999) |
| EmployeeID | INT (FK → Employees) | Employee who processed the order (a few point to non-existent ID 88888) |
| PromotionID | INT (FK → Promotions, nullable) | Promotion applied, if any |
| PaymentMethod | VARCHAR | Visa / Mastercard / PayPal / Apple Pay / Google Pay / Bank Transfer (some missing) |
| ShippingMethod | VARCHAR | Standard / Express / Next Day |
| OrderStatus | VARCHAR | Pending / Packed / Shipped / Delivered / Cancelled / Returned |

**Known issues:** ~2% missing PaymentMethod, ~1% bad CustomerID FK, ~0.5% bad StoreID FK,
~0.5% bad EmployeeID FK, ~0.3% impossible OrderDate, ~1.5% duplicates.

---

## OrderDetails (150,000 rows)
| Column | Type | Description |
|---|---|---|
| OrderDetailID | INT (PK) | Unique line-item identifier |
| OrderID | INT (FK → Orders) | Parent order |
| ProductID | INT (FK → Products) | Product ordered (a few point to non-existent ID 77777) |
| Quantity | INT | Units ordered (some intentionally 0) |
| UnitPrice | DECIMAL | Selling price at time of order |
| Discount | DECIMAL | Discount applied as a fraction |
| Cost | DECIMAL | Total wholesale cost for the line |
| Profit | DECIMAL | Revenue minus cost for the line |

**Known issues:** ~1% zero Quantity, ~0.8% bad ProductID FK.

---

## Inventory (18,000 rows)
| Column | Type | Description |
|---|---|---|
| InventoryID | INT (PK) | Unique inventory snapshot identifier |
| StoreID | INT (FK → Stores) | Store location |
| ProductID | INT (FK → Products) | Product being tracked (a few point to non-existent ID 66666) |
| StockQuantity | INT | Units on hand (some intentionally negative) |
| ReorderLevel | INT | Threshold that should trigger a reorder |
| LastUpdated | DATE | Date of the stock snapshot |

**Known issues:** ~1.5% negative StockQuantity, ~1% bad ProductID FK, and store/product
combinations are deliberately duplicated across snapshot dates.

---

## Shipments (50,000 rows)
| Column | Type | Description |
|---|---|---|
| ShipmentID | INT (PK) | Unique shipment identifier |
| OrderID | INT (FK → Orders) | Related order (a few point to non-existent ID 555555) |
| Carrier | VARCHAR | Royal Mail / DHL / DPD / Evri / UPS (some missing) |
| ShipDate | DATE | Date shipped |
| DeliveryDate | DATE | Date delivered (a few intentionally earlier than ShipDate) |
| ShippingCost | DECIMAL | Cost of shipping (GBP) |

**Known issues:** ~1% DeliveryDate before ShipDate, ~1% missing Carrier, ~0.8% bad
OrderID FK.

---

## Returns (6,000 rows)
| Column | Type | Description |
|---|---|---|
| ReturnID | INT (PK) | Unique return identifier |
| OrderID | INT (FK → Orders) | Related order (a few point to non-existent ID 444444) |
| ReturnDate | DATE | Date of return (a few intentionally before the order's purchase date) |
| ReturnReason | VARCHAR | Damaged / Wrong Item / Late Delivery / Changed Mind / Faulty Product |
| RefundAmount | DECIMAL | Amount refunded (GBP) |

**Known issues:** ~1% ReturnDate before OrderDate, ~0.8% bad OrderID FK.

---

## Summary of intentional data quality issues (by category)

| Category | Where found |
|---|---|
| Duplicate records | Suppliers, Products, Employees, Customers, Orders |
| Missing values | Suppliers (email/phone), Products (price), Employees (hire date), Customers (email/phone/address), Orders (payment method), Shipments (carrier) |
| Invalid data | Products (negative cost), Promotions (>100% discount), Orders (impossible dates), OrderDetails (zero quantity), Inventory (negative stock), Shipments (delivery before ship date), Returns (return before purchase), Customers (invalid email/phone/DOB) |
| Text problems | Categories, Suppliers, Stores, Customers (spacing/casing/misspellings) |
| Foreign key problems | Products→Suppliers, Orders→Customers/Stores/Employees, OrderDetails→Products, Inventory→Products, Shipments→Orders, Returns→Orders |

All issues are capped at roughly 1–3% of records per table, per the original specification.
