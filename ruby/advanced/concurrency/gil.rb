# Ruby Global Interpreter Lock (GIL)
# The GIL is a mutex that prevents multiple Ruby threads from executing Ruby code simultaneously

########################################################################
# Understanding the GIL: What it is and why it exists
#
# The GIL (Global Interpreter Lock) or MRI (Matz's Ruby Interpreter) limits
# Ruby to running only one thread at a time, regardless of CPU cores available.
#
# Why does Ruby have a GIL?
# 1. Memory safety: Prevents race conditions on internal interpreter state
# 2. C extension compatibility: Many C extensions aren't thread-safe
# 3. Simplifies garbage collection: No need for complex concurrent GC

puts "Understanding the Ruby Global Interpreter Lock (GIL)"
puts "==================================================="

########################################################################
# Demonstrating GIL effect on CPU-bound operations
puts "\nCPU-bound operations (affected by GIL):"

def cpu_intensive_task(id, iterations)
  puts "Task #{id} starting..."
  start_time = Time.now

  # CPU-intensive calculation
  result = 0
  iterations.times do |i|
    result += Math.sqrt((i * i) / (i + 1.0)) if i > 0
  end

  end_time = Time.now
  puts "Task #{id} completed in #{end_time - start_time} seconds"
  result
end

# Run tasks sequentially
puts "\nRunning CPU-bound tasks sequentially:"
sequential_start = Time.now

cpu_intensive_task(1, 5_000_000)
cpu_intensive_task(2, 5_000_000)

sequential_time = Time.now - sequential_start
puts "Sequential execution time: #{sequential_time} seconds"

# Run tasks in parallel threads
puts "\nRunning CPU-bound tasks in parallel threads:"
parallel_start = Time.now

t1 = Thread.new { cpu_intensive_task(1, 5_000_000) }
t2 = Thread.new { cpu_intensive_task(2, 5_000_000) }

t1.join
t2.join

parallel_time = Time.now - parallel_start
puts "Parallel execution time: #{parallel_time} seconds"

# Compare results
puts "\nComparison:"
puts "Sequential time: #{sequential_time} seconds"
puts "Parallel time: #{parallel_time} seconds"
puts "Speedup: #{sequential_time / parallel_time}x"
puts "Because of the GIL, CPU-bound tasks usually don't benefit much from threading"

########################################################################
# Demonstrating IO-bound operations (not constrained by the GIL)
puts "\nIO-bound operations (not affected by GIL):"

require "net/http"

def fetch_url(url, id)
  puts "Task #{id} starting to fetch #{url}..."
  start_time = Time.now

  uri = URI(url)
  response = Net::HTTP.get_response(uri)

  end_time = Time.now
  puts "Task #{id} completed in #{end_time - start_time} seconds"
  response.code
end

urls = [
  "https://ruby-lang.org",
  "https://github.com",
]

# Run fetches sequentially
puts "\nFetching URLs sequentially:"
sequential_start = Time.now

urls.each_with_index do |url, index|
  fetch_url(url, index + 1)
end

sequential_time = Time.now - sequential_start
puts "Sequential execution time: #{sequential_time} seconds"

# Run fetches in parallel threads
puts "\nFetching URLs in parallel threads:"
parallel_start = Time.now

threads = urls.map.with_index do |url, index|
  Thread.new { fetch_url(url, index + 1) }
end

threads.each(&:join)

parallel_time = Time.now - parallel_start
puts "Parallel execution time: #{parallel_time} seconds"

# Compare results
puts "\nComparison:"
puts "Sequential time: #{sequential_time} seconds"
puts "Parallel time: #{parallel_time} seconds"
puts "Speedup: #{sequential_time / parallel_time}x"
puts "IO-bound tasks benefit from threading even with the GIL"

########################################################################
# GIL Release during IO Operations
puts "\nGIL Release during IO Operations:"
puts "Ruby automatically releases the GIL during blocking IO operations"
puts "This allows other threads to run while waiting for IO"

########################################################################
# GIL Workarounds
puts "\nWorkarounds for the GIL limitation:"

puts "1. Use multiple processes instead of threads for CPU-bound tasks"
puts "   - Process.fork (on Unix-like systems)"
puts "   - gems like 'parallel' for multi-process parallelism"

puts "\n2. Use native extensions that release the GIL"
puts "   - Some C extensions release the GIL during computation"
puts "   - Example: 'numo-narray' for numerical computations"

puts "\n3. Use non-MRI Ruby implementations"
puts "   - JRuby: Runs on the JVM, no GIL"
puts "   - TruffleRuby: High-performance implementation, no GIL"
puts "   - Note: These may not be 100% compatible with all Ruby code"

########################################################################
# Simple demonstration of the 'parallel' gem (if installed)
puts "\nUsing the 'parallel' gem for multi-process parallelism:"

begin
  require "parallel"

  start_time = Time.now

  # Run tasks in parallel processes
  results = Parallel.map(1..2, in_processes: 2) do |i|
    cpu_intensive_task(i, 5_000_000)
  end

  end_time = Time.now
  puts "Multi-process execution time: #{end_time - start_time} seconds"
  puts "This bypasses the GIL by using multiple processes"
rescue LoadError
  puts "Parallel gem not installed. Install with 'gem install parallel' to try this example."
  puts "Example: Parallel.map(1..10, in_processes: 4) { |i| expensive_computation(i) }"
end

########################################################################
# Monitoring thread status to observe the GIL in action
puts "\nMonitoring thread execution status to observe the GIL:"

thread_count = 4
iterations = 100_000_000
results = Array.new(thread_count) { 0 }
threads = []

puts "Starting #{thread_count} threads with CPU-intensive work..."
puts "Each dot represents a thread switch (when the GIL is passed to another thread)"

# Start timer thread to print progress
timer_thread = Thread.new do
  30.times do
    sleep 0.1
    print "."
  end
  puts "\nObservation complete!"
end

# Start worker threads
thread_count.times do |i|
  threads << Thread.new do
    results[i] = 0
    (iterations / thread_count).times do |j|
      results[i] += Math.sqrt(j) if j > 0
    end
  end
end

# Wait for threads to complete
threads.each(&:join)
timer_thread.join

puts "\nAll computation threads completed."
puts "Even though we had #{thread_count} threads, the GIL ensured only one executed Ruby code at a time."

puts "\nConclusion: The GIL is important to understand when using Ruby threads."
puts "- For CPU-bound tasks: Use multiple processes"
puts "- For IO-bound tasks: Threads work well despite the GIL"
