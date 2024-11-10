WITH demographic_not_null AS (
    SELECT * FROM `rbac-2024-shbfinance.credit_risk_mart.cleaned_demographic`
    WHERE contract_no != 'unknown'
    AND customer_income IS NOT NULL
    AND customer_income > 1000000
), loan_origin_not_null AS (
    SELECT * FROM `rbac-2024-shbfinance.credit_risk_mart.cleaned_loan_origin`
    WHERE contract_no != 'unknown' 
    AND loan_amount IS NOT NULL
    AND loan_term IS NOT NULL
    AND month_interest IS NOT NULL
), loan_month_aggr AS (
    SELECT 
        lo.contract_no
        , lo.business_line
        , lo.loan_purpose
        , lo.loan_purpose_description
        , lo.product_category
        , lo.loan_term
        , lo.month_interest
        , lo.loan_amount
        , lo.disbursement_channel
        , lo.disbursement_date
        , lo.liquidity
        , lo.liquidity_description
        , lo.insurance_rate
        , lo.rate
        , lo.has_insurance
        , de.date_of_birth
        , de.marital_status
        , de.education
        , de.job
        , de.industry
        , de.labour_contract_type
        , de.company_address_province
        , de.permanent_address_province
        , de.working_in_year
        , de.number_of_dependants
        , de.customer_income
        , de.income_resource
        , de.accommodation_type
        , de.weight
        , de.height
        , de.creditibility
        , de.creditibility_description
        , (2024 - de.date_of_birth) AS customer_age
        , (lo.loan_amount / lo.loan_term) AS month_loan_amount
        , (lo.loan_amount * lo.month_interest / 100) AS month_loan_interest
        , CASE
            WHEN lo.insurance_rate IS NOT NULL THEN
                (lo.loan_amount * lo.insurance_rate / 100) / lo.loan_term
            ELSE 0
        END AS month_insurance_cost

    FROM loan_origin_not_null AS lo
    LEFT JOIN demographic_not_null AS de ON lo.contract_no = de.contract_no
)

SELECT aggr.contract_no
    , (aggr.month_loan_amount + month_loan_interest) AS month_loan_payment
    , ((aggr.month_loan_amount + month_loan_interest + aggr.month_insurance_cost) / aggr.customer_income) * 100 AS dti_ratio
    , aggr.customer_income / (aggr.number_of_dependants + 1) AS income_stability_index
    , aggr.loan_purpose_description
    , aggr.liquidity_description
    , aggr.creditibility_description
    , aggr.customer_income
    , aggr.customer_age
    , aggr.month_insurance_cost
    , aggr.month_loan_amount
    , aggr.month_loan_interest
    , aggr.loan_amount as total_loan_amount
    , aggr.loan_term
    , aggr.month_interest
    , aggr.loan_purpose
    , aggr.liquidity
    , aggr.creditibility
    , CASE WHEN aggr.disbursement_date IS NOT NULL THEN EXTRACT(YEAR FROM aggr.disbursement_date) ELSE NULL END AS disbursement_year
    , CASE WHEN aggr.disbursement_date != '3000-01-01' THEN 1 ELSE 0 END AS is_disbursed
    , aggr.disbursement_date
    , aggr.disbursement_channel
    , aggr.has_insurance
    , aggr.rate AS loan_rate
    , aggr.product_category
    , aggr.business_line
    , aggr.labour_contract_type
    , aggr.working_in_year
    , aggr.number_of_dependants
    , aggr.marital_status
    , aggr.income_resource
    , aggr.accommodation_type
    , aggr.job
    , aggr.industry
    , aggr.education
    , aggr.height
    , aggr.weight
    , aggr.company_address_province
    , aggr.permanent_address_province

FROM loan_month_aggr AS aggr
ORDER BY dti_ratio DESC