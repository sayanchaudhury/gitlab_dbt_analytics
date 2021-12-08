{% set version_usage_stats_list = dbt_utils.get_column_values(table=ref ('version_usage_stats_list'), column='full_ping_name', max_records=1000, default=['']) %}

{{ config({
    "materialized": "incremental",
    "unique_key": "id"
    })
}}

WITH usage_data AS (

    SELECT *
    FROM {{ ref('version_usage_data_with_metadata') }}
    {% if is_incremental() %}

      WHERE created_at >= (SELECT MAX(created_at) FROM {{this}})

    {% endif %}

), stats_used_unpacked AS (

    SELECT *
    FROM {{ ref('version_usage_data_unpacked_stats_used') }}
    {% if is_incremental() %}

      WHERE created_at >= (SELECT MAX(created_at) FROM {{this}})

    {% endif %}
    
), unpacked AS (

    SELECT
      {{ dbt_utils.star(from=ref('version_usage_data_with_metadata'), except=["STATS_USED", "COUNTS", "USAGE_ACTIVITY_BY_STAGE", "ANALYTICS_UNIQUE_VISIT"], relation_alias='usage_data') }},
      ping_name,
      full_ping_name,
      ping_value

    FROM usage_data
    LEFT JOIN stats_used_unpacked
      ON usage_data .id = stats_used_unpacked.id

), final AS (

    SELECT
      {{ dbt_utils.star(from=ref('version_usage_data_with_metadata'), except=["STATS_USED", "COUNTS", "USAGE_ACTIVITY_BY_STAGE", "RAW_USAGE_DATA_PAYLOAD", "ANALYTICS_UNIQUE_VISITS"]) }},
      {% for stat_name in version_usage_stats_list %}
        MAX(IFF(full_ping_name = '{{stat_name}}', ping_value::NUMBER, NULL)) AS {{stat_name}}
        {{ "," if not loop.last }}
      {% endfor %}
    FROM unpacked
    {{ dbt_utils.group_by(n=72) }}


)

SELECT *
FROM final
