-- ============================================================
-- Query 2: 10-Year Readmission Rate Trend — Top 3 Trusts
-- Trusts: RF4 (Barking), RFS (Chesterfield), RRE (Midlands)
-- Author: Gunasundar Ram
-- ============================================================

WITH clean_data AS (
    SELECT
        level_description  AS trust_name,
        level              AS trust_code,
        TRIM(year)         AS year,
        indicator_value,
        numerator,
        denominator
    FROM readmissions_provider
    WHERE breakdown = 'Provider'
      AND TRIM(age_breakdown) = 'All'
      AND TRIM(sex_breakdown) = 'Persons'
      AND TRIM(method) = 'Snapshot'
      AND level IN ('RRE', 'RFS', 'RF4')
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
    ROUND(CAST(REPLACE(denominator, ',', '') AS NUMERIC), 0)     AS discharges
FROM clean_data
ORDER BY trust_code, year;