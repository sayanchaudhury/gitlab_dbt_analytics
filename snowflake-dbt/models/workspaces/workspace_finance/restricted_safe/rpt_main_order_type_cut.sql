{{ config(materialized='table') }}

{{ rpt_main_sales_management_cut_generator(["order_type_grouped", "segment_region_grouped"], 'FALSE') }}
