import pika

connection_parameters = pika.ConnectionParameters('localhost')
connection = pika.BlockingConnection(connection_parameters)
channel = connection.channel()

channel.exchange_declare(exchange='hashing', exchange_type='x-consistent-hash')

routing_key = "Hash me!"
message = "This is core message"
channel.basic_publish(
    exchange='hashing',
    routing_key=routing_key,
    body=message)
print(f"sent message: {message}")

connection.close()