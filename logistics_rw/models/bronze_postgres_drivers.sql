{{ config(materialized='table_with_connector') }}

CREATE TABLE {{ this }} (
    driver_id INT PRIMARY KEY,
    name VARCHAR,
    home_base VARCHAR
) WITH (
    connector = 'postgres-cdc',
    hostname = 'postgres',
    port = '5432',
    username = 'admin',
    password = 'password',
    database.name = 'logistics_db',
    schema.name = 'public',
    table.name = 'drivers'
)