CREATE SCHEMA air_quality_db;

--------------------------------------------------------------------------------------
-- VIS
--------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.hum_vis (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.hum_vis (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\hum_vis_sve.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

------------------------------------------------------------------------------------
-- OSIJEK
------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.osijek_1 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.osijek_1 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\osijek_1_sve.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

-----------------------------------------------------------------------------------
CREATE TABLE air_quality_db.osijek_2 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.osijek_2 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\osijek_2_sve.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

SELECT
    *
FROM
    air_quality_db.osijek_2 -------------------------------------------------------------------------------------
    -- SPLIT
    -------------------------------------------------------------------------------------
    CREATE TABLE air_quality_db.lucka_split1922 (
        date_id SERIAL PRIMARY KEY,
        date VARCHAR(255),
        time TIME,
        benzen NUMERIC(10, 3),
        co NUMERIC(10, 3),
        no2 NUMERIC(10, 3),
        o3 NUMERIC(10, 3),
        pm10 NUMERIC(10, 3),
        pm25 NUMERIC(10, 3),
        so2 NUMERIC(10, 3)
    );

COPY air_quality_db.lucka_split1922 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\lucka_uprava_split_2019-2022.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.lucka_split2325 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.lucka_split2325 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\lucka_uprava_split_2023-2025.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

-------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.splir_3_sve (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.splir_3_sve (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\splir_3_sve.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

--------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.split_1_sve (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.split_1_sve (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\split_1_sve.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

--------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.split_2_2019_2022 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.split_2_2019_2022 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\split_2_2019-2022.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

-------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.split_2_2023_2025 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.split_2_2023_2025 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\split_2_2023-2025.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

---------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.split_sveti_kajo_2019_2022 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.split_sveti_kajo_2019_2022 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\split_sveti_kajo_2019-2022.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

---------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.split_sveti_kajo_2023_2025 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.split_sveti_kajo_2023_2025 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\split_sveti_kajo_2023-2025.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

-------------------------------------------------------------------------------------
-- ZAGREB
-------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.zagreb_1_sve (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.zagreb_1_sve (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\zagreb_1_sve.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

--------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.zagreb_2_2019_2022 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.zagreb_2_2019_2022 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\zagreb_2_2019-2022.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

--------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.zagreb_2_2023_2025 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.zagreb_2_2023_2025 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\zagreb_2_2023-2025.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

--------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.zagreb_3_sve (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.zagreb_3_sve (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\zagreb_3_sve.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

---------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.zagreb_4_2019_2022 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.zagreb_4_2019_2022 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\zagreb_4_2019-2022.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

---------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.zagreb_4_2023_2025 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.zagreb_4_2023_2025 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\zagreb_4_2023-2025.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

---------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.zagreb_dordiceva_ulica_2019_2022 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.zagreb_dordiceva_ulica_2019_2022 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\zagreb_dordiceva_ulica_2019-2022.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

----------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.zagreb_dordiceva_ulica_2023_2025 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.zagreb_dordiceva_ulica_2023_2025 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\zagreb_dordiceva_ulica_2023-2025.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

----------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.zagreb_ksaverska_cesta_2019_2022 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.zagreb_ksaverska_cesta_2019_2022 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\zagreb_ksaverska_cesta_2019-2022.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

----------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.zagreb_ksvaerska_cesta_2023_2025 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.zagreb_ksvaerska_cesta_2023_2025 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\zagreb_ksvaerska_cesta_2023-2025.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

----------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.zagreb_susedgrad_2019_2022 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.zagreb_susedgrad_2019_2022 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\zagreb_susedgrad_2019-2022.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

-----------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.zagreb_susedgrad_2023_2025 (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.zagreb_susedgrad_2023_2025 (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\zagreb_susedgrad_2023-2025.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

-----------------------------------------------------------------------------------------
-- DUBROVNIK
-----------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.zarkovica_dubrovnik_sve (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.zarkovica_dubrovnik_sve (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\zarkovica_dubrovnik_sve.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

-----------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.zracna_luka_dubrovnik_sve (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.zracna_luka_dubrovnik_sve (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\zracna_luka_dubrovnik_sve.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

--------------------------------------------------------------------------------------
-- RIJEKA
--------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.rijeka_mlaka_sve (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.rijeka_mlaka_sve (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\rijeka_mlaka_sve.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

--------------------------------------------------------------------------------------   
CREATE TABLE air_quality_db.rijeka_2_sve (
    date_id SERIAL PRIMARY KEY,
    date VARCHAR(255),
    time TIME,
    benzen NUMERIC(10, 3),
    co NUMERIC(10, 3),
    no2 NUMERIC(10, 3),
    o3 NUMERIC(10, 3),
    pm10 NUMERIC(10, 3),
    pm25 NUMERIC(10, 3),
    so2 NUMERIC(10, 3)
);

COPY air_quality_db.rijeka_2_sve (date, time, benzen, co, no2, o3, pm10, pm25, so2)
FROM
    'C:\sql\air_quality_db\CSV\rijeka_2_sve.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

---------------------------------------------------------------------------------------
-- VIS---------------------------------------------------------------------------------
ALTER TABLE
    air_quality_db.hum_vis
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.hum_vis
SET
    location = 'Vis',
    station = 'Vis_Hum';

-- OSIJEK------------------------------------------------------------------------------
ALTER TABLE
    air_quality_db.osijek_1
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.osijek_1
SET
    location = 'Osijek',
    station = 'Osijek_1';

ALTER TABLE
    air_quality_db.osijek_2
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.osijek_2
SET
    location = 'Osijek',
    station = 'Osijek_2';

-- RIJEKA------------------------------------------------------------------------------
ALTER TABLE
    air_quality_db.rijeka_2_sve
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.rijeka_2_sve
SET
    location = 'Rijeka',
    station = 'Rijeka_2';

ALTER TABLE
    air_quality_db.rijeka_mlaka_sve
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.rijeka_mlaka_sve
SET
    location = 'Rijeka',
    station = 'Rijeka_Mlaka';

-- SPLIT-------------------------------------------------------------------------------
ALTER TABLE
    air_quality_db.splir_3_sve
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.splir_3_sve
SET
    location = 'Split',
    station = 'Split_3';

ALTER TABLE
    air_quality_db.split_1_sve
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.split_1_sve
SET
    location = 'Split',
    station = 'Split_1';

ALTER TABLE
    air_quality_db.split_2_2019_2022
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.split_2_2019_2022
SET
    location = 'Split',
    station = 'Split_2';

ALTER TABLE
    air_quality_db.split_2_2023_2025
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.split_2_2023_2025
SET
    location = 'Split',
    station = 'Split_2';

ALTER TABLE
    air_quality_db.split_sveti_kajo_2019_2022
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.split_sveti_kajo_2019_2022
SET
    location = 'Split',
    station = 'Split_sveti_kajo';

ALTER TABLE
    air_quality_db.split_sveti_kajo_2023_2025
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.split_sveti_kajo_2023_2025
SET
    location = 'Split',
    station = 'Split_sveti_kajo';

ALTER TABLE
    air_quality_db.lucka_split1922
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.lucka_split1922
SET
    location = 'Split',
    station = 'Split_lucka_uprava';

ALTER TABLE
    air_quality_db.lucka_split2325
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.lucka_split2325
SET
    location = 'Split',
    station = 'Split_lucka_uprava';

-- ZAGREB------------------------------------------------------------------------------
ALTER TABLE
    air_quality_db.zagreb_1_sve
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.zagreb_1_sve
SET
    location = 'Zagreb',
    station = 'Zagreb_1';

ALTER TABLE
    air_quality_db.zagreb_2_2019_2022
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.zagreb_2_2019_2022
SET
    location = 'Zagreb',
    station = 'Zagreb_2';

ALTER TABLE
    air_quality_db.zagreb_2_2023_2025
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.zagreb_2_2023_2025
SET
    location = 'Zagreb',
    station = 'Zagreb_2';

ALTER TABLE
    air_quality_db.zagreb_3_sve
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.zagreb_3_sve
SET
    location = 'Zagreb',
    station = 'Zagreb_3';

ALTER TABLE
    air_quality_db.zagreb_4_2019_2022
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.zagreb_4_2019_2022
SET
    location = 'Zagreb',
    station = 'Zagreb_4';

ALTER TABLE
    air_quality_db.zagreb_4_2023_2025
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.zagreb_4_2023_2025
SET
    location = 'Zagreb',
    station = 'Zagreb_4';

ALTER TABLE
    air_quality_db.zagreb_dordiceva_ulica_2019_2022
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.zagreb_dordiceva_ulica_2019_2022
SET
    location = 'Zagreb',
    station = 'Zagreb_Dordiceva_ulica';

ALTER TABLE
    air_quality_db.zagreb_dordiceva_ulica_2023_2025
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.zagreb_dordiceva_ulica_2023_2025
SET
    location = 'Zagreb',
    station = 'Zagreb_Dordiceva_ulica';

ALTER TABLE
    air_quality_db.zagreb_ksaverska_cesta_2019_2022
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.zagreb_ksaverska_cesta_2019_2022
SET
    location = 'Zagreb',
    station = 'Zagreb_ksaverska_cesta';

ALTER TABLE
    air_quality_db.zagreb_ksvaerska_cesta_2023_2025
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.zagreb_ksvaerska_cesta_2023_2025
SET
    location = 'Zagreb',
    station = 'Zagreb_ksaverska_cesta';

ALTER TABLE
    air_quality_db.zagreb_susedgrad_2019_2022
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.zagreb_susedgrad_2019_2022
SET
    location = 'Zagreb',
    station = 'Zagreb_susedgrad';

ALTER TABLE
    air_quality_db.zagreb_susedgrad_2023_2025
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.zagreb_susedgrad_2023_2025
SET
    location = 'Zagreb',
    station = 'Zagreb_susedgrad';

-- DUBROVNIK----------------------------------------------------------------------------
ALTER TABLE
    air_quality_db.zarkovica_dubrovnik_sve
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.zarkovica_dubrovnik_sve
SET
    location = 'Dubrovnik',
    station = 'Zarkovica_Dubrovnik';

ALTER TABLE
    air_quality_db.zracna_luka_dubrovnik_sve
ADD
    COLUMN location VARCHAR(50),
ADD
    COLUMN station VARCHAR(100);

UPDATE
    air_quality_db.zracna_luka_dubrovnik_sve
SET
    location = 'Dubrovnik',
    station = 'Zracna_luka_Dubrovnik';

-----------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.air_quality_all AS -- VIS-----------------------------------------------------------------------------------
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.hum_vis
UNION
ALL -- OSIJEK---------------------------------------------------------------------------------
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.osijek_1
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.osijek_2
UNION
ALL -- RIJEKA--------------------------------------------------------------------------------
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.rijeka_2_sve
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.rijeka_mlaka_sve
UNION
ALL -- SPLIT----------------------------------------------------------------------------------
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.splir_3_sve
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.split_1_sve
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.split_2_2019_2022
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.split_2_2023_2025
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.split_sveti_kajo_2019_2022
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.split_sveti_kajo_2023_2025
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.lucka_split1922
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.lucka_split2325
UNION
ALL -- ZAGREB---------------------------------------------------------------------------------
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.zagreb_1_sve
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.zagreb_2_2019_2022
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.zagreb_2_2023_2025
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.zagreb_3_sve
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.zagreb_4_2019_2022
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.zagreb_4_2023_2025
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.zagreb_dordiceva_ulica_2019_2022
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.zagreb_dordiceva_ulica_2023_2025
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.zagreb_ksaverska_cesta_2019_2022
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.zagreb_ksvaerska_cesta_2023_2025
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.zagreb_susedgrad_2019_2022
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.zagreb_susedgrad_2023_2025
UNION
ALL -- DUBROVNIK---------------------------------------------------------------------------
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.zarkovica_dubrovnik_sve
UNION
ALL
SELECT
    date,
    time,
    benzen,
    co,
    no2,
    o3,
    pm10,
    pm25,
    so2,
    location,
    station
FROM
    air_quality_db.zracna_luka_dubrovnik_sve;

---------------------------------------------------------------------------------------
ALTER TABLE
    air_quality_db.air_quality_all
ADD
    COLUMN id SERIAL PRIMARY KEY;

SELECT
    location,
    station,
    COUNT(*) AS number_of_rows
FROM
    air_quality_db.air_quality_all
GROUP BY
    location,
    station;

--------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.air_quality_all_unpivot AS
SELECT
    id,
    date,
    time,
    location,
    station,
    pollutant,
    measured_value
FROM
    air_quality_db.air_quality_all
    CROSS JOIN LATERAL (
        VALUES
            ('benzen', benzen),
            ('co', co),
            ('no2', no2),
            ('o3', o3),
            ('pm10', pm10),
            ('pm25', pm25),
            ('so2', so2)
    ) AS unpivot (pollutant, measured_value);

SELECT
    *
FROM
    air_quality_db.air_quality_all_unpivot
LIMIT
    500000;

SELECT
    *
FROM
    air_quality_db.air_quality_all_unpivot
    LEFT JOIN public.dim_date ON air_quality_db.air_quality_all_unpivot.date = public.dim_date.date
ALTER TABLE
    air_quality_db.air_quality_all_unpivot
ALTER COLUMN
    date TYPE DATE USING CASE
        WHEN TO_DATE(date, 'FMDay, FMMonth, DD.YYYY')
        ELSE TO_DATE(date, 'YYYY-MM-DD');

SELECT
    DISTINCT CASE
        WHEN LEFTWHEN LEFT(date, 1) BETWEEN '0'
        AND '9' AS broj_reedova
        FROM
            air_quality_db.air_quality_all_unpivot
        GROUP BY
            LEFT(date, 10)
        ORDER BY
            COUNT(*) DESC;

ALTER TABLE
    air_quality_db.air_quality_all_unpivot
ALTER COLUMN
    date TYPE DATE USING CASE
        WHEN date LIKE '%.%.%' THEN TO_DATE(date, 'DD.MM.YYYY')
        ELSE TO_DATE(date, 'FMDay, FMMonth DD, YYYY')
    END;

SELECT
    COUNT(*) AS br
FROM
    air_quality_db.air_quality_all_unpivot
SELECT
    COUNT(date) AS br
FROM
    air_quality_db.air_quality_all_unpivot
SELECT
    COUNT(*) AS br
FROM
    air_quality_db.air_quality_all
ALTER TABLE
    air_quality_db.air_quality_all_date
ADD
    CONSTRAINT date_id FOREIGN KEY (date_id) REFERENCES public.dim_date(date_id);

SELECT
    *
FROM
    air_quality_db.air_quality_all_time AS a
    LEFT JOIN public.dim_location AS t ON a.location = t.city
WHERE
    a.location IS NULL
    AND t.city IS NOT NULL
LIMIT
    500000
SELECT
    DISTINCT location
FROM
    air_quality_db.air_quality_all_time
GROUP BY
    location
SELECT
    DISTINCT a.location,
    LENGTH(a.location),
    t.country,
    LENGTH(t.country)
FROM
    air_quality_db.air_quality_all_time a,
    public.dim_location t
WHERE
    a.location = 'Zagreb'
    AND t.country = 'Zagreb';

SELECT
    DISTINCT location
FROM
    air_quality_db.air_quality_all_time;

SELECT
    DISTINCT country
FROM
    public.dim_location;

CREATE TABLE air_quality_db.air_quality_all_location AS
SELECT
    a.*,
    l.location_id
FROM
    air_quality_db.air_quality_all_time AS a
    LEFT JOIN public.dim_location AS l ON a.location = l.city
SELECT
    COUNT(*) AS bez_matcha
FROM
    air_quality_db.air_quality_all_location
WHERE
    location_id IS NULL;

ALTER TABLE
    air_quality_db.air_quality_all_location
ADD
    CONSTRAINT location_id FOREIGN KEY (location_id) REFERENCES public.dim_location(location_id);

ALTER TABLE
    air_quality_db.air_quality_all_location
ADD
    CONSTRAINT date_id FOREIGN KEY (date_id) REFERENCES public.dim_date(date_id);

ALTER TABLE
    air_quality_db.air_quality_all_location
ADD
    CONSTRAINT location_id FOREIGN KEY (location_id) REFERENCES public.dim_location(location_id);

CREATE TABLE air_quality_db.air_quality_all_sp AS
SELECT
    l.*,
    station_id,
    pollutant_id
FROM
    air_quality_db.air_quality_all_location AS l
    LEFT JOIN public.dim_station AS s ON l.station = s.station_name
    LEFT JOIN public.dim_pollutant AS p ON l.pollutant = p.pollutant_short
UPDATE
    public.dim_pollutant
SET
    pollutant_short = CASE
        WHEN pollutant_short = 'Benzen' THEN 'benzen'
        WHEN pollutant_short = 'CO' THEN 'co'
        WHEN pollutant_short = 'NO2' THEN 'no2'
        WHEN pollutant_short = 'O3' THEN 'o3'
        WHEN pollutant_short = 'PM 10' THEN 'pm10'
        WHEN pollutant_short = 'PM 2.5' THEN 'pm25'
        WHEN pollutant_short = 'SO2' THEN 'so2'
        ELSE pollutant_short
    END;

ALTER TABLE
    air_quality_db.air_quality_all_sp DROP COLUMN pollutant_id;

ALTER TABLE
    air_quality_db.air_quality_all_sp
ADD
    COLUMN pollutant_id SMALLINT;

UPDATE
    air_quality_db.air_quality_all_sp a
SET
    pollutant_id = p.pollutant_id
FROM
    public.dim_pollutant p
WHERE
    a.pollutant = p.pollutant_short;

ALTER TABLE
    air_quality_db.air_quality_all_sp
ADD
    COLUMN aq_index SMALLINT;

ALTER TABLE
    air_quality_db.air_quality_all_sp
ALTER COLUMN
    aq_index TYPE VARCHAR(30);

SELECT
    *
FROM
    air_quality_db.air_quality_all_sp --WHERE measured_value IS NULL
LIMIT
    50000
UPDATE
    air_quality_db.air_quality_all_sp
SET
    aq_index = CASE
        WHEN pollutant = 'pm25'
        AND measured_value <= 10 THEN 'Good'
        WHEN pollutant = 'pm25'
        AND measured_value <= 20 THEN 'Fair'
        WHEN pollutant = 'pm25'
        AND measured_value <= 25 THEN 'Moderate'
        WHEN pollutant = 'pm25'
        AND measured_value <= 50 THEN 'Poor'
        WHEN pollutant = 'pm25'
        AND measured_value > 50 THEN 'Very Poor'
        WHEN pollutant = 'pm10'
        AND measured_value <= 20 THEN 'Good'
        WHEN pollutant = 'pm10'
        AND measured_value <= 40 THEN 'Fair'
        WHEN pollutant = 'pm10'
        AND measured_value <= 50 THEN 'Moderate'
        WHEN pollutant = 'pm10'
        AND measured_value <= 100 THEN 'Poor'
        WHEN pollutant = 'pm10'
        AND measured_value > 100 THEN 'Very Poor'
        WHEN pollutant = 'no2'
        AND measured_value <= 40 THEN 'Good'
        WHEN pollutant = 'no2'
        AND measured_value <= 90 THEN 'Fair'
        WHEN pollutant = 'no2'
        AND measured_value <= 120 THEN 'Moderate'
        WHEN pollutant = 'no2'
        AND measured_value <= 230 THEN 'Poor'
        WHEN pollutant = 'no2'
        AND measured_value > 230 THEN 'Very Poor'
        WHEN pollutant = 'o3'
        AND measured_value <= 60 THEN 'Good'
        WHEN pollutant = 'o3'
        AND measured_value <= 120 THEN 'Fair'
        WHEN pollutant = 'o3'
        AND measured_value <= 180 THEN 'Moderate'
        WHEN pollutant = 'o3'
        AND measured_value <= 240 THEN 'Poor'
        WHEN pollutant = 'o3'
        AND measured_value > 240 THEN 'Very Poor'
        WHEN pollutant = 'so2'
        AND measured_value <= 100 THEN 'Good'
        WHEN pollutant = 'so2'
        AND measured_value <= 200 THEN 'Fair'
        WHEN pollutant = 'so2'
        AND measured_value <= 350 THEN 'Moderate'
        WHEN pollutant = 'so2'
        AND measured_value <= 500 THEN 'Poor'
        WHEN pollutant = 'so2'
        AND measured_value > 500 THEN 'Very Poor'
        ELSE NULL
    END;

ALTER TABLE
    air_quality_db.air_quality_all_sp
ADD
    COLUMN category_id SMALLINT;

UPDATE
    air_quality_db.air_quality_all_sp a
SET
    category_id = p.aqi_id
FROM
    public.dim_aqi_category p
WHERE
    a.aq_index = p.category_name;

SELECT
    COUNT(*) AS broj_nula
FROM
    air_quality_db.air_quality_all_sp
WHERE
    measured_value IS NULL;

ALTER TABLE
    air_quality_db.air_quality_all_sp RENAME COLUMN category_id TO aqi_id;

ALTER TABLE
    air_quality_db.air_quality_all_sp RENAME COLUMN id TO aqf_id;

ALTER TABLE
    air_quality_db.air_quality_all_sp
ALTER COLUMN
    aqi_id TYPE SMALLINT,
ALTER COLUMN
    station_id TYPE SMALLINT,
ALTER COLUMN
    location_id TYPE SMALLINT,
ALTER COLUMN
    date_id TYPE SMALLINT,
ALTER COLUMN
    pollutant_id TYPE SMALLINT,
ALTER COLUMN
    time_id TYPE SMALLINT,
ALTER COLUMN
    aqf_id TYPE INT;

ALTER TABLE
    air_quality_db.air_quality_all_sp DROP COLUMN aqf_id;

ALTER TABLE
    air_quality_db.air_quality_all_sp
ADD
    COLUMN aqf_id SERIAL PRIMARY KEY;

ALTER TABLE
    air_quality_db.air_quality_all_sp
ADD
    CONSTRAINT fk_aqi FOREIGN KEY (aqi_id) REFERENCES public.dim_aqi_category(aqi_id),
ADD
    CONSTRAINT fk_station FOREIGN KEY (station_id) REFERENCES public.dim_station(station_id),
ADD
    CONSTRAINT fk_location FOREIGN KEY (location_id) REFERENCES public.dim_location(location_id),
ADD
    CONSTRAINT fk_date FOREIGN KEY (date_id) REFERENCES public.dim_date(date_id),
ADD
    CONSTRAINT fk_pollutant FOREIGN KEY (pollutant_id) REFERENCES public.dim_pollutant(pollutant_id),
ADD
    CONSTRAINT fk_time FOREIGN KEY (time_id) REFERENCES public.dim_time(time_id);

SELECT
    COUNT(aqf_id)
FROM
    air_quality_db.air_quality_all_sp CREATE TABLE public.air_quality_fact AS
SELECT
    *
FROM
    air_quality_db.air_quality_all_sp;

DROP TABLE public.air_quality_fact -------------------------------------------------------------------------------------
CREATE INDEX idx_city_weather_fact_date ON public.city_weather_fact(date_id);

CREATE INDEX idx_city_weather_fact_time ON public.city_weather_fact(time_id);

CREATE INDEX idx_city_weather_fact_location ON public.city_weather_fact(location_id);

CREATE INDEX idx_air_quality_fact_date ON public.air_quality_fact(date_id);

CREATE INDEX idx_air_quality_fact_time ON public.air_quality_fact(time_id);

CREATE INDEX idx_air_quality_fact_pollutant ON public.air_quality_fact(pollutant_id);

CREATE INDEX idx_air_quality_fact_station ON public.air_quality_fact(station_id);

CREATE INDEX idx_air_quality_fact_aqi ON public.air_quality_fact(aqi_id);

SELECT
    *
FROM
    air_quality_db.air_quality_all_sp
LIMIT
    50000 
    
---------------------------------------------------------------------------------
    CREATE TABLE air_quality_db.dubrovnik_prognoza (
        time TIMESTAMP,
        temperature_2m_c NUMERIC(4, 1),
        relative_humidity_2m_pct NUMERIC(5, 2),
        rain_mm NUMERIC(5, 2),
        snowfall_cm NUMERIC(5, 2),
        precipitation_mm NUMERIC(5, 2),
        wind_speed_10m_kmh NUMERIC(5, 2),
        wind_speed_100m_kmh NUMERIC(5, 2),
        wind_direction_10m_deg SMALLINT,
        wind_direction_100m_deg SMALLINT,
        wind_gusts_10m_kmh NUMERIC(5, 2),
        pressure_msl_hpa NUMERIC(6, 2),
        surface_pressure_hpa NUMERIC(6, 2),
        cloud_cover_pct NUMERIC(5, 2),
        cloud_cover_low_pct NUMERIC(5, 2),
        cloud_cover_mid_pct NUMERIC(5, 2),
        cloud_cover_high_pct NUMERIC(5, 2),
        shortwave_radiation_wm2 NUMERIC(6, 2)
    );

COPY air_quality_db.dubrovnik_prognoza (
    time,
    temperature_2m_c,
    relative_humidity_2m_pct,
    rain_mm,
    snowfall_cm,
    precipitation_mm,
    wind_speed_10m_kmh,
    wind_speed_100m_kmh,
    wind_direction_10m_deg,
    wind_direction_100m_deg,
    wind_gusts_10m_kmh,
    pressure_msl_hpa,
    surface_pressure_hpa,
    cloud_cover_pct,
    cloud_cover_low_pct,
    cloud_cover_mid_pct,
    cloud_cover_high_pct,
    shortwave_radiation_wm2
)
FROM
    'C:\sql\air_quality_db\weather\Dubrovnik_prognoza.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

--------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.osijek_prognoza (
    time TIMESTAMP,
    temperature_2m_c NUMERIC(4, 1),
    relative_humidity_2m_pct NUMERIC(5, 2),
    rain_mm NUMERIC(5, 2),
    snowfall_cm NUMERIC(5, 2),
    precipitation_mm NUMERIC(5, 2),
    wind_speed_10m_kmh NUMERIC(5, 2),
    wind_speed_100m_kmh NUMERIC(5, 2),
    wind_direction_10m_deg SMALLINT,
    wind_direction_100m_deg SMALLINT,
    wind_gusts_10m_kmh NUMERIC(5, 2),
    pressure_msl_hpa NUMERIC(6, 2),
    surface_pressure_hpa NUMERIC(6, 2),
    cloud_cover_pct NUMERIC(5, 2),
    cloud_cover_low_pct NUMERIC(5, 2),
    cloud_cover_mid_pct NUMERIC(5, 2),
    cloud_cover_high_pct NUMERIC(5, 2),
    shortwave_radiation_wm2 NUMERIC(6, 2)
);

COPY air_quality_db.osijek_prognoza (
    time,
    temperature_2m_c,
    relative_humidity_2m_pct,
    rain_mm,
    snowfall_cm,
    precipitation_mm,
    wind_speed_10m_kmh,
    wind_speed_100m_kmh,
    wind_direction_10m_deg,
    wind_direction_100m_deg,
    wind_gusts_10m_kmh,
    pressure_msl_hpa,
    surface_pressure_hpa,
    cloud_cover_pct,
    cloud_cover_low_pct,
    cloud_cover_mid_pct,
    cloud_cover_high_pct,
    shortwave_radiation_wm2
)
FROM
    'C:\sql\air_quality_db\weather\Osijek_prognoza.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.split_prognoza (
    time TIMESTAMP,
    temperature_2m_c NUMERIC(4, 1),
    relative_humidity_2m_pct NUMERIC(5, 2),
    rain_mm NUMERIC(5, 2),
    snowfall_cm NUMERIC(5, 2),
    precipitation_mm NUMERIC(5, 2),
    wind_speed_10m_kmh NUMERIC(5, 2),
    wind_speed_100m_kmh NUMERIC(5, 2),
    wind_direction_10m_deg SMALLINT,
    wind_direction_100m_deg SMALLINT,
    wind_gusts_10m_kmh NUMERIC(5, 2),
    pressure_msl_hpa NUMERIC(6, 2),
    surface_pressure_hpa NUMERIC(6, 2),
    cloud_cover_pct NUMERIC(5, 2),
    cloud_cover_low_pct NUMERIC(5, 2),
    cloud_cover_mid_pct NUMERIC(5, 2),
    cloud_cover_high_pct NUMERIC(5, 2),
    shortwave_radiation_wm2 NUMERIC(6, 2)
);

COPY air_quality_db.split_prognoza (
    time,
    temperature_2m_c,
    relative_humidity_2m_pct,
    rain_mm,
    snowfall_cm,
    precipitation_mm,
    wind_speed_10m_kmh,
    wind_speed_100m_kmh,
    wind_direction_10m_deg,
    wind_direction_100m_deg,
    wind_gusts_10m_kmh,
    pressure_msl_hpa,
    surface_pressure_hpa,
    cloud_cover_pct,
    cloud_cover_low_pct,
    cloud_cover_mid_pct,
    cloud_cover_high_pct,
    shortwave_radiation_wm2
)
FROM
    'C:\sql\air_quality_db\weather\Split_prognoza.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

-------------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.vis_prognoza (
    time TIMESTAMP,
    temperature_2m_c NUMERIC(4, 1),
    relative_humidity_2m_pct NUMERIC(5, 2),
    rain_mm NUMERIC(5, 2),
    snowfall_cm NUMERIC(5, 2),
    precipitation_mm NUMERIC(5, 2),
    wind_speed_10m_kmh NUMERIC(5, 2),
    wind_speed_100m_kmh NUMERIC(5, 2),
    wind_direction_10m_deg SMALLINT,
    wind_direction_100m_deg SMALLINT,
    wind_gusts_10m_kmh NUMERIC(5, 2),
    pressure_msl_hpa NUMERIC(6, 2),
    surface_pressure_hpa NUMERIC(6, 2),
    cloud_cover_pct NUMERIC(5, 2),
    cloud_cover_low_pct NUMERIC(5, 2),
    cloud_cover_mid_pct NUMERIC(5, 2),
    cloud_cover_high_pct NUMERIC(5, 2),
    shortwave_radiation_wm2 NUMERIC(6, 2)
);

COPY air_quality_db.vis_prognoza (
    time,
    temperature_2m_c,
    relative_humidity_2m_pct,
    rain_mm,
    snowfall_cm,
    precipitation_mm,
    wind_speed_10m_kmh,
    wind_speed_100m_kmh,
    wind_direction_10m_deg,
    wind_direction_100m_deg,
    wind_gusts_10m_kmh,
    pressure_msl_hpa,
    surface_pressure_hpa,
    cloud_cover_pct,
    cloud_cover_low_pct,
    cloud_cover_mid_pct,
    cloud_cover_high_pct,
    shortwave_radiation_wm2
)
FROM
    'C:\sql\air_quality_db\weather\Vis_prognoza.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

-------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.zagreb_prognoza (
    time TIMESTAMP,
    temperature_2m_c NUMERIC(4, 1),
    relative_humidity_2m_pct NUMERIC(5, 2),
    rain_mm NUMERIC(5, 2),
    snowfall_cm NUMERIC(5, 2),
    precipitation_mm NUMERIC(5, 2),
    wind_speed_10m_kmh NUMERIC(5, 2),
    wind_speed_100m_kmh NUMERIC(5, 2),
    wind_direction_10m_deg SMALLINT,
    wind_direction_100m_deg SMALLINT,
    wind_gusts_10m_kmh NUMERIC(5, 2),
    pressure_msl_hpa NUMERIC(6, 2),
    surface_pressure_hpa NUMERIC(6, 2),
    cloud_cover_pct NUMERIC(5, 2),
    cloud_cover_low_pct NUMERIC(5, 2),
    cloud_cover_mid_pct NUMERIC(5, 2),
    cloud_cover_high_pct NUMERIC(5, 2),
    shortwave_radiation_wm2 NUMERIC(6, 2)
);

COPY air_quality_db.zagreb_prognoza (
    time,
    temperature_2m_c,
    relative_humidity_2m_pct,
    rain_mm,
    snowfall_cm,
    precipitation_mm,
    wind_speed_10m_kmh,
    wind_speed_100m_kmh,
    wind_direction_10m_deg,
    wind_direction_100m_deg,
    wind_gusts_10m_kmh,
    pressure_msl_hpa,
    surface_pressure_hpa,
    cloud_cover_pct,
    cloud_cover_low_pct,
    cloud_cover_mid_pct,
    cloud_cover_high_pct,
    shortwave_radiation_wm2
)
FROM
    'C:\sql\air_quality_db\weather\Zagreb_prognoza.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

--------------------------------------------------------------------------------------
CREATE TABLE air_quality_db.rijeka_prognoza (
    time TIMESTAMP,
    temperature_2m_c NUMERIC(4, 1),
    relative_humidity_2m_pct NUMERIC(5, 2),
    rain_mm NUMERIC(5, 2),
    snowfall_cm NUMERIC(5, 2),
    precipitation_mm NUMERIC(5, 2),
    wind_speed_10m_kmh NUMERIC(5, 2),
    wind_speed_100m_kmh NUMERIC(5, 2),
    wind_direction_10m_deg SMALLINT,
    wind_direction_100m_deg SMALLINT,
    wind_gusts_10m_kmh NUMERIC(5, 2),
    pressure_msl_hpa NUMERIC(6, 2),
    surface_pressure_hpa NUMERIC(6, 2),
    cloud_cover_pct NUMERIC(5, 2),
    cloud_cover_low_pct NUMERIC(5, 2),
    cloud_cover_mid_pct NUMERIC(5, 2),
    cloud_cover_high_pct NUMERIC(5, 2),
    shortwave_radiation_wm2 NUMERIC(6, 2)
);

COPY air_quality_db.rijeka_prognoza (
    time,
    temperature_2m_c,
    relative_humidity_2m_pct,
    rain_mm,
    snowfall_cm,
    precipitation_mm,
    wind_speed_10m_kmh,
    wind_speed_100m_kmh,
    wind_direction_10m_deg,
    wind_direction_100m_deg,
    wind_gusts_10m_kmh,
    pressure_msl_hpa,
    surface_pressure_hpa,
    cloud_cover_pct,
    cloud_cover_low_pct,
    cloud_cover_mid_pct,
    cloud_cover_high_pct,
    shortwave_radiation_wm2
)
FROM
    'C:\sql\air_quality_db\weather\Rijeka_prognoza.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );

--------------------------------------------------------------------------------

ALTER TABLE
    air_quality_db.dubrovnik_prognoza
ADD COLUMN date DATE,
ADD COLUMN location VARCHAR(50),
ADD COLUMN wf_id INT


ALTER TABLE
    air_quality_db.split_prognoza
ADD COLUMN date DATE,
ADD COLUMN location VARCHAR(50),
ADD COLUMN wf_id INT


ALTER TABLE
    air_quality_db.zagreb_prognoza
ADD COLUMN date DATE,
ADD COLUMN location VARCHAR(50),
ADD COLUMN wf_id INT


ALTER TABLE
    air_quality_db.rijeka_prognoza
ADD COLUMN date DATE,
ADD COLUMN location VARCHAR(50),
ADD COLUMN wf_id INT


ALTER TABLE
    air_quality_db.osijek_prognoza
ADD COLUMN date DATE,
ADD COLUMN location VARCHAR(50),
ADD COLUMN wf_id INT


ALTER TABLE air_quality_db.vis_prognoza
ADD COLUMN date DATE,
ADD COLUMN location VARCHAR(50),
ADD COLUMN wf_id INT


UPDATE air_quality_db.vis_prognoza
SET location = 'Vis',
    date = time::DATE;

SELECT * FROM air_quality_db.vis_prognoza

UPDATE air_quality_db.rijeka_prognoza
SET location = 'Rijeka',
    date = time::DATE;


    UPDATE air_quality_db.zagreb_prognoza
SET location = 'Zagreb',
    date = time::DATE;


    UPDATE air_quality_db.split_prognoza
SET location = 'Split',
    date = time::DATE;


    UPDATE air_quality_db.osijek_prognoza
SET location = 'Osijek',
    date = time::DATE;


    UPDATE air_quality_db.dubrovnik_prognoza
SET location = 'Dubrovnik',
    date = time::DATE;

SELECT air_quality_db.split_prognoza
UNION ALL


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

ALTER TABLE air_quality_db.wether_fact_union
ALTER COLUMN time TYPE TIME

ALTER TABLE air_quality_db.wether_fact_union
ADD CONSTRAINT wf_id INT SERIAL PRIMARY KEY

ALTER TABLE air_quality_db.wether_fact_union
DROP COLUMN wf_id;
ALTER TABLE air_quality_db.wether_fact_union
ADD COLUMN wf_id SERIAL PRIMARY KEY;

SELECT * FROM air_quality_db.wether_fact_union

ALTER TABLE air_quality_db.wether_fact_union
ADD COLUMN fk_location_id SMALLINT,
ADD COLUMN fk_date_id SMALLINT,
ADD COLUMN fk_time_id SMALLINT;

UPDATE air_quality_db.wether_fact_union AS a
SET 
    fk_location_id = l.location_id,
    fk_date_id = d.date_id,
    fk_time_id = t.time_id
FROM 
    public.dim_location AS l,
    public.dim_date AS d,
    public.dim_time AS t
WHERE 
    a.location = l.city
    AND a.date = d.date
    AND a.time = t.time;

SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'air_quality_db'
AND table_name = 'wether_fact_union'
ORDER BY ordinal_position;

SELECT *
FROM air_quality_db.wether_fact_union 
WHERE time IS NULL;

UPDATE air_quality_db.air_quality_all_sp
SET measured_value = CASE 
    -- CO
    WHEN pollutant = 'co' AND measured_value BETWEEN -0.5 AND 0 THEN 0
    WHEN pollutant = 'co' AND (measured_value < -0.5 OR measured_value > 50000) THEN NULL
    -- NO2
    WHEN pollutant = 'no2' AND measured_value BETWEEN -0.5 AND 0 THEN 0
    WHEN pollutant = 'no2' AND (measured_value < -0.5 OR measured_value > 1000) THEN NULL
    -- PM10
    WHEN pollutant = 'pm10' AND measured_value BETWEEN -0.5 AND 0 THEN 0
    WHEN pollutant = 'pm10' AND (measured_value < -0.5 OR measured_value > 2000) THEN NULL
    -- PM2.5
    WHEN pollutant = 'pm25' AND measured_value BETWEEN -0.5 AND 0 THEN 0
    WHEN pollutant = 'pm25' AND (measured_value < -0.5 OR measured_value > 1000) THEN NULL
    -- SO2
    WHEN pollutant = 'so2' AND measured_value BETWEEN -0.5 AND 0 THEN 0
    WHEN pollutant = 'so2' AND (measured_value < -0.5 OR measured_value > 2000) THEN NULL
    -- O3
    WHEN pollutant = 'o3' AND measured_value BETWEEN -0.5 AND 0 THEN 0
    WHEN pollutant = 'o3' AND (measured_value < -0.5 OR measured_value > 600) THEN NULL
    -- Benzen
    WHEN pollutant = 'benzen' AND measured_value BETWEEN -0.5 AND 0 THEN 0
    WHEN pollutant = 'benzen' AND (measured_value < -0.5 OR measured_value > 100) THEN NULL

    ELSE measured_value
END;

SELECT COUNT(*) 
FROM air_quality_db.air_quality_all_sp
WHERE measured_value IS NULL;
SELECT *
FROM air_quality_db.air_quality_all_sp
LIMIT 5000

ALTER TABLE air_quality_db.air_quality_all_sp
RENAME COLUMN date_id TO fk_date_id;

ALTER TABLE air_quality_db.air_quality_all_sp
RENAME COLUMN time_id TO fk_time_id;

ALTER TABLE air_quality_db.air_quality_all_sp
RENAME COLUMN pollutant_id TO fk_pollutant_id;

ALTER TABLE air_quality_db.air_quality_all_sp
RENAME COLUMN aqi_id TO fk_aqi_id;

ALTER TABLE air_quality_db.air_quality_all_sp
RENAME COLUMN station_id TO fk_station_id;

ALTER TABLE air_quality_db.air_quality_all_sp
RENAME COLUMN location_id TO fk_location_id;

ALTER TABLE air_quality_db.air_quality_all_sp
RENAME COLUMN aqf_id TO pk_aqf_id;

-- Broj redova
SELECT COUNT(*) AS row_count 
FROM air_quality_db.air_quality_all_sp;

-- Broj stupaca + detalji
SELECT 
    COUNT(*) AS column_count
FROM information_schema.columns
WHERE table_schema = 'air_quality_db'
  AND table_name = 'air_quality_all_sp';

-- Sve zajedno: stupci, tipovi, nullable
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'air_quality_db'
  AND table_name = 'air_quality_all_sp'
ORDER BY ordinal_position;

ALTER TABLE air_quality_db.wether_fact_union 
RENAME COLUMN wf_id TO pk_wf_id;


