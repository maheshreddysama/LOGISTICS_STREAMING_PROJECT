import json
import time
import random
from kafka import KafkaProducer
from datetime import datetime

producer = KafkaProducer(
    bootstrap_servers='localhost:9092',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

driver_ids = [101, 102]

print("Sending telemetry data to Kafka... Press Ctrl+C to stop.")
while True:
    data = {
        "event_time": datetime.utcnow().isoformat(),
        "driver_id": random.choice(driver_ids),
        "latitude": round(random.uniform(43.0, 44.0), 4),
        "longitude": round(random.uniform(-80.0, -79.0), 4),
        "speed_kmh": random.randint(80, 130) # Simulating occasional speeding (>100)
    }
    producer.send('truck_telemetry', value=data)
    print(f"Sent: {data}")
    time.sleep(2) # Send a new ping every 2 seconds