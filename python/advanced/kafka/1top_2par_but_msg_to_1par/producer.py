import json
import time

from kafka import KafkaProducer

from data import get_registered_user


# This is 1 topic 2 partitions, the message will only go to 1 partition of the 2
def json_serializer(data):
    return json.dumps(data).encode('utf-8')


def get_partition(key, all, available):
    return 0


producer = KafkaProducer(bootstrap_server=['localhost:9092'],
                         value_serializer=json_serializer,
                         partitioner=get_partition)

if __name__ == "__main__":
    while True:
        registered_user = get_registered_user()
        print(registered_user)
        # (topic name, message)
        producer.send("registered_user", registered_user)
        time.sleep(4)