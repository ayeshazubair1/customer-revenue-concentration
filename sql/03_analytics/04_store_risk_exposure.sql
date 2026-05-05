/*=====================================================================================
-- BUSINESS QUESTION: Which Stores Are Most Exposed to Customer Revenue Risk?

-- PURPOSE:
--   Identify where high-risk customer revenue is concentrated at the store level,
--   and determine which stores require immediate retention focus.

-- DATA & SCOPE:
--   - Sales table (transaction-level data linking customers to stores)
--   - At-risk customers identified from the view created in Q3
--   - Customer summary used to calculate total business revenue

-- APPROACH:
--   1. Filter sales data to include only at-risk customers
--   2. Aggregate revenue at risk and customer count at the store level
--   3. Calculate each store’s at-risk revenue as a percentage of total business revenue
--   4. Compute store dependency on at-risk customers
--   5. Apply percentile-based segmentation to classify stores by risk level

-- ASSUMPTIONS & NOTES:
--   - At-risk customers are pre-defined using recency and frequency logic (Q3)
--   - Revenue_at_risk is derived from transaction-level sales
--   - business_revenue_at_risk_pct shows how much total business revenue is exposed through each store
--   - Dependency measures how much a store relies on at-risk customers

-- OUTPUT:
--   Store-level risk profile including:
--     - Number of at-risk customers, Revenue at risk, % of total business revenue exposed per store,
		 Store dependency on at-risk customers, Risk segment classification
=====================================================================================*/

WITH store_lvl AS (
	SELECT
		s.store_key, 
		COUNT(DISTINCT s.customer_key) AS customer_count,
		SUM(s.net_price * s.quantity ) AS revenue_at_risk
	FROM clean.sales s
	JOIN analysis.at_risk_customers rc ON s.customer_key = rc.customer_key 
	GROUP BY s.store_key 
),
totals AS (
	SELECT
		SUM(total_revenue) AS revenue
	FROM gold.customer_summary
),
store_revenue AS (
	SELECT 
		store_key,
		SUM(net_price * quantity ) store_total_revenue
	FROM clean.sales
	GROUP BY store_key
),
store_risk AS (
	SELECT
		store_key,
		customer_count,
		revenue_at_risk ,
		ROUND(revenue_at_risk / revenue * 100 , 2) AS business_revenue_at_risk_pct
	FROM store_lvl 
	CROSS JOIN totals
),
threshold AS (
	SELECT 
		PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY business_revenue_at_risk_pct) AS p50_pct,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY business_revenue_at_risk_pct) AS p75_pct,
		PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY business_revenue_at_risk_pct) AS p99_pct
	FROM store_risk
),
segmentation AS (
	SELECT
		sk.store_key,
		customer_count,
		revenue_at_risk,
		business_revenue_at_risk_pct,
		ROUND((revenue_at_risk / store_total_revenue * 100), 2) AS dependency_pct,
		CASE 
			WHEN business_revenue_at_risk_pct >= p99_pct THEN 'Critical'
			WHEN business_revenue_at_risk_pct >= p75_pct THEN 'High'
			WHEN business_revenue_at_risk_pct >= p50_pct THEN 'Medium'
			ELSE 'Low'
		END AS risk_segment
	FROM store_risk sk
	CROSS JOIN threshold
	JOIN store_revenue sr ON sk.store_key = sr.store_key
)
SELECT st.country, s.*
	/* risk_segment,
	COUNT(s.store_key)   AS store_count,
	SUM(customer_count)  AS customer_count,
	SUM(revenue_at_risk) AS total_revenue_at_risk,
	ROUND(AVG(business_revenue_at_risk_pct), 2) AS avg_business_revenue_at_risk_pct */
FROM segmentation s
JOIN clean.stores st ON s.store_key = st.store_key
-- GROUP BY risk_segment
ORDER BY 
	business_revenue_at_risk_pct DESC 
;

--==============================
/*	Output:
--==============================

country       |store_key|customer_count|revenue_at_risk|business_revenue_at_risk_pct|dependency_pct|risk_segment
--------------+---------+--------------+---------------+----------------------------+--------------+------------
Online        |   999999|          1420|    27109844.26|                        1.28|          3.51|Critical    
United States |      440|           454|     2442247.46|                        0.12|          6.63|High        
United States |      550|           415|     2119658.95|                        0.10|          6.38|High        
United States |      540|           414|     2084384.09|                        0.10|          5.90|High     
...
       
--==============================
*	Store Risk Summary 
--==============================

risk_segment|store_count|customer_count|total_revenue_at_risk|avg_business_revenue_at_risk_pct
------------+-----------+--------------+---------------------+--------------------------------
Critical    |          1|          1420|          27109844.26|                            1.28
High        |         18|          7751|          33978311.33|                            0.09
Medium      |         21|          2779|          14974029.29|                            0.03
Low         |         30|           431|           2680648.52|                            0.00
*/