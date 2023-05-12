import pika
from pika.exchange_type import ExchangeType

connection_parameters = pika.ConnectionParameters('localhost')
connection = pika.BlockingConnection(connection_parameters)
channel = connection.channel()

channel.exchange_declare(exchange='exchange_1', exchange_type=ExchangeType.direct)
channel.exchange_declare(exchange='exchange_2', exchange_type=ExchangeType.fanout)
channel.exchange_bind('exchange_2', 'exchange_1')

message = "This message has gone through multiple exchanges"
channel.basic_publish(exchange='exchange_1', routing_key='', body=message)
print(f"sent message: {message}")

connection.close()