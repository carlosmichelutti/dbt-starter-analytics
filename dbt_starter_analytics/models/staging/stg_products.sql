{{ config(materialized='view') }}

WITH products AS (
    SELECT
        p.product_id AS product_id
    ,   UPPER(TRIM(p.product_name)) AS product_name
    ,   UPPER(TRIM(p.category)) AS category
    ,   CASE
            WHEN p.unit_price IS NOT NULL THEN CAST(
                TRIM(
                    REPLACE(
                            REPLACE(p.unit_price, ',', ''), '$', ''
                        )
                    ) AS NUMERIC
                )
            ELSE 0
        END AS unit_price
    ,   CASE
            WHEN LOWER(TRIM(p.is_active)) IN (
                    'true', '1', 's', 'sim', 'yes'
                ) THEN TRUE
            WHEN LOWER(TRIM(p.is_active)) IN (
                    'false', '0', 'n', 'não', 'nao', 'no'
                ) THEN FALSE
            ELSE FALSE
        END AS is_active
    FROM raw.products AS p
)
SELECT
    p.*
,   CASE
        WHEN p.unit_price = 0 THEN 1
        ELSE 0
    END AS has_unit_price_problem
FROM products AS p