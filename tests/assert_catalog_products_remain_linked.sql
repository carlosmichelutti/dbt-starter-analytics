SELECT oi.order_item_id, oi.product_id
FROM {{ ref('int_order_items') }} AS oi
WHERE EXISTS (
    SELECT 1
    FROM {{ ref('stg_products') }} AS p
    WHERE p.product_id = oi.product_id
)
AND NOT EXISTS (
    SELECT 1
    FROM {{ ref('dim_products') }} AS p
    WHERE p.product_id = oi.product_id
)
