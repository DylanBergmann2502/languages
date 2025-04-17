# Concurrent Ruby provides tools for concurrent and parallel programming
# It helps manage the complexity of multi-threaded applications
require "concurrent"

puts "=== Basic Futures ==="
# A Future represents a computation that hasn't completed yet
# It allows you to start a task and retrieve its value later

# Create a future that will compute a value
future = Concurrent::Future.execute do
  # Simulate work that takes time
  sleep(1)
  42
end

# Check if it's complete yet (likely false right after creation)
puts "Completed? #{future.complete?}"

# Wait for completion and get the value
puts "Value: #{future.value}"
puts "Now completed? #{future.complete?}"

# If an exception occurs in the future, it's captured
error_future = Concurrent::Future.execute do
  sleep(0.5)
  raise "Something went wrong!"
end

# Wait for error to happen
sleep(1)
puts "Error future state: #{error_future.state}"
puts "Error message: #{error_future.reason.message}" if error_future.reason

puts "\n=== Promises ==="
# Promises are similar to futures but can be completed by different threads

# Create a simple successful promise
promise = Concurrent::Promise.fulfill("success!")
puts "Promise state: #{promise.state}"
puts "Promise value: #{promise.value}"

# Create a rejected promise
rejected_promise = Concurrent::Promise.reject(RuntimeError.new("failure reason"))
puts "Rejected promise state: #{rejected_promise.state}"
puts "Rejected promise reason: #{rejected_promise.reason.message}"

# Create a promise chain
chain = Concurrent::Promise.execute do
  sleep(0.5)
  "first result"
end.then do |result|
  "#{result} and second result"
end.then do |result|
  "#{result} and final result"
end

# Wait for chain to complete
sleep(1)
puts "Chain result: #{chain.value}"

puts "\n=== Thread Pools ==="
# Thread pools manage a collection of worker threads
# They help limit the number of concurrent threads

# Fixed thread pool with 5 workers
pool = Concurrent::FixedThreadPool.new(5)

10.times do |i|
  pool.post do
    # Each task will print its number and the thread it's running on
    puts "Task #{i} running on thread #{Thread.current.object_id}"
    sleep(rand * 0.5)  # Random sleep to simulate work
  end
end

# Shutdown the pool when done (waits for tasks to complete)
pool.shutdown
pool.wait_for_termination

puts "\n=== Atomic Values ==="
# Atomic operations are thread-safe without explicit locks
# Useful for simple shared state between threads

# Create an atomic counter
counter = Concurrent::AtomicFixnum.new(0)

threads = 5.times.map do
  Thread.new do
    100.times { counter.increment }
  end
end

# Wait for all threads to complete
threads.each(&:join)

puts "Final counter value: #{counter.value}"  # Should be 500

# Atomic reference can hold any object
user = Concurrent::AtomicReference.new({ name: "Alice", age: 30 })

# Update atomically using compare_and_set
current = user.value
new_value = current.dup
new_value[:age] += 1
success = user.compare_and_set(current, new_value)

puts "Update successful? #{success}"
puts "Updated user: #{user.value}"

puts "\n=== Agent Pattern ==="
# Agents provide thread-safe access to shared state
# Updates happen asynchronously through update functions

agent = Concurrent::Agent.new([])

# Update the agent's value by providing a transformation function
5.times do |i|
  agent.send_off { |array| array + [i] }
end

# Allow time for updates to process
sleep(0.5)

puts "Agent value: #{agent.value.inspect}"

puts "\n=== Dataflow Variables ==="
# Dataflow programming model where operations execute
# when their inputs become available

a = Concurrent::dataflow { 2 }
b = Concurrent::dataflow { 3 }
c = Concurrent::dataflow(a, b) { |a_val, b_val| a_val + b_val }

# The result is available once all dependencies resolve
puts "2 + 3 = #{c.value}"

puts "\n=== Thread Synchronization ==="
# Various synchronization primitives

# Mutex for mutual exclusion
mutex = Mutex.new
shared_array = []

threads = 10.times.map do |i|
  Thread.new do
    mutex.synchronize do
      # Critical section - only one thread at a time
      shared_array << i
      puts "Thread #{i} added to array: #{shared_array.inspect}"
    end
  end
end

threads.each(&:join)

puts "\n=== Thread-safe Collections ==="
# Thread-safe versions of common Ruby collections

# Thread-safe hash
map = Concurrent::Map.new
map["key"] = "value"

# Can be safely updated from multiple threads
threads = 5.times.map do |i|
  Thread.new do
    map["thread_#{i}"] = "value_#{i}"
  end
end

threads.each(&:join)

# Convert to string to display contents
puts "Map contents: #{map.inspect}"
# Alternatively, iterate through keys
puts "Map keys and values:"
map.each_pair do |key, value|
  puts "  #{key}: #{value}"
end

puts "\n=== Scheduling and Timers ==="
# Tools for scheduling tasks

# Execute once after a delay
timer = Concurrent::TimerTask.execute(execution_interval: 1) do
  puts "Timer executed at #{Time.now}"
end

# Wait for execution
sleep(1.5)
timer.shutdown

puts "\n=== Observer Pattern ==="
# Thread-safe implementation of the observer pattern using Ruby's Observable

require "observer"

class Counter
  include Observable

  def initialize
    @count = 0
  end

  def increment
    @count += 1
    changed
    notify_observers(@count)
  end
end

class CounterObserver
  def update(count)
    puts "Counter changed to: #{count}"
  end
end

counter = Counter.new
observer = CounterObserver.new

counter.add_observer(observer)
3.times { counter.increment }

puts "\n=== Practical Example: Web Scraper ==="
# Let's combine concepts into a practical example
# This simulates a concurrent web scraper

def fetch_url(url)
  # Simulate HTTP request with random delay
  sleep(rand * 1.0)
  "Content from #{url}"
end

urls = [
  "https://example.com/page1",
  "https://example.com/page2",
  "https://example.com/page3",
  "https://example.com/page4",
  "https://example.com/page5",
]

# Using a thread pool to limit concurrency
pool = Concurrent::FixedThreadPool.new(3)

# Create futures for each URL
futures = urls.map do |url|
  Concurrent::Future.execute(executor: pool) do
    fetch_url(url)
  end
end

# Wait for all futures to complete
sleep(2)

# Collect results
results = futures.map(&:value)

puts "Scraped #{results.size} pages:"
results.each_with_index do |content, index|
  puts "#{index + 1}. #{content[0..20]}..."
end

# Shut down the thread pool
pool.shutdown
pool.wait_for_termination
