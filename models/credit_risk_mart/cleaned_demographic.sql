WITH transform_data_type AS (
    -- Step 1: Transform data types
    SELECT 
        CAST(CONTRACT_NO AS STRING) AS contract_no,
        CAST(DATE_OF_BIRTH AS INT64) AS date_of_birth,
        CAST(MARITAL_STATUS AS STRING) AS marital_status,
        CAST(EDUCATION AS STRING) AS education,
        CAST(JOB AS STRING) AS job,
        CAST(INDUSTRY AS STRING) AS industry,
        CAST(LABOUR_CONTRACT_TYPE AS STRING) AS labour_contract_type,
        CAST(COMPANY_ADDRESS_PROVINCE AS STRING) AS company_address_province,
        CAST(PERMANENT_ADDRESS_PROVINCE AS STRING) AS permanent_address_province,
        CAST(WORKING_IN_YEAR AS INT64) AS working_in_year,
        CAST(NUMBER_OF_DEPENDANTS AS INT64) AS number_of_dependants,
        CAST(CUSTOMER_INCOME AS FLOAT64) AS customer_income,
        CAST(INCOME_RESOURCE AS STRING) AS income_resource,
        CAST(ACCOMMODATION_TYPE AS STRING) AS accommodation_type,
        CAST(WEIGHT AS FLOAT64) AS weight,
        CAST(HEIGHT AS FLOAT64) AS height,
        CAST(CREDITIBILITY AS STRING) AS creditibility
    FROM `rbac-2024-shbfinance.credit_risk_raw.demographic`
),

transform_null_value AS (
    -- Step 2: Handle null values using COALESCE
    SELECT 
        COALESCE(contract_no, 'unknown') AS contract_no,
        COALESCE(date_of_birth, NULL) AS date_of_birth,
        COALESCE(marital_status, '-1') AS marital_status,
        COALESCE(education, '-1') AS education,
        COALESCE(job, '-1') AS job,
        COALESCE(industry, '-1') AS industry,
        COALESCE(labour_contract_type, '-1') AS labour_contract_type,
        COALESCE(company_address_province, '-1') AS company_address_province,
        COALESCE(permanent_address_province, '-1') AS permanent_address_province,
        COALESCE(working_in_year, NULL) AS working_in_year,
        COALESCE(number_of_dependants, NULL) AS number_of_dependants,
        COALESCE(customer_income, NULL) AS customer_income,
        COALESCE(income_resource, '-1') AS income_resource,
        COALESCE(accommodation_type, '-1') AS accommodation_type,
        COALESCE(weight, NULL) AS weight,
        COALESCE(height, NULL) AS height,
        COALESCE(creditibility, '-1') AS creditibility,

        -- Step 3: Derive creditibility description based on the value of creditibility
        CASE 
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

-- Step 4: Final output
SELECT 
    contract_no,
    date_of_birth,
    marital_status,
    education,
    job,
    industry,
    labour_contract_type,
    company_address_province,
    permanent_address_province,
    working_in_year,
    number_of_dependants,
    customer_income,
    income_resource,
    accommodation_type,
    weight,
    height,
    creditibility,
    creditibility_description
FROM transform_null_value;
