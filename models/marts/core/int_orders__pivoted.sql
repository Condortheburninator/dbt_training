

WITH payments AS (

    SELECT * FROM {{ ref('stg_payments')}}

),

pivoted AS (

    SELECT
             order_id
            ,SUM(CASE WHEN payment_method = 'bank_transfer' THEN payment_amount ELSE 0 END) AS bank_transfer_amount
            ,SUM(CASE WHEN payment_method = 'coupon' THEN payment_amount ELSE 0 END)        AS coupon_transfer_amount
            ,SUM(CASE WHEN payment_method = 'credit_card' THEN payment_amount ELSE 0 END)   AS credit_card_transfer_amount
            ,SUM(CASE WHEN payment_method = 'gift_card' THEN payment_amount ELSE 0 END)     AS gift_card_amount

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