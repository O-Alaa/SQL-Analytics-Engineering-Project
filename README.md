# 📊 SQL Analytics Engineering Project

## 📌 Overview
This project demonstrates an end-to-end SQL-based analytics workflow, transforming raw transactional data into actionable business insights. It covers data exploration, time-series analysis, segmentation, and performance evaluation, along with production-ready reporting views.

## 🎯 Objectives
- Analyze customer and product behavior
- Track revenue trends and business performance over time
- Segment customers and products for targeted insights
- Build reusable, analytics-ready data models

## 🧱 Data Model
The project follows a **star schema** structure:
- **Fact Table:** `fact_sales`
- **Dimensions:** `dim_customers`, `dim_products`

## 🔍 Key Analysis Areas
- **Exploratory Data Analysis (EDA)**  
  Schema discovery, distribution checks, and KPI validation

- **Time-Series Analysis**  
  Monthly and yearly revenue trends, customer activity tracking

- **Cumulative Analysis**  
  Running totals and moving averages for growth insights

- **Segmentation**  
  Customer segmentation (VIP, Regular, New)  
  Product segmentation based on cost and performance

- **Performance Analysis**  
  Year-over-Year (YoY) product performance and benchmarking

- **Part-to-Whole Analysis**  
  Revenue contribution by category

## 📊 Reporting Layer
Built **analytics-ready SQL views**:
- `customer_report` → Customer KPIs (LTV, recency, AOV, lifecycle)
- `product_report` → Product performance and revenue insights

## 🛠️ Technologies Used
- SQL (T-SQL)
- Window Functions
- CTEs (Common Table Expressions)
- Data Modeling (Star Schema)

## 🚀 Key Skills Demonstrated
- Advanced SQL querying and optimization
- Data aggregation and transformation
- Analytical thinking and KPI design
- Business-oriented data modeling
- Building scalable reporting layers

## 📈 Business Impact
- Enabled data-driven decision-making through structured KPIs
- Identified high-value customers and top-performing products
- Improved visibility into revenue trends and customer behavior

---

## 🛡️ License

This project is licensed under the MIT License.  
You are free to use, modify, and distribute it with proper attribution.
