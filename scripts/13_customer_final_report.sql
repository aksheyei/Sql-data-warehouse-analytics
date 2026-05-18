/*========================================================
    CUSTOMER ANALYTICS REPORT VIEW
========================================================*/

CREATE VIEW Customer_final_report AS

WITH base_query AS
(
    SELECT
        f.order_date AS order_date,
        f.order_number AS order_number,
        f.product_key AS product_key,
        c.customer_key AS customer_key,
        c.customer_number AS customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        COALESCE(
            TIMESTAMPDIFF(YEAR, c.birthdate, CURDATE()),
            'Unknown'
        ) AS age,
        c.country AS country,
        c.gender AS gender,
        SUM(f.sales_amount) AS total_sales,
        SUM(f.quantity) AS total_quantity,
        COUNT(DISTINCT f.order_number) AS total_orders
    FROM fact_sales f
    LEFT JOIN dim_customers c
        ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        order_date,
        order_number,
        product_key,
        customer_key,
        customer_number,
        customer_name,
        age,
        country,
        gender
),

customer_aggregation AS
(
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        SUM(total_orders) AS total_orders,
        SUM(total_sales) AS total_sales,
        SUM(total_quantity) AS total_quantity,
        TIMESTAMPDIFF(
            MONTH,
            MIN(order_date),
            MAX(order_date)
        ) AS lifespan,
        MAX(order_date) AS last_order_date
    FROM base_query
    GROUP BY
        customer_key,
        customer_number,
        customer_name,
        age
)

SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE 'Above 50'
    END AS age_segment,
    CASE
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segments,
    last_order_date,
    TIMESTAMPDIFF(
        MONTH,
        last_order_date,
        CURDATE()
    ) AS recency,
    total_orders,
    total_sales,
    total_quantity,
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE ROUND((total_sales / total_orders), 1)
    END AS AOV,
    lifespan
FROM customer_aggregation;
