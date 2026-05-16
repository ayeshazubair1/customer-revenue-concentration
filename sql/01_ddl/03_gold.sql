/*=======================================================================================
LAYER: Gold / Aggregated Summary Layer
Schema: gold
Purpose: 
    - Creates aggregated customer-level summary table derived from clean data
    - Precomputes key metrics (revenue, cost, profit etc)

Usage:
    - Run this script to create or refresh summary table / materialized views
    - Used as the primary source for downstream analysis and reporting
=======================================================================================*/

DROP MATERIALIZED VIEW IF EXISTS gold.customer_summary;
CREATE MATERIALIZED VIEW gold.customer_summary AS
SELECT 
    s.customer_key,
    c.customer_name,
    c.gender,
    c.country,
    c.age,
    MIN(s.order_date)                                               AS first_order_date,
    MAX(s.order_date)                                               AS last_order_date,
    COUNT(DISTINCT s.order_key)                                     AS total_orders,
    SUM(s.net_price * s.quantity)                                   AS total_revenue,
    (SUM(s.net_price * s.quantity) - SUM(s.unit_cost * s.quantity)) AS total_profit,
    SUM(s.unit_cost * s.quantity)                                   AS total_cost,
    SUM(s.quantity)                                                 AS total_qty
FROM clean.sales s
JOIN clean.customers c ON s.customer_key = c.customer_key
GROUP BY
    s.customer_key,
    c.customer_name,
    c.gender,
    c.country,
    c.age
;
-- REFRESH MATERIALIZED VIEW gold.customer_summary;