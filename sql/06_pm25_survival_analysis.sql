-- ============================================================================
-- 06_pm25_survival_analysis.sql
-- "Prozračivanje grada" — How long do pollution episodes last?
-- PostgreSQL 16
-- ============================================================================
--
-- PROBLEM: Given hourly PM2.5 readings, identify continuous episodes where
-- pollution stays above a threshold, measure their duration, find the peak,
-- and calculate how long the city takes to recover after the peak.
--
-- TECHNIQUE: Gaps-and-Islands pattern using window functions
--   - LAG() detects breaks between consecutive above-threshold hours
--   - Cumulative SUM() of break flags assigns episode IDs
--   - GROUP BY episode for summary statistics
--
-- Three EAQI thresholds analyzed simultaneously via CROSS JOIN:
--   ≥20 µg/m³ (Moderate)  — WHO annual guideline
--   ≥25 µg/m³ (Poor)      — EU annual limit
--   ≥50 µg/m³ (Very Poor) — EU daily limit
-- ============================================================================

DROP TABLE IF EXISTS pm25_episodes;

CREATE TABLE public.pm25_episodes AS

-- STEP 1: Define thresholds
-- CROSS JOIN will multiply each hour × 3 thresholds
WITH thresholds AS (
    SELECT 
        unnest(ARRAY[20, 25, 50]) AS threshold_ug,
        unnest(ARRAY[
            '≥20 µg/m³ (Moderate)',
            '≥25 µg/m³ (Poor)', 
            '≥50 µg/m³ (Very Poor)'
        ]) AS threshold_label
),

-- STEP 2: Base dataset — PM2.5 only, with reconstructed timestamp
pm25_hourly AS (
    SELECT 
        aq.measured_value,
        dl.city,
        dd.date,
        dt.hour,
        -- Reconstruct timestamp for ORDER BY and gap detection
        dd.date + (dt.hour || ' hours')::INTERVAL AS ts,
        -- Derive season from month number
        CASE 
            WHEN dd.month_number IN (12, 1, 2)  THEN 'Winter'
            WHEN dd.month_number IN (3, 4, 5)   THEN 'Spring'
            WHEN dd.month_number IN (6, 7, 8)   THEN 'Summer'
            WHEN dd.month_number IN (9, 10, 11) THEN 'Autumn'
        END AS season
    FROM public.air_quality_fact aq
    JOIN public.dim_location dl ON aq.fk_location_id = dl.pk_location_id
    JOIN public.dim_date dd     ON aq.fk_date_id = dd.pk_date_id
    JOIN public.dim_time dt     ON aq.fk_time_id = dt.pk_time_id
    WHERE aq.pollutant = 'pm25'
      AND aq.measured_value IS NOT NULL
),

-- STEP 3: CROSS JOIN with thresholds + flag above/below
-- Each row is cloned 3× (once per threshold)
flagged AS (
    SELECT 
        h.*,
        t.threshold_ug,
        t.threshold_label,
        CASE WHEN h.measured_value >= t.threshold_ug THEN 1 ELSE 0 END AS is_above
    FROM pm25_hourly h
    CROSS JOIN thresholds t
),

-- STEP 4: GAPS AND ISLANDS
-- 
-- The core pattern:
--   1. Keep only above-threshold rows
--   2. Use LAG(ts) to look at the previous row's timestamp
--   3. If gap > 1 hour → this is a NEW episode start
--   4. Cumulative SUM of starts = episode_id
--
-- Why LAG instead of ROW_NUMBER difference?
-- Because there may be missing hours in the data (sensor downtime).
-- A 1-hour gap is "continuous"; anything larger is a new episode.

above_only AS (
    SELECT *,
        CASE 
            -- Gap > 1 hour from previous reading = new episode
            WHEN ts - LAG(ts) OVER (
                PARTITION BY city, threshold_ug 
                ORDER BY ts
            ) > INTERVAL '1 hour'
            -- First row has no LAG = also a new episode
            OR LAG(ts) OVER (
                PARTITION BY city, threshold_ug 
                ORDER BY ts
            ) IS NULL
            THEN 1 
            ELSE 0 
        END AS is_episode_start
    FROM flagged
    WHERE is_above = 1
),

episodes AS (
    SELECT *,
        -- Running SUM of episode starts = episode counter
        -- All hours between two starts share the same episode_id
        SUM(is_episode_start) OVER (
            PARTITION BY city, threshold_ug 
            ORDER BY ts
        ) AS episode_id
    FROM above_only
),

-- STEP 5: Summarize each episode
episode_summary AS (
    SELECT 
        city,
        threshold_ug,
        episode_id,
        threshold_label,
        MIN(season) AS season,
        MIN(ts) AS episode_start,
        MAX(ts) AS episode_end,
        COUNT(*) AS duration_hours,
        MAX(measured_value) AS peak_value
    FROM episodes
    GROUP BY city, threshold_ug, episode_id, threshold_label
),

-- STEP 6: Find exact peak timestamp (for recovery calculation)
peak_times AS (
    SELECT city, threshold_ug, episode_id, ts AS peak_ts
    FROM (
        SELECT *, 
            ROW_NUMBER() OVER (
                PARTITION BY city, threshold_ug, episode_id 
                ORDER BY measured_value DESC, ts
            ) AS rn
        FROM episodes
    ) ranked
    WHERE rn = 1
)

-- FINAL OUTPUT: Episode details + recovery time
SELECT 
    es.city,
    es.season,
    es.threshold_ug,
    es.episode_id,
    es.episode_start,
    es.episode_end,
    es.duration_hours,
    es.peak_value,
    pt.peak_ts,
    'µg/m³' AS unit,
    -- Recovery time: hours from peak to end of episode
    ROUND(EXTRACT(EPOCH FROM (es.episode_end - pt.peak_ts)) / 3600)::INT AS recovery_hours
FROM episode_summary es
JOIN peak_times pt USING (city, threshold_ug, episode_id)
ORDER BY city, threshold_ug, es.episode_start;
