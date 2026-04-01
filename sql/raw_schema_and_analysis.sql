CREATE DATABASE air_quality_final;

-----------------------------------------------------------------------------------------------------------------------

CREATE TABLE public.dim_date
(
    pk_date_id SMALLINT PRIMARY KEY,
    date DATE,
    year SMALLINT,
    month VARCHAR(50),
    day_of_week VARCHAR(50),
    month_number SMALLINT,
    quarter SMALLINT,
    week_of_year SMALLINT,
    month_all SMALLINT,
    week_all SMALLINT,
    day_all SMALLINT
);

CREATE TABLE public.dim_location
(
    pk_location_id SMALLINT PRIMARY KEY,
    country VARCHAR(50),
    city VARCHAR(50),
    latitude FLOAT,
    longitude FLOAT
);

CREATE TABLE public.dim_pollutant
(
    pk_pollutant_id SMALLINT PRIMARY KEY,
    pollutant_short VARCHAR(50),
    pollutant_long VARCHAR(50),
    unit VARCHAR(20),
    pollutant_group VARCHAR(50),
    main_source VARCHAR(255),
    has_aqi BOOLEAN
);       

CREATE TABLE public.dim_station
(
    pk_station_id SMALLINT PRIMARY KEY,
    station_name VARCHAR(100),
    fk_location_id SMALLINT REFERENCES public.dim_location(pk_location_id)
);

CREATE TABLE public.dim_time
(
    pk_time_id SMALLINT PRIMARY KEY,
    time TIME,
    hour SMALLINT,
    time_of_day VARCHAR(50),
    is_rush_hour BOOLEAN
);

CREATE TABLE public.dim_aqi_category
(
    pk_aqi_id SMALLINT PRIMARY KEY,
    category_name VARCHAR(50),
    score SMALLINT,
    description VARCHAR(255),
    color_hex VARCHAR(50)
);

CREATE TABLE public.city_weather_fact
(
    pk_cwf_id INT PRIMARY KEY,
    temperature_2m_c NUMERIC(4,1),
    relative_humidity_2m_pct NUMERIC(5,2),
    rain_mm NUMERIC(5,2),
    snowfall_cm NUMERIC(5,2),
    precipitation_mm NUMERIC(5,2),
    wind_speed_10m_kmh NUMERIC(5,2),
    wind_speed_100m_kmh NUMERIC(5,2), 
    wind_direction_10m_deg SMALLINT,
    wind_direction_100m_deg SMALLINT,
    wind_gusts_10m_kmh NUMERIC(5,2),
    pressure_msl_hpa NUMERIC(6,2),
    surface_pressure_hpa NUMERIC(6,2),
    cloud_cover_pct NUMERIC(5,2),
    cloud_cover_low_pct NUMERIC(5,2),
    cloud_cover_mid_pct NUMERIC(5,2),
    cloud_cover_high_pct NUMERIC(5,2),
    shortwave_radiation_wm2 NUMERIC(6,2),
    time TIME,
    date DATE,
    location VARCHAR(50),
    fk_date_id SMALLINT REFERENCES public.dim_date(pk_date_id),
    fk_time_id SMALLINT REFERENCES public.dim_time(pk_time_id),
    fk_location_id SMALLINT REFERENCES public.dim_location(pk_location_id)
);

CREATE TABLE public.air_quality_fact
(
    pk_aqf_id INT PRIMARY KEY,
    date DATE,	
    time TIME,	
    location VARCHAR(50),	
    station VARCHAR(100),
    pollutant VARCHAR(50),	
    measured_value NUMERIC(8,3),	
    aq_index VARCHAR(50),
    fk_date_id SMALLINT REFERENCES public.dim_date(pk_date_id),	
    fk_time_id SMALLINT REFERENCES public.dim_time(pk_time_id),	
    fk_location_id SMALLINT REFERENCES public.dim_location(pk_location_id),	
    fk_station_id SMALLINT REFERENCES public.dim_station(pk_station_id),		
    fk_pollutant_id	SMALLINT REFERENCES public.dim_pollutant(pk_pollutant_id),
    fk_aqi_id SMALLINT REFERENCES public.dim_aqi_category(pk_aqi_id)	
);  

-----------------------------------------------------------------------------------------------------------------------

COPY public.dim_date
    (pk_date_id,date,year,month,day_of_week,month_number,
    quarter,week_of_year,month_all,week_all,day_all)
FROM 'C:\sql\air_quality_final\dim_date.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY public.dim_location 
    (pk_location_id,country,latitude,longitude,city)
FROM 'C:\sql\air_quality_final\dim_location.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY public.dim_pollutant
    (pk_pollutant_id,pollutant_short,pollutant_long,unit,pollutant_group,main_source,has_aqi)
FROM 'C:\sql\air_quality_final\dim_pollutant.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY public.dim_station
    (pk_station_id,station_name,fk_location_id)
FROM 'C:\sql\air_quality_final\dim_station.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY public.dim_time
    (pk_time_id,time,hour,time_of_day,is_rush_hour)
FROM 'C:\sql\air_quality_final\dim_time.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY public.dim_aqi_category
    (pk_aqi_id,category_name,score,description,color_hex)
FROM 'C:\sql\air_quality_final\dim_aqi_category.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY public.city_weather_fact
(
    time,temperature_2m_c,relative_humidity_2m_pct,rain_mm,snowfall_cm,precipitation_mm,
    wind_speed_10m_kmh,wind_speed_100m_kmh,wind_direction_10m_deg,wind_direction_100m_deg,
    wind_gusts_10m_kmh,pressure_msl_hpa,surface_pressure_hpa,cloud_cover_pct,cloud_cover_low_pct,
    cloud_cover_mid_pct,cloud_cover_high_pct,shortwave_radiation_wm2,date,location,
    pk_cwf_id,fk_location_id,fk_date_id,fk_time_id
)
FROM 'C:\sql\air_quality_final\city_weather_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY public.air_quality_fact
(
    date,time,location,station,pollutant,measured_value,fk_date_id,fk_time_id,fk_location_id,
    fk_station_id,aq_index,fk_pollutant_id,fk_aqi_id,pk_aqf_id
)
FROM 'C:\sql\air_quality_final\air_quality_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-----------------------------------------------------------------------------------------------------------------------

CREATE INDEX idx_station_location ON public.dim_station(fk_location_id);

CREATE INDEX idx_city_weather_fact_date ON public.city_weather_fact(fk_date_id);
CREATE INDEX idx_city_weather_fact_time ON public.city_weather_fact(fk_time_id);
CREATE INDEX idx_city_weather_fact_location ON public.city_weather_fact(fk_location_id);

CREATE INDEX idx_air_quality_fact_date ON public.air_quality_fact(fk_date_id);
CREATE INDEX idx_air_quality_fact_time ON public.air_quality_fact(fk_time_id);
CREATE INDEX idx_air_quality_fact_pollutant ON public.air_quality_fact(fk_pollutant_id);
CREATE INDEX idx_air_quality_fact_station ON public.air_quality_fact(fk_station_id);
CREATE INDEX idx_air_quality_fact_aqi ON public.air_quality_fact(fk_aqi_id);
CREATE INDEX idx_air_quality_fact_location ON public.air_quality_fact(fk_location_id);

----------------------------------------------------------------------------------------------------------------------

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


------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS weather_sensitivity;

CREATE TABLE weather_sensitivity AS

SELECT 
    p.pollutant_short AS pollutant,
    'temperature' AS weather_var,
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

SELECT p.pollutant_short, 'humidity',
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

SELECT p.pollutant_short, 'wind_speed',
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

SELECT p.pollutant_short, 'pressure',
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

SELECT p.pollutant_short, 'cloud_cover',
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

SELECT p.pollutant_short, 'radiation',
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

----------------------------------------------------------------------------------------------------------------------

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
      AND w.temperature_2m_c BETWEEN -15 AND 35
      AND w.pressure_msl_hpa BETWEEN 995 AND 1040
      AND w.wind_speed_10m_kmh BETWEEN 0 AND 35
      AND w.relative_humidity_2m_pct BETWEEN 0 AND 100
      AND w.cloud_cover_pct BETWEEN 0 AND 100
      AND w.shortwave_radiation_wm2 >= 0
      AND w.precipitation_mm BETWEEN 0 AND 15
    GROUP BY a.fk_date_id, a.fk_location_id, p.pollutant_short
),
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

SELECT 
    pollutant_short AS pollutant,
    'temperature' AS weather_var,
    CORR(avg_temp, avg_pollution)::DECIMAL(5,3) AS correlation,
    REGR_SLOPE(avg_pollution, avg_temp)::DECIMAL(10,4) AS slope,
    COUNT(*) AS n_obs
FROM cleaned
GROUP BY pollutant_short

UNION ALL

SELECT pollutant_short, 'humidity',
    CORR(avg_humid, avg_pollution)::DECIMAL(5,3),
    REGR_SLOPE(avg_pollution, avg_humid)::DECIMAL(10,4),
    COUNT(*)
FROM cleaned
GROUP BY pollutant_short

UNION ALL

SELECT pollutant_short, 'wind_speed',
    CORR(avg_wind, avg_pollution)::DECIMAL(5,3),
    REGR_SLOPE(avg_pollution, avg_wind)::DECIMAL(10,4),
    COUNT(*)
FROM cleaned
GROUP BY pollutant_short

UNION ALL

SELECT pollutant_short, 'pressure',
    CORR(avg_press, avg_pollution)::DECIMAL(5,3),
    REGR_SLOPE(avg_pollution, avg_press)::DECIMAL(10,4),
    COUNT(*)
FROM cleaned
GROUP BY pollutant_short

UNION ALL

SELECT pollutant_short, 'cloud_cover',
    CORR(avg_cloud, avg_pollution)::DECIMAL(5,3),
    REGR_SLOPE(avg_pollution, avg_cloud)::DECIMAL(10,4),
    COUNT(*)
FROM cleaned
GROUP BY pollutant_short

UNION ALL

SELECT pollutant_short, 'radiation',
    CORR(avg_rad, avg_pollution)::DECIMAL(5,3),
    REGR_SLOPE(avg_pollution, avg_rad)::DECIMAL(10,4),
    COUNT(*)
FROM cleaned
GROUP BY pollutant_short;

-- ============================================
-- PROZRAČIVANJE GRADA — Survival Analysis
-- Epizode zagađenja PM2.5 po EAQI pragovima
-- ============================================

-- KORAK 1: Pragovi (EAQI granice za PM2.5)
-- CROSS JOIN = svaki sat se multiplicira × 3 praga
-- Kao da imaš 3 paralelna filtera odjednom
DROP TABLE IF EXISTS pm25_episodes;
CREATE TABLE public.pm25_episodes AS
WITH thresholds AS (
    SELECT 
        unnest(ARRAY[20, 25, 50]) AS threshold_ug,
        unnest(ARRAY[
            '≥20 µg/m³ (Moderate)',
            '≥25 µg/m³ (Poor)', 
            '≥50 µg/m³ (Very Poor)'
        ]) AS threshold_label
),

-- KORAK 2: Bazni dataset — samo PM2.5 s timestampom
-- Sezonu deriviramo iz month_number jer je nemaš u dim_date
pm25_hourly AS (
    SELECT 
        aq.measured_value,
        dl.city,
        dd.date,
        dt.hour,
        -- Rekonstrukcija timestampa za ORDER BY
        dd.date + (dt.hour || ' hours')::INTERVAL AS ts,
        -- Sezona iz mjeseca (SQL CASE = IF/ELSE lanac)
        CASE 
            WHEN dd.month_number IN (12, 1, 2)  THEN 'Winter'
            WHEN dd.month_number IN (3, 4, 5)   THEN 'Spring'
            WHEN dd.month_number IN (6, 7, 8)   THEN 'Summer'
            WHEN dd.month_number IN (9, 10, 11)  THEN 'Autumn'
        END AS season
    FROM public.air_quality_fact aq
    JOIN public.dim_location dl   ON aq.fk_location_id = dl.pk_location_id
    JOIN public.dim_date dd       ON aq.fk_date_id = dd.pk_date_id
    JOIN public.dim_time dt       ON aq.fk_time_id = dt.pk_time_id
    WHERE aq.pollutant = 'pm25'
      AND aq.measured_value IS NOT NULL
),

-- KORAK 3: CROSS JOIN s pragovima + flag above/below
-- Svaki red se klonira 3× (jednom za svaki prag)
flagged AS (
    SELECT 
        h.*,
        t.threshold_ug,
        t.threshold_label,
        CASE WHEN h.measured_value >= t.threshold_ug THEN 1 ELSE 0 END AS is_above
    FROM pm25_hourly h
    CROSS JOIN thresholds t
),

-- ============================================
-- KORAK 4: GAPS AND ISLANDS
-- 
-- Problem: imaš niz 0-ica i 1-ica (below/above).
-- Trebaš grupirati uzastopne 1-ice u "epizode".
--
-- Trik: LAG gleda prethodni red.
-- Ako prethodni = 0 a trenutni = 1 → POČETAK nove epizode.
-- Cumulative SUM tih startova = episode_id.
--
-- SQL analogija: kao da radiš GROUP BY ali po
-- "otocima" uzastopnih vrijednosti, ne po fiksnoj koloni.
-- ============================================

above_only AS (
    SELECT *,
        CASE 
            WHEN ts - LAG(ts) OVER (
                PARTITION BY city, threshold_ug 
                ORDER BY ts
            ) > INTERVAL '1 hour'
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
        -- Running SUM startova = svaki start incrementa brojač
        -- Svi sati između dva starta dobiju isti episode_id
        SUM(is_episode_start) OVER (
            PARTITION BY city, threshold_ug 
            ORDER BY ts
        ) AS episode_id
    FROM above_only
),

-- KORAK 5: Sažetak po epizodi




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
    -- Recovery: od vrha do pada ispod praga
    -- EXTRACT(EPOCH) daje sekunde, / 3600 = sati
    ROUND(EXTRACT(EPOCH FROM (es.episode_end - pt.peak_ts)) / 3600)::INT AS recovery_hours
FROM episode_summary es
JOIN peak_times pt USING (city, threshold_ug, episode_id)
ORDER BY city, threshold_ug, es.episode_start;


ALTER TABLE public.dim_pollutant 
ADD COLUMN good_threshold SMALLINT;
UPDATE public.dim_pollutant 
SET pollutant_short = 
CASE 
    WHEN pk_pollutant_id = 1 THEN 'Benzen'
    WHEN pk_pollutant_id = 2 THEN 'CO'
    WHEN pk_pollutant_id = 3 THEN 'NO2'
    WHEN pk_pollutant_id = 4 THEN 'O3'
    WHEN pk_pollutant_id = 5 THEN 'PM10'
    WHEN pk_pollutant_id = 6 THEN 'PM2.5'
    WHEN pk_pollutant_id = 7 THEN 'SO2'
END;

UPDATE public.dim_pollutant SET good_threshold 
= CASE
  WHEN pollutant_short = 'PM2.5' THEN 20
  WHEN pollutant_short = 'PM10'  THEN 40
  WHEN pollutant_short = 'NO2'   THEN 40
  WHEN pollutant_short = 'O3'    THEN 100
  WHEN pollutant_short = 'SO2'   THEN 100
  ELSE NULL
END

ALTER TABLE public.dim_date ADD COLUMN season VARCHAR(10);

UPDATE public.dim_date SET season = CASE
  WHEN EXTRACT(MONTH FROM date) IN (12, 1, 2) THEN 'Winter'
  WHEN EXTRACT(MONTH FROM date) IN (3, 4, 5) THEN 'Spring'
  WHEN EXTRACT(MONTH FROM date) IN (6, 7, 8) THEN 'Summer'
  WHEN EXTRACT(MONTH FROM date) IN (9, 10, 11) THEN 'Autumn'
END;

SELECT * FROM public.dim_date;

SELECT * FROM public.dim_pollutant;

CREATE VIEW public.aqi_exceedance_profile AS
SELECT 
  city,
  season,
ROUND(100.0 * AVG(CASE WHEN bad_air = 0 THEN 1 ELSE 0 END), 1) AS good_air,
ROUND(100.0 * AVG(CASE WHEN bad_air = 1 THEN 1 ELSE 0 END), 1) AS moderate,
ROUND(100.0 * AVG(CASE WHEN bad_air = 2 THEN 1 ELSE 0 END), 1) AS bad,
ROUND(100.0 * AVG(CASE WHEN bad_air >= 3 THEN 1 ELSE 0 END), 1) AS very_bad
FROM (
  SELECT 
    l.city,
    d.season,
    f.date,
    f.time,
    SUM(CASE WHEN f.measured_value > p.good_threshold THEN 1 ELSE 0 END) AS bad_air
FROM public.air_quality_fact AS f
    JOIN public.dim_location AS l 
    ON f.fk_location_id = l.pk_location_id
    JOIN public.dim_date AS d 
    ON f.fk_date_id = d.pk_date_id
    JOIN public.dim_pollutant AS p 
    ON f.fk_pollutant_id = p.pk_pollutant_id
        WHERE p.good_threshold IS NOT NULL
        AND p.pollutant_short <> 'O3'
        GROUP BY l.city, d.season, f.date, f.time
) AS sub
GROUP BY city, season
ORDER BY city, season;