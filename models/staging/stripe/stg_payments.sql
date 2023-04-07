

with payments as (

SELECT
         id             AS payment_id
        ,orderid        AS order_id
        ,paymentmethod  AS payment_method
        ,status         AS payment_status
        ,amount         AS payment_amount
        ,created
        ,_batched_at

FROM
        RAW.stripe.payment

)

SELECT * FROM payments