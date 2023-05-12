import pika
from pika.exchange_type import ExchangeType

connection_parameters = pika.ConnectionParameters('localhost')
connection = pika.BlockingConnection(connection_parameters)
channel = connection.channel()

# Enables Publish Confirms
channel.confirm_delivery()

# Enables Transactions
channel.tx_select()

channel.exchange_declare(exchange='pubsub', exchange_type=ExchangeType.fanout)

# Create a durable queue that survives reboots
channel.queue_declare("Test", durable=True)

message = "Hello world"
channel.basic_publish(
    exchange='pubsub',
    routing_key='',
    properties=pika.BasicProperties(
        headers={'name': 'brian'},
        delivery_mode=1,
        expiration=134321,
        content_type="application/json"
    ),
    body=message,
    # Set the publishing to be mandatory - i.e. receive a notification of failure
    mandatory=True
)

# Commit the transaction
channel.tx_commit()

# Rollback the transaction
channel.tx_rollback()

print(f"sent message: {message}")

connection.close()