# RetailHub Analytics

**End-to-end data analytics project** using synthetic retail data (12 tables, ~50k orders).  
**Pipeline:** Data Cleaning → SQL Business Analysis → Excel → Power BI

---

## Status
✅ **SQL Analysis Complete** — 4 production-ready analysis files  
🚧 In Progress: Excel dashboards & Power BI visualizations

---

## Project Structure

```
retailhub_Analysis/
├── Data/
│   ├── Raw_Data/                # Original synthetic CSVs (12 tables)
│   ├── Cleaned_Data/            # Post-cleaning exports
│   └── Documentation/           # Data dictionary & profiling
├── SQL/
│   └── Business_Analysis/
│       ├── 01_Overall_Performance.sql  # KPIs & business health
│       ├── 02_Sales_Trends.sql        # Growth & seasonality (MoM analysis)
│       ├── 03_Product_Analysis.sql    # Product performance & ranking
│       └── 04_Customer_Analysis.sql   # RFM segmentation & VIP identification
├── Excel/                       # (coming soon)
└── PowerBI/                     # (coming soon)
```

---

## SQL Analysis Summary

| File | Focus | Key Queries | Techniques Used |
|------|-------|------------|-----------------|
| **01_Overall_Performance** | Business KPIs | Total revenue, orders, avg order value | Data quality checks, subqueries |
| **02_Sales_Trends** | Growth trajectory | Monthly revenue, MoM growth %, seasonal patterns | LAG(), window functions, CTEs |
| **03_Product_Analysis** | Revenue drivers | Top 10 products/categories, profit margins, dead stock | DENSE_RANK(), LEFT JOIN, complex aggregations |
| **04_Customer_Analysis** | Customer value & segmentation | Top customers, RFM analysis (Recency/Frequency/Monetary) | DATEDIFF(), CASE WHEN, 3-table joins |

---

## Key Findings

### Data Quality
- **750 orders** have no matching OrderDetails (phantom orders)
- **151 orders** have NULL OrderDate ($617k revenue impact)
- *Approach:* Documented & flagged, not deleted. All calculations account for these issues.

### Business Insights
- **Product Performance:** Profit margins range 15.72%–53.58% (3x variance worth investigating)
- **Customer Base:** 
  - 20% ACTIVE (bought last 6 months)
  - 30% AT-RISK (6–12 months since purchase)
  - 50% DORMANT (12+ months inactive)
- **Segment Spending:** Corporate ≈ Consumer spending — no significant difference

---

## SQL Techniques Demonstrated

✅ Joins (INNER, LEFT, multi-table chains)  
✅ Window Functions (LAG, DENSE_RANK with PARTITION BY)  
✅ CTEs & Subqueries (multi-stage complex queries)  
✅ Aggregation & Filtering (GROUP BY, HAVING, CASE WHEN)  
✅ Date Functions (DATEDIFF, YEAR, MONTH, DATE_SUB)  
✅ Data Quality Validation & Documentation

---

## Tools & Stack

- **Database:** MySQL Workbench
- **Data Generation:** Python (Faker library)
- **Version Control:** Git & GitHub
- **Next:** Excel (pivot tables), Power BI (dashboards)

---

## How to Use

1. Clone the repository
2. Connect to your MySQL database
3. Run cleaning scripts in `SQL/Data_Cleaning/`
4. Execute queries in `SQL/Business_Analysis/` for insights
5. Export results to Excel → Power BI (coming soon)

---

## Author

**Naima Abdi** — Data Analyst  
📊 SQL | Excel | Power BI  
🔗 [GitHub](https://github.com/naima-abdii26/retailhub-analytics)

---

**Last Updated:** August 12, 2026