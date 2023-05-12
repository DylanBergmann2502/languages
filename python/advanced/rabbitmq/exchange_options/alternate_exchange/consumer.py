import pika
from pika.exchange_type import ExchangeType


def alt_queue_on_message_received(ch, method, properties, body):
    print(f"Alt: received new message: {body}")


def main_queue_on_message_received(ch, method, properties, body):
    print(f"Main: received new message: {body}")


connection_parameters = pika.ConnectionParameters('localhost')
connection = pika.BlockingConnection(connection_parameters)
channel = connection.channel()

channel.exchange_declare(exchange='alternate', exchange_type=ExchangeType.fanout)
channel.exchange_declare(exchange='main',
                         exchange_type=ExchangeType.direct,
                         arguments={'alternate-exchange': 'alternate'})

channel.queue_declare(queue='alternate-queue')
channel.queue_bind(queue='alternate-queue',exchange='alternate')
channel.basic_consume(queue='alternate-queue', auto_ack=True, on_message_callback=alt_queue_on_message_received)

channel.queue_declare(queue='main-queue')
channel.queue_bind(queue='main-queue',exchange='main', routing_key='test')
channel.basic_consume(queue='main-queue', auto_ack=True, on_message_callback=main_queue_on_message_received)

print("Starting Consuming")
channel.start_consuming()