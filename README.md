# LOGISTICS_STREAMING_PROJECT
# Real-Time Fleet Telematics Streaming Pipeline

## 🚛 Project Overview
This project simulates a real-time event-streaming data pipeline for a modern logistics and carrier business. It processes high-throughput truck telemetry data (GPS, speed) and joins it with operational dimensional data (driver profiles) to maintain a live dashboard of speeding violations.

Traditional batch ETL pipelines (e.g., running daily jobs) are too slow for operational logistics where fleet managers need to know about speeding violations or route deviations the moment they happen. This project solves that latency problem by shifting to a **streaming Medallion Architecture**, processing data as it arrives.

## 🛠️ Tech Stack & Tools
* **PostgreSQL:** Acts as the operational database (OLTP) storing slowly changing dimensional data (driver names, home bases).
* **Change Data Capture (CDC):** Configured on PostgreSQL to capture row-level changes (Inserts/Updates) in real-time without heavy querying.
* **Apache Kafka:** The central nervous system message broker. It ingests continuous, high-throughput JSON telemetry streams.
* **RisingWave:** A distributed SQL streaming database. It connects to both Kafka and Postgres via CDC, processes the continuous streams, and updates materialized views in milliseconds.
* **dbt (Data Build Tool):** Used for analytics engineering. It applies software engineering best practices to our SQL transformations, orchestrating the pipeline from raw sources (Bronze) to aggregated alerts (Gold).
* **Python:** Used to simulate IoT truck sensors, generating random telemetry payloads and pushing them to Kafka.
* **Docker Compose:** Containerizes the entire infrastructure for a reproducible local development environment.

## 🌊 Data Flow Architecture
1. **Event Generation:** A Python script generates live JSON telemetry (timestamp, driver_id, location, speed) and publishes it to a Kafka topic (`truck_telemetry`).
2. **CDC Replication:** PostgreSQL logical replication tracks changes to the `public.drivers` table.
3. **Stream Ingestion (Bronze):** RisingWave connects to Kafka and Postgres-CDC via dbt `source` and `table_with_connector` models.
4. **Real-Time Aggregation (Gold):** A dbt `materialized_view` joins the live Kafka stream with the Postgres driver profiles, filtering for speeds > 105 km/h, and continuously increments a violation count per driver.

## 📂 Project Structure
```text
logistics_streaming_project/
│
├── docker-compose.yml          # Infrastructure configuration (Kafka, Postgres, RisingWave)
├── generate_telemetry.py       # Python IoT sensor simulator
├── .gitignore                  # Git exclusion rules for environments and logs
│
└── logistics_rw/               # dbt project directory
    ├── dbt_project.yml         # dbt configuration
    └── models/
        ├── bronze_telemetry_source.sql  # Kafka connection model
        ├── bronze_postgres_drivers.sql  # Postgres CDC connection model
        └── gold_speeding_alerts.sql     # Live streaming join and aggregation
