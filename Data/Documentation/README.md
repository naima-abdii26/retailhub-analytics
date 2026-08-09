# RetailHub Ltd — Enterprise Retail Data Analytics Portfolio Project

## Project Workflow

✔ Business Understanding
✔ Database Design
✔ Documentation
✔ Data Profiling
⬜ Data Cleaning
⬜ Exploratory Data Analysis (EDA)
⬜ Business Analysis
⬜ SQL Reporting
⬜ Power BI Dashboard


## Overview

RetailHub Ltd is a fictional UK-based retail company operating physical stores and an
online store, selling Electronics, Furniture, Office Supplies, Home & Kitchen, Sports,
Gaming, Fashion, Accessories, and Appliances. This repository contains a realistic,
relational **enterprise retail database** covering **January 2022 – December 2025**,
built as a complete Data Analyst portfolio project.

The dataset is intentionally messy, mirroring a real production database.
It contains duplicates, missing values, invalid data, inconsistent text formatting,
and broken foreign keys at controlled rates (approximately 1–3% per table). 
This makes it suitable for realistic data profiling and data cleaning practice, 
rather than working with a perfectly prepared dataset.

## What's in this project

RetailHub_Analysis/
│
├── README.md                     ← Main project README
│
├── Data/
│   ├── Raw_Data/
│   │   ├── RetailHub_Database.xlsx
│   │   ├── Categories.csv
│   │   ├── Customers.csv
│   │   ├── Employees.csv
│   │   ├── Inventory.csv
│   │   ├── OrderDetails.csv
│   │   ├── Orders.csv
│   │   ├── Products.csv
│   │   ├── Promotions.csv
│   │   ├── Returns.csv
│   │   ├── Shipments.csv
│   │   ├── Stores.csv
│   │   └── Suppliers.csv
│   │
│   ├── Cleaned_Data/
│   │   └── (Export cleaned CSVs here if needed)
│   │
│   └── Documentation/
│       ├── README.md
│       ├── Business_Scenario.md
│       ├── Data_Dictionary.md
│       ├── ER_Diagram.md
│       └── 01_Data_Profiling_Report.md
│
├── SQL/
│   ├── Setup/
│   │   ├── 01_create_tables.sql
│   │   ├── 02_insert_categories.sql
│   │   ├── ...
│   │   └── 13_insert_returns.sql
│   │
│   ├── Data_Profiling/
│   │   ├── 00_Data_Exploration.sql
│   │   └── 01_Data_Profiling.sql
│   │
│   ├── Data_Cleaning/
│   │   ├── 01_Backup_Tables.sql
│   │   ├── 02_Remove_Duplicates.sql
│   │   ├── 03_Handle_Missing_Values.sql
│   │   ├── 04_Standardize_Data.sql
│   │   ├── 05_Data_Validation.sql
│   │   └── 06_Data_Cleaning_Report.sql
│   │
│   ├── Business_Analysis/
│   │
│   └── Views/
│
├── PowerBI/
│   ├── RetailHub.pbix
│   └── Dashboard.pdf
│
└── Images/
    ├── Dashboard.png
    ├── ER_Diagram.png
    └── Project_Cover.png
```

## Tables & row counts

| Table | Rows | Notes |
|---|---:|---|
| Categories | 18 | 2 sub-categories per product line|
| Suppliers | 122 | Contains approximately 2% intentional duplicate records|
| Products | 459 | Contains approximately 2% intentional duplicate records|
| Stores | 30 | UK physical stores|
| Employees | 357 | Contains approximately 2% intentional duplicate records|
| Customers | 7,650 | Contains approximately 2% intentional duplicate records|
| Promotions | 40 | Black Friday, Christmas, Summer Sale, Back to School, Clearance, Flash Sale|
| Orders | 50,750 | Jan 2022 – Dec 2025; includes seasonal sales patterns|
| OrderDetails | 150,000 | order line items|
| Inventory | 18,000 | store × product stock snapshots|
| Shipments | 50,000 | carrier, ship & delivery dates|
| Returns | 6,000 | return reason & refund amount|

See `Data_Dictionary.md` for full column definitions and a breakdown of the data quality issues.

## Suggested workflow for this portfolio project

1. **SQL — Data Profiling & Cleaning**
   Load `sql/01_create_tables.sql` then the `INSERT` files into MySQL Server. 
   Profile each table (row counts, nulls, duplicates, orphaned foreign keys),
   then write cleaning queries (dedupe, standardize text casing, fix invalid dates,
   flag negative prices, etc.).

2. **SQL — Business Analysis**
   Write analytical queries: revenue by category/store/region, top customers, monthly
   sales trends, promotion effectiveness, return rates by reason, employee performance.

3. **Excel — Validation & Pivot Tables**
   Open `excel/RetailHub_Database.xlsx`. Use it to cross-check your SQL cleaning logic,
   build pivot tables, and produce quick summary charts.

4. **Power BI — Interactive Dashboard**
   Import the cleaned data (from SQL or the CSVs) into Power BI and build a dashboard
   covering sales performance, store/region comparisons, product/category trends, and
   customer segmentation.

5. **GitHub — Documentation**
   Publish this repository with the README, data dictionary, ER diagram, and your SQL
   scripts so employers can review your end-to-end workflow (SQL → Excel → Power BI).

6. **Interview Preparation**
   Use `docs/Business_Scenario.md` for a set of realistic stakeholder questions you
   can practice answering out loud, as you might in a Data Analyst interview.

## Tools this project is designed for

SQL (data profiling, cleaning, business analysis) · Microsoft Excel (validation, pivot
tables) · Power BI (interactive dashboards) · GitHub (portfolio documentation).

## Disclaimer

RetailHub Ltd, its employees, customers, and suppliers are entirely fictional. All data
was synthetically generated for portfolio and educational purposes only.
