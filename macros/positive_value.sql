{% test positive_value(model, column_name) %}
    SELECT {{ column_name }}
    FROM {{ model }}
    WHERE {{ column_name }} IS NULL OR {{ column_name }} <= 0
{% endtest %}
