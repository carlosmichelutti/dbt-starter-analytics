SELECT DISTINCT
    c.customer_id AS customer_id
,   c.full_name AS customer_name
,   c.email AS email
,   c.registration_date AS registration_date
,   c.city AS city
,   c.state AS state
,   c.has_email_problem AS has_email_problem
,   c.has_registration_date_problem AS has_registration_date_problem
FROM {{ ref('stg_customers') }} AS c
