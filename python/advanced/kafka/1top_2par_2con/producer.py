import json
import time

from kafka import KafkaProducer

from data import get_registered_user


# 2 consumers belong to the same group
def json_serializer(data):
    return json.dumps(data).encode('utf-8')


producer = KafkaProducer(bootstrap_servers=['localhost:9092'], value_serializer=json_serializer)

if __name__ == "__main__":
    while True:
        registered_user = get_registered_user()
        print(registered_user)
        # (topic name to pub message, message)
        producer.send("registered_user", registered_user)
        time.sleep(4)