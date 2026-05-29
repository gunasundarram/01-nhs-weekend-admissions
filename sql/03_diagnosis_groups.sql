-- ============================================================
-- Query 3: Readmissions by Diagnosis Group — England Level
-- Period: 2023/24 | All Persons
-- Author: Gunasundar Ram
-- ============================================================

WITH clean_data AS (
    SELECT
        TRIM(year)          AS year,
        level_description   AS geography,
        diagnosis,
        indicator_value,
        numerator,
        denominator
    FROM readmissions_diagnosis
    WHERE breakdown = 'England'
      AND TRIM(year) = '2023/24'
      AND TRIM(sex_breakdown) = 'Persons'
      AND indicator_value ~ '^[0-9,\.]+$'
      AND numerator ~ '^[0-9,\.]+$'
      AND denominator ~ '^[0-9,\.]+$'
)
SELECT
    diagnosis,
    ROUND(CAST(REPLACE(indicator_value, ',', '') AS NUMERIC), 2) AS readmission_rate,
    ROUND(CAST(REPLACE(numerator, ',', '') AS NUMERIC), 0)       AS readmissions,
    ROUND(CAST(REPLACE(denominator, ',', '') AS NUMERIC), 0)     AS discharges
FROM clean_data
ORDER BY CAST(REPLACE(numerator, ',', '') AS NUMERIC) DESC
LIMIT 15;