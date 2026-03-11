{% macro cents_to_dollars(column_name) -%}
    round({{ column_name }} / 100.0, 2)
{%- endmacro %}
