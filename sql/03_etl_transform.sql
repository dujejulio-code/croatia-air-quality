-- ============================================================================
-- 03_etl_transform.sql
-- UNION ALL → Unpivot → Date Parsing → FK Assignment → AQI Classification
-- PostgreSQL 16
-- ============================================================================
--
-- This is the core transformation pipeline:
-- 1. UNION ALL 27 station tables into one wide table
-- 2. CROSS JOIN LATERAL to unpivot wide → long (7 pollutant columns → rows)
-- 3. Parse mixed date formats (DD.MM.YYYY vs "Day, Month DD, YYYY")
-- 4. Join to dimension tables to populate foreign keys
-- 5. Classify each measurement into EAQI categories
-- 6. Clean outliers (negative values, sensor errors)
-- ============================================================================

-- ============================================================================
-- STEP 1: UNION ALL — Combine all 27 station tables
-- ============================================================================
-- Each staging table has: date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
-- UNION ALL preserves duplicates (different stations may report at the same time)

CREATE TABLE air_quality_db.air_quality_all AS
-- VIS
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.hum_vis
UNION ALL
-- OSIJEK (2 stations)
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.osijek_1
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.osijek_2
UNION ALL
-- RIJEKA (2 stations)
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.rijeka_2_sve
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.rijeka_mlaka_sve
UNION ALL
-- SPLIT (7 table files across 4 stations)
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.splir_3_sve
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.split_1_sve
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.split_2_2019_2022
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.split_2_2023_2025
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.split_sveti_kajo_2019_2022
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.split_sveti_kajo_2023_2025
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.lucka_split1922
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.lucka_split2325
UNION ALL
-- ZAGREB (12 table files across 7 stations)
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.zagreb_1_sve
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.zagreb_2_2019_2022
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.zagreb_2_2023_2025
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.zagreb_3_sve
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.zagreb_4_2019_2022
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.zagreb_4_2023_2025
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.zagreb_dordiceva_ulica_2019_2022
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.zagreb_dordiceva_ulica_2023_2025
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.zagreb_ksaverska_cesta_2019_2022
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.zagreb_ksvaerska_cesta_2023_2025
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.zagreb_susedgrad_2019_2022
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.zagreb_susedgrad_2023_2025
UNION ALL
-- DUBROVNIK (2 stations)
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.zarkovica_dubrovnik_sve
UNION ALL
SELECT date, time, benzen, co, no2, o3, pm10, pm25, so2, location, station
FROM air_quality_db.zracna_luka_dubrovnik_sve;

ALTER TABLE air_quality_db.air_quality_all ADD COLUMN id SERIAL PRIMARY KEY;

-- ============================================================================
-- STEP 2: CROSS JOIN LATERAL — Unpivot wide format to long format
-- ============================================================================
-- Input:  1 row  = date, time, station, benzen, co, no2, o3, pm10, pm25, so2
-- Output: 7 rows = date, time, station, pollutant, measured_value
--
-- CROSS JOIN LATERAL with VALUES creates a virtual table of (name, value) pairs
-- for each row. This is the PostgreSQL equivalent of UNPIVOT in SQL Server.

CREATE TABLE air_quality_db.air_quality_all_unpivot AS
SELECT
    id, date, time, location, station,
    pollutant, measured_value
FROM air_quality_db.air_quality_all
CROSS JOIN LATERAL (
    VALUES
        ('benzen', benzen),
        ('co',     co),
        ('no2',    no2),
        ('o3',     o3),
        ('pm10',   pm10),
        ('pm25',   pm25),
        ('so2',    so2)
) AS unpivot (pollutant, measured_value);

-- ============================================================================
-- STEP 3: Date Parsing — Handle mixed formats
-- ============================================================================
-- The CSV files use two different date formats:
--   Format A: "DD.MM.YYYY"              (e.g., "15.01.2021")
--   Format B: "Day, Month DD, YYYY"     (e.g., "Friday, January 15, 2021")
--
-- CASE expression detects format by checking if first character is a digit.
-- FM prefix in format strings removes leading zeros/spaces.

ALTER TABLE air_quality_db.air_quality_all_unpivot
ALTER COLUMN date TYPE DATE USING CASE
    WHEN date LIKE '%.%.%' THEN TO_DATE(date, 'DD.MM.YYYY')
    ELSE TO_DATE(date, 'FMDay, FMMonth DD, YYYY')
END;

-- ============================================================================
-- STEP 4: FK Assignment — Join to dimension tables
-- ============================================================================
-- Build the fact table incrementally by joining to each dimension:
-- date → dim_date, time → dim_time, location → dim_location,
-- station → dim_station, pollutant → dim_pollutant

-- Standardize pollutant names to match dim_pollutant
UPDATE public.dim_pollutant SET pollutant_short = CASE
    WHEN pollutant_short = 'Benzen' THEN 'benzen'
    WHEN pollutant_short = 'CO'     THEN 'co'
    WHEN pollutant_short = 'NO2'    THEN 'no2'
    WHEN pollutant_short = 'O3'     THEN 'o3'
    WHEN pollutant_short = 'PM 10'  THEN 'pm10'
    WHEN pollutant_short = 'PM 2.5' THEN 'pm25'
    WHEN pollutant_short = 'SO2'    THEN 'so2'
    ELSE pollutant_short
END;

-- Join to dim_location
CREATE TABLE air_quality_db.air_quality_all_location AS
SELECT a.*, l.pk_location_id AS location_id
FROM air_quality_db.air_quality_all_unpivot AS a
LEFT JOIN public.dim_location AS l ON a.location = l.city;

-- Join to dim_station and dim_pollutant
CREATE TABLE air_quality_db.air_quality_all_sp AS
SELECT l.*, s.pk_station_id AS station_id, p.pk_pollutant_id AS pollutant_id
FROM air_quality_db.air_quality_all_location AS l
LEFT JOIN public.dim_station AS s ON l.station = s.station_name
LEFT JOIN public.dim_pollutant AS p ON l.pollutant = p.pollutant_short;

-- ============================================================================
-- STEP 5: EAQI Classification — Assign air quality categories
-- ============================================================================
-- European Air Quality Index (EAQI) thresholds per pollutant.
-- Each measurement gets a category: Good, Fair, Moderate, Poor, Very Poor.

ALTER TABLE air_quality_db.air_quality_all_sp ADD COLUMN aq_index VARCHAR(30);

UPDATE air_quality_db.air_quality_all_sp
SET aq_index = CASE
    -- PM2.5 (µg/m³)
    WHEN pollutant = 'pm25' AND measured_value <= 10  THEN 'Good'
    WHEN pollutant = 'pm25' AND measured_value <= 20  THEN 'Fair'
    WHEN pollutant = 'pm25' AND measured_value <= 25  THEN 'Moderate'
    WHEN pollutant = 'pm25' AND measured_value <= 50  THEN 'Poor'
    WHEN pollutant = 'pm25' AND measured_value > 50   THEN 'Very Poor'
    -- PM10 (µg/m³)
    WHEN pollutant = 'pm10' AND measured_value <= 20  THEN 'Good'
    WHEN pollutant = 'pm10' AND measured_value <= 40  THEN 'Fair'
    WHEN pollutant = 'pm10' AND measured_value <= 50  THEN 'Moderate'
    WHEN pollutant = 'pm10' AND measured_value <= 100 THEN 'Poor'
    WHEN pollutant = 'pm10' AND measured_value > 100  THEN 'Very Poor'
    -- NO2 (µg/m³)
    WHEN pollutant = 'no2' AND measured_value <= 40   THEN 'Good'
    WHEN pollutant = 'no2' AND measured_value <= 90   THEN 'Fair'
    WHEN pollutant = 'no2' AND measured_value <= 120  THEN 'Moderate'
    WHEN pollutant = 'no2' AND measured_value <= 230  THEN 'Poor'
    WHEN pollutant = 'no2' AND measured_value > 230   THEN 'Very Poor'
    -- O3 (µg/m³)
    WHEN pollutant = 'o3' AND measured_value <= 60    THEN 'Good'
    WHEN pollutant = 'o3' AND measured_value <= 120   THEN 'Fair'
    WHEN pollutant = 'o3' AND measured_value <= 180   THEN 'Moderate'
    WHEN pollutant = 'o3' AND measured_value <= 240   THEN 'Poor'
    WHEN pollutant = 'o3' AND measured_value > 240    THEN 'Very Poor'
    -- SO2 (µg/m³)
    WHEN pollutant = 'so2' AND measured_value <= 100  THEN 'Good'
    WHEN pollutant = 'so2' AND measured_value <= 200  THEN 'Fair'
    WHEN pollutant = 'so2' AND measured_value <= 350  THEN 'Moderate'
    WHEN pollutant = 'so2' AND measured_value <= 500  THEN 'Poor'
    WHEN pollutant = 'so2' AND measured_value > 500   THEN 'Very Poor'
    ELSE NULL   -- Benzen and CO: no standard EAQI thresholds
END;

-- ============================================================================
-- STEP 6: Outlier Cleaning — Remove sensor errors
-- ============================================================================
-- Sensor malfunctions can produce negative values or impossibly high readings.
-- Small negatives (-0.5 to 0) are rounded to 0; extreme values are set to NULL.

UPDATE air_quality_db.air_quality_all_sp
SET measured_value = CASE
    WHEN pollutant = 'co'     AND measured_value BETWEEN -0.5 AND 0 THEN 0
    WHEN pollutant = 'co'     AND (measured_value < -0.5 OR measured_value > 50000) THEN NULL
    WHEN pollutant = 'no2'    AND measured_value BETWEEN -0.5 AND 0 THEN 0
    WHEN pollutant = 'no2'    AND (measured_value < -0.5 OR measured_value > 1000) THEN NULL
    WHEN pollutant = 'pm10'   AND measured_value BETWEEN -0.5 AND 0 THEN 0
    WHEN pollutant = 'pm10'   AND (measured_value < -0.5 OR measured_value > 2000) THEN NULL
    WHEN pollutant = 'pm25'   AND measured_value BETWEEN -0.5 AND 0 THEN 0
    WHEN pollutant = 'pm25'   AND (measured_value < -0.5 OR measured_value > 1000) THEN NULL
    WHEN pollutant = 'so2'    AND measured_value BETWEEN -0.5 AND 0 THEN 0
    WHEN pollutant = 'so2'    AND (measured_value < -0.5 OR measured_value > 2000) THEN NULL
    WHEN pollutant = 'o3'     AND measured_value BETWEEN -0.5 AND 0 THEN 0
    WHEN pollutant = 'o3'     AND (measured_value < -0.5 OR measured_value > 600) THEN NULL
    WHEN pollutant = 'benzen' AND measured_value BETWEEN -0.5 AND 0 THEN 0
    WHEN pollutant = 'benzen' AND (measured_value < -0.5 OR measured_value > 100) THEN NULL
    ELSE measured_value
END;

-- ============================================================================
-- STEP 7: Final fact table — Move to public schema with FK constraints
-- ============================================================================

CREATE TABLE public.air_quality_fact AS
SELECT * FROM air_quality_db.air_quality_all_sp;

ALTER TABLE public.air_quality_fact
ADD CONSTRAINT fk_aqi       FOREIGN KEY (fk_aqi_id)       REFERENCES public.dim_aqi_category(pk_aqi_id),
ADD CONSTRAINT fk_station   FOREIGN KEY (fk_station_id)   REFERENCES public.dim_station(pk_station_id),
ADD CONSTRAINT fk_location  FOREIGN KEY (fk_location_id)  REFERENCES public.dim_location(pk_location_id),
ADD CONSTRAINT fk_date      FOREIGN KEY (fk_date_id)      REFERENCES public.dim_date(pk_date_id),
ADD CONSTRAINT fk_pollutant FOREIGN KEY (fk_pollutant_id) REFERENCES public.dim_pollutant(pk_pollutant_id),
ADD CONSTRAINT fk_time      FOREIGN KEY (fk_time_id)      REFERENCES public.dim_time(pk_time_id);
