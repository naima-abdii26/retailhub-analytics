# RetailHub SQL Data Profiling Report

## Project Overview

The Data Profiling phase was conducted to assess the quality of the RetailHub dataset before performing any data cleaning.
 The objective was to identify data quality issues such as duplicate records, missing values, inconsistent data, and business rule violations.


# Data Profiling Objectives

The profiling process focused on the following areas:

- Understanding the dataset structure
- Reviewing sample records
- Detecting duplicate records
- Identifying missing values
- Checking data consistency
- Validating business rules

---

# Step 1: Table Structure Review

## Objective

Review the structure of each table to understand the available columns, data types, and primary keys.

## Result

All tables were successfully reviewed.

No structural issues were identified.

**Status:** ✅ Completed

---

# Step 2: Data Preview

## Objective

Inspect sample records from every table to understand the stored information.

## Result

All tables contained valid records and were successfully loaded.

**Status:** ✅ Completed

---

# Step 3: Duplicate Record Check

## Objective

Identify duplicate records across all tables.

## Result

No duplicate records were found in any table.

**Status:** ✅ Passed

---

# Step 4: Missing Value Analysis

## Objective

Identify NULL values and empty fields.

## Missing Values Found

| Table | Column | Missing Records |
|--------|--------|----------------:|
| Customers | Email | 153 |
| Customers | Phone | 227 |
| Customers | Address | 77 |
| Orders | PaymentMethod | 1012 |
| Products | SellingPrice | 6 |
| Suppliers | Email | 3 |
| Suppliers | Phone | 3 |
| Employees | HireDate | 10 |
| Shipments | Carrier | 500 |

## Tables Without Missing Values

- Categories
- Stores
- Promotions
- Inventory
- Returns
- OrderDetails

**Status:** ⚠ Missing values detected.

---

# Step 5: Data Consistency Check

## Objective

Review categorical columns to ensure consistent values.

The following columns were analysed:

- Product Status
- Customer Segment
- Payment Method
- Shipping Method
- Carrier
- Employee Job Title

## Result

No formatting inconsistencies were identified.

**Status:** ✅ Passed

---

# Step 6: Business Rule Validation

The following business rules were validated.

| Business Rule | Status |
|---------------|:------:|
| SellingPrice ≥ CostPrice | ✅ Passed |
| DeliveryDate ≥ ShipDate | ❌ Failed |
| Promotion EndDate ≥ StartDate | ✅ Passed |
| Employee Salary > 0 | ✅ Passed |
| DiscountPercent between 0 and 1 | ❌ Failed |
| StockQuantity ≥ 0 | ❌ Failed |
| ReorderLevel ≥ 0 | ✅ Passed |
| ShippingCost ≥ 0 | ✅ Passed |
| RefundAmount ≥ 0 | ✅ Passed |
| Quantity > 0 | ❌ Failed |
| UnitPrice > 0 | ✅ Passed |

---

# Data Quality Issues Identified

The profiling process identified the following data quality issues.

## 1. Missing Values

Missing data was found in several tables, including:

- Customer Email
- Customer Phone
- Customer Address
- Payment Method
- Selling Price
- Supplier Email
- Supplier Phone
- Employee Hire Date
- Shipment Carrier

---

## 2. Invalid Shipment Dates

Some shipment records contained a DeliveryDate earlier than the ShipDate.

---

## 3. Invalid Discount Percentages

Two promotion records contained DiscountPercent values greater than 1 (100%).

---

## 4. Negative Inventory

Several inventory records contained negative StockQuantity values.

---

## 5. Invalid Order Quantities

Several order detail records contained Quantity values equal to zero.

---

# Summary

The RetailHub dataset is generally well structured and contains no duplicate records. 
However, the profiling process identified several data quality issues that must be addressed before performing analysis.

The main issues include:

- Missing values
- Invalid shipment dates
- Invalid discount percentages
- Negative inventory quantities
- Invalid order quantities

These findings will guide the Data Cleaning phase.

---

# Next Phase

The next phase of the project is **Data Cleaning**, 
where all identified data quality issues will be corrected,
 validated, and documented before the dataset is used for analysis.