/* =============================================================================
   CUMULATIVE & TREND ANALYSIS
   =============================================================================
   Objective:
   - Track growth trajectory using running totals
   - Smooth pricing trends via moving averages
============================================================================= */

SELECT
    order_date,
    total_sales,

    -- Running total to visualize cumulative growth
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,

    -- Moving average for price stabilization insight
    AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price

FROM (
    SELECT
        DATETRUNC(YEAR, order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(YEAR, order_date)
) t;