-- TOTAL SALES GENERATED
SELECT
    SUM(sales_amount) AS total_sales
FROM fact_sales;

-- TOTAL QUANTITY OF PRODUCTS SOLD
SELECT
    SUM(quantity) AS total_quantity_sold
FROM fact_sales;

-- AVERAGE SELLING PRICE
SELECT
    AVG(price) AS average_selling_price
FROM fact_sales;

-- TOTAL NUMBER OF UNIQUE ORDERS
SELECT
    COUNT(DISTINCT order_number) AS total_orders
FROM fact_sales;

-- TOTAL NUMBER OF UNIQUE PRODUCTS
SELECT
    COUNT(DISTINCT product_name) AS total_products
FROM dim_products;

-- TOTAL NUMBER OF UNIQUE CUSTOMERS
SELECT
    COUNT(DISTINCT customer_key) AS total_customers
FROM dim_customers;
