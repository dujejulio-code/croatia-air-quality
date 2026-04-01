# Data Dictionary

Complete reference for all tables in the `air_quality_final` PostgreSQL database.

---

## Fact Tables

### `air_quality_fact` (~8 million rows)

Hourly pollutant concentration measurements from 19 monitoring stations across 6 Croatian cities.

| Column | Type | Description |
|--------|------|-------------|
| `pk_aqf_id` | INT | Primary key |
| `date` | DATE | Measurement date |
| `time` | TIME | Measurement hour |
| `location` | VARCHAR(50) | City name (denormalized for convenience) |
| `station` | VARCHAR(100) | Station name (denormalized) |
| `pollutant` | VARCHAR(50) | Pollutant code: benzen, co, no2, o3, pm10, pm25, so2 |
| `measured_value` | NUMERIC(8,3) | Concentration in µg/m³ |
| `aq_index` | VARCHAR(50) | EAQI category: Good, Fair, Moderate, Poor, Very Poor |
| `fk_date_id` | SMALLINT | → dim_date |
| `fk_time_id` | SMALLINT | → dim_time |
| `fk_location_id` | SMALLINT | → dim_location |
| `fk_station_id` | SMALLINT | → dim_station |
| `fk_pollutant_id` | SMALLINT | → dim_pollutant |
| `fk_aqi_id` | SMALLINT | → dim_aqi_category |

### `city_weather_fact` (~400K rows)

Hourly weather observations from Open-Meteo API for each of the 6 cities.

| Column | Type | Description |
|--------|------|-------------|
| `pk_cwf_id` | INT | Primary key |
| `temperature_2m_c` | NUMERIC(4,1) | Air temperature at 2m height (°C) |
| `relative_humidity_2m_pct` | NUMERIC(5,2) | Relative humidity (%) |
| `rain_mm` | NUMERIC(5,2) | Rainfall (mm) |
| `snowfall_cm` | NUMERIC(5,2) | Snowfall (cm) |
| `precipitation_mm` | NUMERIC(5,2) | Total precipitation (mm) |
| `wind_speed_10m_kmh` | NUMERIC(5,2) | Wind speed at 10m (km/h) — ground level |
| `wind_speed_100m_kmh` | NUMERIC(5,2) | Wind speed at 100m (km/h) — upper level |
| `wind_direction_10m_deg` | SMALLINT | Wind direction at 10m (degrees, 0-360) |
| `wind_direction_100m_deg` | SMALLINT | Wind direction at 100m (degrees) |
| `wind_gusts_10m_kmh` | NUMERIC(5,2) | Wind gusts at 10m (km/h) |
| `pressure_msl_hpa` | NUMERIC(6,2) | Sea-level pressure (hPa) |
| `surface_pressure_hpa` | NUMERIC(6,2) | Surface pressure (hPa) |
| `cloud_cover_pct` | NUMERIC(5,2) | Total cloud cover (%) |
| `cloud_cover_low_pct` | NUMERIC(5,2) | Low cloud cover (%) |
| `cloud_cover_mid_pct` | NUMERIC(5,2) | Mid cloud cover (%) |
| `cloud_cover_high_pct` | NUMERIC(5,2) | High cloud cover (%) |
| `shortwave_radiation_wm2` | NUMERIC(6,2) | Solar radiation (W/m²) |
| `fk_date_id` | SMALLINT | → dim_date |
| `fk_time_id` | SMALLINT | → dim_time |
| `fk_location_id` | SMALLINT | → dim_location |

---

## Dimension Tables

### `dim_date` (2,192 rows — one per day, 2019-01-01 to 2024-12-31)

| Column | Type | Description |
|--------|------|-------------|
| `pk_date_id` | SMALLINT | Primary key (sequential) |
| `date` | DATE | Calendar date |
| `year` | SMALLINT | 2019–2024 |
| `month` | VARCHAR(50) | Month name (January–December) |
| `day_of_week` | VARCHAR(50) | Day name (Monday–Sunday) |
| `month_number` | SMALLINT | 1–12 |
| `quarter` | SMALLINT | 1–4 |
| `week_of_year` | SMALLINT | 1–53 |
| `month_all` | SMALLINT | Continuous month counter across years |
| `week_all` | SMALLINT | Continuous week counter |
| `day_all` | SMALLINT | Continuous day counter |
| `season` | VARCHAR(10) | Winter (Dec-Feb), Spring (Mar-May), Summer (Jun-Aug), Autumn (Sep-Nov) |

### `dim_time` (24 rows — one per hour)

| Column | Type | Description |
|--------|------|-------------|
| `pk_time_id` | SMALLINT | 0–23 |
| `time` | TIME | Clock time (00:00–23:00) |
| `hour` | SMALLINT | 0–23 |
| `time_of_day` | VARCHAR(50) | Night, Morning, Before noon, Noon, Afternoon, Evening, Late night |
| `is_rush_hour` | BOOLEAN | TRUE for hours 7–9 and 16–18 |

### `dim_location` (6 rows)

| Column | Type | Description |
|--------|------|-------------|
| `pk_location_id` | SMALLINT | 1–6 |
| `country` | VARCHAR(50) | "Croatia" |
| `city` | VARCHAR(50) | Zagreb, Split, Rijeka, Osijek, Dubrovnik, Vis |
| `latitude` | FLOAT | GPS latitude |
| `longitude` | FLOAT | GPS longitude |

### `dim_station` (19 rows)

| Column | Type | Description |
|--------|------|-------------|
| `pk_station_id` | SMALLINT | 1–19 |
| `station_name` | VARCHAR(100) | Station identifier (e.g., Zagreb_1, Zarkovica_Dubrovnik) |
| `fk_location_id` | SMALLINT | → dim_location (which city the station belongs to) |

### `dim_pollutant` (7 rows)

| Column | Type | Description |
|--------|------|-------------|
| `pk_pollutant_id` | SMALLINT | 1–7 |
| `pollutant_short` | VARCHAR(50) | Benzen, CO, NO2, O3, PM10, PM2.5, SO2 |
| `pollutant_long` | VARCHAR(50) | Full name (e.g., Nitrogen Dioxide) |
| `unit` | VARCHAR(20) | µg/m³ for all |
| `pollutant_group` | VARCHAR(50) | Gas or Aerosol |
| `main_source` | VARCHAR(255) | Primary emission source |
| `has_aqi` | BOOLEAN | Whether EAQI thresholds exist |
| `good_threshold` | SMALLINT | EAQI "Good" upper limit (NULL for Benzen, CO) |

### `dim_aqi_category` (5 rows)

| Column | Type | Description |
|--------|------|-------------|
| `pk_aqi_id` | SMALLINT | 1–5 |
| `category_name` | VARCHAR(50) | Good, Fair, Moderate, Poor, Very Poor |
| `score` | SMALLINT | 1–5 severity score |
| `description` | VARCHAR(255) | Health impact description |
| `color_hex` | VARCHAR(50) | Dashboard color code |

---

## Analytical Tables

### `weather_statistics` / `weather_sensitivity_cleaned`

Pre-computed correlations between each pollutant and weather variable.

| Column | Type | Description |
|--------|------|-------------|
| `pollutant` | VARCHAR | Pollutant code |
| `weather_var` | VARCHAR | Temperature, Humidity, Wind Speed, Pressure, Cloud Cover, Radiation |
| `correlation` | DECIMAL(5,3) | Pearson correlation coefficient |
| `slope` | DECIMAL(10,4) | Regression slope |
| `n_obs` | INT | Number of observations |
| `r_squared` | DECIMAL(10,6) | Coefficient of determination (correlation²) |

### `pm25_episodes`

Continuous PM2.5 exceedance episodes detected using gaps-and-islands pattern.

| Column | Type | Description |
|--------|------|-------------|
| `city` | VARCHAR | City name |
| `season` | VARCHAR | Season of episode start |
| `threshold_ug` | INT | Threshold used (20, 25, or 50 µg/m³) |
| `episode_id` | INT | Unique episode identifier (per city + threshold) |
| `episode_start` | TIMESTAMP | First hour above threshold |
| `episode_end` | TIMESTAMP | Last hour above threshold |
| `duration_hours` | INT | Total hours above threshold |
| `peak_value` | NUMERIC | Maximum PM2.5 during episode |
| `peak_ts` | TIMESTAMP | Timestamp of peak value |
| `unit` | VARCHAR | µg/m³ |
| `recovery_hours` | INT | Hours from peak to dropping below threshold |

### `wind_pollution` (VIEW)

Cross-fact-table join enabling wind direction analysis of pollution.

| Column | Type | Description |
|--------|------|-------------|
| `wind_direction_10m_deg` | SMALLINT | Ground-level wind direction (degrees) |
| `wind_direction_100m_deg` | SMALLINT | Upper-level wind direction (degrees) |
| `measured_value` | NUMERIC | Pollutant concentration |
| `fk_aqi_id` | SMALLINT | → dim_aqi_category |
| `fk_pollutant_id` | SMALLINT | → dim_pollutant |
| `fk_date_id` | SMALLINT | → dim_date |
| `fk_location_id` | SMALLINT | → dim_location |
| `fk_time_id` | SMALLINT | → dim_time |
