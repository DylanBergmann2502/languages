import pika
import time
import random

connection_params = pika.ConnectionParameters('localhost')
connection = pika.BlockingConnection(connection_params)
channel = connection.channel()

channel.queue_declare(queue='letterbox')

message_id = 1

while True:
    message = f"Sending message: {message_id}"

    # exchange without specifying anything = Default Exchange
    channel.basic_publish(exchange='', routing_key='letterbox', body=message)

    print(f'sent message: {message}')

    time.sleep(random.randint(1,4))

    message_id += 1