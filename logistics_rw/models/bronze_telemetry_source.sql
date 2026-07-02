{{ config(materialized='source') }}

CREATE SOURCE {{ this }} (
    event_time TIMESTAMP,
    driver_id INT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    speed_kmh INT
) WITH (
    connector = 'kafka',
    topic = 'truck_telemetry',
    -- Update this specific line in the WITH clause
    properties.bootstrap.server = 'kafka:29092', 
    scan.startup.mode = 'earliest'
) FORMAT PLAIN ENCODE JSON