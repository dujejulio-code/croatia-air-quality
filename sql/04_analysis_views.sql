-- ============================================================================
-- 04_analysis_views.sql
-- Analytical views for cross-fact-table analysis
-- PostgreSQL 16
-- ============================================================================

-- ============================================================================
-- VIEW: wind_pollution
-- ============================================================================
-- Joins air quality measurements with wind direction data from the weather table.
-- Enables analysis of which wind directions bring the most pollution.
-- 
-- This is a cross-fact-table join: air_quality_fact and city_weather_fact
-- share three keys (date, location, time) — the galaxy schema pattern.

CREATE VIEW public.wind_pollution AS
SELECT  
    w.wind_direction_10m_deg,
    w.wind_direction_100m_deg,
    a.measured_value,
    a.fk_aqi_id,
    a.fk_pollutant_id,
    a.fk_date_id,
    a.fk_location_id,
    a.fk_time_id
FROM public.city_weather_fact AS w
JOIN public.air_quality_fact AS a
    ON w.fk_date_id = a.fk_date_id
    AND w.fk_location_id = a.fk_location_id
    AND w.fk_time_id = a.fk_time_id;

-- ============================================================================
-- VIEW: aqi_exceedance_profile
-- ============================================================================
-- For each city and season: what percentage of hours fall into each 
-- air quality tier (Good, Moderate, Bad, Very Bad)?
--
-- Logic: For each (city, season, date, time), count how many pollutants
-- exceed their "Good" threshold. Then aggregate into percentage buckets.
--
-- Excludes O3 (ozone behaves inversely — higher in summer/clean air)
-- and pollutants without EAQI thresholds (Benzen, CO).

CREATE VIEW public.aqi_exceedance_profile AS
SELECT 
    city,
    season,
    ROUND(100.0 * AVG(CASE WHEN bad_air = 0  THEN 1 ELSE 0 END), 1) AS good_air,
    ROUND(100.0 * AVG(CASE WHEN bad_air = 1  THEN 1 ELSE 0 END), 1) AS moderate,
    ROUND(100.0 * AVG(CASE WHEN bad_air = 2  THEN 1 ELSE 0 END), 1) AS bad,
    ROUND(100.0 * AVG(CASE WHEN bad_air >= 3 THEN 1 ELSE 0 END), 1) AS very_bad
FROM (
    SELECT 
        l.city,
        d.season,
        f.date,
        f.time,
        -- Count how many pollutants exceed "Good" threshold at this hour
        SUM(CASE WHEN f.measured_value > p.good_threshold THEN 1 ELSE 0 END) AS bad_air
    FROM public.air_quality_fact AS f
    JOIN public.dim_location AS l   ON f.fk_location_id = l.pk_location_id
    JOIN public.dim_date AS d       ON f.fk_date_id = d.pk_date_id
    JOIN public.dim_pollutant AS p  ON f.fk_pollutant_id = p.pk_pollutant_id
    WHERE p.good_threshold IS NOT NULL
      AND p.pollutant_short <> 'O3'     -- exclude ozone (inverse seasonal pattern)
    GROUP BY l.city, d.season, f.date, f.time
) AS sub
GROUP BY city, season
ORDER BY city, season;
