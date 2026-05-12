/*===============================================================================
LAYER:  Clean / Validation
Schema: clean
Purpose:
    - Quantifies the financial impact of multi-currency transactions
    - Confirms analytical findings are directionally accurate across all 
      currency markets

Usage Notes:
    - Run as a standalone validation check
===============================================================================*/

-- Check:  Revenue impact by currency — raw vs USD-normalized per currency code
-- Result: EUR/GBP overstated, CAD/AUD understated due to no normalization
SELECT 
    currency_code,
    COUNT(*)                                            AS total_rows,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2)   AS pct_of_total,
    ROUND(SUM(net_price * quantity), 2)                 AS raw_revenue,
    ROUND(SUM(net_price * quantity / exchange_rate), 2) AS usd_normalized_revenue,
    ROUND(SUM(net_price * quantity / exchange_rate) 
        - SUM(net_price * quantity), 2)                 AS difference
FROM sales
GROUP BY currency_code
ORDER BY raw_revenue DESC
;
--=========================
/*	Output:
--=========================
currency_code | total_rows | pct_of_total | raw_revenue        | usd_normalized_revenue | difference
USD           | 1,094,935  | 52.17        | 1,113,989,347.43   | 1,113,989,347.43       | 0
EUR           | 437,697    | 20.86        | 439,392,492.01     | 487,337,917.37         | 47,945,425.36
GBP           | 222,225    | 10.59        | 233,259,454.52     | 305,012,562.50         | 71,753,107.98
CAD           | 218,686    | 10.42        | 216,736,510.98     | 165,172,010.69         | -51,564,500.29
AUD           | 125,090    | 5.96         | 124,551,161.99     | 87,746,805.72          | -36,804,356.27
*/

-- Check:  Net revenue difference across all currencies combined
-- Result: 1.47% total deviation — overstatements and understatements offset each other
SELECT
    ROUND(SUM(net_price * quantity), 2)                 AS raw_revenue,
    ROUND(SUM(net_price * quantity / exchange_rate), 2) AS usd_normalized_revenue,
    ROUND(SUM(net_price * quantity / exchange_rate) 
        - SUM(net_price * quantity), 2)                 AS total_difference,
    ROUND((SUM(net_price * quantity / exchange_rate) 
        - SUM(net_price * quantity)) 
        / SUM(net_price * quantity) * 100, 2)           AS pct_difference
FROM sales
;
--=========================
/*	Output:
--=========================
raw_revenue         | usd_normalized_revenue | total_difference | pct_difference
2,127,928,966.93    | 2,159,258,643.72       | 31,329,676.79    | 1.47
*/