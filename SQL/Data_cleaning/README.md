# RetailHub Enterprise Retail Analysis — Data Cleaning

This folder contains the data cleaning phase for the RetailHub Ltd retail
database project, split by table for readability and reuse. Each script
follows the same structure: **Preview → Missing Values → Duplicates →
Standardization/Fixes → Validation → Summary.**

## Run Order

| # | File | Table |
|---|------|-------|
| 1 | `01_Clean_Customers.sql` | customers |
| 2 | `02_Clean_Orders.sql` | orders |
| 3 | `03_Clean_OrderDetails.sql` | orderdetails |
| 4 | `04_Clean_Employees.sql` | employees |
| 5 | `05_Clean_Categories.sql` | categories |
| 6 | `06_Clean_Inventory.sql` | inventory |
| 7 | `07_Clean_Products.sql` | products |
| 8 | `08_Clean_Promotions.sql` | promotions |
| 9 | `09_Clean_Shipments.sql` | shipments |
| 10 | `10_Clean_Stores.sql` | stores |
| 11 | `11_Clean_Suppliers.sql` | suppliers |
| 12 | `12_Clean_Returns.sql` | returns |

Tables were cleaned in roughly the order the raw data was profiled;
there are no cross-file dependencies except that `11_Clean_Suppliers.sql`
checks for foreign keys before deleting duplicate suppliers, and
`06_Clean_Inventory.sql` joins to `products` (run after `07` if you want
that join to reflect deduplicated product data).

## Corrections Made to the Original Script

While reorganizing, a few logic errors were found in the original combined
script. These were corrected because they would have produced wrong
results or silently corrupted data if run as-is:

1. **Gmail typo (Customers):** the email fix replaced `gmail` with `@gamil`
   (misspelled) instead of `@gmail`, which would have broken every Gmail
   address it touched.
2. **Outlook wildcard bug (Customers):** the guard condition
   `NOT LIKE '@outlook'` had no `%` wildcards, so it almost never matched —
   added wildcards so the update only runs on rows that actually need it.
3. **Wrong column compared (Customers):** the `CustomerSegment` formatting
   check compared `TRIM(Region)` instead of `TRIM(CustomerSegment)`.
4. **Phone validation logic (Customers):** the original used `OR` between
   conditions, which matched almost every row regardless of format;
   changed to `AND` so it only flags genuinely invalid phone numbers.
5. **Wrong column in NULL check (Suppliers):** `Missing_SupplierName` was
   actually checking `SupplierID = ''`, so `SupplierName` was never
   validated. Corrected to check the right column.
6. **Suppliers duplicate check:** grouping by `SupplierID` alone can never
   find duplicates, since it's the primary key. Changed to group by
   contact details (`ContactName`, `Email`, `Phone`, `City`, `Country`),
   which is how the real duplicates were actually found.
7. **Promotions date logic:** the check for invalid date ranges used
   `StartDate < EndDate` (which returns the *valid* rows), instead of
   `StartDate > EndDate` (which finds the actual errors).
8. **Promotions discount check:** `DiscountPercent != TRIM(DiscountPercent)`
   doesn't make sense for a numeric column — replaced with a proper
   0–100% range check.
9. **Employees duplicate removal:** the `ROW_NUMBER()` used to pick which
   duplicate to delete had no `ORDER BY`, making the result
   non-deterministic. Added `ORDER BY EmployeeID` so the same row is kept
   every time the script runs.

## Data Quality Issues Found (No Fix Needed / Documented Only)

- **Orders.PaymentMethod** — 1,012 NULLs retained; correct value can't be
  determined from other fields.
- **Orders.PromotionID** — 45,595 NULLs retained; represents "no
  promotion applied," not missing data.
- **Orders.OrderDate** — 151 rows had the invalid date `2023-02-30`; set
  to NULL since the real date is unrecoverable.
- **Inventory.StockQuantity** — some negative values retained for review;
  correct stock levels unknown.
- **Employees.HireDate** — some NULLs retained; no reliable source to
  backfill.
- **Returns.OrderID** — 48 rows had placeholder value `444444`; flagged
  via a new `IsValidOrder` column rather than deleted (see file 12).

## Consistency Note

The `Returns` table fix (file 12) matches the same flagging approach used
in the Excel version of this dataset (`IsValidOrder` column, `Yes`/`No`),
so the two deliverables tell a consistent story if shared side by side on
GitHub/LinkedIn.
