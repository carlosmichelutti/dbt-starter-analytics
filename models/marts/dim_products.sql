SELECT DISTINCT
    p.product_id AS product_id
,   p.product_name AS product_name
,   p.category AS category
,   p.unit_price AS unit_price
,   p.is_active AS is_active
,   p.has_unit_price_problem AS has_unit_price_problem
FROM {{ ref('stg_products') }} AS p
WHERE p.has_unit_price_problem = 0
