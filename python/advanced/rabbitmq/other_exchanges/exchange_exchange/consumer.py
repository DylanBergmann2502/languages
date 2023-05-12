import pika
from pika.exchange_type import ExchangeType


def on_message_received(ch, method, properties, body):
    print(f"received new message: {body}")


connection_parameters = pika.ConnectionParameters('localhost')
connection = pika.BlockingConnection(connection_parameters)
channel = connection.channel()

channel.exchange_declare(exchange='exchange_2', exchange_type=ExchangeType.fanout)
channel.queue_declare(queue='letterbox')
channel.queue_bind('letterbox', 'exchange_2')

channel.basic_consume(queue='letterbox', auto_ack=True, on_message_callback=on_message_received)

print("Starting Consuming")
channel.start_consuming()