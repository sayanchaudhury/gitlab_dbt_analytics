{{ config(alias='report_pipeline_velocity_quarter') }}
WITH sfdc_opportunity_snapshot_history_xf AS (

    SELECT *
    FROM {{ref('wk_sales_sfdc_opportunity_snapshot_history_xf')}}  
    WHERE is_deleted = 0
      AND is_edu_oss = 0
  
), report_pipeline_velocity_quarter AS (

    SELECT
      snapshot_date,
      snapshot_fiscal_quarter_name,
      snapshot_fiscal_quarter_date,
      snapshot_fiscal_year,
      snapshot_day_of_fiscal_quarter_normalised,
      close_day_of_fiscal_quarter_normalised,
      close_fiscal_quarter_name,
      close_fiscal_quarter_date,
      close_fiscal_year,
      sales_team_cro_level,
      sales_team_rd_asm_level,
      sales_qualified_source,
      order_type_stamped,
      deal_group,
      deal_category,
      stage_name_3plus,
      stage_name_4plus,
      is_stage_1_plus,
      is_stage_3_plus,
      is_stage_4_plus,
      is_open,
      is_lost,
      is_won,
      is_renewal,
      is_excluded_flag,
      stage_name,
      forecast_category_name,
      
      SUM(open_1plus_net_arr)             AS open_1plus_net_arr,
      SUM(open_3plus_net_arr)             AS open_3plus_net_arr,
      SUM(open_4plus_net_arr)             AS open_4plus_net_arr,
      SUM(booked_net_arr)                 AS booked_net_arr,
      SUM(churned_contraction_net_arr)    AS churned_contraction_net_arr,
      SUM(net_arr)                        AS net_arr,
      
      SUM(calculated_deal_count)          AS deal_count

    FROM sfdc_opportunity_snapshot_history_xf 
    WHERE 
      -- 2 quarters before start and full quarter, total rolling 9 months at end of quarter
      -- till end of quarter
      snapshot_date <= DATEADD(month,3,close_fiscal_quarter_date)
      -- 2 quarters before start
      AND snapshot_date >= DATEADD(month,-6,close_fiscal_quarter_date)
    GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,12, 13, 14, 15, 16,17,18,19,20,21,22,23,24,25,26,27

)

SELECT *
FROM report_pipeline_velocity_quarter
