from kafka import KafkaConsumer
import json

if __name__ == '__main__':
    # (topic to consume from, , ,)
    consumer = KafkaConsumer(
        'registered_user',
        bootstrap_servers=['localhost:9092'],
        auto_offset_reset='earliest', # always read from the 0 offset
        group_id="consumer-group-a"
    )
    print("Starting the consumer")
    for msg in consumer:
        print("Registered User: {}".format(json.loads(msg.value)))