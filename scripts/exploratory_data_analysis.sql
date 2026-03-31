/* =============================================================================
   DATABASE EXPLORATION & CORE BUSINESS METRICS
   =============================================================================
   Objective:
   - Perform initial exploration across schema, dimensions, and key measures
   - Establish foundational understanding of data distribution and scale
============================================================================= */

-- =============================================================================
-- Schema Exploration
-- =============================================================================

-- Inspect all tables available in the database
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

-- Inspect column structure for customer dimension
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';


-- =============================================================================
-- Dimensions Exploration
-- =============================================================================

-- Identify geographic distribution of customers
SELECT DISTINCT
    country
FROM gold.dim_customers;

-- Review product hierarchy and catalog structure
SELECT DISTINCT
    category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY
    category,
    subcategory,
    product_name;


-- =============================================================================
-- Date Range Exploration
-- =============================================================================

-- Determine overall sales coverage window
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales;

-- Evaluate customer age distribution boundaries
SELECT
    MIN(brithdate) AS oldest_birthdate,
    MAX(brithdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MIN(brithdate), GETDATE()) AS oldest_age,
    DATEDIFF(YEAR, MAX(brithdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;


-- =============================================================================
-- Measures Exploration (Key KPIs)
-- =============================================================================

-- Core revenue metric
SELECT SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

-- Total volume of items sold
SELECT SUM(quantity) AS total_quantity
FROM gold.fact_sales;

-- Pricing benchmark across transactions
SELECT AVG(price) AS avg_price
FROM gold.fact_sales;

-- Order volume (raw vs distinct)
SELECT COUNT(order_number) AS total_orders
FROM gold.fact_sales;

SELECT COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;

-- Product and customer scale
SELECT COUNT(product_key) AS total_products
FROM gold.dim_products;

SELECT COUNT(customer_key) AS total_customers
FROM gold.dim_customers;

-- Active customers (engaged in transactions)
SELECT COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales;

-- Consolidated KPI snapshot (BI-friendly format)
SELECT 'Total Sales'      AS measure_name, SUM(sales_amount)             AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity)                                   FROM gold.fact_sales
UNION ALL
SELECT 'Average Price',  AVG(price)                                      FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders',   COUNT(DISTINCT order_number)                    FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(product_key)                              FROM gold.dim_products
UNION ALL
SELECT 'Total Customers',COUNT(customer_key)                             FROM gold.dim_customers;


-- =============================================================================
-- Magnitude Analysis
-- =============================================================================

-- Customer distribution by country
SELECT
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Customer distribution by gender
SELECT
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Product distribution across categories
SELECT
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- Cost benchmarking by category
SELECT
    category,
    AVG(cost) AS avg_costs
FROM gold.dim_products
GROUP BY category
ORDER BY avg_costs DESC;

-- Revenue contribution by category
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Revenue concentration by customer
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- Sales volume distribution by geography
SELECT
    c.country,
    SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;


-- =============================================================================
-- Ranking Analysis
-- =============================================================================

-- Top-performing products by revenue
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Ranking via window function (scalable pattern)
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) t
WHERE rank_products <= 5;

-- Lowest-performing products
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;

-- High-value customers
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- Low engagement customers (fewest orders)
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ASC;