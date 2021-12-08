{{ config(alias='report_pipeline_metrics_day_with_targets') }}

WITH date_details AS (
  
  SELECT *
  FROM   {{ ref('wk_sales_date_details') }} 
  
), report_pipeline_metrics_day AS (

   SELECT *
   FROM  {{ ref('wk_sales_report_pipeline_metrics_per_day') }} 

), report_targets_totals_per_quarter AS (

    SELECT *
    FROM  {{ ref('wk_sales_report_targets_totals_per_quarter') }} 

), mart_sales_funnel_target_daily AS (

  SELECT *
  FROM {{ref('wk_sales_mart_sales_funnel_target_daily')}}

-- make sure the aggregation works at the level we want it
-- make sure the aggregation works at the level we want it
), consolidated_metrics AS (

    SELECT 
        ---------------------------
        -- Keys
        sales_team_cro_level, 
        sales_team_rd_asm_level,
        deal_group,
        sales_qualified_source,
        -----------------------------

        close_fiscal_quarter_date,
        close_fiscal_quarter_name,
        close_day_of_fiscal_quarter_normalised,

        -- reported quarter
        SUM(deal_count)                     AS deal_count,
        SUM(open_1plus_deal_count)          AS open_1plus_deal_count,
        SUM(open_3plus_deal_count)          AS open_3plus_deal_count,
        SUM(open_4plus_deal_count)          AS open_4plus_deal_count, 
        SUM(booked_deal_count)              AS booked_deal_count,
        SUM(churned_contraction_deal_count) AS churned_contraction_deal_count,

        SUM(created_in_quarter_count)       AS created_in_quarter_count,

        -- reported quarter + 1
        SUM(rq_plus_1_open_1plus_deal_count)    AS rq_plus_1_open_1plus_deal_count,
        SUM(rq_plus_1_open_3plus_deal_count)    AS rq_plus_1_open_3plus_deal_count,
        SUM(rq_plus_1_open_4plus_deal_count)    AS rq_plus_1_open_4plus_deal_count,

        -- reported quarter + 2
        SUM(rq_plus_2_open_1plus_deal_count)    AS rq_plus_2_open_1plus_deal_count,
        SUM(rq_plus_2_open_3plus_deal_count)    AS rq_plus_2_open_3plus_deal_count,
        SUM(rq_plus_2_open_4plus_deal_count)    AS rq_plus_2_open_4plus_deal_count,

        ------------------------------
        -- Net ARR 
        -- Use Net ARR instead     
        -- created and closed

        -- reported quarter
        SUM(booked_net_arr)                     AS booked_net_arr,
        SUM(churned_contraction_net_arr)        AS churned_contraction_net_arr,

        SUM(open_1plus_net_arr)                 AS open_1plus_net_arr,
        SUM(open_3plus_net_arr)                 AS open_3plus_net_arr, 
        SUM(open_4plus_net_arr)                 AS open_4plus_net_arr, 

        SUM(created_and_won_same_quarter_net_arr)       AS created_and_won_same_quarter_net_arr,
        SUM(created_in_quarter_net_arr)                 AS created_in_quarter_net_arr,

        -- reported quarter + 1
        SUM(rq_plus_1_open_1plus_net_arr)       AS rq_plus_1_open_1plus_net_arr,
        SUM(rq_plus_1_open_3plus_net_arr)       AS rq_plus_1_open_3plus_net_arr,
        SUM(rq_plus_1_open_4plus_net_arr)       AS rq_plus_1_open_4plus_net_arr,

        -- reported quarter + 2
        SUM(rq_plus_2_open_1plus_net_arr)       AS rq_plus_2_open_1plus_net_arr,
        SUM(rq_plus_2_open_3plus_net_arr)       AS rq_plus_2_open_3plus_net_arr,
        SUM(rq_plus_2_open_4plus_net_arr)       AS rq_plus_2_open_4plus_net_arr
    FROM report_pipeline_metrics_day
    WHERE close_day_of_fiscal_quarter_normalised > 0
    GROUP BY 1,2,3,4,5,6,7
  
), consolidated_targets AS (

    SELECT
        ---------------------------
        -- Keys
        sales_team_cro_level, 
        sales_team_rd_asm_level,
        deal_group,
        sales_qualified_source,
        -----------------------------

        close_fiscal_quarter_name,
        close_fiscal_quarter_date,
     
        close_fiscal_year,
     
        SUM(target_net_arr)                         AS target_net_arr,
        SUM(target_deal_count)                      AS target_deal_count,
        SUM(target_pipe_generation_net_arr)         AS target_pipe_generation_net_arr, 
  
        SUM(total_booked_net_arr)                           AS total_booked_net_arr,
        SUM(total_churned_contraction_net_arr)              AS total_churned_contraction_net_arr,
        SUM(total_booked_deal_count)                        AS total_booked_deal_count,
        SUM(total_churned_contraction_deal_count)           AS total_churned_contraction_deal_count,
        SUM(total_pipe_generation_net_arr)                  AS total_pipe_generation_net_arr,
        SUM(total_pipe_generation_deal_count)               AS total_pipe_generation_deal_count,
        SUM(total_created_and_booked_same_quarter_net_arr)  AS total_created_and_booked_same_quarter_net_arr,
  
        SUM(calculated_target_net_arr)              AS calculated_target_net_arr, 
        SUM(calculated_target_deal_count)           AS calculated_target_deal_count,  
        SUM(calculated_target_pipe_generation)      AS calculated_target_pipe_generation
  FROM report_targets_totals_per_quarter
  GROUP BY 1,2,3,4,5,6,7

), consolidated_targets_per_day AS (
  
  SELECT 
        targets.*,
        close_day_of_fiscal_quarter_normalised
  FROM consolidated_targets targets
  CROSS JOIN (SELECT day_of_fiscal_quarter_normalised AS close_day_of_fiscal_quarter_normalised
                FROM date_details
                WHERE day_of_fiscal_quarter_normalised > 0
                GROUP BY 1)


-- some of the funnel metrics have daily targets with a very specific seasonality
-- this models tracks the target allocated a given point in time on the quarter
), funnel_allocated_targets_qtd AS (

  SELECT 
    target_fiscal_quarter_date                AS close_fiscal_quarter_date,
    target_day_of_fiscal_quarter_normalised   AS close_day_of_fiscal_quarter_normalised,
    sales_team_rd_asm_level,
    sales_team_cro_level,
    sales_qualified_source,
    deal_group,
    SUM(CASE 
          WHEN kpi_name = 'Net ARR' 
            THEN qtd_allocated_target
           ELSE 0 
        END)                        AS qtd_target_net_arr,
    SUM(CASE 
          WHEN kpi_name = 'Deals' 
            THEN qtd_allocated_target
           ELSE 0 
        END)                        AS qtd_target_deal_count,
    SUM(CASE 
          WHEN kpi_name = 'Net ARR Pipeline Created' 
            THEN qtd_allocated_target
           ELSE 0 
        END)                        AS qtd_target_pipe_generation_net_arr
  FROM mart_sales_funnel_target_daily
  GROUP BY 1,2,3,4,5,6

), key_fields AS (
    
  SELECT         
        sales_team_cro_level, 
        sales_team_rd_asm_level,
        deal_group,
        sales_qualified_source,
        close_fiscal_quarter_date
  FROM consolidated_targets
  UNION
  SELECT         
        sales_team_cro_level, 
        sales_team_rd_asm_level,
        deal_group,
        sales_qualified_source,
        close_fiscal_quarter_date
    FROM consolidated_metrics
  
), base_fields AS (
  
 SELECT 
    key_fields.*,
    close_date.fiscal_quarter_name_fy              AS close_fiscal_quarter_name,
    close_date.fiscal_year                         AS close_fiscal_year,
    close_date.day_of_fiscal_quarter_normalised    AS close_day_of_fiscal_quarter_normalised,
    close_date.date_actual                         AS close_date,
    rq_plus_1.first_day_of_fiscal_quarter          AS rq_plus_1_close_fiscal_quarter_date,
    rq_plus_1.fiscal_quarter_name_fy               AS rq_plus_1_close_fiscal_quarter_name,
    rq_plus_2.first_day_of_fiscal_quarter          AS rq_plus_2_close_fiscal_quarter_date,
    rq_plus_2.fiscal_quarter_name_fy               AS rq_plus_2_close_fiscal_quarter_name
 FROM key_fields
 INNER JOIN date_details close_date
    ON close_date.first_day_of_fiscal_quarter = key_fields.close_fiscal_quarter_date
 LEFT JOIN date_details rq_plus_1
    ON rq_plus_1.date_actual = dateadd(month,3,close_date.first_day_of_fiscal_quarter) 
 LEFT JOIN date_details rq_plus_2
    ON rq_plus_2.date_actual = dateadd(month,6,close_date.first_day_of_fiscal_quarter)  
  
), final AS (
  
    SELECT 

        --------------------------
        -- keys
        base.sales_team_cro_level, 
        base.sales_team_rd_asm_level,
        base.deal_group,
        base.sales_qualified_source,
        --------------------------
  
        base.close_fiscal_quarter_date,
        base.close_fiscal_quarter_name,
        base.close_fiscal_year,
        base.close_date,
        base.close_day_of_fiscal_quarter_normalised,

        -- report quarter plus 1 / 2 date fields
        base.rq_plus_1_close_fiscal_quarter_name,
        base.rq_plus_1_close_fiscal_quarter_date,
        base.rq_plus_2_close_fiscal_quarter_name,
        base.rq_plus_2_close_fiscal_quarter_date,    

        -- reported quarter
        metrics.deal_count,
        metrics.open_1plus_deal_count,
        metrics.open_3plus_deal_count,
        metrics.open_4plus_deal_count, 
        metrics.booked_deal_count,
        metrics.churned_contraction_deal_count,

        metrics.created_in_quarter_count,

        -- reported quarter + 1
        metrics.rq_plus_1_open_1plus_deal_count,
        metrics.rq_plus_1_open_3plus_deal_count,
        metrics.rq_plus_1_open_4plus_deal_count,

        -- reported quarter + 2
        metrics.rq_plus_2_open_1plus_deal_count,
        metrics.rq_plus_2_open_3plus_deal_count,
        metrics.rq_plus_2_open_4plus_deal_count,

        ------------------------------
        -- Net ARR 
        -- Use Net ARR instead     
        -- created and closed

        -- reported quarter
        metrics.booked_net_arr,
        metrics.churned_contraction_net_arr,
        metrics.open_1plus_net_arr,
        metrics.open_3plus_net_arr, 
        metrics.open_4plus_net_arr, 

        metrics.created_and_won_same_quarter_net_arr,
        metrics.created_in_quarter_net_arr,

        -- reported quarter + 1
        metrics.rq_plus_1_open_1plus_net_arr,
        metrics.rq_plus_1_open_3plus_net_arr,
        metrics.rq_plus_1_open_4plus_net_arr,

        -- reported quarter + 2
        metrics.rq_plus_2_open_1plus_net_arr,
        metrics.rq_plus_2_open_3plus_net_arr,
        metrics.rq_plus_2_open_4plus_net_arr,

        -- targets current quarter
        COALESCE(targets.target_net_arr,0)                        AS target_net_arr,
        COALESCE(targets.target_deal_count,0)                     AS target_deal_count,
        COALESCE(targets.target_pipe_generation_net_arr,0)        AS target_pipe_generation_net_arr, 
  
        COALESCE(targets.total_booked_net_arr,0)                            AS total_booked_net_arr,
        COALESCE(targets.total_churned_contraction_net_arr,0)               AS total_churned_contraction_net_arr,
        COALESCE(targets.total_booked_deal_count,0)                         AS total_booked_deal_count,
        COALESCE(targets.total_churned_contraction_deal_count,0)            AS total_churned_contraction_deal_count,        
        COALESCE(targets.total_pipe_generation_net_arr,0)                   AS total_pipe_generation_net_arr,
        COALESCE(targets.total_pipe_generation_deal_count,0)                AS total_pipe_generation_deal_count,
        COALESCE(targets.total_created_and_booked_same_quarter_net_arr,0)   AS total_created_and_booked_same_quarter_net_arr,
  
        COALESCE(targets.calculated_target_net_arr,0)             AS calculated_target_net_arr, 
        COALESCE(targets.calculated_target_deal_count,0)          AS calculated_target_deal_count,  
        COALESCE(targets.calculated_target_pipe_generation,0)     AS calculated_target_pipe_generation,
  
        -- totals quarter plus 1
        COALESCE(rq_plus_one.total_booked_net_arr,0)            AS rq_plus_1_total_booked_net_arr,
        COALESCE(rq_plus_one.total_booked_deal_count,0)         AS rq_plus_1_total_booked_deal_count,
        COALESCE(rq_plus_one.target_net_arr,0)                  AS rq_plus_1_target_net_arr,
        COALESCE(rq_plus_one.target_deal_count,0)               AS rq_plus_1_target_deal_count,
        COALESCE(rq_plus_one.calculated_target_net_arr,0)       AS rq_plus_1_calculated_target_net_arr,
        COALESCE(rq_plus_one.calculated_target_deal_count,0)    AS rq_plus_1_calculated_target_deal_count,
  
         -- totals quarter plus 2
        COALESCE(rq_plus_two.total_booked_net_arr,0)              AS rq_plus_2_total_booked_net_arr,
        COALESCE(rq_plus_two.total_booked_deal_count,0)           AS rq_plus_2_total_booked_deal_count,
        COALESCE(rq_plus_two.target_net_arr,0)                    AS rq_plus_2_target_net_arr,
        COALESCE(rq_plus_two.target_deal_count,0)                 AS rq_plus_2_target_deal_count,
        COALESCE(rq_plus_two.calculated_target_net_arr,0)         AS rq_plus_2_calculated_target_net_arr,
        COALESCE(rq_plus_two.calculated_target_deal_count,0)      AS rq_plus_2_calculated_target_deal_count,

        -- totals one year ago
        COALESCE(year_minus_one.total_booked_net_arr,0)             AS year_minus_one_total_booked_net_arr,
        COALESCE(year_minus_one.total_booked_deal_count,0)          AS year_minus_one_total_booked_deal_count,
        COALESCE(year_minus_one.total_pipe_generation_net_arr,0)    AS year_minus_one_total_pipe_generation_net_arr,
        COALESCE(year_minus_one.total_pipe_generation_deal_count,0) AS year_minus_one_total_pipe_generation_deal_count,

        COALESCE(qtd_target.qtd_target_net_arr,0)                   AS qtd_target_net_arr,
        COALESCE(qtd_target.qtd_target_deal_count,0)                AS qtd_target_deal_count,
        COALESCE(qtd_target.qtd_target_pipe_generation_net_arr,0)   AS qtd_target_pipe_generation_net_arr,

      -- TIMESTAMP
      current_timestamp                                              AS dbt_last_run_at
  
    FROM base_fields base 
    LEFT JOIN consolidated_metrics metrics
    ON metrics.sales_team_cro_level = base.sales_team_cro_level
      AND metrics.sales_team_rd_asm_level = base.sales_team_rd_asm_leveL
      AND metrics.sales_qualified_source = base.sales_qualified_source
      AND metrics.deal_group = base.deal_group
      AND metrics.close_fiscal_quarter_date = base.close_fiscal_quarter_date
      AND metrics.close_day_of_fiscal_quarter_normalised = base.close_day_of_fiscal_quarter_normalised
    -- current quarter
    LEFT JOIN consolidated_targets_per_day targets 
      ON targets.sales_team_cro_level = base.sales_team_cro_level
        AND targets.sales_team_rd_asm_level = base.sales_team_rd_asm_leveL
        AND targets.sales_qualified_source = base.sales_qualified_source
        AND targets.deal_group = base.deal_group
        AND targets.close_fiscal_quarter_date = base.close_fiscal_quarter_date
        AND targets.close_day_of_fiscal_quarter_normalised = base.close_day_of_fiscal_quarter_normalised
    -- quarter plus 1 targets
    LEFT JOIN consolidated_targets_per_day rq_plus_one
      ON rq_plus_one.sales_team_cro_level = base.sales_team_cro_level
        AND rq_plus_one.sales_team_rd_asm_level = base.sales_team_rd_asm_leveL
        AND rq_plus_one.sales_qualified_source = base.sales_qualified_source
        AND rq_plus_one.deal_group = base.deal_group
        AND rq_plus_one.close_fiscal_quarter_date = base.rq_plus_1_close_fiscal_quarter_date
        AND rq_plus_one.close_day_of_fiscal_quarter_normalised = base.close_day_of_fiscal_quarter_normalised
    -- quarter plus 2 targets
    LEFT JOIN consolidated_targets_per_day rq_plus_two
      ON rq_plus_two.sales_team_cro_level = base.sales_team_cro_level
        AND rq_plus_two.sales_team_rd_asm_level = base.sales_team_rd_asm_leveL
        AND rq_plus_two.sales_qualified_source = base.sales_qualified_source
        AND rq_plus_two.deal_group = base.deal_group
        AND rq_plus_two.close_fiscal_quarter_date = base.rq_plus_2_close_fiscal_quarter_date
        AND rq_plus_two.close_day_of_fiscal_quarter_normalised = base.close_day_of_fiscal_quarter_normalised
    -- one year ago totals
    LEFT JOIN consolidated_targets_per_day year_minus_one
      ON year_minus_one.sales_team_cro_level = base.sales_team_cro_level
        AND year_minus_one.sales_team_rd_asm_level = base.sales_team_rd_asm_leveL
        AND year_minus_one.sales_qualified_source = base.sales_qualified_source
        AND year_minus_one.deal_group = base.deal_group
        AND year_minus_one.close_fiscal_quarter_date = dateadd(month,-12,base.close_fiscal_quarter_date)
        AND year_minus_one.close_day_of_fiscal_quarter_normalised = base.close_day_of_fiscal_quarter_normalised
    -- qtd allocated targets
    LEFT JOIN funnel_allocated_targets_qtd qtd_target
      ON qtd_target.sales_team_cro_level = base.sales_team_cro_level
        AND qtd_target.sales_team_rd_asm_level = base.sales_team_rd_asm_leveL
        AND qtd_target.sales_qualified_source = base.sales_qualified_source
        AND qtd_target.deal_group = base.deal_group
        AND qtd_target.close_fiscal_quarter_date = dateadd(month,-12,base.close_fiscal_quarter_date)
        AND qtd_target.close_day_of_fiscal_quarter_normalised = base.close_day_of_fiscal_quarter_normalised
   

)
 SELECT *
 FROM final
 