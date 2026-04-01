-- ============================================================================
-- 05_weather_sensitivity.sql
-- Statistical correlation between pollutants and weather variables
-- PostgreSQL 16
-- ============================================================================
--
-- Two approaches implemented:
--   1. Raw hourly correlations (weather_sensitivity)
--   2. Cleaned daily averages with percentile trimming (weather_sensitivity_cleaned)
--
-- Key PostgreSQL functions used:
--   CORR(x, y)       — Pearson correlation coefficient (-1 to +1)
--   REGR_SLOPE(y, x) — slope of least-squares regression line
--   PERCENT_RANK()    — percentile position for outlier trimming
--
-- Weather variables analyzed:
--   Temperature, Humidity, Wind Speed, Pressure, Cloud Cover, Solar Radiation
-- ============================================================================

-- ============================================================================
-- VERSION 1: Raw hourly correlations
-- ============================================================================
-- Direct CORR/REGR_SLOPE on hourly fact-to-fact joins.
-- Fast but potentially influenced by outliers and hourly noise.

DROP TABLE IF EXISTS weather_sensitivity;

CREATE TABLE weather_sensitivity AS

SELECT 
    p.pollutant_short AS pollutant,
    'Temperature' AS weather_var,
    CORR(w.temperature_2m_c, a.measured_value)::DECIMAL(5,3) AS correlation,
    REGR_SLOPE(a.measured_value, w.temperature_2m_c)::DECIMAL(10,4) AS slope,
    COUNT(w.temperature_2m_c) AS n_obs
FROM air_quality_fact a
JOIN city_weather_fact w 
    ON a.fk_date_id = w.fk_date_id
    AND a.fk_location_id = w.fk_location_id
    AND a.fk_time_id = w.fk_time_id
JOIN dim_pollutant p ON a.fk_pollutant_id = p.pk_pollutant_id
WHERE a.measured_value IS NOT NULL
GROUP BY p.pollutant_short

UNION ALL

SELECT p.pollutant_short, 'Humidity',
    CORR(w.relative_humidity_2m_pct, a.measured_value)::DECIMAL(5,3),
    REGR_SLOPE(a.measured_value, w.relative_humidity_2m_pct)::DECIMAL(10,4),
    COUNT(w.relative_humidity_2m_pct)
FROM air_quality_fact a
JOIN city_weather_fact w 
    ON a.fk_date_id = w.fk_date_id
    AND a.fk_location_id = w.fk_location_id
    AND a.fk_time_id = w.fk_time_id
JOIN dim_pollutant p ON a.fk_pollutant_id = p.pk_pollutant_id
WHERE a.measured_value IS NOT NULL
GROUP BY p.pollutant_short

UNION ALL

SELECT p.pollutant_short, 'Wind Speed',
    CORR(w.wind_speed_10m_kmh, a.measured_value)::DECIMAL(5,3),
    REGR_SLOPE(a.measured_value, w.wind_speed_10m_kmh)::DECIMAL(10,4),
    COUNT(w.wind_speed_10m_kmh)
FROM air_quality_fact a
JOIN city_weather_fact w 
    ON a.fk_date_id = w.fk_date_id
    AND a.fk_location_id = w.fk_location_id
    AND a.fk_time_id = w.fk_time_id
JOIN dim_pollutant p ON a.fk_pollutant_id = p.pk_pollutant_id
WHERE a.measured_value IS NOT NULL
GROUP BY p.pollutant_short

UNION ALL

SELECT p.pollutant_short, 'Pressure',
    CORR(w.pressure_msl_hpa, a.measured_value)::DECIMAL(5,3),
    REGR_SLOPE(a.measured_value, w.pressure_msl_hpa)::DECIMAL(10,4),
    COUNT(w.pressure_msl_hpa)
FROM air_quality_fact a
JOIN city_weather_fact w 
    ON a.fk_date_id = w.fk_date_id
    AND a.fk_location_id = w.fk_location_id
    AND a.fk_time_id = w.fk_time_id
JOIN dim_pollutant p ON a.fk_pollutant_id = p.pk_pollutant_id
WHERE a.measured_value IS NOT NULL
GROUP BY p.pollutant_short

UNION ALL

SELECT p.pollutant_short, 'Cloud Cover',
    CORR(w.cloud_cover_pct, a.measured_value)::DECIMAL(5,3),
    REGR_SLOPE(a.measured_value, w.cloud_cover_pct)::DECIMAL(10,4),
    COUNT(w.cloud_cover_pct)
FROM air_quality_fact a
JOIN city_weather_fact w 
    ON a.fk_date_id = w.fk_date_id
    AND a.fk_location_id = w.fk_location_id
    AND a.fk_time_id = w.fk_time_id
JOIN dim_pollutant p ON a.fk_pollutant_id = p.pk_pollutant_id
WHERE a.measured_value IS NOT NULL
GROUP BY p.pollutant_short

UNION ALL

SELECT p.pollutant_short, 'Radiation',
    CORR(w.shortwave_radiation_wm2, a.measured_value)::DECIMAL(5,3),
    REGR_SLOPE(a.measured_value, w.shortwave_radiation_wm2)::DECIMAL(10,4),
    COUNT(w.shortwave_radiation_wm2)
FROM air_quality_fact a
JOIN city_weather_fact w 
    ON a.fk_date_id = w.fk_date_id
    AND a.fk_location_id = w.fk_location_id
    AND a.fk_time_id = w.fk_time_id
JOIN dim_pollutant p ON a.fk_pollutant_id = p.pk_pollutant_id
WHERE a.measured_value IS NOT NULL
GROUP BY p.pollutant_short;

-- Add R-squared column
ALTER TABLE weather_sensitivity ADD COLUMN r_squared DECIMAL(10,6);
UPDATE weather_sensitivity SET r_squared = correlation * correlation;

-- ============================================================================
-- VERSION 2: Cleaned daily averages with outlier trimming
-- ============================================================================
-- Improvement over Version 1:
--   1. Aggregate to daily averages (reduces hourly noise)
--   2. Apply physical range filters (e.g., temp between -15°C and 35°C)
--   3. Trim 1st and 99th percentiles using PERCENT_RANK()
--
-- This produces more reliable correlations for the bubble chart visual.

DROP TABLE IF EXISTS weather_sensitivity_cleaned;

CREATE TABLE weather_sensitivity_cleaned AS

WITH daily_avg AS (
    SELECT 
        a.fk_date_id,
        a.fk_location_id,
        p.pollutant_short,
        AVG(a.measured_value) AS avg_pollution,
        AVG(w.temperature_2m_c) AS avg_temp,
        AVG(w.relative_humidity_2m_pct) AS avg_humid,
        AVG(w.wind_speed_10m_kmh) AS avg_wind,
        AVG(w.pressure_msl_hpa) AS avg_press,
        AVG(w.cloud_cover_pct) AS avg_cloud,
        AVG(w.shortwave_radiation_wm2) AS avg_rad
    FROM air_quality_fact a
    JOIN city_weather_fact w 
        ON a.fk_date_id = w.fk_date_id
        AND a.fk_location_id = w.fk_location_id
        AND a.fk_time_id = w.fk_time_id
    JOIN dim_pollutant p ON a.fk_pollutant_id = p.pk_pollutant_id
    WHERE a.measured_value IS NOT NULL
      AND a.measured_value > 0
      -- Physical range filters to remove sensor errors
      AND w.temperature_2m_c BETWEEN -15 AND 35
      AND w.pressure_msl_hpa BETWEEN 995 AND 1040
      AND w.wind_speed_10m_kmh BETWEEN 0 AND 35
      AND w.relative_humidity_2m_pct BETWEEN 0 AND 100
      AND w.cloud_cover_pct BETWEEN 0 AND 100
      AND w.shortwave_radiation_wm2 >= 0
      AND w.precipitation_mm BETWEEN 0 AND 15
    GROUP BY a.fk_date_id, a.fk_location_id, p.pollutant_short
),

-- Percentile trimming: remove extreme 1% on each side
with_percentiles AS (
    SELECT *,
        PERCENT_RANK() OVER(
            PARTITION BY pollutant_short 
            ORDER BY avg_pollution
        ) AS pct_rank
    FROM daily_avg
),

cleaned AS (
    SELECT * FROM with_percentiles
    WHERE pct_rank BETWEEN 0.01 AND 0.99
)

-- Compute cleaned correlations for each weather variable
SELECT pollutant_short AS pollutant, 'Temperature' AS weather_var,
    CORR(avg_temp, avg_pollution)::DECIMAL(5,3) AS correlation,
    REGR_SLOPE(avg_pollution, avg_temp)::DECIMAL(10,4) AS slope,
    COUNT(*) AS n_obs
FROM cleaned GROUP BY pollutant_short

UNION ALL

SELECT pollutant_short, 'Humidity',
    CORR(avg_humid, avg_pollution)::DECIMAL(5,3),
    REGR_SLOPE(avg_pollution, avg_humid)::DECIMAL(10,4),
    COUNT(*) FROM cleaned GROUP BY pollutant_short

UNION ALL

SELECT pollutant_short, 'Wind Speed',
    CORR(avg_wind, avg_pollution)::DECIMAL(5,3),
    REGR_SLOPE(avg_pollution, avg_wind)::DECIMAL(10,4),
    COUNT(*) FROM cleaned GROUP BY pollutant_short

UNION ALL

SELECT pollutant_short, 'Pressure',
    CORR(avg_press, avg_pollution)::DECIMAL(5,3),
    REGR_SLOPE(avg_pollution, avg_press)::DECIMAL(10,4),
    COUNT(*) FROM cleaned GROUP BY pollutant_short

UNION ALL

SELECT pollutant_short, 'Cloud Cover',
    CORR(avg_cloud, avg_pollution)::DECIMAL(5,3),
    REGR_SLOPE(avg_pollution, avg_cloud)::DECIMAL(10,4),
    COUNT(*) FROM cleaned GROUP BY pollutant_short

UNION ALL

SELECT pollutant_short, 'Radiation',
    CORR(avg_rad, avg_pollution)::DECIMAL(5,3),
    REGR_SLOPE(avg_pollution, avg_rad)::DECIMAL(10,4),
    COUNT(*) FROM cleaned GROUP BY pollutant_short;
