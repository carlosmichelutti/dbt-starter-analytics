WITH cases (input_value, expected_value) AS (
    VALUES
        (NULL::TEXT, NULL::NUMERIC)
    ,   ('', NULL)
    ,   ('   ', NULL)
    ,   ('0', 0)
    ,   ('1299', 1299)
    ,   ('-1299', -1299)
    ,   ('+1299', 1299)
    ,   ('29.99', 29.99)
    ,   ('29,99', 29.99)
    ,   ('-29.99', -29.99)
    ,   ('-29,99', -29.99)
    ,   ('0,5', 0.5)
    ,   ('  $ 249.99  ', 249.99)
    ,   ('R$ 29,99', 29.99)
    ,   ('-R$ 29,99', -29.99)
    ,   ('R$ -29,99', -29.99)
    ,   ('-$ 29.99', -29.99)
    ,   ('1,299.00', 1299)
    ,   ('1.299,00', 1299)
    ,   ('-1,299.00', -1299)
    ,   ('-1.299,00', -1299)
    ,   ('1,234,567.89', 1234567.89)
    ,   ('1.234.567,89', 1234567.89)
    ,   ('1,234,567', 1234567)
    ,   ('1.234.567', 1234567)
    ,   ('1,234', NULL)
    ,   ('1.234', NULL)
    ,   ('1234.567', NULL)
    ,   ('12.3.4', NULL)
    ,   ('12,34.56', NULL)
    ,   ('12.34,56', NULL)
    ,   ('1,23,456.78', NULL)
    ,   ('abc123.45', NULL)
    ,   ('12abc34', NULL)
    ,   ('--29.99', NULL)
    ,   ('-R$ -29,99', NULL)
    ,   ('29.99-', NULL)
    ,   ('NaN', NULL)
    ,   ('Infinity', NULL)
    ,   ('1e3', NULL)
), parsed AS (
    SELECT
        input_value
    ,   expected_value
    ,   {{ parse_money('input_value') }} AS actual_value
    FROM cases
)
SELECT *
FROM parsed
WHERE actual_value IS DISTINCT FROM expected_value
