WITH source AS (

    SELECT *
    FROM {{ source('zoominfo', 'global') }}

), renamed AS (

    SELECT 
      zi_c_id::NUMBER			                         	AS 	zi_c_id,     	           	              
      zi_c_hq_id::NUMBER			          	            AS 	zi_c_hq_id,     	           	              
      zi_c_is_hq::VARCHAR			          	            AS 	zi_c_is_hq,     	           	              
      zi_es_ecid::NUMBER				                    AS 	zi_es_ecid,     	           	              
      zi_es_location_id::VARCHAR		            	  	AS 	zi_es_location_id,     	           	              
      zi_c_tier_grade::VARCHAR			            	    AS 	zi_c_tier_grade,     	           	              
      zi_c_name::VARCHAR				                    AS 	zi_c_name,     	           	              
      zi_c_name_display::VARCHAR		            	  	AS 	zi_c_name_display,     	           	              
      zi_c_legal_entity_type::VARCHAR	            		AS 	zi_c_legal_entity_type,     	           	              
      zi_c_url::VARCHAR			                        	AS 	zi_c_url,     	           	              
      zi_c_street::VARCHAR		                    		AS 	zi_c_street,     	           	              
      zi_c_street_2::VARCHAR		                		AS 	zi_c_street_2,     	           	              
      zi_c_city::VARCHAR			          	            AS 	zi_c_city,     	           	              
      zi_c_state::VARCHAR			          	            AS 	zi_c_state,     	           	              
      zi_c_zip::VARCHAR			            	            AS 	zi_c_zip,     	           	              
      zi_c_country::VARCHAR		        		            AS 	zi_c_country,     	           	              
      zi_c_cbsa_name::VARCHAR		      		            AS 	zi_c_cbsa_name,     	           	              
      zi_c_county::VARCHAR			        	            AS 	zi_c_county,     	           	              
      zi_c_latitude::FLOAT			        	            AS 	zi_c_latitude,     	           	              
      zi_c_longitude::FLOAT			        	            AS 	zi_c_longitude,     	           	              
      zi_c_verified_address::VARCHAR			            AS 	zi_c_verified_address,     	           	              
      zi_c_employee_range::VARCHAR				            AS 	zi_c_employee_range,     	           	              
      zi_c_employees::NUMBER				                AS 	zi_c_employees,     	           	              
      zi_c_revenue_range::VARCHAR			  	            AS 	zi_c_revenue_range,     	           	              
      zi_c_revenue::NUMBER			        	            AS 	zi_c_revenue,     	           	              
      zi_c_phone::VARCHAR			                     	AS 	zi_c_phone,     	           	              
      zi_c_fax::VARCHAR			                        	AS 	zi_c_fax,     	           	              
      zi_c_industry_primary::VARCHAR		            	AS 	zi_c_industry_primary,     	           	              
      zi_c_sub_industry_primary::VARCHAR                	AS 	zi_c_sub_industry_primary,     	           	              
      zi_c_industries::VARCHAR			                	AS 	zi_c_industries,     	           	              
      zi_c_sub_industries::VARCHAR		             		AS 	zi_c_sub_industries,     	           	              
      zi_es_industry::VARCHAR			                	AS 	zi_es_industry,     	           	              
      zi_es_industries_top3::VARCHAR	            		AS 	zi_es_industries_top3,     	           	              
      zi_c_naics2::VARCHAR			                     	AS 	zi_c_naics2,     	           	              
      zi_c_naics4::VARCHAR			                    	AS 	zi_c_naics4,     	           	              
      zi_c_naics6::VARCHAR			                     	AS 	zi_c_naics6,     	           	              
      zi_c_naics_top3::VARCHAR			    	            AS 	zi_c_naics_top3,     	           	              
      zi_c_sic2::VARCHAR			          	            AS 	zi_c_sic2,     	           	              
      zi_c_sic3::VARCHAR			                        AS 	zi_c_sic3,     	           	              
      zi_c_sic4::VARCHAR		          		            AS 	zi_c_sic4,     	           	              
      zi_c_sic_top3::VARCHAR		   		                AS 	zi_c_sic_top3,     	           	              
      zi_c_estimated_age::NUMBER							AS 	zi_c_estimated_age,     	           	              
      zi_c_year_founded::VARCHAR							AS 	zi_c_year_founded,     	           	              
      zi_c_is_b2b::VARCHAR									AS 	zi_c_is_b2b,     	           	              
      zi_c_is_b2c::VARCHAR									AS 	zi_c_is_b2c,     	           	              
      zi_es_hq_ecid::NUMBER									AS 	zi_es_hq_ecid,     	           	              
      zi_es_hq_location_id::VARCHAR						    AS 	zi_es_hq_location_id,     	           	              
      zi_c_hq_name::VARCHAR									AS 	zi_c_hq_name,     	           	              
      zi_c_hq_url::VARCHAR									AS 	zi_c_hq_url,     	           	              
      zi_c_hq_street::VARCHAR								AS 	zi_c_hq_street,     	           	              
      zi_c_hq_street_2::VARCHAR								AS 	zi_c_hq_street_2,     	           	              
      zi_c_hq_city::VARCHAR								    AS 	zi_c_hq_city,     	           	              
      zi_c_hq_state::VARCHAR								AS 	zi_c_hq_state,     	           	              
      zi_c_hq_zip::VARCHAR									AS 	zi_c_hq_zip,     	           	              
      zi_c_hq_country::VARCHAR								AS 	zi_c_hq_country,     	           	              
      zi_c_hq_cbsa_name::VARCHAR							AS 	zi_c_hq_cbsa_name,     	           	              
      zi_c_hq_county::VARCHAR								AS 	zi_c_hq_county,     	           	              
      zi_c_hq_latitude::FLOAT								AS 	zi_c_hq_latitude,     	           	              
      zi_c_hq_longitude::FLOAT								AS 	zi_c_hq_longitude,     	           	              
      zi_c_hq_verified_address::VARCHAR						AS 	zi_c_hq_verified_address,     	           	              
      zi_c_hq_employee_range::VARCHAR						AS 	zi_c_hq_employee_range,     	           	              
      zi_c_hq_employees::NUMBER								AS 	zi_c_hq_employees,     	           	              
      zi_c_hq_revenue_range::VARCHAR						AS 	zi_c_hq_revenue_range,     	           	              
      zi_c_hq_revenue::NUMBER								AS 	zi_c_hq_revenue,     	           	              
      zi_c_hq_phone::VARCHAR								AS 	zi_c_hq_phone,     	           	              
      zi_c_hq_fax::VARCHAR									AS 	zi_c_hq_fax,     	           	              
      zi_c_linkedin_url::VARCHAR							AS 	zi_c_linkedin_url,     	           	              
      zi_c_facebook_url::VARCHAR							AS 	zi_c_facebook_url,     	           	              
      zi_c_twitter_url::VARCHAR								AS 	zi_c_twitter_url,     	           	              
      zi_c_yelp_url::VARCHAR								AS 	zi_c_yelp_url,     	           	              
      zi_c_alexa_rank::NUMBER								AS 	zi_c_alexa_rank,     	           	              
      zi_c_keywords::VARCHAR								AS 	zi_c_keywords,     	           	              
      zi_c_top_keywords::VARCHAR							AS 	zi_c_top_keywords,     	           	              
      zi_c_num_keywords::NUMBER					         	AS 	zi_c_num_keywords,     	           	              
      zi_c_employee_growth_1yr::FLOAT						AS 	zi_c_employee_growth_1yr,     	           	              
      zi_c_employee_growth_2yr::FLOAT						AS 	zi_c_employee_growth_2yr,     	           	              
      zi_es_growth::VARCHAR									AS 	zi_es_growth,     	           	              
      zi_es_employee_growth::VARCHAR						AS 	zi_es_employee_growth,     	           	              
      zi_es_revenue_growth::VARCHAR					    	AS 	zi_es_revenue_growth,     	           	              
      zi_es_percent_employee_growth::FLOAT					AS 	zi_es_percent_employee_growth,     	           	              
      zi_es_percent_revenue_growth::FLOAT					AS 	zi_es_percent_revenue_growth,     	           	              
      zi_c_name_confidence_score::FLOAT				    	AS 	zi_c_name_confidence_score,     	           	              
      zi_c_url_confidence_score::FLOAT						AS 	zi_c_url_confidence_score,     	           	              
      zi_c_address_confidence_score::FLOAT					AS 	zi_c_address_confidence_score,     	           	              
      zi_c_phone_confidence_score::FLOAT					AS 	zi_c_phone_confidence_score,     	           	              
      zi_c_employees_confidence_score::FLOAT				AS 	zi_c_employees_confidence_score,     	           	              
      zi_c_revenue_confidence_score::FLOAT					AS 	zi_c_revenue_confidence_score,     	           	              
      zi_es_industry_confidence_score::FLOAT				AS 	zi_es_industry_confidence_score,     	           	              
      zi_c_naics_confidence_score::FLOAT					AS 	zi_c_naics_confidence_score,     	           	              
      zi_c_sic_confidence_score::FLOAT						AS 	zi_c_sic_confidence_score,     	           	              
      zi_es_industries_top3_confidence_scores::VARCHAR		AS 	zi_es_industries_top3_confidence_scores,     	           	              
      zi_c_naics_top3_confidence_scores::VARCHAR			AS 	zi_c_naics_top3_confidence_scores,     	           	              
      zi_c_sic_top3_confidence_scores::VARCHAR				AS 	zi_c_sic_top3_confidence_scores,     	           	              
      zi_c_ids_merged::VARCHAR								AS 	zi_c_ids_merged,     	           	              
      zi_c_names_other::VARCHAR								AS 	zi_c_names_other,     	           	              
      zi_c_url_status::VARCHAR								AS 	zi_c_url_status,     	           	              
      zi_c_urls_alt::VARCHAR								AS 	zi_c_urls_alt,     	           	              
      zi_c_url_last_updated::VARCHAR						AS 	zi_c_url_last_updated,     	           	              
      zi_c_inactive_flag::VARCHAR							AS 	zi_c_inactive_flag,     	           	              
      zi_c_ein::VARCHAR										AS 	zi_c_ein,     	           	              
      zi_c_is_small_business::VARCHAR						AS 	zi_c_is_small_business,     	           	              
      zi_c_is_public::VARCHAR								AS 	zi_c_is_public,     	           	              
      zi_c_ticker::VARCHAR									AS 	zi_c_ticker,     	           	              
      zi_c_tickers_alt::VARCHAR								AS 	zi_c_tickers_alt,     	           	              
      zi_c_has_mobile_app::VARCHAR							AS 	zi_c_has_mobile_app,     	           	              
      zi_c_currency_code::VARCHAR			        		AS 	zi_c_currency_code,     	           	              
      zi_c_num_locations::NUMBER			      			AS 	zi_c_num_locations,     	           	              
      zi_c_hr_contacts::NUMBER								AS 	zi_c_hr_contacts,     	           	              
      zi_c_sales_contacts::NUMBER							AS 	zi_c_sales_contacts,     	           	              
      zi_c_marketing_contacts::NUMBER						AS 	zi_c_marketing_contacts,     	           	              
      zi_c_finance_contacts::NUMBER					    	AS 	zi_c_finance_contacts,     	           	              
      zi_c_c_suite_contacts::NUMBER				     		AS 	zi_c_c_suite_contacts,     	           	              
      zi_c_engineering_contacts::NUMBER						AS 	zi_c_engineering_contacts,     	           	              
      zi_c_it_contacts::NUMBER								AS 	zi_c_it_contacts,     	           	              
      zi_c_operations_contacts::NUMBER						AS 	zi_c_operations_contacts,     	           	              
      zi_c_legal_contacts::NUMBER					    	AS 	zi_c_legal_contacts,     	           	              
      zi_c_medical_contacts::NUMBER					    	AS 	zi_c_medical_contacts,     	           	              
      zi_c_tech_ids::VARCHAR								AS 	zi_c_tech_ids,     	           	              
      zi_c_latest_funding_age::NUMBER						AS 	zi_c_latest_funding_age,     	           	              
      zi_c_num_of_investors::NUMBER					    	AS 	zi_c_num_of_investors,     	           	              
      zi_c_investor_names::VARCHAR					    	AS 	zi_c_investor_names,     	           	              
      zi_c_funding_strength::VARCHAR						AS 	zi_c_funding_strength,     	           	              
      zi_c_funding_type::VARCHAR					    	AS 	zi_c_funding_type,     	           	              
      zi_c_total_funding_amount::NUMBER						AS 	zi_c_total_funding_amount,     	           	              
      zi_c_latest_funding_amount::NUMBER					AS 	zi_c_latest_funding_amount,     	           	              
      zi_c_latest_funding_date::VARCHAR						AS 	zi_c_latest_funding_date,     	           	              
      zi_c_num_funding_rounds::NUMBER						AS 	zi_c_num_funding_rounds,     	           	              
      zi_c_is_fortune_100::VARCHAR					    	AS 	zi_c_is_fortune_100,     	           	              
      zi_c_is_fortune_500::VARCHAR					    	AS 	zi_c_is_fortune_500,     	           	              
      zi_c_is_s_and_p_500::VARCHAR				     		AS 	zi_c_is_s_and_p_500,     	           	              
      zi_c_is_domestic_hq::VARCHAR				     		AS 	zi_c_is_domestic_hq,     	           	              
      zi_c_is_global_parent::VARCHAR						AS 	zi_c_is_global_parent,     	           	              
      zi_c_is_subsidiary::VARCHAR							AS 	zi_c_is_subsidiary,     	           	              
      zi_c_is_franchisor::VARCHAR				  			AS 	zi_c_is_franchisor,     	           	              
      zi_c_is_franchisee::VARCHAR							AS 	zi_c_is_franchisee,     	           	              
      zi_c_hierarchy_code::VARCHAR							AS 	zi_c_hierarchy_code,     	           	              
      zi_c_hierarchy_level::NUMBER							AS 	zi_c_hierarchy_level,     	           	              
      zi_c_parent_child_confidence_score::FLOAT				AS 	zi_c_parent_child_confidence_score,     	           	              
      zi_c_immediate_parent_id::NUMBER						AS 	zi_c_immediate_parent_id,     	           	              
      zi_es_immediate_parent_ecid::NUMBER			     	AS 	zi_es_immediate_parent_ecid,     	           	              
      zi_es_immediate_parent_location_id::VARCHAR			AS 	zi_es_immediate_parent_location_id,     	           	              
      zi_c_immediate_parent_name::VARCHAR				    AS 	zi_c_immediate_parent_name,     	           	              
      zi_c_immediate_parent_url::VARCHAR				    AS 	zi_c_immediate_parent_url,     	           	              
      zi_c_immediate_parent_street::VARCHAR				    AS 	zi_c_immediate_parent_street,     	           	              
      zi_c_immediate_parent_street_2::VARCHAR				AS 	zi_c_immediate_parent_street_2,     	           	              
      zi_c_immediate_parent_city::VARCHAR				    AS 	zi_c_immediate_parent_city,     	           	              
      zi_c_immediate_parent_zip::VARCHAR			 		AS 	zi_c_immediate_parent_zip,     	           	              
      zi_c_immediate_parent_state::VARCHAR					AS 	zi_c_immediate_parent_state,     	           	              
      zi_c_immediate_parent_country::VARCHAR				AS 	zi_c_immediate_parent_country,     	           	              
      zi_c_domestic_parent_id::NUMBER						AS 	zi_c_domestic_parent_id,     	           	              
      zi_es_domestic_parent_ecid::NUMBER					AS 	zi_es_domestic_parent_ecid,     	           	              
      zi_es_domestic_parent_location_id::VARCHAR			AS 	zi_es_domestic_parent_location_id,     	           	              
      zi_c_domestic_parent_name::VARCHAR					AS 	zi_c_domestic_parent_name,     	           	              
      zi_c_domestic_parent_url::VARCHAR				    	AS 	zi_c_domestic_parent_url,     	           	              
      zi_c_domestic_parent_street::VARCHAR					AS 	zi_c_domestic_parent_street,     	           	              
      zi_c_domestic_parent_street_2::VARCHAR				AS 	zi_c_domestic_parent_street_2,     	           	              
      zi_c_domestic_parent_city::VARCHAR					AS 	zi_c_domestic_parent_city,     	           	              
      zi_c_domestic_parent_zip::VARCHAR						AS 	zi_c_domestic_parent_zip,     	           	              
      zi_c_domestic_parent_state::VARCHAR					AS 	zi_c_domestic_parent_state,     	           	              
      zi_c_domestic_parent_country::VARCHAR					AS 	zi_c_domestic_parent_country,     	           	              
      zi_c_global_parent_id::NUMBER							AS 	zi_c_global_parent_id,     	           	              
      zi_es_global_parent_ecid::NUMBER						AS 	zi_es_global_parent_ecid,     	           	              
      zi_es_global_parent_location_id::VARCHAR				AS 	zi_es_global_parent_location_id,     	           	              
      zi_c_global_parent_name::VARCHAR						AS 	zi_c_global_parent_name,     	           	              
      zi_c_global_parent_url::VARCHAR						AS 	zi_c_global_parent_url,     	           	              
      zi_c_global_parent_street::VARCHAR					AS 	zi_c_global_parent_street,     	           	              
      zi_c_global_parent_street_2::VARCHAR					AS 	zi_c_global_parent_street_2,     	           	              
      zi_c_global_parent_city::VARCHAR						AS 	zi_c_global_parent_city,     	           	              
      zi_c_global_parent_zip::VARCHAR						AS 	zi_c_global_parent_zip,     	           	              
      zi_c_global_parent_state::VARCHAR						AS 	zi_c_global_parent_state,     	           	              
      zi_c_global_parent_country::VARCHAR					AS 	zi_c_global_parent_country,     	           	              
      zi_c_franchisor_id::NUMBER							AS 	zi_c_franchisor_id,     	           	              
      zi_es_franchisor_ecid::NUMBER							AS 	zi_es_franchisor_ecid,     	           	              
      zi_es_franchisor_location_id::VARCHAR					AS 	zi_es_franchisor_location_id,     	           	              
      zi_c_franchisor_name::VARCHAR							AS 	zi_c_franchisor_name,     	           	              
      zi_c_franchisor_url::VARCHAR							AS 	zi_c_franchisor_url,     	           	              
      zi_c_franchisor_street::VARCHAR						AS 	zi_c_franchisor_street,     	           	              
      zi_c_franchisor_street_2::VARCHAR						AS 	zi_c_franchisor_street_2,     	           	              
      zi_c_franchisor_city::VARCHAR					    	AS 	zi_c_franchisor_city,     	           	              
      zi_c_franchisor_zip::VARCHAR							AS 	zi_c_franchisor_zip,     	           	              
      zi_c_franchisor_state::VARCHAR						AS 	zi_c_franchisor_state,     	           	              
      zi_c_franchisor_country::VARCHAR						AS 	zi_c_franchisor_country,     	           	              
      zi_c_last_updated_date::VARCHAR						AS 	zi_c_last_updated_date,     	           	              
      zi_c_release_date::VARCHAR							AS 	zi_c_release_date
    FROM source

)

SELECT *
FROM renamed                           
