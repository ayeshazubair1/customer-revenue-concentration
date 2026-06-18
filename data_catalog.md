## Dataset Overview
The dataset represents a large-scale fictional company operating across multiple countries and regions. It provides comprehensive transactional data capturing end-to-end retail operations, including customer orders, product sales, store performance, and multi-currency transactions. The dataset comprises 8 relational tables covering the full order fulfilment lifecycle.
**Data Source**: The original raw csv files can be downloaded from [here](https://github.com/sql-bi/Contoso-Data-Generator-V2-data/releases/tag/ready-to-use-data) 
<br>
<img src="docs/contoso_ERD.svg" width="700" alt="Vertical bar chart showing financial loss from shrinkage">
<br>
#### ⚠️ Data Load Issue — Customer Table

While loading `customer.csv`, the batch insert failed due to hidden null bytes (`\0`) present in 104,753 rows — invisible in editors like Excel but invalid in PostgreSQL UTF-8 encoding.

**Fix:** Null bytes were stripped using the `tr` command before reloading:

```bash
tr < customer.csv -d '\000' > customer_safe.csv
```
All 104,752 rows loaded successfully after cleaning.

---
#### Data Quality Assessment
After loading the data into the raw schema, quality checks were performed across all tables. The data was largely clean, with only minor issues found around null values, inconsistent casing, and decimal precision.

| Table        | Column     | Issue                               | Fix Applied                                |
|-------------------|------------------|-----------------------------------------------|-------------------------------------------|
| store             | close_date       | Empty strings                                 | NULLIF()                                  |
|                   | status           | Empty/null values                             | COALESCE(), NULLIF()                      |
| product           | color            | Inconsistent casing                           | INITCAP()                                 |
|                   | cost, price      | Inconsistent decimal precision                | ROUND()                                   |
| customer          | customer_name    | Inconsistent casing, leading/trailing spaces  | INITCAP(), TRIM()                         |
|                   | state            | Leading/trailing spaces                       | TRIM()                                    |
|                   | country          | Null values                                   | COALESCE()                                |
|                   | occupation       | Null values, inconsistent casing              | COALESCE(), INITCAP()                     |
| currency_exchange | exchange_rate    | Inconsistent decimal precision                | ROUND()                                   |
| sales             | unit_price, net_price, unit_cost, exchange_rate   | Inconsistent decimal precision      | ROUND()            |

<br>

### Table Description
**Note**: `Order_Rows` table was excluded from the final model because its grain (order_key + product_key + line_number) and business content were fully covered by the `Sales` table.
<br>

**Stores** — Contains information about each retail store, including location, size, and operational status. 
Rows: **74**

| Column        | Description |
|-----------------|------------|
| store_key       | Unique identifier for each store |
| status          | Current operational status (e.g., Open, Closed) |
| open_date       | Date when the store was opened |
| close_date      | Date when the store was closed (if applicable) |
| country         | Full country name |
| state           | State where the store is located |
| description     | Name/description of the store |
| geo_area_key    | Geographic area identifier |
| square_meters   | Size of the store in square meters |

<br>

**Products** — Holds information about each product, including identifiers, descriptions, prices, and category details. 
Rows: **2K**

| Column           | Description |
|------------------|------------|
| product_key       | Unique identifier for each product |
| product_name      | Descriptive name of the product |
| manufacturer      | Company producing the product |
| brand             | Brand name of the product |
| color             | Color description of the product |
| weight_unit       | Measurement unit for weight |
| weight            | Weight of the product |
| cost              | Cost to produce or acquire the product |
| price             | Price at which the product is sold |
| category_name     | Name of the product category |
| sub_category_name | Name of the subcategory |

<br>

**Customers** — Stores information about customers, including demographics and location.
Rows: **104K**

| Column        | Description |
|---------------|------------|
| customer_key    | Unique identifier for each customer |
| start_date      | when the customer record became active |
| end_date        | when the customer record became inactive |
| customer_name   | Customer's full name |
| gender          | Gender of the customer |
| title           | Customer's title (e.g., Mr., Ms.) |
| age             | Age of the customer |
| occupation      | Job or occupation of the customer |
| continent       | Continent of the customer's address |
| country         | Full country name |
| city            | City where the customer resides |
| state           | State name of the customer's address |
| street_address  | Street address of the customer |
| zip_code        | Postal code of the customer's address |
| geo_area_key    | Geographic area identifier|
| latitude        | Latitude of the customer's location |
| longitude       | Longitude of the customer's location |

<br>

**Date** — Provides calendar-based information, supporting analysis by different time dimensions such as year, quarter, month, and day of the week.
Rows: **3K**

| Column            | Description |
|---------------|------------|
| date          | Calendar date used for time-based analysis |
| year          | Year component |
| year_quarter  | Year and quarter combination |
| month_short   | Abbreviated month name |
| month_number  | Numeric representation of the month |
| day_of_week   | Full name of the day of the week |
| working_day   | Indicates if it's a working day |

<br>

**Orders** — Provides summary-level details of customer orders, including dates, currency, and related customer and store keys.
Rows: **875K**

| Column       | Description |
|---------------|------------|
| order_key     | Unique identifier for each order |
| customer_key  | Identifier for the customer placing the order |
| store_key     | Identifier for the store fulfilling the order |
| order_date    | Date when the order was placed |
| delivery_date | Expected or actual delivery date |
| currency_code | Currency code used in the order |

<br>

**CurrencyExchange** — Stores exchange rate information, allowing accurate conversion of amounts across different currencies.
Rows: **91K**

| Column       | Description |
|----------------|------------|
| date           | Date of the exchange rate |
| from_currency  | Currency code being converted from |
| to_currency    | Currency code being converted to |
| exchange_rate  | Conversion rate between the two currencies |

<br>

**Sales** — Includes line-level transactional details of each order, including order date, customer, store, and product information.
Rows: **2M**

| Column         | Description |
|----------------|------------|
| order_key      | Identifier for the order (can repeat across multiple line items) |
| line_number    | Line item number within the order (ensures row-level uniqueness) |
| order_date     | Date the order was placed |
| delivery_date  | Date the order was delivered |
| customer_key   | Identifier for the customer who placed the order |
| store_key      | Identifier for the store fulfilling the order |
| product_key    | Identifier for the product ordered |
| quantity       | Number of units ordered |
| unit_price     | Price per unit of the product |
| net_price      | Price per unit after discount |
| unit_cost      | Cost per unit of the product |
| currency_code  | Currency code used in the transaction |
| exchange_rate  | Exchange rate applicable to the order |
---
**SQL Scripts:**  
• [DDL](sql/01_ddl)  
• [Data Quality Checks](sql/02_test/quality_checks_raw.sql)  
• [Database init ](sql/db_init.sql)  