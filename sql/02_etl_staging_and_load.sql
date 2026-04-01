-- ============================================================================
-- 02_etl_staging_and_load.sql
-- Loading 27 CSV files into staging tables + 6 weather files
-- PostgreSQL 16
-- ============================================================================
--
-- Data source: Croatian Environment Agency (kvaliteta-zraka.hr)
-- Each monitoring station's data comes as a separate CSV file.
-- Some stations span the full period (2019-2024), others are split into
-- 2019-2022 and 2023-2025 files due to agency formatting changes.
--
-- Weather data source: Open-Meteo Historical Weather API
-- One file per city (6 cities × 1 file each).
--
-- NOTE: The pattern below repeats for all 27 station tables.
-- Only a representative sample is shown. Full script: air_quality_db_session.sql
-- ============================================================================

CREATE SCHEMA air_quality_db;

-- ============================================================================
-- AIR QUALITY STAGING TABLES (27 total)
-- ============================================================================
-- Pattern: One table per station CSV file. All share the same wide-format
-- structure with one column per pollutant (will be unpivoted in step 03).
--
-- Stations by city:
--   Zagreb (7 stations):  Zagreb_1, Zagreb_2, Zagreb_3, Zagreb_4,
--                         Zagreb_Dordiceva_ulica, Zagreb_ksaverska_cesta, Zagreb_susedgrad
--   Split (4 stations):   Split_1, Split_2, Split_3, Split_lucka_uprava, Split_sveti_kajo
--   Osijek (2 stations):  Osijek_1, Osijek_2
--   Rijeka (2 stations):  Rijeka_2, Rijeka_Mlaka
--   Dubrovnik (2 stations): Zarkovica_Dubrovnik, Zracna_luka_Dubrovnik
--   Vis (1 station):      Vis_Hum
-- ============================================================================

-- Example: Vis (single file for entire period)
CREATE TABLE air_quality_db.hum_vis (
    date_id SERIAL PRIMARY KEY,
    date    VARCHAR(255),           -- stored as text initially (mixed date formats)
    time    TIME,
    benzen  NUMERIC(10, 3),
    co      NUMERIC(10, 3),
    no2     NUMERIC(10, 3),
    o3      NUMERIC(10, 3),
    pm10    NUMERIC(10, 3),
    pm25    NUMERIC(10, 3),
    so2     NUMERIC(10, 3)
);

COPY air_quality_db.hum_vis (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM 'C:\sql\air_quality_db\CSV\hum_vis_sve.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Example: Zagreb station split across two files (2019-2022 + 2023-2025)
CREATE TABLE air_quality_db.zagreb_2_2019_2022 (
    date_id SERIAL PRIMARY KEY,
    date    VARCHAR(255),
    time    TIME,
    benzen  NUMERIC(10, 3),
    co      NUMERIC(10, 3),
    no2     NUMERIC(10, 3),
    o3      NUMERIC(10, 3),
    pm10    NUMERIC(10, 3),
    pm25    NUMERIC(10, 3),
    so2     NUMERIC(10, 3)
);

COPY air_quality_db.zagreb_2_2019_2022 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM 'C:\sql\air_quality_db\CSV\zagreb_2_2019-2022.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

CREATE TABLE air_quality_db.zagreb_2_2023_2025 (
    date_id SERIAL PRIMARY KEY,
    date    VARCHAR(255),
    time    TIME,
    benzen  NUMERIC(10, 3),
    co      NUMERIC(10, 3),
    no2     NUMERIC(10, 3),
    o3      NUMERIC(10, 3),
    pm10    NUMERIC(10, 3),
    pm25    NUMERIC(10, 3),
    so2     NUMERIC(10, 3)
);

COPY air_quality_db.zagreb_2_2023_2025 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM 'C:\sql\air_quality_db\CSV\zagreb_2_2023-2025.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- ... (same pattern repeats for all 27 station tables)
-- Full staging script available in: air_quality_db_session.sql

-- ============================================================================
-- ADD location AND station COLUMNS TO EACH TABLE
-- ============================================================================
-- Before UNION ALL, each table needs to know which city/station it belongs to.
-- Example pattern:

ALTER TABLE air_quality_db.hum_vis
ADD COLUMN location VARCHAR(50),
ADD COLUMN station  VARCHAR(100);

UPDATE air_quality_db.hum_vis
SET location = 'Vis', station = 'Vis_Hum';

ALTER TABLE air_quality_db.zagreb_2_2019_2022
ADD COLUMN location VARCHAR(50),
ADD COLUMN station  VARCHAR(100);

UPDATE air_quality_db.zagreb_2_2019_2022
SET location = 'Zagreb', station = 'Zagreb_2';

-- ... (same pattern for all 27 tables)

-- ============================================================================
-- WEATHER STAGING TABLES (6 cities)
-- ============================================================================
-- Source: Open-Meteo Historical Weather API
-- One file per city with hourly observations.

-- Example: Dubrovnik
CREATE TABLE air_quality_db.dubrovnik_prognoza (
    time                        TIMESTAMP,
    temperature_2m_c            NUMERIC(4, 1),
    relative_humidity_2m_pct    NUMERIC(5, 2),
    rain_mm                     NUMERIC(5, 2),
    snowfall_cm                 NUMERIC(5, 2),
    precipitation_mm            NUMERIC(5, 2),
    wind_speed_10m_kmh          NUMERIC(5, 2),
    wind_speed_100m_kmh         NUMERIC(5, 2),
    wind_direction_10m_deg      SMALLINT,
    wind_direction_100m_deg     SMALLINT,
    wind_gusts_10m_kmh          NUMERIC(5, 2),
    pressure_msl_hpa            NUMERIC(6, 2),
    surface_pressure_hpa        NUMERIC(6, 2),
    cloud_cover_pct             NUMERIC(5, 2),
    cloud_cover_low_pct         NUMERIC(5, 2),
    cloud_cover_mid_pct         NUMERIC(5, 2),
    cloud_cover_high_pct        NUMERIC(5, 2),
    shortwave_radiation_wm2     NUMERIC(6, 2)
);

COPY air_quality_db.dubrovnik_prognoza (
    time, temperature_2m_c, relative_humidity_2m_pct, rain_mm, snowfall_cm,
    precipitation_mm, wind_speed_10m_kmh, wind_speed_100m_kmh,
    wind_direction_10m_deg, wind_direction_100m_deg, wind_gusts_10m_kmh,
    pressure_msl_hpa, surface_pressure_hpa, cloud_cover_pct,
    cloud_cover_low_pct, cloud_cover_mid_pct, cloud_cover_high_pct,
    shortwave_radiation_wm2
)
FROM 'C:\sql\air_quality_db\weather\Dubrovnik_prognoza.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- ... (same pattern for Zagreb, Split, Osijek, Rijeka, Vis)

-- Add date, location, and FK columns to each weather table
ALTER TABLE air_quality_db.dubrovnik_prognoza
ADD COLUMN date DATE,
ADD COLUMN location VARCHAR(50),
ADD COLUMN wf_id INT;

UPDATE air_quality_db.dubrovnik_prognoza
SET location = 'Dubrovnik',
    date = time::DATE;

-- ... (same for all 6 weather tables)

-- ============================================================================
-- UNION ALL — Combine all weather tables
-- ============================================================================

CREATE TABLE air_quality_db.wether_fact_union AS
SELECT * FROM air_quality_db.zagreb_prognoza
UNION ALL
SELECT * FROM air_quality_db.split_prognoza
UNION ALL
SELECT * FROM air_quality_db.rijeka_prognoza
UNION ALL
SELECT * FROM air_quality_db.osijek_prognoza
UNION ALL
SELECT * FROM air_quality_db.vis_prognoza
UNION ALL
SELECT * FROM air_quality_db.dubrovnik_prognoza;

-- Add primary key and foreign keys
ALTER TABLE air_quality_db.wether_fact_union
ADD COLUMN wf_id SERIAL PRIMARY KEY;

ALTER TABLE air_quality_db.wether_fact_union
ADD COLUMN fk_location_id SMALLINT,
ADD COLUMN fk_date_id SMALLINT,
ADD COLUMN fk_time_id SMALLINT;

-- Populate FKs by joining to dimension tables
UPDATE air_quality_db.wether_fact_union AS a
SET 
    fk_location_id = l.pk_location_id,
    fk_date_id = d.pk_date_id,
    fk_time_id = t.pk_time_id
FROM 
    public.dim_location AS l,
    public.dim_date AS d,
    public.dim_time AS t
WHERE 
    a.location = l.city
    AND a.date = d.date
    AND a.time = t.time;
