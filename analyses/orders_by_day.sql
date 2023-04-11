

WITH orders AS (

    SELECT * FROM {{ ref( 'stg_orders' ) }}

),

DAILY AS (

    SELECT
             order_date
            ,count(*) AS ORDER_NUM
            
            {% for order_status in [ 'returned', 'completed', 'return_pending', 'shipped', 'placed' ] %}

                ,SUM(
                    CASE
                        WHEN status = {{ order_status }}
                        THEN 1
                        ELSE 0
                    END
                )                           AS {{ order_status }}_total 
            
            {% endfor %}

    FROM
            orders

    GROUP BY
            1

    ORDER BY
            order_date DESC

),

COMPARED AS (

    SELECT
            *
            ,LAG( ORDER_NUM ) OVER( ORDER BY order_date DESC ) AS previous_day_orders
    FROM
            DAILY

)

SELECT * FROM COMPARED