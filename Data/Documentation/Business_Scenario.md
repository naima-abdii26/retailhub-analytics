# Business Scenario — RetailHub Ltd

## Company background

RetailHub Ltd is a mid-sized UK retail chain with 30 physical stores spread across
England, Scotland, Wales, and Northern Ireland, plus an online store. The company
sells nine product lines: Electronics, Furniture, Office Supplies, Home & Kitchen,
Sports, Gaming, Fashion, Accessories, and Appliances.

Since 2022, RetailHub has been investing in data-driven decision-making. The Head of
Commercial Operations has asked the Data Analytics team to build a single source of
truth covering sales, inventory, customers, and returns from January 2022 through
December 2025 — and to surface the insights leadership needs ahead of the 2026
planning cycle.

## Stakeholders

- **Head of Commercial Operations** — wants a view of overall revenue and profit
  trends, and which stores/regions are under- or over-performing.
- **Marketing Director** — wants to know whether seasonal promotions (Black Friday,
  Christmas, Summer Sale, Back to School) are actually driving incremental revenue,
  and which campaigns deliver the best ROI.
- **Supply Chain Manager** — is concerned about stock-outs and overstocking, and
  wants visibility into which stores/products are at risk.
- **Customer Experience Lead** — wants to understand why customers return products
  and whether certain carriers or shipping methods correlate with more returns.
- **HR Business Partner** — wants a view of headcount, salary bands, and staffing
  levels by store to support the 2026 workforce plan.

## Known data quality problems (raised by the BI team)

The data engineering team flagged that the operational systems feeding this warehouse
have historically had loose validation. Before any dashboard goes to leadership, the
data needs profiling and cleaning — expect duplicate customer/order/product records,
missing contact details, a handful of impossible dates, some negative prices, and a
small number of orders/shipments/returns referencing IDs that no longer exist.

## Suggested analysis questions

**Sales & Revenue**
- What is total revenue and profit by year, quarter, and month? How would you describe
  the seasonal pattern?
- Which stores and regions generate the most revenue? Which underperform relative to
  their size/region?
- Which product categories are the fastest growing / declining over the four years?

**Customers**
- What is the customer distribution across Consumer, Corporate, and Small Business
  segments, and how does average order value differ between them?
- Who are the top 20 customers by lifetime spend?
- What does customer acquisition (JoinDate) look like over time?

**Promotions**
- Do order volumes spike during Black Friday, Christmas, Back to School, and Summer
  Sale periods, relative to the rest of the year?
- Which promotions have the highest discount cost relative to the revenue they drove?

**Operations & Inventory**
- Which store/product combinations are frequently below their reorder level?
- Which products have the highest and lowest profit margins?

**Returns & Logistics**
- What is the overall return rate, and which return reasons are most common?
- Is there a relationship between shipping carrier/method and return rate or delivery
  time?

**People**
- What does the headcount and salary distribution look like by job title and store?
- Are any stores understaffed relative to their order volume?

## Interview-style questions to practice

1. Walk me through how you would validate this dataset before building a dashboard.
2. How would you detect and handle the duplicate customer records?
3. A stakeholder asks "why did returns spike in March 2024?" — how would you
   investigate that in SQL?
4. How would you design a Power BI dashboard for the Head of Commercial Operations
   versus one for the Supply Chain Manager? What would differ?
5. If you found that 1% of orders reference a CustomerID that doesn't exist in the
   Customers table, what are your options, and what would you recommend and why?
6. How would you measure whether a promotion was actually profitable, not just
   whether it drove more orders?
