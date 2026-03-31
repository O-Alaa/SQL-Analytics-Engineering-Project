/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

CREATE VIEW gold.products_report AS

-- =============================================================================
-- Base Layer: Transaction enrichment
-- =============================================================================
WITH base_query AS (
    SELECT
        f.order_date,
        f.order_number,
        f.quantity,
        f.customer_key,
        f.sales_amount,

        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost

    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),

-- =============================================================================
-- Aggregation Layer: Product KPIs
-- =============================================================================
product_aggregation AS (
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,

        COUNT(DISTINCT order_number) AS total_orders,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,

        MAX(order_date) AS last_order_date,

        -- Active selling duration
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS life_span,

        -- Unit economics (price realization)
        ROUND(
            AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),
            1
        ) AS avg_selling_amount

    FROM base_query
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

-- =============================================================================
-- Final Projection
-- =============================================================================
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,

    total_orders,
    total_quantity,
    total_customers,
    total_sales,

    last_order_date,
    life_span,
    avg_selling_amount,

    -- Performance classification
    CASE
        WHEN total_sales > 50000 THEN 'High-Performers'
        WHEN total_sales < 10000 THEN 'Mid-Performers'
        ELSE 'Low-Performers'
    END AS product_segement,

    -- Recency for demand monitoring
    DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency_in_months,

    -- Revenue normalization per order
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS average_order_revenue,

    -- Revenue normalization over lifecycle
    CASE
        WHEN life_span = 0 THEN total_sales
        ELSE total_sales / life_span
    END AS average_monthly_revenue

FROM product_aggregation;