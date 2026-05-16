/*=====================================================================================
LAYER: Raw / Source (DATA INGESTION)
Schema: raw
Purpose: 
		- Defines raw ingestion tables that mirror source files exactly
        - Preserves original structure, naming, and data types
Usage:
    	- Run this script to load unprocessed data before cleaning or transformation.
=======================================================================================*/

-- ============================
-- 1) raw.store
-- ============================
DROP TABLE IF EXISTS raw.store;
CREATE TABLE raw.store (
    "StoreKey"     int4        NULL,
    "StoreCode"    int4        NULL,
    "GeoAreaKey"   int4        NULL,
    "CountryCode"  varchar(50) NULL,
    "CountryName"  varchar(50) NULL,
    "State"        varchar(50) NULL,
    "OpenDate"     varchar(50) NULL,
    "CloseDate"    varchar(50) NULL,
    "Description"  varchar(50) NULL,
    "SquareMeters" int4        NULL,
    "Status"       varchar(50) NULL
);

-- ============================
-- 2) raw.product
-- ============================
DROP TABLE IF EXISTS raw.product;
CREATE TABLE raw.product (
    "ProductKey"      int4        NULL,
    "ProductCode"     int4        NULL,
    "ProductName"     text        NULL,
    "Manufacturer"    varchar(50) NULL,
    "Brand"           varchar(50) NULL,
    "Color"           varchar(50) NULL,
    "WeightUnit"      varchar(50) NULL,
    "Weight"          float4      NULL,
    "Cost"            float4      NULL,
    "Price"           float4      NULL,
    "CategoryKey"     int4        NULL,
    "CategoryName"    varchar(50) NULL,
    "SubCategoryKey"  int4        NULL,
    "SubCategoryName" varchar(50) NULL
);

-- ============================
-- 3) raw.customer
-- ============================
DROP TABLE IF EXISTS raw.customer;
CREATE TABLE raw.customer (
    customerkey   int4        NULL,
    geoareakey    int4        NULL,
    startdt       varchar(50) NULL,
    enddt         varchar(50) NULL,
    continent     varchar(50) NULL,
    gender        varchar(50) NULL,
    title         varchar(50) NULL,
    givenname     varchar(50) NULL,
    middleinitial varchar(50) NULL,
    surname       varchar(50) NULL,
    streetaddress text        NULL,
    city          varchar(50) NULL,
    state         varchar(50) NULL,
    statefull     varchar(50) NULL,
    zipcode       varchar(20) NULL,
    country       varchar(50) NULL,
    countryfull   varchar(50) NULL,
    birthday      varchar(50) NULL,
    age           int4        NULL,
    occupation    text        NULL,
    company       text        NULL,
    vehicle       text        NULL,
    latitude      float4      NULL,
    longitude     float4      NULL
);

-- ============================
-- 4) raw.date
-- ============================
DROP TABLE IF EXISTS raw."date";
CREATE TABLE raw."date" (
    "Date"              varchar(50) NULL,
    "DateKey"           int4        NULL,
    "Year"              int4        NULL,
    "YearQuarter"       varchar(50) NULL,
    "YearQuarterNumber" int4        NULL,
    "Quarter"           varchar(50) NULL,
    "YearMonth"         varchar(50) NULL,
    "YearMonthShort"    varchar(50) NULL,
    "YearMonthNumber"   int4        NULL,
    "Month"             varchar(50) NULL,
    "MonthShort"        varchar(50) NULL,
    "MonthNumber"       int4        NULL,
    "DayofWeek"         varchar(50) NULL,
    "DayofWeekShort"    varchar(50) NULL,
    "DayofWeekNumber"   int4        NULL,
    "WorkingDay"        int4        NULL,
    "WorkingDayNumber"  int4        NULL
);

-- ============================
-- 5) raw.orders
-- ============================
DROP TABLE IF EXISTS raw.orders;
CREATE TABLE raw.orders (
    "OrderKey"     int4        NULL,
    "CustomerKey"  int4        NULL,
    "StoreKey"     int4        NULL,
    "OrderDate"    varchar(50) NULL,
    "DeliveryDate" varchar(50) NULL,
    "CurrencyCode" varchar(50) NULL
);

-- ============================
-- 6) raw.currencyexchange
-- ============================
DROP TABLE IF EXISTS raw.currencyexchange;
CREATE TABLE raw.currencyexchange (
    "Date"         varchar(50) NULL,
    "FromCurrency" varchar(50) NULL,
    "ToCurrency"   varchar(50) NULL,
    "Exchange"     float4      NULL
);

-- ============================
-- 7) raw.orderrows
-- ============================
DROP TABLE IF EXISTS raw.orderrows;
CREATE TABLE raw.orderrows (
    "OrderKey"   int4   NULL,
    "LineNumber" int4   NULL,
    "ProductKey" int4   NULL,
    "Quantity"   int4   NULL,
    "UnitPrice"  float4 NULL,
    "NetPrice"   float4 NULL,
    "UnitCost"   float4 NULL
);

-- ============================
-- 8) raw.sales
-- ============================
DROP TABLE IF EXISTS raw.sales;
CREATE TABLE raw.sales (
    "OrderKey"     int4        NULL,
    "LineNumber"   int4        NULL,
    "OrderDate"    varchar(50) NULL,
    "DeliveryDate" varchar(50) NULL,
    "CustomerKey"  int4        NULL,
    "StoreKey"     int4        NULL,
    "ProductKey"   int4        NULL,
    "Quantity"     int4        NULL,
    "UnitPrice"    float4      NULL,
    "NetPrice"     float4      NULL,
    "UnitCost"     float4      NULL,
    "CurrencyCode" varchar(50) NULL,
    "ExchangeRate" float4      NULL
);