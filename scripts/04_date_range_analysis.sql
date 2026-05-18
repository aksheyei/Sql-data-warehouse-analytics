
-- FIND EARLIEST AND LATEST ORDER DATES
SELECT
    MIN(order_date) AS earliest_date,
    MAX(order_date) AS latest_date
FROM fact_sales;

-- FIND YOUNGEST AND OLDEST CUSTOMER BIRTHDATES
SELECT
    MIN(birthdate) AS youngest_customer,
    MAX(birthdate) AS oldest_customer
FROM dim_customers;
