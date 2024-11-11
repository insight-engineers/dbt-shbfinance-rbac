WITH transform_data_type AS (
    -- Step 1: Transform data types
    SELECT 
        CAST(CONTRACT_NO AS STRING) AS contract_no,
        CAST(BUSINESS_LINE AS STRING) AS business_line,
        CAST(LOAN_PURPOSE AS STRING) AS loan_purpose,
        CAST(PRODUCT_CATEGORY AS STRING) AS product_category,
        CAST(LOAN_TERM AS INT64) AS loan_term,
        CAST(MONTH_INTEREST AS FLOAT64) AS month_interest,
        CAST(LOAN_AMOUNT AS FLOAT64) AS loan_amount,
        CAST(DISBURSEMENT_CHANNEL AS STRING) AS disbursement_channel,
        CAST(DISBURSEMENT_DATE AS STRING) AS disbursement_date,
        CAST(LIQUIDITY AS INT64) AS liquidity,
        CAST(INSURANCE_RATE AS FLOAT64) AS insurance_rate,
        CAST(RATE AS FLOAT64) AS rate,
        CAST(HAS_INSURANCE AS STRING) AS has_insurance
    FROM `rbac-2024-shbfinance.credit_risk_raw.loan_origin`
),

transform_null_value AS (
    -- Step 2: Handle null values using COALESCE
    SELECT 
        COALESCE(contract_no, 'unknown') AS contract_no,
        COALESCE(business_line, '-1') AS business_line,
        COALESCE(loan_purpose, '7') AS loan_purpose,
        COALESCE(product_category, '-1') AS product_category,
        COALESCE(loan_term, NULL) AS loan_term,
        COALESCE(month_interest, NULL) AS month_interest,
        COALESCE(loan_amount, NULL) AS loan_amount,
        COALESCE(disbursement_channel, '-1') AS disbursement_channel,
        COALESCE(disbursement_date, '3000-01') AS disbursement_date,
        COALESCE(liquidity, NULL) AS liquidity,
        COALESCE(insurance_rate, NULL) AS insurance_rate,
        COALESCE(rate, NULL) AS rate,
        COALESCE(has_insurance, 'unknown') AS has_insurance
    FROM transform_data_type
)

-- Step 3: Final output with derived fields
SELECT 
    contract_no,
    business_line,
    loan_purpose,
    
    -- Deriving loan_purpose_description based on loan_purpose value
    CASE 
        WHEN loan_purpose = '0' THEN 'HEALTHCARE'
        WHEN loan_purpose = '1' THEN 'ACCOMMODATION'
        WHEN loan_purpose = '2' THEN 'EDUCATION'
        WHEN loan_purpose = '3' THEN 'SHOPPING'
        WHEN loan_purpose = '4' THEN 'BILLS'
        WHEN loan_purpose = '5' THEN 'TRAVEL'
        WHEN loan_purpose = '6' THEN 'VEHICLE'
        ELSE 'NULL'
    END AS loan_purpose_description,
    
    product_category,
    loan_term,
    month_interest,
    loan_amount,
    disbursement_channel,
    
    -- Parsing disbursement_date to DATE format
    PARSE_DATE('%Y-%m-%d', CONCAT(disbursement_date, '-01')) AS disbursement_date,
    
    liquidity,
    
    -- Deriving liquidity_description based on liquidity value
    CASE 
        WHEN liquidity = 1 THEN 'POOR'
        WHEN liquidity = 2 THEN 'BAD'
        WHEN liquidity = 3 THEN 'AVERAGE'
        WHEN liquidity = 4 THEN 'GOOD'
        WHEN liquidity = 5 THEN 'EXCELLENT'
        ELSE 'UNKNOWN'
    END AS liquidity_description,
    
    insurance_rate,
    rate,
    has_insurance

FROM transform_null_value;
