/* =============================================================================
   PART-TO-WHOLE ANALYSIS
   =============================================================================
   Objective:
   - Measure category contribution to total revenue
   - Enable quick identification of dominant segments
============================================================================= */

WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)

SELECT
    category,
    total_sales,

    -- Overall revenue baseline
    SUM(total_sales) OVER () AS overall_sales,

    -- Relative contribution
    CONCAT(
        ROUND(
            (CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100,
            2
        ),
        '%'
    ) AS percentage_of_total

FROM category_sales
ORDER BY total_sales DESC;