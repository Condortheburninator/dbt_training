

{%- set payment_methods = ['bank_transfer', 'coupon', 'credit_card', 'gift_card'] -%}

WITH payments AS (

    SELECT * FROM {{ ref('stg_payments')}}

),

pivoted AS (

    SELECT
             order_id

            {% for payment_method in payment_methods -%}

            ,SUM(CASE WHEN payment_method = '{{ payment_method}}' THEN payment_amount ELSE 0 END)   AS {{ payment_method }}_amount

            {% endfor %}

    FROM
            payments

    WHERE
            1 = 1
            AND
            payment_status = 'success'

    GROUP BY
            1
)

SELECT * FROM pivoted