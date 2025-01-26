# Since Erlang and Elixir share the same BEAM runtime,
# Elixir provides great interoperability with Erlang libraries.

# To use Erlang libraries, you can call them directly
# using the atom syntax (:library_name).

## Erlang libraries' characteristics:
# They often return charlists instead of Elixir strings
# Their APIs might feel more "Erlang-like" (using atoms for options)
# They return tuples like {:ok, result} or {:error, reason}

################################################################
## 1. :crypto
# Generate a random 16-byte key
key = :crypto.strong_rand_bytes(16)
IO.inspect(key) # <<Random 16 bytes like: 23, 156, 89, ...>>

# Simple encryption example
text = "Hello, Crypto!"
encrypted = :crypto.crypto_one_time(:aes_128_ecb, key, text, true)
IO.inspect(encrypted) # <<Encrypted bytes>>

################################################################
## 2. :observer
# Start the observer GUI (this opens a window)
:observer.start()

Process.sleep(5000)

################################################################
## 3. :timer
# Sleep for 1 second
:timer.sleep(1000)
IO.puts("Woke up after 1 second!")

# Send a message after 2 seconds
:timer.send_after(2000, self(), :timeout)
receive do
  :timeout -> IO.puts("Received timeout message")
end

################################################################
## 4. :inet
# Get local hostname
{:ok, hostname} = :inet.gethostname()
IO.inspect(hostname) # ~c"LAPTOP-BFFSIHBQ"

# Parse IP address
{:ok, ip_tuple} = :inet.parse_address(~c'192.168.1.1')
IO.inspect(ip_tuple) # {192, 168, 1, 1}

Process.sleep(3000)

################################################################
## 4. :os
# Get environment variables
path = :os.getenv(~c'PATH')
IO.inspect(path) # Returns PATH as charlist

# Get system time
timestamp = :os.system_time(:millisecond)
IO.inspect(timestamp) # Current Unix timestamp in milliseconds

Process.sleep(3000)

################################################################
## 5. :rand - Random number generation
# Generate random integer between 1 and 100
random_number = :rand.uniform(100)
IO.inspect(random_number) # Random number between 1-100

# Generate random float between 0 and 1
random_float = :rand.uniform()
IO.inspect(random_float) # Random float like 0.123456

################################################################
## 6. :filename - File path manipulation
# Join paths
path = :filename.join(["users", "documents", "file.txt"])
IO.inspect(path) # "users/documents/file.txt"

# Get file extension
extension = :filename.extension("image.jpg")
IO.inspect(extension) # ".jpg"

################################################################
## 7. :calendar - Date and time functions
# Check if year is leap year
is_leap = :calendar.is_leap_year(2024)
IO.inspect(is_leap) # true

# Convert datetime to gregorian seconds
seconds = :calendar.datetime_to_gregorian_seconds({{2024, 1, 1}, {0, 0, 0}})
IO.inspect(seconds) # Number of seconds since year 0

################################################################
## 8. :mathex - Mathematical functions
pi = :math.pi()
angle_45_deg = pi * 45.0 / 180.0
sin = :math.sin(angle_45_deg)
IO.inspect(sin) # 0.7071067811865475

expo = :math.exp(55.0)
IO.inspect(expo) # 7.694785265142018e23

loga = :math.log(7.694785265142018e23)
IO.inspect(loga) # 55.0

################################################################
## 9. :zlib - Compression
# Compress string
text = "Hello, compression!"
compressed = :zlib.compress(text)
decompressed = :zlib.uncompress(compressed)
IO.inspect(decompressed) # "Hello, compression!"

################################################################
## 10. :queue - Efficient FIFO queue implementation

# Create a new queue
queue = :queue.new()
IO.inspect(queue) # {[], []}

# Add elements to queue (enqueue)
queue = :queue.in(1, queue)
queue = :queue.in(2, queue)
queue = :queue.in(3, queue)
IO.inspect(queue) # {[3, 2], [1]}

# Get queue length
length = :queue.len(queue)
IO.inspect(length) # 3

# Peek at first element without removing
{:value, first} = :queue.peek(queue)
IO.inspect(first) # 1

# Remove and get first element (dequeue)
{{:value, item}, queue} = :queue.out(queue)
IO.inspect(item) # 1
IO.inspect(queue) # {[3], [2]}

# Check if queue is empty
is_empty = :queue.is_empty(queue)
IO.inspect(is_empty) # false

# Convert queue to list
list = :queue.to_list(queue)
IO.inspect(list) # [2, 3]

# Create queue from list
new_queue = :queue.from_list([4, 5, 6])
IO.inspect(new_queue) # {[6, 5], [4]}

# Join two queues
joined = :queue.join(queue, new_queue)
IO.inspect(:queue.to_list(joined)) # [2, 3, 4, 5, 6]
