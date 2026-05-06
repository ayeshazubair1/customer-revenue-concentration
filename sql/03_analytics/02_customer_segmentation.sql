/*=====================================================================================
-- BUSINESS QUESTION: Are High-Value Customers Stable or Showing Early Risk Signals?

-- PURPOSE:
--   Evaluate whether high-value customers remain consistently engaged or are showing
--   early warning signs of weakening purchase behavior.

-- DATA & SCOPE:
--   - Customer summary table (aggregated at customer level)
--   - Date table used to define the latest date in the business timeline

-- APPROACH:
--   1. Select the top 20% high-value customers ranked by total revenue
--   2. Calculate Recency, Frequency, and Average Order Value (AOV)
--   3. Use percentile-based thresholds to segment customers into behavioral groups

-- ASSUMPTIONS & NOTES:
--   - Recency is measured as the gap between the latest business date and last order date
--   - Frequency is based on total distinct orders
--   - AOV is used to profile segments, not define them
--   - Distribution analysis was performed on recency and frequency prior to selecting 
--	   segmentation thresholds

-- OUTPUT:
--   Segment-level summary showing: customer count, average AOV, average frequency,
--   and average recency for (Consistent, Stable, Declining, and Inactive customers)
=====================================================================================*/

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
		(max_date - last_order_date) AS recency,
		cs.total_orders 		  	 AS frequency,
		ROUND(cs.total_revenue / cs.total_orders, 2) AS aov
	FROM gold.customer_summary cs
	JOIN customer_rank cr ON cs.customer_key = cr.customer_key 
	CROSS JOIN threshold
	CROSS JOIN max_date
	WHERE rn <= twenty_pct
)
SELECT * FROM metrics
;

--===========================================
-- Customer Behavioral Segmentation
--===========================================

WITH threshold AS (
	SELECT
		PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY recency)   AS p50_recency,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY recency)   AS p75_recency,
		PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY frequency) AS p50_frequency,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY frequency) AS p75_frequency
	FROM analysis.high_value_customers
),
segmentation AS (
	SELECT 
		CASE
			WHEN recency <= p75_recency AND frequency >= p75_frequency THEN 'Consistent'
		  	WHEN recency <= p75_recency AND frequency >= p50_frequency THEN 'Stable'
		 	WHEN recency >  p75_recency AND frequency >= p50_frequency THEN 'Declining'
		  ELSE 'Inactive'
		END AS segment,
		COUNT(*) AS customer_count,
		ROUND(AVG(aov), 2) 		 AS avg_aov,
		ROUND(AVG(frequency), 2) AS avg_frequency,
		ROUND(AVG(recency), 2) 	 AS avg_recency
	FROM analysis.high_value_customers
	CROSS JOIN threshold 
	GROUP BY segment
)
SELECT 
	*
FROM segmentation
ORDER BY 
	CASE 
		WHEN segment = 'Consistent' THEN 1
		WHEN segment = 'Stable' 	THEN 2
		WHEN segment = 'Declining'  THEN 3
		ELSE 4
	END
;
--==============================
/*	Output:
--==============================
segment   |customer_count|avg_aov|avg_frequency|avg_recency
----------+--------------+-------+-------------+-----------
Consistent|          4599|2563.82|        23.76|     330.17
Stable    |          2974|2883.25|        17.96|     335.76
Declining |          1421|2769.44|        20.19|     558.14
Inactive  |          8580|3904.33|        12.96|     462.39	
*/