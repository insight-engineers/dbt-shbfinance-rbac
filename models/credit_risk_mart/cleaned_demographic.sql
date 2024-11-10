WITH transform_data_type AS (
     SELECT CAST(CONTRACT_NO AS STRING) AS contract_no
          , CAST(DATE_OF_BIRTH AS INT64) AS date_of_birth
          , CAST(MARITAL_STATUS AS STRING) AS marital_status
          , CAST(EDUCATION AS STRING) AS education
          , CAST(JOB AS STRING) AS job
          , CAST(INDUSTRY AS STRING) AS industry
          , CAST(LABOUR_CONTRACT_TYPE AS STRING) AS labour_contract_type
          , CAST(COMPANY_ADDRESS_PROVINCE AS STRING) AS company_address_province
          , CAST(PERMANENT_ADDRESS_PROVINCE AS STRING) AS permanent_address_province
          , CAST(WORKING_IN_YEAR AS INT64) AS working_in_year
          , CAST(NUMBER_OF_DEPENDANTS AS INT64) AS number_of_dependants
          , CAST(CUSTOMER_INCOME AS FLOAT64) AS customer_income
          , CAST(INCOME_RESOURCE AS STRING) AS income_resource
          , CAST(ACCOMMODATION_TYPE AS STRING) AS accommodation_type
          , CAST(WEIGHT AS FLOAT64) AS weight
          , CAST(HEIGHT AS FLOAT64) AS height
          , CAST(creditibility AS STRING) AS creditibility
     FROM `rbac-2024-shbfinance.credit_risk_raw.demographic`
), transform_null_value AS (
     SELECT
          CASE WHEN contract_no IS NULL THEN 'unknown' ELSE contract_no END AS contract_no
          , CASE WHEN date_of_birth IS NULL THEN NULL ELSE date_of_birth END AS date_of_birth
          , CASE WHEN marital_status IS NULL THEN '-1' ELSE marital_status END AS marital_status
          , CASE WHEN education IS NULL THEN '-1' ELSE education END AS education
          , CASE WHEN job IS NULL THEN '-1' ELSE job END AS job
          , CASE WHEN industry IS NULL THEN '-1' ELSE industry END AS industry
          , CASE WHEN labour_contract_type IS NULL THEN '-1' ELSE labour_contract_type END AS labour_contract_type
          , CASE WHEN company_address_province IS NULL THEN '-1' ELSE company_address_province END AS company_address_province
          , CASE WHEN permanent_address_province IS NULL THEN '-1' ELSE permanent_address_province END AS permanent_address_province
          , CASE WHEN working_in_year IS NULL THEN NULL ELSE working_in_year END AS working_in_year
          , CASE WHEN number_of_dependants IS NULL THEN NULL ELSE number_of_dependants END AS number_of_dependants
          , CASE WHEN customer_income IS NULL THEN NULL ELSE customer_income END AS customer_income
          , CASE WHEN income_resource IS NULL THEN '-1' ELSE income_resource END AS income_resource
          , CASE WHEN accommodation_type IS NULL THEN '-1' ELSE accommodation_type END AS accommodation_type
          , CASE WHEN weight IS NULL THEN NULL ELSE weight END AS weight
          , CASE WHEN height IS NULL THEN NULL ELSE height END AS height
          , CASE WHEN creditibility IS NULL THEN '-1' ELSE creditibility END AS creditibility
          , CASE 
               WHEN creditibility = '-1' THEN 'NULL'
               WHEN creditibility = '1' THEN 'POOR'
               WHEN creditibility = '2' THEN 'BAD'
               WHEN creditibility = '3' THEN 'AVERAGE'
               WHEN creditibility = '4' THEN 'GOOD'
               WHEN creditibility = '5' THEN 'EXCELLENT'
               ELSE 'UNKNOWN'
          END AS creditibility_description
     FROM transform_data_type
)

SELECT
     contract_no
     , date_of_birth
     , marital_status
     , education
     , job
     , industry
     , labour_contract_type
     , company_address_province
     , permanent_address_province
     , working_in_year
     , number_of_dependants
     , customer_income
     , income_resource
     , accommodation_type
     , weight
     , height
     , creditibility
     , creditibility_description
FROM transform_null_value