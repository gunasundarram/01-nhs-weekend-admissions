-- ============================================================
-- Query 1: Top 20 NHS Trusts by 30-Day Readmission Rate
-- Period: 2024/25 | Method: Snapshot | All Ages | All Persons
-- Author: Gunasundar Ram
-- ============================================================

WITH clean_data AS (
    SELECT
        level_description   AS trust_name,
        level               AS trust_code,
        TRIM(year)          AS year,
        indicator_value,
        numerator,
        denominator,
        banding
    FROM readmissions_provider
    WHERE breakdown = 'Provider'
      AND TRIM(year) = '2024/25'
      AND TRIM(age_breakdown) = 'All'
      AND TRIM(sex_breakdown) = 'Persons'
      AND TRIM(method) = 'Snapshot'
      AND indicator_value ~ '^[0-9,\.]+$'
      AND numerator ~ '^[0-9,\.]+$'
      AND denominator ~ '^[0-9,\.]+$'
)
SELECT
    trust_name,
    trust_code,
    year,
    ROUND(CAST(REPLACE(indicator_value, ',', '') AS NUMERIC), 2) AS readmission_rate,
    ROUND(CAST(REPLACE(numerator, ',', '') AS NUMERIC), 0)       AS readmissions,
    ROUND(CAST(REPLACE(denominator, ',', '') AS NUMERIC), 0)     AS discharges,
    banding
FROM clean_data
ORDER BY CAST(REPLACE(indicator_value, ',', '') AS NUMERIC) DESC
LIMIT 20;
