/*=======================================================================
LAYER: RAW / DATA QUALITY CHECKS
Schema: raw
No. of tables: 8
=========================================================================
Purpose:
    - Validates raw/source data for completeness, accuracy,
      and consistency
    - Identifies nulls, duplicates, negative values,
      inconsistent formatting, and referential integrity issues
    - Detects standardization issues in strings, dates,
      and numeric fields
    - Ensures data is ready for analysis and reporting
 
Usage Notes:
    - Run prior to the clean/transformation steps
    - Investigate, correct, and document any anomalies found
=========================================================================*/
 
-- ============================
-- 1) raw.store
-- ============================
 
-- Check: Duplicates in PK 'StoreKey'
-- Result: No issues
SELECT "StoreKey", COUNT(*)
FROM raw.store
GROUP BY "StoreKey"
HAVING COUNT(*) > 1;
 
-- Check: NULL or non-positive values in 'StoreKey'
-- Result: No issues
SELECT "StoreKey"
FROM raw.store
WHERE "StoreKey" IS NULL
    OR "StoreKey" <= 0;
 
-- Check: NULL or non-positive values in 'GeoAreaKey'
-- Result: No issues
SELECT "GeoAreaKey"
FROM raw.store
WHERE "GeoAreaKey" IS NULL
    OR "GeoAreaKey" <= 0;
 
-- Check: Distinct values in 'Country' for standardization
-- Result: No issues
SELECT DISTINCT "CountryName"
FROM raw.store;
 
-- Check: Distinct values in 'State' for standardization
-- Result: No issues
SELECT DISTINCT "State"
FROM raw.store;
 
-- Check: NULL or empty values in 'OpenDate'
-- Result: No issues
SELECT "OpenDate"
FROM raw.store
WHERE "OpenDate" IS NULL
    OR "OpenDate" = '';
 
-- Check: Empty strings in 'CloseDate'
-- Result: 58 empty records found
SELECT COUNT("CloseDate")
FROM raw.store
WHERE "CloseDate" = '';
 
-- Check: CloseDate occurring before OpenDate (logical integrity)
-- Result: No issues
SELECT *
FROM raw.store
WHERE "CloseDate" < "OpenDate";
 
-- Check: NULL or empty values in 'Description'
-- Result: No issues
SELECT "Description"
FROM raw.store
WHERE "Description" IS NULL
    OR "Description" = '';
 
-- Check: NULL or non-positive values in 'SquareMeters'
-- Result: No issues
SELECT COUNT("SquareMeters")
FROM raw.store
WHERE "SquareMeters" IS NULL
    OR "SquareMeters" <= 0;
 
-- Check: Empty values in 'Status'
-- Result: Empty values found
SELECT COUNT("Status")
FROM raw.store
WHERE "Status" = '';

-- ============================
-- 2) raw.product
-- ============================
 
-- Check: Duplicates in PK 'ProductKey'
-- Result: No issues
SELECT "ProductKey", COUNT(*)
FROM raw.product
GROUP BY "ProductKey"
HAVING COUNT(*) > 1;
 
-- Check: NULL or non-positive values in 'ProductKey'
-- Result: No issues
SELECT "ProductKey"
FROM raw.product
WHERE "ProductKey" IS NULL
    OR "ProductKey" <= 0;
 
-- Check: NULL, empty, or untrimmed values in 'ProductName'
-- Result: No issues
SELECT "ProductName"
FROM raw.product
WHERE "ProductName" IS NULL
    OR "ProductName" = ''
    OR "ProductName" != TRIM("ProductName");
 
-- Check: Distinct values in 'Brand' for standardization
-- Result: No issues
SELECT DISTINCT "Brand"
FROM raw.product;
 
-- Check: Distinct values in 'Color' for casing standardization
-- Result: Mixed casing found
SELECT DISTINCT "Color"
FROM raw.product;
 
-- Check: Distinct values in 'WeightUnit' for standardization
-- Result: No issues
SELECT DISTINCT "WeightUnit"
FROM raw.product;
 
-- Check: NULL values in 'Weight'
-- Result: 284 NULL records found
SELECT "Weight"
FROM raw.product
WHERE "Weight" IS NULL;
 
-- Check: Non-positive values in 'Cost'
-- Result: No issues
SELECT "Cost"
FROM raw.product
WHERE "Cost" <= 0;
 
-- Check: Non-positive values in 'Price'
-- Result: No issues
SELECT "Price"
FROM raw.product
WHERE "Price" <= 0;
 
-- Check: Distinct values in 'CategoryName' for standardization
-- Result: No issues
SELECT DISTINCT "CategoryName"
FROM raw.product;
 
-- Check: Distinct values in 'SubCategoryName' for standardization
-- Result: No issues
SELECT DISTINCT "SubCategoryName"
FROM raw.product;
 
-- ============================
-- 3) raw.customer
-- ============================
 
-- Check: Duplicates in PK 'customerkey'
-- Result: No issues
SELECT customerkey, COUNT(*)
FROM raw.customer
GROUP BY customerkey
HAVING COUNT(*) > 1;
 
-- Check: NULL or non-positive values in 'customerkey'
-- Result: No issues
SELECT customerkey
FROM raw.customer
WHERE customerkey IS NULL
    OR customerkey <= 0;
 
-- Check: NULL or empty values in 'startdt'
-- Result: No issues
SELECT startdt
FROM raw.customer
WHERE startdt IS NULL
    OR startdt = '';
 
-- Check: NULL or empty values in 'enddt'
-- Result: No issues
SELECT enddt
FROM raw.customer
WHERE enddt IS NULL
    OR enddt = '';
 
-- Check: enddt occurring before startdt (logical integrity)
-- Result: No issues
SELECT *
FROM raw.customer
WHERE enddt < startdt;
 
-- Check: Distinct values in 'continent' for standardization
-- Result: No issues
SELECT DISTINCT continent
FROM raw.customer;
 
-- Check: Distinct values in 'gender' for standardization
-- Result: No issues
SELECT DISTINCT gender
FROM raw.customer;
 
-- Check: Distinct values in 'title' for standardization
-- Result: No issues
SELECT DISTINCT title
FROM raw.customer;
 
-- Check: Unwanted spaces in 'givenname' and 'surname'
-- Result: Whitespace found
SELECT givenname, surname
FROM raw.customer
WHERE givenname != TRIM(givenname)
    OR surname != TRIM(surname);
 
-- Check: NULL or empty values in 'city'
-- Result: No issues
SELECT city
FROM raw.customer
WHERE city IS NULL
    OR TRIM(city) = '';
 
-- Check: Unwanted spaces in 'statefull'
-- Result: Whitespace found
SELECT statefull
FROM raw.customer
WHERE statefull != TRIM(statefull);
 
-- Check: Distinct values in 'countryfull' for NULL/standardization check
-- Result: NULL values found
SELECT DISTINCT countryfull
FROM raw.customer;
 
-- Check: NULL or non-positive values in 'age'
-- Result: No issues
SELECT age
FROM raw.customer
WHERE age IS NULL
    OR age <= 0;

-- Check: Distinct values in 'occupation' for NULL/standardization check
-- Result: NULL values found
SELECT DISTINCT occupation
FROM raw.customer;

-- Check: NULL or empty values in 'company'
-- Result: NULL and empty values found
SELECT company
FROM raw.customer
WHERE company IS NULL
    OR company = '';
 
-- Check: NULL values in 'latitude' or 'longitude'
-- Result: No issues
SELECT latitude, longitude
FROM raw.customer
WHERE latitude IS NULL
    OR longitude IS NULL;
 
-- ============================
-- 4) raw.date
-- ============================

-- Check: Duplicates in PK 'Date'
-- Result: No issues
SELECT "Date", COUNT(*)
FROM raw.date
GROUP BY "Date"
HAVING COUNT(*) > 1;

-- Check: NULL or empty values in 'Date'
-- Result: No issues
SELECT "Date"
FROM raw."date"
WHERE "Date" IS NULL
    OR "Date" = '';
 
-- Check: Range Validation in 'Year'
-- Result: No issues
SELECT DISTINCT "Year"
FROM raw."date";
 
-- Check: Range Validation in 'YearQuarter'
-- Result: No issues
SELECT DISTINCT "YearQuarter"
FROM raw."date";
 
-- Check: Range Validation in 'MonthShort'
-- Result: No issues
SELECT DISTINCT "MonthShort"
FROM raw."date";
 
-- Check: Range Validation in 'MonthNumber'
-- Result: No issues
SELECT DISTINCT "MonthNumber"
FROM raw."date";
 
-- Check: Range Validation in 'DayofWeek'
-- Result: No issues
SELECT DISTINCT "DayofWeek"
FROM raw."date";
 
-- Check: Range Validation in 'WorkingDay'
-- Result: No issues
SELECT DISTINCT "WorkingDay"
FROM raw."date";
 
-- ============================
-- 5) raw.orders
-- ============================
 
-- Check: Duplicates in PK 'OrderKey'
-- Result: No issues
SELECT "OrderKey", COUNT(*)
FROM raw.orders
GROUP BY "OrderKey"
HAVING COUNT(*) > 1;
 
-- Check: NULL values in 'OrderDate'
-- Result: No issues
SELECT "OrderDate"
FROM raw.orders
WHERE "OrderDate" IS NULL;
 
-- Check: NULL values in 'DeliveryDate'
-- Result: No issues
SELECT "DeliveryDate"
FROM raw.orders
WHERE "DeliveryDate" IS NULL;
 
-- Check: OrderDate occurring after DeliveryDate (logical integrity)
-- Result: No issues
SELECT *
FROM raw.orders
WHERE "OrderDate" > "DeliveryDate";
 
-- Check: Distinct values in 'CurrencyCode' for standardization
-- Result: No issues
SELECT DISTINCT "CurrencyCode"
FROM raw.orders;
 
-- Check: FK 'CustomerKey' referential integrity against raw.customer
-- Result: No issues
SELECT o."CustomerKey"
FROM raw.orders o
LEFT JOIN raw.customer c ON o."CustomerKey" = c.customerkey
WHERE c.customerkey IS NULL;
 
-- Check: FK 'StoreKey' referential integrity against raw.store
-- Result: No issues
SELECT o."StoreKey"
FROM raw.orders o
LEFT JOIN raw.store s ON o."StoreKey" = s."StoreKey"
WHERE s."StoreKey" IS NULL; 
 
-- ============================
-- 6) raw.currencyexchange
-- ============================
 
-- Check: Distinct values in 'FromCurrency' for standardization
-- Result: No issues
SELECT DISTINCT "FromCurrency"
FROM raw.currencyexchange;
 
-- Check: Distinct values in 'ToCurrency' for standardization
-- Result: No issues
SELECT DISTINCT "ToCurrency"
FROM raw.currencyexchange;
 
-- Check: NULL or non-positive values in 'Exchange'
-- Result: No issues
SELECT "Exchange"
FROM raw.currencyexchange
WHERE "Exchange" IS NULL
    OR "Exchange" <= 0; 
 
/* ============================
-- 7) raw.orderrows
-- ============================
 
-- Check: Duplicates or NULL in 'OrderKey + ProductKey + LineNumber'
-- Result: No issues
SELECT "OrderKey", "ProductKey", "LineNumber", COUNT(*)
FROM raw.orderrows
GROUP BY "OrderKey", "ProductKey", "LineNumber"
HAVING COUNT(*) > 1;
 
-- Check: FK 'ProductKey' referential integrity against raw.product
-- Result: No issues
SELECT o."ProductKey"
FROM raw.orderrows o
LEFT JOIN raw.product p ON o."ProductKey" = p."ProductKey"
WHERE p."ProductKey" IS NULL;
 */

-- ============================
-- 8) raw.sales
-- ============================
 
-- Check: Duplicates or NULL in 'OrderKey + ProductKey + LineNumber'
-- Result: No issues
SELECT
    "OrderKey",
    "LineNumber",
    "ProductKey",
    COUNT(*) AS cnt
FROM raw.sales
GROUP BY "OrderKey", "ProductKey", "LineNumber"
HAVING COUNT(*) > 1;

-- Check: NULL values in 'OrderDate'
-- Result: No issues
SELECT "OrderDate"
FROM raw.sales
WHERE "OrderDate" IS NULL;
 
-- Check: NULL values in 'DeliveryDate'
-- Result: No issues
SELECT "DeliveryDate"
FROM raw.sales
WHERE "DeliveryDate" IS NULL;
 
-- Check: FK 'OrderDate' referential integrity against raw.date
-- Result: No issues
SELECT s."OrderDate"
FROM raw.sales s
LEFT JOIN raw."date" d ON s."OrderDate" = d."Date"
WHERE d."Date" IS NULL;
 
-- Check: FK 'DeliveryDate' referential integrity against raw.date
-- Result: No issues
SELECT s."DeliveryDate"
FROM raw.sales s
LEFT JOIN raw."date" d ON s."DeliveryDate" = d."Date"
WHERE d."Date" IS NULL;
 
-- Check: FK 'CustomerKey' referential integrity against raw.customer
-- Result: No issues
SELECT s."CustomerKey"
FROM raw.sales s
LEFT JOIN raw.customer c ON s."CustomerKey" = c.customerkey
WHERE c.customerkey IS NULL;
 
-- Check: FK 'StoreKey' referential integrity against raw.store
-- Result: No issues
SELECT s."StoreKey"
FROM raw.sales s
LEFT JOIN raw.store st ON s."StoreKey" = st."StoreKey"
WHERE st."StoreKey" IS NULL;
 
-- Check: FK 'ProductKey' referential integrity against raw.product
-- Result: No issues
SELECT s."ProductKey"
FROM raw.sales s
LEFT JOIN raw.product p ON s."ProductKey" = p."ProductKey"
WHERE p."ProductKey" IS NULL;
 
-- Check: NULL or non-positive values in 'Quantity'
-- Result: No issues
SELECT "Quantity"
FROM raw.sales
WHERE "Quantity" <= 0
    OR "Quantity" IS NULL;
 
-- Check: NULL or non-positive values in 'UnitPrice'
-- Result: No issues
SELECT "UnitPrice"
FROM raw.sales
WHERE "UnitPrice" <= 0
    OR "UnitPrice" IS NULL;
 
-- Check: NULL or non-positive values in 'NetPrice'
-- Result: No issues
SELECT "NetPrice"
FROM raw.sales
WHERE "NetPrice" <= 0
    OR "NetPrice" IS NULL;
 
-- Check: NULL or non-positive values in 'UnitCost'
-- Result: No issues
SELECT "UnitCost"
FROM raw.sales
WHERE "UnitCost" <= 0
    OR "UnitCost" IS NULL;
 
-- Check: NULL values in 'ExchangeRate'
-- Result: No issues
SELECT "ExchangeRate"
FROM raw.sales
WHERE "ExchangeRate" IS NULL;