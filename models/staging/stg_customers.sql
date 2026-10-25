WITH raw_customers AS (
    SELECT
        rc.customer_id AS customer_id
    ,   UPPER(TRIM(rc.full_name)) AS full_name
    ,   CASE
            WHEN (TRIM(rc.email) IS NULL) OR (TRIM(rc.email) = '') THEN NULL
            ELSE LOWER(TRIM(rc.email))
        END AS email
    ,   CASE
            WHEN pg_input_is_valid(TRIM(rc.registration_date), 'date')
                THEN CAST(TRIM(rc.registration_date) AS DATE)
            ELSE NULL
        END AS registration_date
    ,   UPPER(TRIM(rc.city)) AS city
    ,   UPPER(TRIM(rc.state)) AS state
    FROM {{ source('ecom', 'customers') }} AS rc
)
SELECT
    rc.*
,   CASE
        WHEN rc.email IS NULL THEN 1
        ELSE 0
    END AS has_email_problem
,   CASE
        WHEN rc.registration_date IS NULL THEN 1
        ELSE 0
    END AS has_registration_date_problem
FROM raw_customers AS rc
