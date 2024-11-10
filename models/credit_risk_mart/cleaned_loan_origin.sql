WITH transform_data_type AS (
     SELECT CAST(CONTRACT_NO AS STRING) AS contract_no
          , CAST(BUSINESS_LINE AS STRING) AS business_line
          , CAST(LOAN_PURPOSE AS STRING) AS loan_purpose
          , CAST(PRODUCT_CATEGORY AS STRING) AS product_category
          , CAST(LOAN_TERM AS INT64) AS loan_term
          , CAST(MONTH_INTEREST AS FLOAT64) AS month_interest
          , CAST(LOAN_AMOUNT AS FLOAT64) AS loan_amount
          , CAST(DISBURSEMENT_CHANNEL AS STRING) AS disbursement_channel
          , CAST(DISBURSEMENT_DATE AS STRING) AS disbursement_date
          , CAST(LIQUIDITY AS INT64) AS liquidity
          , CAST(INSURANCE_RATE AS FLOAT64) AS insurance_rate
          , CAST(RATE AS FLOAT64) AS rate
          , CAST(HAS_INSURANCE AS STRING) AS has_insurance
     FROM `rbac-2024-shbfinance.credit_risk_raw.loan_origin`
), transform_null_value AS (
     SELECT
          CASE WHEN contract_no IS NULL THEN 'unknown' ELSE contract_no END AS contract_no
          , CASE WHEN business_line IS NULL THEN '-1' ELSE business_line END AS business_line
          , CASE WHEN loan_purpose IS NULL THEN '7' ELSE loan_purpose END AS loan_purpose
          , CASE WHEN product_category IS NULL THEN '-1' ELSE product_category END AS product_category
          , CASE WHEN loan_term IS NULL THEN NULL ELSE loan_term END AS loan_term
          , CASE WHEN month_interest IS NULL THEN NULL ELSE month_interest END AS month_interest
          , CASE WHEN loan_amount IS NULL THEN NULL ELSE loan_amount END AS loan_amount
          , CASE WHEN disbursement_channel IS NULL THEN '-1' ELSE disbursement_channel END AS disbursement_channel
          , CASE WHEN disbursement_date IS NULL THEN '3000-01' ELSE disbursement_date END AS disbursement_date
          , CASE WHEN liquidity IS NULL THEN NULL ELSE liquidity END AS liquidity
          , CASE WHEN insurance_rate IS NULL THEN NULL ELSE insurance_rate END AS insurance_rate
          , CASE WHEN rate IS NULL THEN NULL ELSE rate END AS rate
          , CASE WHEN has_insurance IS NULL THEN 'unknown' ELSE has_insurance END AS has_insurance
     FROM transform_data_type
)

SELECT
     contract_no
     , business_line
     , loan_purpose
     , CASE 
          WHEN loan_purpose = '0' THEN 'HEALTHCARE'
          WHEN loan_purpose = '1' THEN 'ACCOMODATION'
          WHEN loan_purpose = '2' THEN 'EDUCATION'
          WHEN loan_purpose = '3' THEN 'SHOPPING'
          WHEN loan_purpose = '4' THEN 'BILLS'
          WHEN loan_purpose = '5' THEN 'TRAVEL'
          WHEN loan_purpose = '6' THEN 'VEHICLE'
          ELSE 'NULL'
     END AS loan_purpose_description
     , product_category
     , loan_term
     , month_interest
     , loan_amount
     , disbursement_channel
     , PARSE_DATE('%Y-%m-%d', CONCAT(disbursement_date, '-01')) AS disbursement_date
     , liquidity
     , CASE 
          WHEN liquidity = 1 THEN 'POOR'
          WHEN liquidity = 2 THEN 'BAD'
          WHEN liquidity = 3 THEN 'AVERAGE'
          WHEN liquidity = 4 THEN 'GOOD'
          WHEN liquidity = 5 THEN 'EXCELLENT'
          ELSE 'UNKNOWN'
     END AS liquidity_description
     , insurance_rate
     , rate
     , has_insurance
FROM transform_null_value