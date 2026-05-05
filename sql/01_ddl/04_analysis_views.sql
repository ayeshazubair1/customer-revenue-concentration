/*=======================================================================================
LAYER: Analysis / Reusable Business Views
Schema: analysis
Purpose:
    - Stores reusable business logic (e.g., churn risk, segmentation)
    - Avoids duplication of complex logic in multiple queries

Usage:
    - Run this script to create or refresh analysis views
    - Referenced directly in business questions and reporting workflow

NOTE:
    - Core logic originates from Business Question 2 and 3
    - Refer to corresponding scripts in the analytics/ folder for detailed methodology
=========================================================================================*/

--====================================================================
-- Top 20% High-Value Customers (Based on Business Question 2)
--====================================================================
-- DROP VIEW analysis.high_value_customers;
CREATE OR REPLACE VIEW analysis.high_value_customers AS
WITH customer_rank AS (
	SELECT 
		customer_key,
		customer_name,
		ROW_NUMBER() OVER(ORDER BY total_revenue DESC) AS rn
	FROM gold.customer_summary
),
threshold AS (
	SELECT 
		CEIL(COUNT(*) * 0.20) AS twenty_pct
	FROM gold.customer_summary 
),
max_date AS (
	SELECT
		MAX(date) AS max_date
	FROM clean.date
),
metrics AS (
	SELECT 
		cs.customer_key,
		cs.customer_name,
		cs.total_revenue,
		cs.total_profit,
		(max_date - last_order_date) 				 AS recency,
		cs.total_orders 							 AS frequency,
		ROUND(cs.total_revenue / cs.total_orders, 2) AS aov
	FROM gold.customer_summary cs
	JOIN customer_rank cr ON cs.customer_key = cr.customer_key 
	CROSS JOIN threshold
	CROSS JOIN max_date
	WHERE rn <= twenty_pct
)
SELECT * FROM metrics
;

--==================================================================
-- Customers Likely to Disengage (Based on Business Question 3)
--==================================================================
-- DROP VIEW analysis.at_risk_customers;
CREATE OR REPLACE VIEW analysis.at_risk_customers AS
WITH percentile AS (
	SELECT
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY recency)   AS p75_recency,
		PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY frequency) AS p50_frequency
	FROM analysis.high_value_customers
)
SELECT hvc.*
FROM analysis.high_value_customers hvc
CROSS JOIN percentile
WHERE recency > p75_recency
	AND frequency >= p50_frequency
;