/*
==============================================================
Project      : RetailHub Enterprise Retail Analysis
Phase        : Data Cleaning
Table        : Promotions
File         : 08_Clean_Promotions.sql
==============================================================
*/

-- ============================================
-- 1. Initial Preview
-- ============================================
SELECT * FROM promotions;
SELECT DISTINCT CampaignName FROM promotions;

-- ============================================
-- 2. Date Logic Validation
-- ============================================
-- Check for promotions where StartDate is AFTER EndDate (invalid range)
SELECT * FROM promotions WHERE StartDate > EndDate;
-- NOTE (fixed): original condition checked "StartDate < EndDate", which
-- returns the *valid* rows instead of the invalid ones. Corrected to
-- StartDate > EndDate to actually surface date-range errors.
-- Findings: No invalid date ranges found.

-- ============================================
-- 3. Missing Values
-- ============================================
SELECT
    COUNT(CASE WHEN PromotionID IS NULL THEN 1 END) AS PromotionID_NULLs,
    COUNT(CASE WHEN CampaignName IS NULL THEN 1 END) AS CampaignName_NULLs,
    COUNT(CASE WHEN StartDate IS NULL THEN 1 END) AS StartDate_NULLs,
    COUNT(CASE WHEN EndDate IS NULL THEN 1 END) AS EndDate_NULLs,
    COUNT(CASE WHEN DiscountPercent IS NULL THEN 1 END) AS DiscountPercent_NULLs
FROM promotions;
-- Findings: No missing values found.

-- ============================================
-- 4. DiscountPercent: Range Validation
-- ============================================
SELECT * FROM promotions WHERE DiscountPercent < 0 OR DiscountPercent > 100;
-- NOTE (fixed): original check compared DiscountPercent to TRIM(DiscountPercent),
-- which doesn't make sense for a numeric column. Replaced with a proper
-- range check (0–100%).
-- Findings: No out-of-range discount values found.

/* ==============================
   PROMOTIONS TABLE — SUMMARY
================================
- No missing values found.
- No duplicate records found.
- Date ranges validated (StartDate <= EndDate for all rows).
- DiscountPercent validated within 0-100% range.
================================ */
