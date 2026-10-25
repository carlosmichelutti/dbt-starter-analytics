{{ config(materialized='view') }}

WITH raw_products AS (
    SELECT
        rp.product_id AS product_id
    ,   UPPER(TRIM(rp.product_name)) AS product_name
    ,   UPPER(TRIM(rp.category)) AS category
    ,   CASE
            WHEN rp.unit_price IS NOT NULL THEN CAST(
                TRIM(
                    REPLACE(
                            REPLACE(rp.unit_price, ',', ''), '$', ''
                        )
                    ) AS NUMERIC
                )
            ELSE 0
        END AS unit_price
    ,   CASE
            WHEN LOWER(TRIM(rp.is_active)) IN (
                    'true', '1', 's', 'sim', 'yes'
                ) THEN TRUE
            WHEN LOWER(TRIM(rp.is_active)) IN (
                    'false', '0', 'n', 'não', 'nao', 'no'
                ) THEN FALSE
            ELSE FALSE
        END AS is_active
    FROM {{ source('ecom', 'products') }} AS rp
)
SELECT
    rp.*
,   CASE
        WHEN rp.unit_price = 0 THEN 1
        ELSE 0
    END AS has_unit_price_problem
FROM raw_products AS rp
