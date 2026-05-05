/*=====================================================================================
-- BUSINESS QUESTION: How Much Revenue Is at Risk from Potential Churn?

-- PURPOSE:
--   Identify customers likely to disengage and quantify the revenue and profit
--   exposure if they churn.

-- DATA & SCOPE:
--   - High-Value Customers View (Top 20% by revenue)
--   - Customer Summary table (aggregated at customer level)

-- APPROACH:
--   1. Use the High-Value Customers view to access pre-calculated R/F/M metrics
--   2. Identify likely-to-disengage customers using the 'Declining' segment logic
--   3. Summarize total revenue and profit at risk for the at-risk group

-- ASSUMPTIONS & NOTES:
--   - Likely-to-disengage customers are those with 'recency > P75 and frequency >= P50'
--   - Revenue at Risk is the primary KPI; Profit at Risk is supporting context

-- OUTPUT:
--   Summary of at-risk customers, including: customer count, revenue at risk,
--   revenue at risk %, profit at risk, and profit at risk %
=====================================================================================*/

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

--==============================
-- Revenue Risk Summary 
--==============================

WITH totals AS (
	SELECT
		SUM(total_revenue) AS revenue,
		SUM(total_profit)  AS profit
	FROM gold.customer_summary
)	
SELECT
	COUNT(*) AS at_risk_customer_count,
	SUM(total_revenue) AS revenue_at_risk,
	ROUND((SUM(total_revenue) / revenue) * 100, 2) AS revenue_at_risk_pct,
	SUM(total_profit) AS profit_at_risk,
	ROUND((SUM(total_profit) / profit) * 100, 2) AS profit_at_risk_pct
FROM analysis.at_risk_customers
CROSS JOIN totals 
GROUP BY 
	revenue,
	profit
;

--==============================
/*	Output:
--==============================

at_risk_customer_count|revenue_at_risk|revenue_at_risk_pct|profit_at_risk|profit_at_risk_pct
----------------------+---------------+-------------------+--------------+------------------
                  1421|    78742833.40|               3.71|   44201613.16|              3.73
*/