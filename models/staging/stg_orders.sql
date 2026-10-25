WITH raw_orders AS (
    SELECT
        ro.order_id AS order_id
    ,   ro.customer_id AS customer_id
    ,   CASE
            WHEN pg_input_is_valid(ro.order_date, 'date')
                THEN CAST(ro.order_date AS DATE)
            ELSE NULL
        END AS order_date
    ,   CASE
            WHEN (TRIM(ro.status) IS NULL) OR (TRIM(ro.status) = '') THEN 'UNDEFINED'
            WHEN UPPER(TRIM(ro.status)) IN ('COMPLETED', 'COMPLETE') THEN 'COMPLETED'
            WHEN UPPER(TRIM(ro.status)) IN ('CANCELED', 'CANCELLED') THEN 'CANCELED'
            ELSE UPPER(TRIM(ro.status))
        END AS status
    ,   CASE
            WHEN (TRIM(ro.payment_method) IS NULL) OR (TRIM(ro.payment_method) = '') THEN 'UNDEFINED'
            ELSE UPPER(
                REGEXP_REPLACE(
                    TRIM(ro.payment_method), '[^a-zA-Z]+', '_', 'g'
                )
            )
        END AS payment_method
    FROM {{ source('ecom', 'orders') }} AS ro
)
SELECT
    ro.*
,   CASE
        WHEN ro.order_date IS NULL THEN 1
        ELSE 0
    END AS has_order_date_problem
FROM raw_orders AS ro
