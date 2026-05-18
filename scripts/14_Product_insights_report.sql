/*========================================================
    PRODUCT INSIGHT REPORT VIEW
========================================================*/

CREATE VIEW product_insight AS

WITH base_query AS
(
    SELECT
        f.order_number AS order_number,
        f.customer_key AS customer_key,
        f.order_date AS order_date,
        p.product_key AS product_key,
        p.product_number AS product_number,
        p.product_name AS product_name,
        p.category AS category,
        p.subcategory AS subcategory,
        p.cost AS cost
    FROM fact_sales f
    LEFT JOIN dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        order_number,
        customer_key,
        order_date,
        product_key,
        product_number,
        product_name,
        category,
        subcategory,
        cost
),

product_aggregation AS
(
    SELECT
        b.order_date AS order_date,
        b.product_key AS product_key,
        b.product_number AS product_number,
        b.product_name AS product_name,
        b.category AS category,
        b.subcategory AS subcategory,
        b.cost AS cost,
        SUM(f.sales_amount) AS total_sales,
        SUM(f.quantity) AS total_quantity,
        COUNT(DISTINCT f.order_number) AS total_orders,
        COUNT(DISTINCT f.customer_key) AS total_customers,
        TIMESTAMPDIFF(
            MONTH,
            MIN(b.order_date),
            CURDATE()
        ) AS lifespan
    FROM base_query b
    LEFT JOIN fact_sales f
        ON b.product_key = f.product_key
    GROUP BY
        b.order_date,
        b.product_key,
        b.product_number,
        b.product_name,
        b.category,
        b.subcategory,
        b.cost
)

SELECT
    order_date,
    product_key,
    product_number,
    product_name,
    category,
    subcategory,
    cost,
    CASE
        WHEN total_sales > 12000 THEN 'High Performer'
        WHEN total_sales BETWEEN 5000 AND 12000 THEN 'Mid Range'
        ELSE 'Low Performer'
    END AS product_segments,
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE ROUND((total_sales / total_orders), 1)
    END AS aov,
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE ROUND((total_sales / lifespan), 1)
    END AS monthly_revenue,
    total_sales,
    total_quantity,
    total_orders,
    total_customers,
    lifespan
FROM product_aggregation;
