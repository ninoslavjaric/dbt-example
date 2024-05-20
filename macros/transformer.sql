{% macro transformer(reference_model) %}
    {%- set meta_mapping_query -%}
    select source_mapping, map_column from {{ source('meta', 'mapping_rules') }} 
    where lower(source_database) = '{{reference_model.database | lower}}'
        and lower(source_schema) = '{{reference_model.schema | lower}}'
        and lower(source_table) = '{{reference_model.table | lower}}'
    {%- endset -%}
    /*
    meta_mapping_query:
    ------------------------------
    {{meta_mapping_query}}
    ------------------------------
    */
    {% set meta_mapping = run_query(meta_mapping_query) -%}


    select 
    {% for row in meta_mapping %}
        {{row.SOURCE_MAPPING}} as {{row.MAP_COLUMN}}{%- if not loop.last -%},{% endif %} 
    {%- endfor %}
    from {{reference_model}}
{% endmacro %}