# RetailHub Analytics

End-to-end data analytics project on a synthetic retail dataset — covering data cleaning, 
SQL business analysis, Excel, and Power BI dashboards.

## Project Overview
This project simulates a real-world retail business (RetailHub Ltd) using a synthetic dataset 
generated with Python (Faker library). It follows a full analytics pipeline: 
**data cleaning → SQL business analysis → Excel → Power BI dashboards**.

## Status
🚧 In Progress — SQL Business Analysis phase (Product Analysis)

## Project Structure



retailhub_Analysis/
├── Data/
│ ├── Raw_Data/ # Original synthetic CSVs
│ ├── Cleaned_Data/ # Cleaned CSV exports (coming soon)
│ └── Documentation/ # Data dictionary, ER diagram, business scenario, profiling report
├── SQL/
│ ├── Data_cleaning/ # Per-table cleaning scripts
│ ├── Data_Profiling/ # Initial data exploration & profiling
│ └── Business_Analysis/ # Business question SQL files (01-03 so far)
├── PowerBI/ # (coming soon)
└── Images/



## Dataset
Synthetic 12-table retail dataset generated with Python (Faker), including Orders, OrderDetails, 
Products, Categories, Customers, Employees, Inventory, Promotions, Returns, Shipments, Stores, 
and Suppliers.

## Key Data Findings
- 151 orders had NULL OrderDates — excluded from trend queries, not deleted
- 750 orders had no matching OrderDetails rows — flagged and documented, not deleted
- Converted varchar date columns to proper DATE types
- All data quality issues documented rather than silently removed, to preserve data integrity

## Tools Used
- SQL (MySQL Workbench)
- Excel
- Power BI
- Python (Faker) for synthetic data generation

## Author
Naima Abdi