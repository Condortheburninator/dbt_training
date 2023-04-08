

{% macro grant_select(schema=target.schema, role=target.role) %}

  {% set sql %}
  
  GRANT USAGE ON SCHEMA {{ schema }} to role {{ role }};
  GRANT SELECT ON ALL tables    IN SCHEMA {{ schema }} TO ROLE {{ role }};
  GRANT SELECT ON ALL views     IN SCHEMA {{ schema }} TO ROLE {{ role }};
  
  {% endset %}

  {{ log('Granting select on all tables and views in schema ' ~ target.schema ~ ' to role ' ~ role, info = True) }}
  
  {% do run_query(sql) %}
  
  {{ log('Privileges granted', info = True) }}

{% endmacro %}