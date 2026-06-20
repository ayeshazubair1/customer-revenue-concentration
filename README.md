# Revenue Risk & Customer Dependency Analysis — Contoso

## Business Context
Contoso is a global retail company operating across multiple countries and product categories. Revenue grew from **\$88M in 2015** to **$444M in 2022** before declining, raising concerns around customer retention and revenue concentration.   
Leadership suspects that revenue may be heavily dependent on a relatively small group of high-value customers, creating potential exposure if these customers reduce engagement or churn.

> **The Challenge:** Assess dependency on high-value customers, identify early disengagement signals, and quantify revenue exposed to potential churn.

## 🎯 Executive Summary
43.5% of Contoso's revenue comes from its top 20% of customers, creating significant concentration risk.   

Within this segment, 49% of customers are already inactive, while **1,421 Declining customers represent \$78.7M in revenue and \$44.2M in profit**. The online channel alone accounts for **\$27.1M** in at-risk revenue, while 18 high-risk physical stores contribute an additional **$34M**.   

Revenue risk is concentrated among a relatively small group of customers, channels, and locations rather than distributed across the business.   

## Key Findings & Business Implications

#### 1. Nearly Half of Contoso's Revenue Flows from Just 20% of Customers
The top 20% of customers contribute **43.5% of total revenue** and **44.26% of total profit**. Within that group, the top 10% alone account for more than a quarter of both revenue and profit.   

<img src="docs/charts/revenue_concentration.png" width="300" alt="bar chart showing revenue concentration">

#### 2. Within the Top 20%, Engagement Is Fragmenting
Only **26%** of high-value customers show consistent engagement, while **49%** are classified as Inactive. The **Declining segment** (1,421 customers) shows the largest recency gap at ~558 days despite historically healthy purchase frequency.   

<img src="docs/charts/customer_segment.png" width="300" alt="Horizontal bar chart showing customer segmentation">

#### 3. $78M in Revenue Is Still Recoverable
The Declining segment contributes **\$78.7M in revenue** and **\$44.2M in profit**, representing the largest recoverable opportunity among high-value customers. In contrast, Inactive customers account for **\$411M** in historical revenue, indicating a substantial portion has already been lost.

#### 4. Risk Is Concentrated — One Channel Dominates Revenue Exposure
The Online channel holds **\$27.1M at risk** across 1,420 declining customers, representing **34% of total at-risk revenue**. Eighteen high-risk physical stores contribute an additional **\$34M**, but the exposure is distributed across locations rather than concentrated in a single channel.

<img src="docs/charts/store_risk.png" width="300" alt="tree map showing store risk">

## Recommended Action Plan

#### 1. Retain Declining High-Value Customers (Immediate)
**Target Segment:** 1,421 Declining customers ($78.7M revenue at risk)

* Prioritize customers with the longest inactivity periods
* Personalize offers using historical purchase behavior
* Collect feedback to identify drivers of disengagement

#### 2. Treat Online Channel Risk Separately (Critical)
**Target Area:** Online channel (\$27.1M at-risk revenue)

* Segment outreach by inactivity duration
* Prioritize high-spend customers for direct intervention
* Implement dedicated digital retention campaigns

#### 3. Activate Store-Level Retention in High-Risk Locations
**Target Area:** 18 high-risk stores ($34M at-risk revenue)

* Provide store-level lists of at-risk customers to each store manager
* Review purchase history for product availability issues
* Track monthly recovery rates by store

#### 4. Escalate Customer Concentration Risk to Leadership (Strategic)
**Target Area:** Customer concentration risk

* Establish monitoring thresholds for top-customer activity
* Reduce long-term dependency through broader customer acquisition

## Methodology & Analytical Approach
**1. Customer Summary Table:** Build as materialized view to support all analysis and improve query performance.   
**2. Customer Ranking:** `ROW_NUMBER()` used to identify top 10% and top 20% customers by revenue and profit.   
**3. Analytical Views:** `high_value_customers` (top 20% by revenue) and `at_risk_customers` (Declining customer segment) standardized downstream analysis.   
**4. Data-Driven Segmentation:** `PERCENTILE_CONT()` used to derive customer and store risk thresholds.   
**5. Recency Logic:** Recency measured against the latest available date in the dataset (Dec 31, 2024).   
**6. Query Design:** CTEs used to keep transformations modular and auditable.   

## Key Metrics
| Metric                            | Value  | Business Context                                      |
| :-------------------------------- | :----- | :---------------------------------------------------- |
| **Top 20% Revenue Contribution**  | 43.5%  | Nearly half of total revenue comes from top customers |
| **Top 20% Profit Contribution**   | 44.26% | Profitability is equally concentrated                 |
| **Revenue at Risk**               | $78.7M | Revenue tied to declining high-value customers        |
| **Profit at Risk**                | $44.2M | Profit exposure if declining customers churn          |
| **Largest Risk Channel (Online)** | $27.1M | Highest concentration of at-risk revenue              |

## Tech Stack & Data Architecture
**Tools:** PostgreSQL • DBeaver • Tableau    
**Architecture:** Raw → Clean → Gold → Analysis
```text
Raw Tables
   ↓
Clean Layer (type casting, validation, standardization)
   ↓
Gold Layer (customer_summary materialized view)
   ↓
Analysis Layer (high_value_customers, at_risk_customers)
```
**Why this setup:** Separates raw data from business-ready model, improves performance, and ensures consistent metrics across analysis.   
Detailed documentation [here](data_catalog.md)

## Future Analysis Opportunities
**1. Root Cause Analysis:** Investigate why high-value customers are disengaging using customer feedback, complaints, or support data.     
**2. Seasonality Analysis:** Compare declining customer behavior against holidays, promotions, and seasonal demand patterns.   
**3. Online Channel Analysis:** Assess website performance, cart abandonment, and digital journey friction.   
**4. Regional Risk Analysis:** Evaluate revenue concentration and churn risk across continents.   
**5. Customer Re-Acquisition:** Identify inactive customers with the highest recovery potential.   

## Limitations & Assumptions
**1. Partial 2024 Data:** The latest recorded orders end in April 2024. As a result, recency metrics may appear higher because the full year is not represented.   
**2. Churn Estimated from Behavior:** At-risk customers were identified using recency and frequency patterns, not confirmed churn records.     
**3. No External Context:** The analysis identifies who is at risk and how much revenue is exposed, but cannot fully explain why customers are disengaging without feedback or market data.    
**4. Threshold Benchmarks:** All segmentation thresholds were derived from internal data distributions, as no external industry benchmarks were available.     
**5. Multi-Currency Transactions:** Revenue figures were calculated in transaction currency without USD normalization. A post-analysis validation confirmed only a 1.47% net difference — findings remain directionally accurate.     
**6. Synthetic Dataset:** Contoso is a fictional dataset. Additional context such as loyalty history, customer feedback, or campaign data was unavailable.    

## Project Structure
```
contoso/
├── docs/
├── sql/
├── License.txt
├── README.md
├── dashboard.twb
└── data_catalog.md
```
### 📬 Feel Free to Connect
[![Gmail](https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:ayeshazubair.contact@gmail.com) [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/ayeshazubair-az/) [![Portfolio](https://img.shields.io/badge/Portfolio-709fa5?style=for-the-badge&logo=google-chrome&logoColor=white)](https://ayeshazubair1.github.io/portfolio/projects/revenue_risk_analysis.html) [![Tableau](https://img.shields.io/badge/Tableau-E97627?style=for-the-badge&logo=tableau&logoColor=white)](https://public.tableau.com/app/profile/ayeshazubair/vizzes)

### 📄 License
This project is licensed under the MIT License. See the [License](License.txt) file for details.