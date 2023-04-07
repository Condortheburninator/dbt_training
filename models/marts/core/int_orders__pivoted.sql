

WITH payments AS (

    SELECT * FROM {{ ref('stg_payments')}}

),

pivoted AS (

    SELECT
            order_id
            ,SUM(
                CASE
                    WHEN payment_method = 'bank_transfer'
                    THEN payment_amount
                    ELSE 0
                END
            )               AS bank_transfer_amount

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