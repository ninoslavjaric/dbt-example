{% macro stager(source_relation) %}


{%- set meta_unpivots_query -%}
select * from {{ source('meta', 'unpivot_rules') }} 
where lower(source_database) = '{{source_relation.database}}'
    and lower(source_schema) = '{{source_relation.schema}}'
    and lower(source_table) = '{{source_relation.table}}'
{%- endset -%}

/*
meta_unpivots_query:
------------------------------
{{meta_unpivots_query}}
------------------------------
*/
{%- set meta_unpivots = run_query(meta_unpivots_query) -%}


{%- set selects = ['*'] -%}
{%- set unpivot_expressions = [] -%}
{%- set casts = {} -%}

{%- for row in meta_unpivots -%}
    {%- if row.CAST not in casts -%}
        {%- do casts.update({row.CAST: []}) -%}
    {%- endif -%}

    {%- set unpivot_columns_query -%}
    select column_name 
    from {{source_relation.database}}.information_schema.columns 
    where lower(table_catalog) = '{{source_relation.database}}' 
        and lower(table_schema) = '{{source_relation.schema}}'
        and lower(table_name) = '{{source_relation.table}}'
        and {{row.RULE}}
    {%- endset -%}

    /*
    unpivot_columns_query:
    ------------------------------
    {{unpivot_columns_query}}
    ------------------------------
    */
    {%- set unpivot_columns = run_query(unpivot_columns_query) -%}


    {%- set unpivot_expression -%}
    UNPIVOT ( {{row.VALUE_COLUMN}}
             FOR {{row.NAME_COLUMN}} IN ( 
                    {%- for unpivot_column in unpivot_columns -%}
                        {%- do casts[row.CAST].append(unpivot_column.COLUMN_NAME) -%}
                        "{{unpivot_column.COLUMN_NAME}}"{%- if not loop.last -%},{% endif %} 
                    {%- endfor -%}
                ) 
            )
    {%- endset -%}

    {%- do selects.append(row.NAME_COLUMN) -%}
    {%- do selects.append(row.VALUE_COLUMN) -%}
    {%- do unpivot_expressions.append(unpivot_expression) -%}
{%- endfor -%}


{%- set selection = [] -%}
{%- for cast_selection in casts.values() -%}
    {%- do selection.extend(cast_selection) -%}
{%- endfor -%}


with filtered as (
    select *
    {% if selection %}
    exclude(
        {% for select in selection %}
            "{{select}}" {%- if not loop.last -%},{% endif %} 
        {%- endfor -%}
    ),
        {% for cast_type, columns in casts.items() %}
            {% for column in columns %}
                "{{column}}"::{{cast_type}} as "{{column}}"
                {%- if not loop.last -%},{% endif %} 
            {%- endfor -%}
        {%- endfor -%}
    {%- endif %}
 from {{source_relation}})
select *
from filtered
{% for unpivot_expression in unpivot_expressions -%}
    {{unpivot_expression}}
{%- endfor -%}
{% endmacro %}