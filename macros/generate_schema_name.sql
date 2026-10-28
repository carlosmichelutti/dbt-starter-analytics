{% macro generate_schema_name(custom_schema_name, node) -%}
    {# Only fixture seeds use an exact schema so they match source('ecom', ...). #}
    {%- if node.resource_type == 'seed' and 'raw_input' in node.config.tags -%}
        {{ custom_schema_name | trim }}
    {%- elif custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ target.schema }}_{{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
