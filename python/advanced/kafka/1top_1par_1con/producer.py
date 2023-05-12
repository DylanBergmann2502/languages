import json
import time
from kafka import KafkaProducer
from data import get_registered_user


def json_serializer(data):
    return json.dumps(data).encode('utf-8')

# All messages will be published to P0 partition
# All messages will be consumed by Consumer 1(C1)
producer = KafkaProducer(bootstrap_servers=['localhost:9092'], value_serializer=json_serializer)

if __name__ == "__main__":
    while True:
        registered_user = get_registered_user()
        print(registered_user)
        # (topic name to pub message, message)
        producer.send("registered_user", registered_user)
        time.sleep(4)