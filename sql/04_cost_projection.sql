-- ============================================================
-- Query 4: Excess Cost Projection vs England Average
-- Cost assumption: £2,800 per emergency readmission
-- Source: NHS National Schedule of Reference Costs 2023/24
-- Author: Gunasundar Ram
-- ============================================================

WITH baseline AS (
    SELECT
        AVG(CAST(REPLACE(indicator_value, ',', '') AS NUMERIC)) AS england_avg_rate
    FROM readmissions_provider
    WHERE breakdown = 'England'
      AND TRIM(year) = '2024/25'
      AND TRIM(age_breakdown) = 'All'
      AND TRIM(sex_breakdown) = 'Persons'
      AND TRIM(method) = 'Snapshot'
      AND indicator_value ~ '^[0-9,\.]+$'
),
trust_data AS (
    SELECT
        level_description                                            AS trust_name,
        level                                                        AS trust_code,
        CAST(REPLACE(indicator_value, ',', '') AS NUMERIC)          AS readmission_rate,
        CAST(REPLACE(numerator, ',', '') AS NUMERIC)                AS readmissions,
        CAST(REPLACE(denominator, ',', '') AS NUMERIC)              AS discharges
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
    t.trust_name,
    t.trust_code,
    ROUND(t.readmission_rate, 2)                                              AS actual_rate_pct,
    ROUND(b.england_avg_rate, 2)                                              AS england_avg_pct,
    ROUND(t.readmission_rate - b.england_avg_rate, 2)                         AS excess_rate_pct,
    ROUND(t.discharges * (t.readmission_rate - b.england_avg_rate) / 100, 0)  AS excess_readmissions,
    ROUND(t.discharges * (t.readmission_rate - b.england_avg_rate) / 100
          * 2800, 0)                                                           AS estimated_excess_cost_gbp
FROM trust_data t
CROSS JOIN baseline b
WHERE t.readmission_rate > b.england_avg_rate
ORDER BY estimated_excess_cost_gbp DESC
LIMIT 10;