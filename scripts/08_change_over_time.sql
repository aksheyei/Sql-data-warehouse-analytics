-- YEARLY SALES PERFORMANCE ANALYSIS
SELECT
    YEAR(order_date) AS year_value,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
GROUP BY year_value
ORDER BY year_value;

-- MONTHLY SALES PERFORMANCE ANALYSIS
SELECT
    MONTH(order_date) AS month_value,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
GROUP BY month_value
ORDER BY month_value;
