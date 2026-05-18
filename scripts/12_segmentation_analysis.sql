*========================================================
    DATA SEGMENTATION ANALYSIS
========================================================*/

-- PRODUCT SEGMENTATION BASED ON COST RANGE
WITH product_segments AS
(
    SELECT
        product_key,
        product_name,
        cost,

        CASE
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost < 500 THEN 'Below 500'
            WHEN cost < 1000 THEN 'Below 1000'
            ELSE 'Above 1000'
        END AS cost_range

    FROM dim_products
)

SELECT
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range;


-- CUSTOMER SEGMENTATION BASED ON TOTAL PURCHASE VALUE
WITH customer_segments AS
(
    SELECT
        c.customer_key AS customer_id,
        SUM(f.sales_amount) AS total_sales,

        CASE
            WHEN SUM(f.sales_amount) < 5000 THEN 'Regular'
            ELSE 'VIP'
        END AS customer_segment

    FROM fact_sales f
    LEFT JOIN dim_customers c
        ON f.customer_key = c.customer_key

    GROUP BY c.customer_key
)

SELECT
    customer_segment,
    COUNT(customer_id) AS total_customers
FROM customer_segments
GROUP BY customer_segment;
