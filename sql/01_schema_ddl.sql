-- ============================================================================
-- 01_schema_ddl.sql
-- Galaxy Schema for Croatia Air Quality Analysis
-- PostgreSQL 16
-- ============================================================================
-- 
-- Schema design: Galaxy schema with TWO fact tables sharing dimension tables.
-- This enables cross-fact-table analysis (e.g., correlating weather with pollution)
-- through shared dimension keys (date, time, location).
--
-- Run order: This script first. Then 02_ for staging, 03_ for transforms.
-- ============================================================================

CREATE DATABASE air_quality_final;

-- ============================================================================
-- DIMENSION TABLES
-- ============================================================================

CREATE TABLE public.dim_date
(
    pk_date_id      SMALLINT PRIMARY KEY,
    date            DATE,
    year            SMALLINT,
    month           VARCHAR(50),
    day_of_week     VARCHAR(50),
    month_number    SMALLINT,
    quarter         SMALLINT,
    week_of_year    SMALLINT,
    month_all       SMALLINT,       -- continuous month counter across all years
    week_all        SMALLINT,       -- continuous week counter across all years
    day_all         SMALLINT        -- continuous day counter across all years
);

CREATE TABLE public.dim_location
(
    pk_location_id  SMALLINT PRIMARY KEY,
    country         VARCHAR(50),
    city            VARCHAR(50),
    latitude        FLOAT,
    longitude       FLOAT
);

CREATE TABLE public.dim_pollutant
(
    pk_pollutant_id SMALLINT PRIMARY KEY,
    pollutant_short VARCHAR(50),
    pollutant_long  VARCHAR(50),
    unit            VARCHAR(20),
    pollutant_group VARCHAR(50),    -- 'Gas' or 'Aerosol'
    main_source     VARCHAR(255),
    has_aqi         BOOLEAN         -- whether EAQI thresholds exist for this pollutant
);

CREATE TABLE public.dim_station
(
    pk_station_id   SMALLINT PRIMARY KEY,
    station_name    VARCHAR(100),
    fk_location_id  SMALLINT REFERENCES public.dim_location(pk_location_id)
);

CREATE TABLE public.dim_time
(
    pk_time_id      SMALLINT PRIMARY KEY,
    time            TIME,
    hour            SMALLINT,
    time_of_day     VARCHAR(50),    -- Night, Morning, Before noon, Noon, Afternoon, Evening, Late night
    is_rush_hour    BOOLEAN         -- TRUE for hours 7-9 and 16-18
);

CREATE TABLE public.dim_aqi_category
(
    pk_aqi_id       SMALLINT PRIMARY KEY,
    category_name   VARCHAR(50),    -- Good, Fair, Moderate, Poor, Very Poor
    score           SMALLINT,       -- 1-5 severity score
    description     VARCHAR(255),
    color_hex       VARCHAR(50)     -- for dashboard conditional formatting
);

-- ============================================================================
-- FACT TABLES
-- ============================================================================

-- Fact table 1: Air quality measurements
-- ~8 million rows (7 pollutants × 19 stations × ~50K hours)
CREATE TABLE public.air_quality_fact
(
    pk_aqf_id       INT PRIMARY KEY,
    date            DATE,
    time            TIME,
    location        VARCHAR(50),
    station         VARCHAR(100),
    pollutant       VARCHAR(50),
    measured_value  NUMERIC(8,3),   -- concentration in µg/m³
    aq_index        VARCHAR(50),    -- EAQI category name
    fk_date_id      SMALLINT REFERENCES public.dim_date(pk_date_id),
    fk_time_id      SMALLINT REFERENCES public.dim_time(pk_time_id),
    fk_location_id  SMALLINT REFERENCES public.dim_location(pk_location_id),
    fk_station_id   SMALLINT REFERENCES public.dim_station(pk_station_id),
    fk_pollutant_id SMALLINT REFERENCES public.dim_pollutant(pk_pollutant_id),
    fk_aqi_id       SMALLINT REFERENCES public.dim_aqi_category(pk_aqi_id)
);

-- Fact table 2: Weather observations
-- ~400K rows (6 cities × ~50K hours)
CREATE TABLE public.city_weather_fact
(
    pk_cwf_id                   INT PRIMARY KEY,
    temperature_2m_c            NUMERIC(4,1),
    relative_humidity_2m_pct    NUMERIC(5,2),
    rain_mm                     NUMERIC(5,2),
    snowfall_cm                 NUMERIC(5,2),
    precipitation_mm            NUMERIC(5,2),
    wind_speed_10m_kmh          NUMERIC(5,2),
    wind_speed_100m_kmh         NUMERIC(5,2),
    wind_direction_10m_deg      SMALLINT,
    wind_direction_100m_deg     SMALLINT,
    wind_gusts_10m_kmh          NUMERIC(5,2),
    pressure_msl_hpa            NUMERIC(6,2),
    surface_pressure_hpa        NUMERIC(6,2),
    cloud_cover_pct             NUMERIC(5,2),
    cloud_cover_low_pct         NUMERIC(5,2),
    cloud_cover_mid_pct         NUMERIC(5,2),
    cloud_cover_high_pct        NUMERIC(5,2),
    shortwave_radiation_wm2     NUMERIC(6,2),
    time                        TIME,
    date                        DATE,
    location                    VARCHAR(50),
    fk_date_id                  SMALLINT REFERENCES public.dim_date(pk_date_id),
    fk_time_id                  SMALLINT REFERENCES public.dim_time(pk_time_id),
    fk_location_id              SMALLINT REFERENCES public.dim_location(pk_location_id)
);

-- ============================================================================
-- INDEXES — Optimizing joins on foreign keys
-- ============================================================================

CREATE INDEX idx_station_location            ON public.dim_station(fk_location_id);

CREATE INDEX idx_city_weather_fact_date      ON public.city_weather_fact(fk_date_id);
CREATE INDEX idx_city_weather_fact_time      ON public.city_weather_fact(fk_time_id);
CREATE INDEX idx_city_weather_fact_location  ON public.city_weather_fact(fk_location_id);

CREATE INDEX idx_air_quality_fact_date       ON public.air_quality_fact(fk_date_id);
CREATE INDEX idx_air_quality_fact_time       ON public.air_quality_fact(fk_time_id);
CREATE INDEX idx_air_quality_fact_pollutant  ON public.air_quality_fact(fk_pollutant_id);
CREATE INDEX idx_air_quality_fact_station    ON public.air_quality_fact(fk_station_id);
CREATE INDEX idx_air_quality_fact_aqi        ON public.air_quality_fact(fk_aqi_id);
CREATE INDEX idx_air_quality_fact_location   ON public.air_quality_fact(fk_location_id);

-- ============================================================================
-- SCHEMA UPDATES — Added after initial load
-- ============================================================================

-- EAQI "Good" threshold per pollutant (used for AQI Ratio calculations)
ALTER TABLE public.dim_pollutant ADD COLUMN good_threshold SMALLINT;

UPDATE public.dim_pollutant SET good_threshold = CASE
    WHEN pollutant_short = 'PM2.5' THEN 20
    WHEN pollutant_short = 'PM10'  THEN 40
    WHEN pollutant_short = 'NO2'   THEN 40
    WHEN pollutant_short = 'O3'    THEN 100
    WHEN pollutant_short = 'SO2'   THEN 100
    ELSE NULL   -- Benzen and CO have no EAQI threshold
END;

-- Season column derived from month (for filtering without joins)
ALTER TABLE public.dim_date ADD COLUMN season VARCHAR(10);

UPDATE public.dim_date SET season = CASE
    WHEN EXTRACT(MONTH FROM date) IN (12, 1, 2)  THEN 'Winter'
    WHEN EXTRACT(MONTH FROM date) IN (3, 4, 5)   THEN 'Spring'
    WHEN EXTRACT(MONTH FROM date) IN (6, 7, 8)   THEN 'Summer'
    WHEN EXTRACT(MONTH FROM date) IN (9, 10, 11) THEN 'Autumn'
END;
