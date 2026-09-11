-- ============================================================
-- Credit Risk Analysis
-- Data Quality Checks
-- ============================================================

-- 1. Check total number of records
SELECT COUNT(*) AS TotalRows
FROM dbo.credit_risk_dataset;


-- 2. Check for missing values
SELECT
    COUNT(*) AS TotalRows,
    COUNT(customer_id) AS CustomerID_Count,
    COUNT(age) AS Age_Count,
    COUNT(annual_income) AS Income_Count,
    COUNT(credit_score) AS CreditScore_Count,
    COUNT(loan_amount) AS LoanAmount_Count,
    COUNT(application_date) AS ApplicationDate_Count,
    COUNT(loan_status) AS LoanStatus_Count,
    COUNT(default_probability) AS DefaultProbability_Count,
    COUNT(risk_category) AS RiskCategory_Count
FROM dbo.credit_risk_dataset;


-- 3. Check for duplicate customer IDs
SELECT
    customer_id,
    COUNT(*) AS RecordCount
FROM dbo.credit_risk_dataset
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 4. Check age range
SELECT
    MIN(age) AS MinimumAge,
    MAX(age) AS MaximumAge
FROM dbo.credit_risk_dataset;

-- 5. Check credit score range
SELECT
    MIN(credit_score) AS MinimumCreditScore,
    MAX(credit_score) AS MaximumCreditScore
FROM dbo.credit_risk_dataset;

-- 6. Inspect highest annual incomes
SELECT TOP 10
    customer_id,
    annual_income
FROM dbo.credit_risk_dataset
ORDER BY annual_income DESC;

-- 7. Check loan amount range
SELECT
    MIN(loan_amount) AS MinimumLoanAmount,
    MAX(loan_amount) AS MaximumLoanAmount
FROM dbo.credit_risk_dataset;

-- 8. Check interest rate range
SELECT
    MIN(interest_rate) AS MinimumInterestRate,
    MAX(interest_rate) AS MaximumInterestRate
FROM dbo.credit_risk_dataset;

-- 9. Check debt-to-income ratio range
SELECT
    MIN(debt_to_income_ratio) AS MinimumDTI,
    MAX(debt_to_income_ratio) AS MaximumDTI
FROM dbo.credit_risk_dataset;

-- 10. Check frequency of maximum DTI value
SELECT
    COUNT(*) AS RecordsAtMaxDTI
FROM dbo.credit_risk_dataset
WHERE debt_to_income_ratio = 65;

-- 11. Check gender categories
SELECT
    gender,
    COUNT(*) AS CustomerCount
FROM dbo.credit_risk_dataset
GROUP BY gender
ORDER BY CustomerCount DESC;

-- 12. Check marital status categories
SELECT
    marital_status,
    COUNT(*) AS CustomerCount
FROM dbo.credit_risk_dataset
GROUP BY marital_status
ORDER BY CustomerCount DESC;

-- 13. Check education level categories
SELECT
    education_level,
    COUNT(*) AS CustomerCount
FROM dbo.credit_risk_dataset
GROUP BY education_level
ORDER BY CustomerCount DESC;

-- 14. Check employment status categories
SELECT
    employment_status,
    COUNT(*) AS CustomerCount
FROM dbo.credit_risk_dataset
GROUP BY employment_status
ORDER BY CustomerCount DESC;

-- 15. Check remaining categorical variables
SELECT 'home_ownership' AS ColumnName, home_ownership AS Category, COUNT(*) AS RecordCount
FROM dbo.credit_risk_dataset
GROUP BY home_ownership

UNION ALL

SELECT 'loan_purpose', loan_purpose, COUNT(*)
FROM dbo.credit_risk_dataset
GROUP BY loan_purpose

UNION ALL

SELECT 'loan_status', loan_status, COUNT(*)
FROM dbo.credit_risk_dataset
GROUP BY loan_status

UNION ALL

SELECT 'risk_category', risk_category, COUNT(*)
FROM dbo.credit_risk_dataset
GROUP BY risk_category

ORDER BY ColumnName, RecordCount DESC;

-- 16. Check remaining numeric fields and application dates
SELECT
    MIN(employment_length_years) AS MinEmploymentLength,
    MAX(employment_length_years) AS MaxEmploymentLength,
    MIN(number_of_open_accounts) AS MinOpenAccounts,
    MAX(number_of_open_accounts) AS MaxOpenAccounts,
    MIN(number_of_credit_inquiries) AS MinCreditInquiries,
    MAX(number_of_credit_inquiries) AS MaxCreditInquiries,
    MIN(delinquency_2yrs) AS MinDelinquencies,
    MAX(delinquency_2yrs) AS MaxDelinquencies,
    MIN(previous_defaults) AS MinPreviousDefaults,
    MAX(previous_defaults) AS MaxPreviousDefaults,
    MIN(loan_term_months) AS MinLoanTerm,
    MAX(loan_term_months) AS MaxLoanTerm,
    MIN(default_probability) AS MinDefaultProbability,
    MAX(default_probability) AS MaxDefaultProbability,
    MIN(application_date) AS EarliestApplication,
    MAX(application_date) AS LatestApplication
FROM dbo.credit_risk_dataset;