# Creating bytes objects
empty_bytes = bytes()
from_string = bytes("Hello, World!", "utf-8")
from_iterable = bytes([72, 101, 108, 108, 111])  # ASCII values for "Hello"
literal_bytes = b"Hello"  # Byte literal
zeros = bytes(5)  # Creates 5 null bytes

# Printing bytes objects
print("Empty bytes:", empty_bytes)  # b''
print("Bytes from string:", from_string)  # b'Hello, World!'
print("Bytes from iterable:", from_iterable)  # b'Hello'
print("Byte literal:", literal_bytes)  # b'Hello'
print("Five zeros:", zeros)  # b'\x00\x00\x00\x00\x00'

# Accessing bytes elements
print("\nAccessing bytes elements:")
print("First byte as integer:", from_string[0])  # 72 (ASCII for 'H')
print("Second byte as integer:", from_string[1])  # 101 (ASCII for 'e')

# Slicing bytes
print("\nSlicing bytes:")
print("First 5 bytes:", from_string[:5])  # b'Hello'
print("Last 6 bytes:", from_string[-6:])  # b'World!'

# Bytes are immutable
print("\nBytes immutability:")
try:
    from_string[0] = 74  # This will raise a TypeError
except TypeError as e:
    print("Error when modifying bytes:", e)  # 'bytes' object does not support item assignment

# Converting between bytes and other types
print("\nConversions:")
# String to bytes
string_value = "Python bytecode"
string_to_bytes = string_value.encode("utf-8")
print("String to bytes:", string_to_bytes)  # b'Python bytecode'

# Bytes to string
bytes_to_string = from_string.decode("utf-8")
print("Bytes to string:", bytes_to_string)  # Hello, World!

# Bytes to list of integers
bytes_to_list = list(from_string)
print("Bytes to list:", bytes_to_list)  # [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]

# Hexadecimal representation
hex_representation = from_string.hex()
print("Hex representation:", hex_representation)  # 48656c6c6f2c20576f726c6421

# From hex back to bytes
from_hex = bytes.fromhex(hex_representation)
print("From hex to bytes:", from_hex)  # b'Hello, World!'

# Bytes operations
print("\nBytes operations:")
print("Length of bytes:", len(from_string))  # 13

# Concatenation
combined = literal_bytes + b", Python!"
print("Concatenated bytes:", combined)  # b'Hello, Python!'

# Repetition
repeated = literal_bytes * 3
print("Repeated bytes:", repeated)  # b'HelloHelloHello'

# Membership
print("Is byte 101 in from_string?", 101 in from_string)  # True (ASCII for 'e')
print("Is byte sequence b'Hello' in from_string?", b'Hello' in from_string)  # True

# Finding
print("Find position of b'World':", from_string.find(b'World'))  # 7
print("Count occurrences of b'l':", from_string.count(b'l'))  # 3

# ByteArray - mutable version of bytes
print("\nByteArray:")
byte_array = bytearray(b"Hello")
print("Original bytearray:", byte_array)  # bytearray(b'Hello')

# Modifying bytearray
byte_array[0] = 74  # ASCII for 'J'
print("Modified bytearray:", byte_array)  # bytearray(b'Jello')

# Append to bytearray
byte_array.append(33)  # ASCII for '!'
print("After append:", byte_array)  # bytearray(b'Jello!')

# Extend bytearray
byte_array.extend(b" World")
print("After extend:", byte_array)  # bytearray(b'Jello! World')

# Insert into bytearray
byte_array.insert(6, 45)  # ASCII for '-'
print("After insert:", byte_array)  # bytearray(b'Jello!- World')

# Remove from bytearray
byte_array.remove(45)  # Remove the '-' character (ASCII 45)
print("After remove:", byte_array)  # bytearray(b'Jello! World')

# Converting between bytearray and other types
print("\nByteArray conversions:")
# To bytes
bytearray_to_bytes = bytes(byte_array)
print("ByteArray to bytes:", bytearray_to_bytes)  # b'Jello! World'

# To string
bytearray_to_string = byte_array.decode("utf-8")
print("ByteArray to string:", bytearray_to_string)  # Jello! World

# Practical uses: Reading binary files
print("\nReading binary file:")
import os

# Create a small binary file
with open("sample.bin", "wb") as f:
    f.write(b"Binary\xFFData\x00Example")

# Read binary file
with open("sample.bin", "rb") as f:
    binary_data = f.read()
    print("Binary file content:", binary_data)  # b'Binary\xffData\x00Example'
    print("Hex representation:", binary_data.hex())  # 42696e6172790044617461004578616d706c65

# Clean up the file
os.remove("sample.bin")

# Working with network data
print("\nNetwork data example:")
# Simulate network protocol message
header = bytearray(b"\x02\x01\x03")  # Message type and flags
length = bytearray((10).to_bytes(2, byteorder='big'))  # Message length (16-bit)
payload = bytearray(b"Hello Data")
message = header + length + payload

print("Protocol message (hex):", message.hex())
# Decode the message
msg_type = message[0]
flags = message[1:3]
msg_length = int.from_bytes(message[3:5], byteorder='big')
msg_payload = message[5:5+msg_length].decode('utf-8')

print(f"Decoded - Type: {msg_type}, Flags: {list(flags)}, Length: {msg_length}, Payload: {msg_payload}")

# Memory View - shared memory view of bytes without copying
print("\nMemoryView example:")
data = bytearray(b'abcdefgh')
view = memoryview(data)
print("Original data:", data)  # bytearray(b'abcdefgh')

# Modify through memory view
view[2:4] = b'XY'
print("Data after view modification:", data)  # bytearray(b'abXYefgh')

# Working with different formats through memoryview
import array
numbers = array.array('i', [1, 2, 3, 4])  # Array of integers
view = memoryview(numbers)
print("Memory view of array:", view.tolist())  # [1, 2, 3, 4]