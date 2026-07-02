{{ config(materialized='materialized_view') }}

SELECT 
    d.name AS driver_name,
    d.home_base,
    COUNT(*) AS total_speeding_violations,
    MAX(t.speed_kmh) AS highest_speed_recorded
FROM {{ ref('bronze_telemetry_source') }} t
JOIN {{ ref('bronze_postgres_drivers') }} d 
  ON t.driver_id = d.driver_id
WHERE t.speed_kmh > 105
GROUP BY d.name, d.home_base