{{ config(materialized='view') }}

WITH customers AS (
    SELECT
        c.customer_id AS customer_id
    ,   UPPER(TRIM(c.full_name)) AS full_name
    ,   CASE
            WHEN (TRIM(c.email) IS NULL) OR (TRIM(c.email) = '') THEN NULL
            ELSE LOWER(TRIM(c.email))
        END AS email
    ,   CASE
            WHEN pg_input_is_valid(TRIM(c.registration_date), 'date')
                THEN CAST(TRIM(c.registration_date) AS DATE)
            ELSE NULL
        END AS registration_date
    ,   UPPER(TRIM(c.city)) AS city
    ,   UPPER(TRIM(c.state)) AS state
    FROM raw.customers AS c
)
SELECT
    c.*
,   CASE
        WHEN c.email IS NULL THEN 1
        ELSE 0
    END AS has_email_problem
,   CASE
        WHEN c.registration_date IS NULL THEN 1
        ELSE 0
    END AS has_registration_date_problem
FROM customers AS c