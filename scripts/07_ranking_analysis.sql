-- TOP 5 BEST-SELLING PRODUCTS BY SALES REVENUE
SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_sales
FROM fact_sales f
LEFT JOIN dim_products p
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 5;

-- TOP 5 LOWEST-SELLING PRODUCTS BY SALES REVENUE
SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_sales
FROM fact_sales f
LEFT JOIN dim_products p
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_sales ASC
LIMIT 5;
