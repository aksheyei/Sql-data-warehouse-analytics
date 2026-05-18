-- RUNNING TOTAL SALES BY MONTH
SELECT
    MONTH(order_date) AS month_value,
    SUM(sales_amount) AS total_sales,
    SUM(SUM(sales_amount)) OVER (
        ORDER BY MONTH(order_date)
    ) AS running_total_sales
FROM fact_sales
GROUP BY month_value
ORDER BY month_value;

-- MOVING AVERAGE PRICE BY MONTH
SELECT
    MONTH(order_date) AS month_value,
    AVG(price) AS average_price,
    AVG(AVG(price)) OVER (
        ORDER BY MONTH(order_date)
    ) AS moving_average_price
FROM fact_sales
GROUP BY month_value
ORDER BY month_value;
