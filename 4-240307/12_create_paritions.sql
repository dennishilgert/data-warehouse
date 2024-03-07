-- Create the partitioned fact table
CREATE TABLE mart.fact_messung (
    dim_fahrzeug_id INT NOT NULL,
    gesendet TIMESTAMP WITH TIME ZONE NOT NULL,
    empfangen TIMESTAMP WITH TIME ZONE NOT NULL,
    geschwindigkeit INT NOT NULL,
    CONSTRAINT pk_fact_messung PRIMARY KEY (dim_fahrzeug_id, empfangen)
) PARTITION BY RANGE (empfangen);

-- Create the partitions for 2023 and 2024
CREATE TABLE mart.fact_messung_2023 PARTITION OF mart.fact_messung
    FOR VALUES FROM (MINVALUE) TO ('2024-01-01 00:00:00+00');

CREATE TABLE mart.fact_messung_2024 PARTITION OF mart.fact_messung
    FOR VALUES FROM ('2024-01-01 00:00:00+00') TO ('2025-01-01 00:00:00+00');


-- Load data into mart.fact_messung table
INSERT INTO mart.fact_messung (dim_fahrzeug_id, gesendet, empfangen, geschwindigkeit)
SELECT 
    f.dim_fahrzeug_id,
    to_timestamp((m.payload->>'zeit')::BIGINT) AT TIME ZONE 'UTC' as gesendet,
    m.empfangen,
    (m.payload->>'geschwindigkeit')::INT
FROM staging.messung m
JOIN mart.dim_fahrzeug f ON m.payload->>'fin' = f.fin;


-- Create 1min sampling view the simple way
CREATE OR REPLACE VIEW mart.agg_sampling_1min AS
SELECT
    dim_fahrzeug_id,
    date_trunc('minute', gesendet) AS minute_interval,
    AVG(geschwindigkeit) AS durch_geschw,
    COUNT(*) AS anzahl
FROM
    mart.fact_messung
GROUP BY
    dim_fahrzeug_id,
    date_trunc('minute', gesendet);

-- Create 1min sampling view the hard way
CREATE OR REPLACE VIEW mart.agg_sampling_1min_complete AS
WITH time_series AS (
    SELECT generate_series(
        date_trunc('minute', MIN(gesendet)), -- Start des Zeitintervalls
        date_trunc('minute', MAX(gesendet)), -- Ende des Zeitintervalls
        '1 minute'::interval -- Intervallgröße
    ) AS minute_interval
    FROM mart.fact_messung
),
aggregated_data AS (
    SELECT 
        fm.dim_fahrzeug_id, 
        date_trunc('minute', fm.gesendet) AS minute_interval, 
        AVG(fm.geschwindigkeit) AS durch_geschw, 
        COUNT(*) AS anzahl_messungen
    FROM mart.fact_messung fm
    GROUP BY fm.dim_fahrzeug_id, date_trunc('minute', fm.gesendet)
)
SELECT 
    ts.minute_interval, 
    ad.dim_fahrzeug_id, 
    ad.durch_geschw, 
    ad.anzahl_messungen
FROM time_series ts
LEFT JOIN aggregated_data ad ON ts.minute_interval = ad.minute_interval
ORDER BY ad.dim_fahrzeug_id, ts.minute_interval;
