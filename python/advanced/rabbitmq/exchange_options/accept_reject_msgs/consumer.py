import pika
from pika.exchange_type import ExchangeType


def on_message_received(ch, method, properties, body):
    # ch.basic_ack(delivery_tag=method.delivery_tag, multiple=True)

    # if method.delivery_tag % 5 == 0:
    #     ch.basic_ack(delivery_tag=method.delivery_tag, multiple=True)

    if method.delivery_tag % 5 == 0:
        # requeue=True => send msg in an infinite loop
        ch.basic_nack(delivery_tag=method.delivery_tag, requeue=False, multiple=True)

    print(f"received new message: {body}")


connection_parameters = pika.ConnectionParameters('localhost')
connection = pika.BlockingConnection(connection_parameters)
channel = connection.channel()

channel.exchange_declare(exchange='accept_reject', exchange_type=ExchangeType.fanout)
message = 'Let\'s send this'

channel.queue_declare(queue='letterbox')
channel.queue_bind(exchange='accept_reject', queue='letterbox', routing_key='test')
channel.basic_consume(queue='letterbox', on_message_callback=on_message_received)

print("Starting Consuming")
channel.start_consuming()