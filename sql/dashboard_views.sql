-- ============================================================
-- Credit Risk Analysis
-- Dashboard Views
-- ============================================================
-- Creates reusable analytics views from the cleaned
-- credit risk staging table for dashboard reporting.
-- ============================================================

CREATE SCHEMA analytics;

GO

-- ============================================================
-- 1. Portfolio Overview
-- ============================================================

CREATE VIEW analytics.vw_PortfolioOverview AS

SELECT
    COUNT(*) AS TotalLoans,
    SUM(loan_amount) AS TotalLoanExposure,
    CAST(AVG(loan_amount) AS DECIMAL(15,2)) AS AverageLoanAmount,
    COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) AS DefaultedLoans,
    CAST(
        COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS DefaultRatePercent,
    CAST(AVG(interest_rate) AS DECIMAL(5,2)) AS AverageInterestRate,
    CAST(AVG(default_probability) AS DECIMAL(8,6)) AS AverageDefaultProbability
FROM staging.CreditRiskClean;

GO

-- ============================================================
-- 2. Risk Category Performance
-- ============================================================

CREATE VIEW analytics.vw_RiskCategoryPerformance AS

SELECT
    risk_category,
    COUNT(*) AS TotalLoans,
    COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) AS DefaultedLoans,
    CAST(
        COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS DefaultRatePercent,
    CAST(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER ()
        AS DECIMAL(5,2)
    ) AS PortfolioSharePercent
FROM staging.CreditRiskClean
GROUP BY risk_category;

GO

-- ============================================================
-- 3. Borrower Risk Profile
-- ============================================================

CREATE VIEW analytics.vw_BorrowerRiskProfile AS

-- Credit Score
SELECT
    'Credit Score' AS RiskFactor,
    CASE
        WHEN credit_score < 580 THEN 'Poor'
        WHEN credit_score < 670 THEN 'Fair'
        WHEN credit_score < 740 THEN 'Good'
        ELSE 'Very Good'
    END AS RiskBand,
    COUNT(*) AS TotalLoans,
    COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) AS DefaultedLoans,
    CAST(
        COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS DefaultRatePercent
FROM staging.CreditRiskClean
GROUP BY
    CASE
        WHEN credit_score < 580 THEN 'Poor'
        WHEN credit_score < 670 THEN 'Fair'
        WHEN credit_score < 740 THEN 'Good'
        ELSE 'Very Good'
    END

UNION ALL

-- Debt-to-Income Ratio
SELECT
    'Debt-to-Income' AS RiskFactor,
    CASE
        WHEN debt_to_income_ratio < 20 THEN 'Low DTI'
        WHEN debt_to_income_ratio < 40 THEN 'Moderate DTI'
        WHEN debt_to_income_ratio < 60 THEN 'High DTI'
        ELSE 'Very High DTI'
    END AS RiskBand,
    COUNT(*) AS TotalLoans,
    COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) AS DefaultedLoans,
    CAST(
        COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS DefaultRatePercent
FROM staging.CreditRiskClean
GROUP BY
    CASE
        WHEN debt_to_income_ratio < 20 THEN 'Low DTI'
        WHEN debt_to_income_ratio < 40 THEN 'Moderate DTI'
        WHEN debt_to_income_ratio < 60 THEN 'High DTI'
        ELSE 'Very High DTI'
    END

UNION ALL

-- Employment Length
SELECT
    'Employment Length' AS RiskFactor,
    CASE
        WHEN employment_length_years < 2 THEN 'Less than 2 years'
        WHEN employment_length_years < 5 THEN '2 - 5 years'
        WHEN employment_length_years < 10 THEN '5 - 10 years'
        ELSE '10+ years'
    END AS RiskBand,
    COUNT(*) AS TotalLoans,
    COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) AS DefaultedLoans,
    CAST(
        COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS DefaultRatePercent
FROM staging.CreditRiskClean
GROUP BY
    CASE
        WHEN employment_length_years < 2 THEN 'Less than 2 years'
        WHEN employment_length_years < 5 THEN '2 - 5 years'
        WHEN employment_length_years < 10 THEN '5 - 10 years'
        ELSE '10+ years'
    END;

GO

-- ============================================================
-- 4. Loan Characteristics
-- ============================================================

CREATE VIEW analytics.vw_LoanCharacteristics AS

-- Loan Purpose
SELECT
    'Loan Purpose' AS Characteristic,
    loan_purpose AS Category,
    COUNT(*) AS TotalLoans,
    COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) AS DefaultedLoans,
    CAST(
        COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS DefaultRatePercent
FROM staging.CreditRiskClean
GROUP BY loan_purpose

UNION ALL

-- Loan Amount
SELECT
    'Loan Amount' AS Characteristic,
    CASE
        WHEN loan_amount < 10000 THEN 'Below 10K'
        WHEN loan_amount < 25000 THEN '10K - 25K'
        WHEN loan_amount < 50000 THEN '25K - 50K'
        ELSE '50K+'
    END AS Category,
    COUNT(*) AS TotalLoans,
    COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) AS DefaultedLoans,
    CAST(
        COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS DefaultRatePercent
FROM staging.CreditRiskClean
GROUP BY
    CASE
        WHEN loan_amount < 10000 THEN 'Below 10K'
        WHEN loan_amount < 25000 THEN '10K - 25K'
        WHEN loan_amount < 50000 THEN '25K - 50K'
        ELSE '50K+'
    END

UNION ALL

-- Interest Rate
SELECT
    'Interest Rate' AS Characteristic,
    CASE
        WHEN interest_rate < 7 THEN 'Below 7%'
        WHEN interest_rate < 10 THEN '7% - 10%'
        WHEN interest_rate < 15 THEN '10% - 15%'
        ELSE '15%+'
    END AS Category,
    COUNT(*) AS TotalLoans,
    COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) AS DefaultedLoans,
    CAST(
        COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS DefaultRatePercent
FROM staging.CreditRiskClean
GROUP BY
    CASE
        WHEN interest_rate < 7 THEN 'Below 7%'
        WHEN interest_rate < 10 THEN '7% - 10%'
        WHEN interest_rate < 15 THEN '10% - 15%'
        ELSE '15%+'
    END

UNION ALL

-- Annual Income
SELECT
    'Annual Income' AS Characteristic,
    CASE
        WHEN annual_income < 30000 THEN 'Below 30K'
        WHEN annual_income < 60000 THEN '30K - 60K'
        WHEN annual_income < 100000 THEN '60K - 100K'
        ELSE '100K+'
    END AS Category,
    COUNT(*) AS TotalLoans,
    COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) AS DefaultedLoans,
    CAST(
        COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS DefaultRatePercent
FROM staging.CreditRiskClean
GROUP BY
    CASE
        WHEN annual_income < 30000 THEN 'Below 30K'
        WHEN annual_income < 60000 THEN '30K - 60K'
        WHEN annual_income < 100000 THEN '60K - 100K'
        ELSE '100K+'
    END;

GO

-- ============================================================
-- 5. Risk Exposure
-- ============================================================

CREATE VIEW analytics.vw_RiskExposure AS

SELECT
    risk_category,
    COUNT(*) AS TotalLoans,
    SUM(loan_amount) AS TotalExposure,
    SUM(
        CASE
            WHEN loan_status = 'Default' THEN loan_amount
            ELSE 0
        END
    ) AS DefaultedExposure,
    CAST(
        SUM(
            CASE
                WHEN loan_status = 'Default' THEN loan_amount
                ELSE 0
            END
        ) * 100.0
        / SUM(loan_amount)
        AS DECIMAL(5,2)
    ) AS DefaultedExposurePercent
FROM staging.CreditRiskClean
GROUP BY risk_category;

GO