import pika
from pika.exchange_type import ExchangeType

connection_parameters = pika.ConnectionParameters('localhost')
connection = pika.BlockingConnection(connection_parameters)
channel = connection.channel()

channel.exchange_declare(exchange='headers', exchange_type=ExchangeType.headers)

message = "This message will be sent with headers"
channel.basic_publish(
    exchange='headers',
    routing_key='',
    properties=pika.BasicProperties(headers={'name': 'brian'}),
    body=message)
print(f"sent message: {message}")

connection.close()