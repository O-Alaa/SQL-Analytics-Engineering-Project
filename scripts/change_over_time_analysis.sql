/* =============================================================================
   TEMPORAL ANALYSIS - SALES PERFORMANCE OVER TIME
   =============================================================================
   Objective:
   - Analyze trends across different time granularities
   - Highlight impact of date formatting on ordering and aggregation
============================================================================= */

-- Monthly trend (numeric ordering ensures chronological accuracy)
SELECT
    MONTH(order_date) AS order_month,
    YEAR(order_date)  AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    YEAR(order_date),
    MONTH(order_date);


-- Yearly aggregation using DATETRUNC (date-safe grouping)
SELECT
    DATETRUNC(YEAR, order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR, order_date)
ORDER BY DATETRUNC(YEAR, order_date);


-- Formatted date (string-based, may break chronological sorting)
SELECT
    FORMAT(order_date, 'yyyy-MMM') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM');