WITH

-- Import CTEs
orders as (

    select * from {{ ref('stg_orders') }}

),

customers as (

    select * from {{ ref('stg_customers') }}

),

payments as (

    select * from {{ ref('stg_payments') }}

),


-- marts

customer_order_history as (

    select 

        customers.customer_id,
        customers.full_name,
        customers.surname,
        customers.givenname,

        min(order_date) as first_order_date,

        min(case 
            when a.status not in ('returned','return_pending') 
            then order_date 
        end) as first_non_returned_order_date,

        max(case 
            when a.status not in ('returned','return_pending') 
            then order_date 
        end) as most_recent_non_returned_order_date,

        coalesce(max(user_order_seq),0) as order_count,

        coalesce(count(case 
            when a.status != 'returned' 
            then 1 end),
            0
        ) as non_returned_order_count,

        sum(case 
            when a.status not in ('returned','return_pending') 
            then round(c.amount/100.0,2) 
            else 0 
        end) as total_lifetime_value,

        sum(case 
            when a.status not in ('returned','return_pending') 
            then round(c.amount/100.0,2) 
            else 0 
        end)
        / nullif(count(case 
            when a.status not in ('returned','return_pending') 
            then 1 end),
            0
        ) as avg_non_returned_order_value,

        array_agg(distinct a.id) as order_ids

    from a

    join customers
    on a.user_id = customers.id

    left outer join payments as c
    on a.id = c.orderid

    where a.status not in ('pending') and c.status != 'fail'

    group by customers.id, customers.name, customers.last_name, customers.first_name

),

-- Final CTEs 
final as (

    select 

        orders.id as order_id,
        orders.user_id as customer_id,
        last_name as surname,
        first_name as givenname,
        first_order_date,
        order_count,
        total_lifetime_value,
        round(amount/100.0,2) as order_value_dollars,
        orders.status as order_status,
        payments.status as payment_status

    from orders

    join customers
    on orders.user_id = customers.id

    join customer_order_history
    on orders.user_id = customer_order_history.customer_id

    left outer join payments
    on orders.id = payments.orderid

    where payments.status != 'fail'

)

-- Simple Select Statement
SELECT * FROM FINAL