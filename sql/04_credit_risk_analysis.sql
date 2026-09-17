-- ============================================================
-- 1. Portfolio Overview
-- ============================================================

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

-- ============================================================
-- 2. Risk Category Performance
-- ============================================================

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
GROUP BY risk_category
ORDER BY DefaultRatePercent DESC;

-- ============================================================
-- 3. Borrower Risk Factors
-- ============================================================

-- Default rate by credit score band
SELECT
    CASE
        WHEN credit_score < 580 THEN 'Poor'
        WHEN credit_score < 670 THEN 'Fair'
        WHEN credit_score < 740 THEN 'Good'
        ELSE 'Very Good'
    END AS CreditScoreBand,
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
ORDER BY DefaultRatePercent DESC;

-- Default rate by previous defaults
SELECT
    previous_defaults,
    COUNT(*) AS TotalLoans,
    COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) AS DefaultedLoans,
    CAST(
        COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS DefaultRatePercent
FROM staging.CreditRiskClean
GROUP BY previous_defaults
ORDER BY previous_defaults;

-- Default rate by debt-to-income ratio band
SELECT
    CASE
        WHEN debt_to_income_ratio < 20 THEN 'Low DTI'
        WHEN debt_to_income_ratio < 40 THEN 'Moderate DTI'
        WHEN debt_to_income_ratio < 60 THEN 'High DTI'
        ELSE 'Very High DTI'
    END AS DTIBand,
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
ORDER BY DefaultRatePercent DESC;

-- ============================================================
-- 4. Loan Characteristics
-- ============================================================

-- Default rate by loan purpose
SELECT
    loan_purpose,
    COUNT(*) AS TotalLoans,
    COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) AS DefaultedLoans,
    CAST(
        COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS DefaultRatePercent
FROM staging.CreditRiskClean
GROUP BY loan_purpose
ORDER BY DefaultRatePercent DESC;

-- Default rate by loan amount band
SELECT
    CASE
        WHEN loan_amount < 10000 THEN 'Below 10K'
        WHEN loan_amount < 25000 THEN '10K - 25K'
        WHEN loan_amount < 50000 THEN '25K - 50K'
        ELSE '50K+'
    END AS LoanAmountBand,
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
ORDER BY DefaultRatePercent DESC;

-- Default rate by interest rate band
SELECT
    CASE
        WHEN interest_rate < 7 THEN 'Below 7%'
        WHEN interest_rate < 10 THEN '7% - 10%'
        WHEN interest_rate < 15 THEN '10% - 15%'
        ELSE '15%+'
    END AS InterestRateBand,
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
ORDER BY DefaultRatePercent DESC;

-- Default rate by annual income band
SELECT
    CASE
        WHEN annual_income < 30000 THEN 'Below 30K'
        WHEN annual_income < 60000 THEN '30K - 60K'
        WHEN annual_income < 100000 THEN '60K - 100K'
        ELSE '100K+'
    END AS IncomeBand,
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
    END
ORDER BY DefaultRatePercent DESC;

-- ============================================================
-- 5. Additional Borrower Behaviour
-- ============================================================

-- Default rate by recent delinquencies
SELECT
    delinquency_2yrs,
    COUNT(*) AS TotalLoans,
    COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) AS DefaultedLoans,
    CAST(
        COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS DefaultRatePercent
FROM staging.CreditRiskClean
GROUP BY delinquency_2yrs
ORDER BY delinquency_2yrs;

-- Default rate by number of credit inquiries
SELECT
    number_of_credit_inquiries,
    COUNT(*) AS TotalLoans,
    COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) AS DefaultedLoans,
    CAST(
        COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS DefaultRatePercent
FROM staging.CreditRiskClean
GROUP BY number_of_credit_inquiries
ORDER BY number_of_credit_inquiries;

-- Default rate by employment length
SELECT
    CASE
        WHEN employment_length_years < 2 THEN 'Less than 2 years'
        WHEN employment_length_years < 5 THEN '2 - 5 years'
        WHEN employment_length_years < 10 THEN '5 - 10 years'
        ELSE '10+ years'
    END AS EmploymentLengthBand,
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
    END
ORDER BY DefaultRatePercent DESC;

-- ============================================================
-- 6. Combined Risk Segmentation
-- ============================================================

SELECT
    CASE
        WHEN credit_score < 670
             AND debt_to_income_ratio >= 40
             AND employment_length_years < 5
            THEN 'Higher Risk Segment'
        ELSE 'Other Borrowers'
    END AS RiskSegment,
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
        WHEN credit_score < 670
             AND debt_to_income_ratio >= 40
             AND employment_length_years < 5
            THEN 'Higher Risk Segment'
        ELSE 'Other Borrowers'
    END
ORDER BY DefaultRatePercent DESC;

-- ============================================================
-- 7. Predicted Risk vs. Observed Default
-- ============================================================

SELECT
    risk_category,
    COUNT(*) AS TotalLoans,
    COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) AS DefaultedLoans,
    CAST(
        COUNT(CASE WHEN loan_status = 'Default' THEN 1 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ObservedDefaultRate,
    CAST(
        AVG(default_probability) * 100
        AS DECIMAL(5,2)
    ) AS AveragePredictedProbability
FROM staging.CreditRiskClean
GROUP BY risk_category
ORDER BY AveragePredictedProbability DESC;

-- ============================================================
-- 8. Loan Exposure by Risk Category
-- ============================================================

SELECT
    risk_category,
    COUNT(*) AS TotalLoans,
    SUM(loan_amount) AS TotalExposure,
    SUM(CASE
        WHEN loan_status = 'Default' THEN loan_amount
        ELSE 0
    END) AS DefaultedExposure,
    CAST(
        SUM(CASE
            WHEN loan_status = 'Default' THEN loan_amount
            ELSE 0
        END) * 100.0
        / SUM(loan_amount)
        AS DECIMAL(5,2)
    ) AS DefaultedExposurePercent
FROM staging.CreditRiskClean
GROUP BY risk_category
ORDER BY DefaultedExposurePercent DESC;