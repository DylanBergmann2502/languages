import pika
from pika.exchange_type import ExchangeType

connection_parameters = pika.ConnectionParameters('localhost')
connection = pika.BlockingConnection(connection_parameters)
channel = connection.channel()


channel.exchange_declare(exchange='alternate', exchange_type=ExchangeType.fanout)
channel.exchange_declare(exchange='main',
                         exchange_type=ExchangeType.direct,
                         arguments={'alternate-exchange': 'alternate'})

message = "Hello this is my first message"
channel.basic_publish(exchange='main', routing_key='simple', body=message)
print(f"sent message: {message}")

connection.close()