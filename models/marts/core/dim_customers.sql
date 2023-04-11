

WITH
     customers      AS ( SELECT * FROM {{ ref("stg_customers") }})
    ,orders         AS ( SELECT * FROM {{ ref("fct_orders") }})
    ,employees      AS ( SELECT * FROM {{ ref('employees' ) }} )
    ,customer_orders as (
        select
            customer_id,
            min(order_date) as first_order_date,
            max(order_date) as most_recent_order_date,
            count(order_id) as number_of_orders,
            sum(amount) as lifetime_value
        from orders
        group by 1
    )
    ,
    FINAL as (
        
        SELECT
                customers.customer_id,
                customers.first_name,
                customers.last_name,
                employees.employee_id IS NOT NULL AS is_employee,
                customer_orders.first_order_date,
                customer_orders.most_recent_order_date,
                coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
                customer_orders.lifetime_value
        
        FROM
                customers
        
        LEFT JOIN customer_orders USING (customer_id)
        LEFT JOIN employees USING (customer_id)
    )

SELECT * FROM FINAL
