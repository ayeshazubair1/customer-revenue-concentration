/*=======================================================================================
LAYER: Clean / Standardized Views
Schema: clean
Purpose: 
	- Creates transformed views, derived from the source tables in the 'raw' schema
    - Resolves known data quality issues (formats, casing, NULL, duplicates)

Usage:
	- Run this script to create or refresh views showing cleaned data
    - Analysis-ready source for SQL queries and visualization
=========================================================================================*/

 -- ============================
-- 1) clean.stores
 -- ============================
CREATE OR REPLACE VIEW clean.stores AS
SELECT
    "StoreKey"                                       ::INTEGER       AS store_key,      -- PK
    COALESCE(NULLIF("Status", ''), 'Unknown')        ::VARCHAR(15)   AS status,    
    "OpenDate"                                       ::DATE          AS open_date,
    NULLIF("CloseDate", '')                          ::DATE          AS close_date,
    "CountryName"                                    ::VARCHAR(20)   AS country,
    "State"                                          ::VARCHAR(30)   AS state,
    "Description"                                    ::VARCHAR(50)   AS description,
    "GeoAreaKey"                                     ::INTEGER       AS geo_area_key,
    "SquareMeters"                                   ::INTEGER       AS square_meters
    -- "StoreCode"                                                   AS store_code,
    -- "CountryCode"                                                 AS country_code,
 FROM raw.store;

-- ============================
-- 2) clean.products
-- ============================
 
CREATE OR REPLACE VIEW clean.products AS
SELECT
    "ProductKey"        ::INTEGER       AS product_key,         -- PK
    "ProductName"       ::VARCHAR(90)   AS product_name,
    "Manufacturer"      ::VARCHAR(30)   AS manufacturer,
    "Brand"             ::VARCHAR(30)   AS brand,
    INITCAP("Color")    ::VARCHAR(20)   AS color,
    "WeightUnit"        ::VARCHAR(10)   AS weight_unit,
    ROUND("Weight"      ::NUMERIC, 2)   AS weight,
    ROUND("Cost"        ::NUMERIC, 2)   AS cost,
    ROUND("Price"       ::NUMERIC, 2)   AS price,
    "CategoryName"      ::VARCHAR(40)   AS category_name,
    "SubCategoryName"   ::VARCHAR(40)   AS sub_category_name
    -- "ProductCode"                    AS product_code,
    -- "CategoryKey"                    AS category_key,
    -- "SubCategoryKey"                 AS sub_category_key
FROM raw.product;
  
-- ============================
-- 3) clean.customers
-- ============================
 
CREATE OR REPLACE VIEW clean.customers AS
SELECT
    customerkey                                               ::INTEGER      AS customer_key,       -- PK
    startdt                                                   ::DATE         AS start_date,
    enddt                                                     ::DATE         AS end_date,
    INITCAP(TRIM(givenname)) || ' ' || INITCAP(TRIM(surname)) ::VARCHAR(50)  AS customer_name,
    gender                                                    ::VARCHAR(10)  AS gender,    
    title                                                     ::VARCHAR(10)  AS title,
    age                                                       ::INTEGER      AS age,
    COALESCE(INITCAP(occupation), 'Unknown')                  ::VARCHAR(70)  AS occupation,
    continent                                                 ::VARCHAR(20)  AS continent,
    COALESCE(countryfull, 'Unknown')                          ::VARCHAR(30)  AS country,
    city                                                      ::VARCHAR(50)  AS city,
    TRIM(statefull)                                           ::VARCHAR(50)  AS state,
    streetaddress                                             ::VARCHAR(50)  AS street_address,    
    zipcode                                                   ::INTEGER      AS zip_code,
    geoareakey                                                ::INTEGER      AS geo_area_key,
    latitude                                                  ::FLOAT        AS latitude,
    longitude                                                 ::FLOAT        AS longitude
    -- TRIM(givenname)                                                       AS given_name,
    -- middleinitial                                                         AS middle_initial,
    -- TRIM(surname)                                                         AS surname,
    -- birthday                                                              AS birthday,
    --country                                                                AS country_code,
    -- state                                                                 AS state_code,
    -- COALESCE(NULLIF(TRIM(company), ''), 'Unknown')         ::VARCHAR(40)  AS company,
    -- COALESCE(TRIM(vehicle), 'Unknown')                     ::VARCHAR(50)  AS vehicle,
FROM raw.customer;

-- ============================ 
-- 4) clean.date
-- ============================
 
CREATE OR REPLACE VIEW clean.date AS
SELECT
    "Date"              ::DATE          AS date,                        -- PK
    "Year"              ::INTEGER       AS year,
    "YearQuarter"       ::VARCHAR(20)   AS year_quarter,
    "MonthShort"        ::VARCHAR(10)   AS month_short,
    "MonthNumber"       ::INTEGER       AS month_number,
    "DayofWeek"         ::VARCHAR(20)   AS day_of_week,
    "WorkingDay"        ::INTEGER       AS working_day
    -- "DateKey"                        AS date_key,
    -- "YearQuarterNumber"              AS year_quarter_number,
    -- "Quarter"                        AS quarter,
    -- "YearMonth"                      AS year_month,
    -- "YearMonthShort"                 AS year_month_short,
    -- "YearMonthNumber"                AS year_month_number,
    -- "Month"                          AS month,
    -- "DayofWeekShort"                 AS day_of_week_short,
    -- "DayofWeekNumber"                AS day_of_week_number,
    -- "WorkingDayNumber"               AS working_day_number
FROM raw."date";
 
-- ============================ 
-- 5) clean.orders
-- ============================

CREATE OR REPLACE VIEW clean.orders AS
SELECT
    "OrderKey"      ::INTEGER       AS order_key,                       -- PK
    "CustomerKey"   ::INTEGER       AS customer_key,                    -- FK -> customers.customer_key
    "StoreKey"      ::INTEGER       AS store_key,                       -- FK -> stores.store_key
    "OrderDate"     ::DATE          AS order_date,
    "DeliveryDate"  ::DATE          AS delivery_date,
    "CurrencyCode"  ::VARCHAR(5)    AS currency_code
FROM raw.orders;
 
-- ============================ 
-- 6) clean.currency_exchange
-- ============================
 
CREATE OR REPLACE VIEW clean.currency_exchange AS
SELECT
    "Date"                          ::DATE          AS date,            -- FK -> date.date
    "FromCurrency"                  ::VARCHAR(5)    AS from_currency,
    "ToCurrency"                    ::VARCHAR(5)    AS to_currency,
    ROUND("Exchange"                ::NUMERIC, 2)   AS exchange_rate
FROM raw.currencyexchange;

/* ============================ 
-- 7) clean.order_rows
-- ============================
 
CREATE OR REPLACE VIEW clean.order_rows AS
SELECT
    "OrderKey"                      ::INTEGER       AS order_key,       -- FK -> orders.order_key
    "LineNumber"                    ::INTEGER       AS line_number,
    "ProductKey"                    ::INTEGER       AS product_key,     -- FK -> products.product_key
    "Quantity"                      ::INTEGER       AS quantity,
    ROUND("UnitPrice"               ::NUMERIC, 2)   AS unit_price,
    ROUND("NetPrice"                ::NUMERIC, 2)   AS net_price,
    ROUND("UnitCost"                ::NUMERIC, 2)   AS unit_cost
FROM raw.orderrows;
*/
 
-- ============================
-- 8) clean.sales
-- ============================
 
CREATE OR REPLACE VIEW clean.sales AS
SELECT
    "OrderKey"                      ::INTEGER       AS order_key,       -- FK -> orders.order_key
    "LineNumber"                    ::INTEGER       AS line_number,
    "OrderDate"                     ::DATE          AS order_date,
    "DeliveryDate"                  ::DATE          AS delivery_date,
    "CustomerKey"                   ::INTEGER       AS customer_key,    -- FK -> customers.customer_key
    "StoreKey"                      ::INTEGER       AS store_key,       -- FK -> stores.store_key
    "ProductKey"                    ::INTEGER       AS product_key,     -- FK -> products.product_key
    "Quantity"                      ::INTEGER       AS quantity,
    ROUND("UnitPrice"               ::NUMERIC, 2)   AS unit_price,
    ROUND("NetPrice"                ::NUMERIC, 2)   AS net_price,
    ROUND("UnitCost"                ::NUMERIC, 2)   AS unit_cost,
    "CurrencyCode"                  ::VARCHAR(5)    AS currency_code,
    ROUND("ExchangeRate"            ::NUMERIC, 2)   AS exchange_rate
FROM raw.sales;