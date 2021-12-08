WITH source AS (

    SELECT *
    FROM {{ source('salesforce', 'lead') }}

), renamed AS(

    SELECT
        --id
        id                                                      AS lead_id,
        name                                                    AS lead_name,
        firstname                                               AS lead_first_name,
        lastname                                                AS lead_last_name,
        email                                                   AS lead_email,
        split_part(email,'@',2)                                 AS email_domain,
        {{email_domain_type("split_part(email,'@',2)", 'leadsource')}}
                                                                AS email_domain_type,

        --keys
        masterrecordid                                          AS master_record_id,
        convertedaccountid                                      AS converted_account_id,
        convertedcontactid                                      AS converted_contact_id,
        convertedopportunityid                                  AS converted_opportunity_id,
        ownerid                                                 AS owner_id,
        recordtypeid                                            AS record_type_id,
        round_robin_id__c                                       AS round_robin_id,
        instance_uuid__c                                        AS instance_uuid,
        lean_data_matched_account__c                            AS lean_data_matched_account,

        --lead info
        isconverted                                             AS is_converted,
        converteddate                                           AS converted_date,
        title                                                   AS title,
        {{it_job_title_hierarchy('title')}},
        donotcall                                               AS is_do_not_call,
        hasoptedoutofemail                                      AS has_opted_out_email,
        emailbounceddate                                        AS email_bounced_date,
        emailbouncedreason                                      AS email_bounced_reason,
        leadsource                                              AS lead_source,
        lead_from__c                                            AS lead_from,
        lead_source_type__c                                     AS lead_source_type,
        lead_conversion_approval_status__c                      AS lead_conversiona_approval_status,
        street                                                  AS street,
        city                                                    AS city,
        state                                                   AS state,
        statecode                                               AS state_code,
        country                                                 AS country,
        countrycode                                             AS country_code,
        postalcode                                              AS postal_code,
        zi_company_country__c                                   AS zoominfo_company_country,
        zi_contact_country__c                                   AS zoominfo_contact_country,
        zi_company_state__c                                     AS zoominfo_company_state,
        zi_contact_state__c                                     AS zoominfo_contact_state,
  
        -- info
        requested_contact__c                                    AS requested_contact,
        company                                                 AS company,
        buying_process_for_procuring_gitlab__c                  AS buying_process,
        core_check_in_notes__c                                  AS core_check_in_notes,
        industry                                                AS industry,
        region__c                                               AS region,
        largeaccount__c                                         AS is_large_account,
        outreach_stage__c                                       AS outreach_stage,
        interested_in_gitlab_ee__c                              AS is_interested_gitlab_ee,
        interested_in_hosted_solution__c                        AS is_interested_in_hosted,
        lead_assigned_datetime__c::TIMESTAMP                    AS assigned_datetime,
        matched_account_top_list__c                             AS matched_account_top_list,
        mql_date__c                                             AS marketo_qualified_lead_date,
        mql_datetime__c                                         AS marketo_qualified_lead_datetime,
        mql_datetime_inferred__c                                AS mql_datetime_inferred,
        inquiry_datetime__c                                     AS inquiry_datetime,
        accepted_datetime__c                                    AS accepted_datetime,
        qualifying_datetime__c                                  AS qualifying_datetime,
        qualified_datetime__c                                   AS qualified_datetime,
        unqualified_datetime__c                                 AS unqualified_datetime,
        nurture_datetime__c                                     AS nurture_datetime,
        bad_data_datetime__c                                    AS bad_data_datetime,
        worked_date__c                                          AS worked_datetime,
        web_portal_purchase_datetime__c                         AS web_portal_purchase_datetime,
        {{ sales_segment_cleaning('sales_segmentation__c') }}   AS sales_segmentation,
        mkto71_Lead_Score__c                                    AS person_score,
        status                                                  AS lead_status,
        last_utm_campaign__c                                    AS last_utm_campaign, 
        last_utm_content__c                                     AS last_utm_content,
        crm_partner_id_lookup__c                                AS crm_partner_id,
        name_of_active_sequence__c                              AS name_of_active_sequence,
        sequence_task_due_date__c::DATE                         AS sequence_task_due_date,
        sequence_status__c                                      AS sequence_status,
        sequence_step_type2__c                                  AS sequence_step_type,
        actively_being_sequenced__c::BOOLEAN                    AS is_actively_being_sequenced,


        {{  sfdc_source_buckets('leadsource') }}

        -- territory success planning info
        leandata_owner__c                                       AS tsp_owner,
        leandata_region__c                                      AS tsp_region,
        leandata_sub_region__c                                  AS tsp_sub_region,
        leandata_territory__c                                   AS tsp_territory,

        --path factory info
        pathfactory_experience_name__c                          AS pathfactory_experience_name,
        pathfactory_engagement_score__c                         AS pathfactory_engagement_score,
        pathfactory_content_count__c                            AS pathfactory_content_count,
        pathfactory_content_list__c                             AS pathfactory_content_list,
        pathfactory_content_journey__c                          AS pathfactory_content_journey,
        pathfactory_topic_list__c                               AS pathfactory_topic_list,

        --gitlab internal
        bdr_lu__c                                               AS business_development_look_up,
        business_development_rep_contact__c                     AS business_development_representative_contact,
        business_development_representative__c                  AS business_development_representative,
        sdr_lu__c                                               AS sales_development_representative,
        competition__c                                          AS competition,

        --metadata
        createdbyid                                             AS created_by_id,
        createddate                                             AS created_date,
        isdeleted                                               AS is_deleted,
        lastactivitydate::DATE                                  AS last_activity_date,
        lastmodifiedbyid                                        AS last_modified_id,
        lastmodifieddate                                        AS last_modified_date,
        systemmodstamp

    FROM source

)

SELECT *
FROM renamed
