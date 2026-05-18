-- CATEGORY CONTRIBUTION TO OVERALL SALES
WITH category_sales AS
(
    SELECT
        p.category AS category_name,
        SUM(f.sales_amount) AS total_sales
    FROM fact_sales f
    LEFT JOIN dim_products p
        ON f.product_key = p.product_key
    GROUP BY p.category
)

SELECT
    category_name,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,

    CONCAT(
        ROUND(
            (total_sales / SUM(total_sales) OVER ()) * 100,
            2
        ),
        '%'
    ) AS sales_contribution_percentage

FROM category_sales;
