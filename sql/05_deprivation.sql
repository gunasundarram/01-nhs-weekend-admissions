-- ============================================================
-- Query 5: Readmission Rate by Deprivation Quintile
-- Period: 2024/25 | Health Inequality Analysis
-- Author: Gunasundar Ram
-- ============================================================

WITH clean_data AS (
    SELECT
        TRIM(year)         AS year,
        level_description  AS deprivation_quintile,
        indicator_value,
        numerator,
        denominator
    FROM readmissions_provider
    WHERE breakdown = 'Deprivation quintile'
      AND TRIM(year) = '2024/25'
      AND TRIM(age_breakdown) = 'All'
      AND TRIM(sex_breakdown) = 'Persons'
      AND TRIM(method) = 'Snapshot'
      AND indicator_value ~ '^[0-9,\.]+$'
      AND numerator ~ '^[0-9,\.]+$'
      AND denominator ~ '^[0-9,\.]+$'
)
SELECT
    deprivation_quintile,
    ROUND(CAST(REPLACE(indicator_value, ',', '') AS NUMERIC), 2) AS readmission_rate,
    ROUND(CAST(REPLACE(numerator, ',', '') AS NUMERIC), 0)       AS readmissions,
    ROUND(CAST(REPLACE(denominator, ',', '') AS NUMERIC), 0)     AS discharges
FROM clean_data
ORDER BY deprivation_quintile;