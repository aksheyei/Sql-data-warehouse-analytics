-- YEAR-OVER-YEAR PRODUCT SALES PERFORMANCE
SELECT
    YEAR(f.order_date) AS year_value,
    p.product_name AS product_name,
    SUM(f.sales_amount) AS current_year_sales,

    LAG(SUM(f.sales_amount)) OVER (
        PARTITION BY p.product_name
        ORDER BY YEAR(f.order_date)
    ) AS previous_year_sales,

    (
        SUM(f.sales_amount)
        - LAG(SUM(f.sales_amount)) OVER (
            PARTITION BY p.product_name
            ORDER BY YEAR(f.order_date)
        )
    ) AS sales_difference

FROM fact_sales f
LEFT JOIN dim_products p
    ON f.product_key = p.product_key

GROUP BY
    YEAR(f.order_date),
    p.product_name

ORDER BY
    p.product_name,
    year_value;
