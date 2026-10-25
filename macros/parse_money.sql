{% macro parse_money(expression) -%}
    (
        SELECT
            CASE
                WHEN pg_input_is_valid(normalized_value, 'numeric')
                    THEN CAST(normalized_value AS NUMERIC)
                ELSE NULL
            END
        FROM (
            SELECT
                CASE
                    WHEN cleaned_value ~ '^[+-]?[0-9]+$'
                        THEN cleaned_value
                    WHEN cleaned_value ~ '^[+-]?[0-9]+[.,][0-9]{1,2}$'
                        THEN REPLACE(cleaned_value, ',', '.')
                    WHEN cleaned_value ~ '^[+-]?[0-9]{1,3}(,[0-9]{3})+[.][0-9]{1,2}$'
                        THEN REPLACE(cleaned_value, ',', '')
                    WHEN cleaned_value ~ '^[+-]?[0-9]{1,3}([.][0-9]{3})+,[0-9]{1,2}$'
                        THEN REPLACE(REPLACE(cleaned_value, '.', ''), ',', '.')
                    WHEN cleaned_value ~ '^[+-]?[0-9]{1,3}(,[0-9]{3}){2,}$'
                        THEN REPLACE(cleaned_value, ',', '')
                    WHEN cleaned_value ~ '^[+-]?[0-9]{1,3}([.][0-9]{3}){2,}$'
                        THEN REPLACE(cleaned_value, '.', '')
                    ELSE NULL
                END AS normalized_value
            FROM (
                SELECT
                    REGEXP_REPLACE(
                        REGEXP_REPLACE(
                            CAST({{ expression }} AS TEXT),
                            '^[[:space:]]+|[[:space:]]+$', '', 'g'
                        ),
                        '^([+-]?)[[:space:]]*(R[$]|[$])[[:space:]]*',
                        '\1', 'i'
                    ) AS cleaned_value
            ) AS cleaned_money
        ) AS normalized_money
    )
{%- endmacro %}
