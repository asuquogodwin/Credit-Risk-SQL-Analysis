-- ============================================================
-- Credit Risk Analysis
-- Data Cleaning & Staging
-- ============================================================

-- Create the staging schema
CREATE SCHEMA staging;
GO

-- Create the cleaned staging table
CREATE TABLE staging.CreditRiskClean (
    customer_id VARCHAR(20),
    age INT,
    gender VARCHAR(20),
    marital_status VARCHAR(30),
    education_level VARCHAR(50),
    employment_status VARCHAR(30),
    employment_length_years DECIMAL(5,2),
    home_ownership VARCHAR(30),
    annual_income DECIMAL(15,2),
    credit_score INT,
    number_of_open_accounts INT,
    number_of_credit_inquiries INT,
    delinquency_2yrs INT,
    previous_defaults INT,
    loan_purpose VARCHAR(50),
    loan_amount DECIMAL(15,2),
    loan_term_months INT,
    interest_rate DECIMAL(5,2),
    debt_to_income_ratio DECIMAL(5,2),
    application_date DATE,
    loan_status VARCHAR(30),
    default_probability DECIMAL(8,6),
    risk_category VARCHAR(30)
);
GO

INSERT INTO staging.CreditRiskClean (
    customer_id,
    age,
    gender,
    marital_status,
    education_level,
    employment_status,
    employment_length_years,
    home_ownership,
    annual_income,
    credit_score,
    number_of_open_accounts,
    number_of_credit_inquiries,
    delinquency_2yrs,
    previous_defaults,
    loan_purpose,
    loan_amount,
    loan_term_months,
    interest_rate,
    debt_to_income_ratio,
    application_date,
    loan_status,
    default_probability,
    risk_category
)
SELECT
    customer_id,
    age,
    gender,
    marital_status,
    education_level,
    employment_status,
    CAST(employment_length_years AS DECIMAL(5,2)),
    home_ownership,
    CAST(annual_income AS DECIMAL(15,2)),
    credit_score,
    number_of_open_accounts,
    number_of_credit_inquiries,
    delinquency_2yrs,
    previous_defaults,
    loan_purpose,
    CAST(loan_amount AS DECIMAL(15,2)),
    loan_term_months,
    CAST(interest_rate AS DECIMAL(5,2)),
    CAST(debt_to_income_ratio AS DECIMAL(5,2)),
    CAST(application_date AS DATE),
    loan_status,
    CAST(default_probability AS DECIMAL(8,6)),
    risk_category
FROM dbo.credit_risk_dataset;

-- Verify cleaned numeric precision
SELECT TOP 10
    customer_id,
    employment_length_years,
    annual_income,
    loan_amount,
    interest_rate,
    debt_to_income_ratio,
    default_probability
FROM staging.CreditRiskClean;

-- Validate the cleaned staging table
SELECT
    COUNT(*) AS TotalRows,
    COUNT(customer_id) AS CustomerID_Count,
    COUNT(application_date) AS ApplicationDate_Count,
    COUNT(loan_amount) AS LoanAmount_Count,
    COUNT(default_probability) AS DefaultProbability_Count
FROM staging.CreditRiskClean;