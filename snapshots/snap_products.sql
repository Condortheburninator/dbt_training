

{% snapshot snap_products %}

{{
    config(
         target_database    = 'analytics'
        ,target_schema      = 'dbt_cferguson'
        ,unique_key         = 'id'

        ,strategy           = 'timestamp'
        ,check_cols         = ['price']
    )
}}

{% end snapshot%}