# Maven Toys – Retail Sales & Inventory Optimization

![SQL](https://img.shields.io/badge/SQL-GoogleSQL-blue)
![BigQuery](https://img.shields.io/badge/Google%20BigQuery-Data%20Warehouse-orange)
![Looker Studio](https://img.shields.io/badge/Looker%20Studio-Dashboard-yellow)
![Status](https://img.shields.io/badge/Project-Completed-success)

## 📊 Project Overview

An end-to-end **Retail Sales & Inventory Optimization** case study for Maven Toys, a toy-store chain operating across Mexico.

The project combines **Google BigQuery, GoogleSQL and Looker Studio** to transform raw sales, product, store and inventory data into business-focused insights for sales, merchandising, inventory and management decisions.

### Key Areas
- Sales and profitability
- Product and category performance
- Geographic and store performance
- Pricing and sales volume
- Product distribution
- Inventory risk
- Monthly performance and seasonality
- Advanced SQL, ranking and Pareto analysis

## 🚀 Live Dashboard

### [▶ View Interactive Looker Studio Dashboard](https://datastudio.google.com/reporting/275db6a6-f137-4c08-bebb-b09210bb19aa)

Dashboard sections:
1. Sales & Performance
2. Geography & Stores
3. Products & Pricing
4. Time & Seasonality
5. Advanced Analysis

> The dashboard is hosted in Looker Studio. GitHub contains the SQL, datasets, documentation and report outputs supporting the dashboard.

## 🎯 Business Problem

Management needs to understand:
- Which products and categories generate the most revenue and profit?
- Which stores and cities contribute most to sales?
- Does price relate to sales volume?
- Which products are widely distributed?
- Where are current inventory levels potentially insufficient?
- Which products drive most company revenue?
- How does performance change over time?

## 📁 Dataset

| Table | Description | Records |
|---|---|---:|
| `sales` | Transaction-level sales | 829,262 |
| `stores` | Store master data | 50 |
| `products` | Product master data | 35 |
| `inventory` | Current inventory snapshot | 1,593 |

**Sales period:** 1 January 2022 – 30 September 2023  
**Selling days:** 638  
**Transactions:** 829,262  
**Units sold:** 1,090,565

## 🛠️ Technology Stack

| Tool | Purpose |
|---|---|
| Google BigQuery | Data warehouse and analytical views |
| GoogleSQL | Data profiling, transformation and business analysis |
| Looker Studio | Interactive dashboard |
| GitHub | Version control and portfolio presentation |
| Word / PDF | Detailed analysis documentation |

# 📌 Key Business Results

## Overall Performance

| KPI | Result |
|---|---:|
| Total Revenue | **$14.44M** |
| Units Sold | **1.09M** |
| Total Cost | **$10.43M** |
| Gross Profit | **$4.01M** |
| Gross Margin | **27.79%** |

The business generated approximately **$14.44M revenue** from more than **1.09M units sold**, producing approximately **$4.01M gross profit**.

## 🏆 Category Performance

| Category | Revenue | Revenue Contribution | Gross Margin |
|---|---:|---:|---:|
| Toys | **$5.09M** | **35.26%** | 21.20% |
| Art & Crafts | **$2.71M** | **18.73%** | 27.85% |
| Electronics | **$2.25M** | **15.55%** | **44.57%** |
| Games | **$2.23M** | **15.42%** | 30.27% |
| Sports & Outdoors | **$2.17M** | **15.04%** | 23.28% |

**Insight:** Toys is the largest revenue category but has the lowest gross margin. Electronics has the strongest margin at approximately **44.57%**.

## 🏙️ Geographic Performance

Top cities by revenue:
1. Ciudad de Mexico – **$1.65M**
2. Guadalajara – **$1.32M**
3. Monterrey – **$1.26M**
4. Hermosillo – **$0.90M**
5. Guanajuato – **$0.87M**

The top five cities contribute approximately **41.58% of company revenue**, indicating meaningful geographic concentration.

## 🧸 Product Performance

### Top Products by Revenue

| Product | Revenue |
|---|---:|
| Lego Bricks | **$2.39M** |
| Colorbuds | **$1.56M** |
| Magic Sand | **$0.97M** |
| Action Figure | **$0.93M** |
| Rubik's Cube | **$0.91M** |
| Deck Of Cards | **$0.59M** |
| Splash Balls | **$0.54M** |
| Nerf Gun | **$0.53M** |
| Animal Figures | **$0.51M** |
| Dart Gun | **$0.51M** |

### Top Products by Unit Volume
- Colorbuds – **104,368**
- PlayDoh Can – **103,128**
- Barrel O' Slime – **91,663**
- Deck Of Cards – **84,034**
- Magic Sand – **60,598**

## 💰 Pricing & Sales Volume

Price bands:
- `< $5`
- `$5–$10`
- `$11–$25`
- `$26–$50`
- `$50+`

The dataset contains products priced up to approximately **$39.99**, so there are no products in the `$50+` band.

**Finding:** There is no simple linear price-volume relationship. Both lower-priced and premium products can achieve strong sales, suggesting that category, product appeal and assortment also influence demand.

## 📦 Product Distribution

Distribution is based on current inventory records.

- **20** products: Universal distribution
- **9** products: High distribution
- **6** products: Medium distribution
- **0** products: Low distribution

All 35 products are currently represented in at least 25 of the 50 stores.

> Distribution represents current inventory coverage, not historical product availability.

## 📊 Inventory Risk

Current stock is compared with historical sales velocity.

| Indicator | Definition |
|---|---|
| No Historical Sales | No recorded sales for the store-product combination |
| High Risk | Stock below 50% of average monthly sales |
| Potential Reorder | Stock below average monthly sales |
| Normal | Stock at or above average monthly sales |

Three inventory records have stock but no historical sales:
- Store 14 – PlayDoh Playset – 3 units
- Store 27 – PlayDoh Playset – 6 units
- Store 29 – Teddy Bear – 6 units

> Inventory is a current snapshot. The analysis identifies potential current risk using historical sales velocity; it does not reconstruct historical stockouts or exact reorder dates.

## 📈 Time & Seasonality

Analysis includes:
- Monthly revenue
- Units sold
- Gross profit
- Month-over-month growth
- Cumulative revenue
- Calendar-month seasonality

The analysis identifies strong growth from March to April 2022, a decline during July/August, and approximately **19.67% revenue growth from August to September 2022**.

> 2023 contains data only through September, so October–December comparisons are incomplete.

# 🎯 Advanced SQL Analysis

## Store Rank Within City
Ranks stores against other stores in the same city to identify local leaders and weaker performers.

## Product Contribution Within Category
Measures how individual products contribute to their respective categories.

## Pareto Analysis

The first **15 of 35 products** account for approximately **80.08% of total revenue**.

The 80% threshold is crossed at:

**Rank 15 – Gamer Headphones**

This demonstrates a highly concentrated revenue portfolio.

# 🔎 Data Quality Checks

- Invalid store/product references in sales: **None**
- Duplicate stores: **0**
- Duplicate products: **0**
- Duplicate sales: **0**
- Duplicate inventory rows: **7**
- Possible store-product combinations: **1,750**
- Store-product combinations without an inventory record: **157**

Inventory duplicates and incomplete store-product coverage were considered when interpreting inventory and distribution results.

# 🧠 Management Recommendations

### 1. Prioritize high-margin categories
Electronics has the strongest gross margin at approximately **44.57%**. Evaluate expansion of successful electronics products.

### 2. Review the Toys category
Toys generates the most revenue but the lowest category margin. Review pricing, product mix and promotions.

### 3. Protect high-contribution products
Approximately **15 of 35 products generate 80% of revenue**. Prioritize availability, replenishment, pricing and promotions for these products.

### 4. Investigate high-risk inventory
Review stores with high proportions of high-risk inventory for replenishment accuracy, local demand and assortment.

### 5. Use geographic concentration
The top five cities contribute approximately **41.58% of revenue**. Use this insight to prioritize inventory, promotions and sales initiatives.

# 🧮 SQL Analysis Framework

```text
01 – Data Understanding
02 – Core Sales
03 – Geography & Stores
04 – Products & Pricing
05 – Inventory Risk
06 – Time & Seasonality
07 – Advanced SQL
```

Workflow:

**Raw Data → BigQuery → GoogleSQL → Business Analysis → Looker Studio → Management Insights**

# 📂 Repository Structure

```text
Maven-Toys-Retail-Sales-Inventory-Optimization/
│
├── README.md
├── data/
│   ├── inventory.csv
│   ├── products.csv
│   ├── sales.csv
│   └── stores.csv
├── sql/
│   ├── 01_data_understanding.sql
│   ├── 02_core_sales.sql
│   ├── 03_geography_and_stores.sql
│   ├── 04_products_and_pricing.sql
│   ├── 05_inventory_risk.sql
│   ├── 06_time_and_seasonality.sql
│   └── 07_advanced_sql.sql
├── images/
│   └── Maven_Toys_ER_Diagram.png
└── reports/
    ├── Maven_Toys_Looker_Studio_Dashboard.pdf
    ├── Maven_Toys_Professional_Analysis_Report.pdf
    └── Maven_Toys_Professional_Analysis_Report.docx
```

# 📚 Analytical Questions Covered

### Data Understanding
Dataset profiling, sales period, referential integrity, duplicates and inventory completeness.

### Sales
Overall performance, top products, category performance and store performance.

### Geography & Stores
City ranking, location type, store age, store contribution and geographic concentration.

### Products & Pricing
Universal products, distribution, price bands, price-volume analysis, same-price products, margins and revenue/profit champions.

### Inventory
Inventory value, inventory risk, risk concentration and no-historical-sales cases.

### Time
Monthly performance, MoM growth, cumulative revenue and seasonality.

### Advanced SQL
Store ranking, product contribution and Pareto analysis.

# 💼 Skills Demonstrated

- SQL / GoogleSQL
- Google BigQuery
- Data cleaning and validation
- Relational joins
- CTEs
- Aggregations
- Window functions
- Ranking
- Running totals
- Percentage contribution
- Pareto analysis
- Inventory analytics
- KPI development
- Dashboard design
- Business storytelling
- Management recommendations

# ⚠️ Analytical Limitations

1. Inventory is a current snapshot, so historical stock levels and stockouts cannot be reconstructed.
2. Missing inventory records do not automatically mean zero stock.
3. Inventory risk is an indicator based on historical sales velocity, not a precise demand forecast.
4. Product distribution measures current inventory coverage.
5. Price-volume analysis identifies association, not causation.
6. 2023 contains sales only through September.
7. Duplicate inventory records require care when counting store-product coverage or risk records.

# 👤 Author

**Vijay Kumar**

Data Analytics / Business Intelligence Portfolio Project

### Repository
[**Maven Toys – Retail Sales & Inventory Optimization**](https://github.com/vijaybsbs/Maven-Toys-Retail-Sales-Inventory-Optimization)

### Interactive Dashboard
[**Open Looker Studio Dashboard**](https://datastudio.google.com/reporting/275db6a6-f137-4c08-bebb-b09210bb19aa)

---

## ⭐ Project Summary

This portfolio project demonstrates how transactional retail data can be transformed into actionable business insights using:

**BigQuery + GoogleSQL + Looker Studio + Business Analysis**

The focus is not only on writing SQL, but on connecting analytical results to practical decisions across **sales, merchandising, inventory and store management**.
