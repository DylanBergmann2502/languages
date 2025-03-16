# Ruby Threads
# Threads allow for concurrent execution within a Ruby process

########################################################################
# Basic Thread Creation
# Create a thread using Thread.new with a block of code to execute
t = Thread.new do
  puts "Thread started"
  sleep 1
  puts "Thread finished"
end

# Main thread continues execution
puts "Main thread continues..."

# Wait for thread to finish with join
t.join
puts "Thread has been joined"

########################################################################
# Threads with Arguments
# You can pass arguments to threads when creating them
t = Thread.new("argument1", "argument2") do |arg1, arg2|
  puts "Thread received: #{arg1}, #{arg2}"
end
t.join

########################################################################
# Thread States
# Threads can be in different states: run, sleep, aborting, or dead
t = Thread.new { sleep 3 }
puts "Thread status: #{t.status}" # sleep
t.join
puts "Thread status after join: #{t.status}" # false (dead, normal exit)

t_error = Thread.new { raise "Error in thread" }
begin
  t_error.join
rescue => e
  puts "Thread died with error: #{e.message}"
  puts "Thread status after error: #{t_error.status}" # nil (dead, error)
end

########################################################################
# Thread Variables
# Each thread has its own local variables
t1 = Thread.new do
  # Thread-local variable
  Thread.current[:counter] = 0
  5.times do
    Thread.current[:counter] += 1
    puts "Thread 1: counter = #{Thread.current[:counter]}"
    sleep 0.1
  end
end

t2 = Thread.new do
  # Each thread has its own copy
  Thread.current[:counter] = 100
  5.times do
    Thread.current[:counter] += 1
    puts "Thread 2: counter = #{Thread.current[:counter]}"
    sleep 0.1
  end
end

t1.join
t2.join

########################################################################
# Mutex for Thread Safety
# Mutex (Mutual Exclusion) helps prevent race conditions
counter = 0
mutex = Mutex.new

threads = 10.times.map do
  Thread.new do
    100.times do
      # Synchronize access to shared resource
      mutex.synchronize do
        temp = counter
        # This sleep makes race condition more likely without mutex
        sleep 0.0001
        counter = temp + 1
      end
    end
  end
end

threads.each(&:join)
puts "Final counter value: #{counter}" # Should be 1000

########################################################################
# Thread Pool Example
# Creating a simple thread pool for parallel tasks
def thread_pool(size, tasks)
  queue = Queue.new
  tasks.each { |task| queue << task }

  workers = size.times.map do
    Thread.new do
      until queue.empty?
        # Try to get a task, continue if queue is empty
        task = queue.pop(true) rescue nil
        task.call if task
      end
    end
  end

  workers.each(&:join)
end

# Create some sample tasks
tasks = 10.times.map do |i|
  -> {
    puts "Task #{i} started by thread #{Thread.current.object_id}"
    sleep rand(0.1..0.5)
    puts "Task #{i} completed"
  }
end

puts "Running tasks in thread pool..."
thread_pool(3, tasks)
puts "All tasks completed"

########################################################################
# Thread Priorities
# You can set priorities, but they're only hints to the scheduler
t1 = Thread.new { 1000.times { puts "Low priority" if $stdout.winsize rescue nil; sleep 0.01 } }
t2 = Thread.new { 1000.times { puts "High priority" if $stdout.winsize rescue nil; sleep 0.01 } }

# Set thread priorities
t1.priority = -1
t2.priority = 3
puts "t1 priority: #{t1.priority}, t2 priority: #{t2.priority}"

# Uncomment to run the priority example (commented to avoid too much output)
# t1.join
# t2.join

########################################################################
# Thread Abort on Exception
# By default, exceptions in threads don't affect the main program
Thread.abort_on_exception = true # Change default for all new threads
puts "Thread.abort_on_exception is now #{Thread.abort_on_exception}"

# Uncomment to see program terminate on thread exception
=begin
Thread.new do
    sleep 1
    raise "This exception will terminate the program"
end
sleep 2
puts "This line won't execute if Thread.abort_on_exception is true"
=end

# You can also set it for individual threads
t = Thread.new do
  sleep 1
  raise "Thread exception"
end
t.abort_on_exception = false
begin
  t.join
rescue => e
  puts "Caught thread exception: #{e.message}"
end

puts "Main thread completed"
