

{% test assert_column_is_greater_than_five(model, column_name) %}

SELECT
        {{ column_name }}

FROM
        {{ model }}

WHERE
        {{ column_name }} <= 5

{% endtest %}
