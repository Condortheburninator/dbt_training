

SELECT
    id              as payment_id,
    orderid         as order_id,
    paymentmethod   as payment_method,
    status          as payment_status,

    {{ cents_to_dollars() }}    as payment_amount,
    created         as created_at

FROM 
        {{ source( 'stripe', 'payment' ) }}