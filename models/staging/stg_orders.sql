{{ config(materialized='view') }}

WITH orders AS (
    SELECT
        o.order_id AS order_id
    ,   o.customer_id AS customer_id
    ,   CASE
            WHEN pg_input_is_valid(o.order_date, 'date')
                THEN CAST(o.order_date AS DATE)
            ELSE NULL
        END AS order_date
    ,   CASE
            WHEN (TRIM(o.status) IS NULL) OR (TRIM(o.status) = '') THEN 'UNDEFINED'
            WHEN UPPER(TRIM(o.status)) IN ('COMPLETED', 'COMPLETE') THEN 'COMPLETED'
            WHEN UPPER(TRIM(o.status)) IN ('CANCELED', 'CANCELLED') THEN 'CANCELED'
            ELSE UPPER(TRIM(o.status))
        END AS status
    ,   CASE
            WHEN (TRIM(o.payment_method) IS NULL) OR (TRIM(o.payment_method) = '') THEN 'UNDEFINED'
            ELSE UPPER(TRIM(o.payment_method))
        END AS payment_method
    FROM raw.orders AS o
)
SELECT
    o.*
,   CASE
        WHEN o.order_date IS NULL THEN 1
        ELSE 0
    END AS has_order_date_problem
FROM orders AS o