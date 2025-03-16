# Benchmark is a standard library module that provides methods to measure and
# report the time used to execute Ruby code.

require 'benchmark'

########################################################################
# Basic usage with Benchmark.measure
# This method executes the code in the block and returns the time information.

result = Benchmark.measure do
 # Some operation to measure
 sum = 0
 1_000_000.times { sum += 1 }
end

puts "Basic measurement:"
puts result
# Output includes: user CPU time, system CPU time, total time, and real time
# Format: user     system      total        real
#         0.203000   0.000000   0.203000 (  0.203942)

########################################################################
# Measuring different code blocks with Benchmark.bm
# This provides a simple way to compare the performance of different implementations

n = 1_000_000

puts "\nComparing operations with Benchmark.bm:"
Benchmark.bm(15) do |x|
 # The argument 15 sets the label width
 
 x.report("Addition:") do
   sum = 0
   n.times { sum += 1 }
 end
 
 x.report("Multiplication:") do
   product = 1
   n.times { product *= 1 }
 end
 
 x.report("Array append:") do
   array = []
   n.times { array << 1 }
 end
end

########################################################################
# Using Benchmark.bmbm for more accurate measurements
# bmbm runs the code twice - first as a rehearsal to warm up, then for the actual measurement
# This helps avoid inaccuracies due to garbage collection, caching, etc.

puts "\nMore accurate comparison with Benchmark.bmbm:"
Benchmark.bmbm(15) do |x|
 x.report("String concat (+):") do
   str = ""
   1_000.times { str = str + "x" }
 end
 
 x.report("String concat (<<):") do
   str = ""
   1_000.times { str << "x" }
 end
 
 x.report("String interpolation:") do
   str = ""
   1_000.times { str = "#{str}x" }
 end
end

########################################################################
# Measuring memory usage alongside time
# Note: Requires Ruby 2.1+ for memory_usages

puts "\nMeasuring memory allocation:"
array = []

GC.disable # Disable garbage collection for more accurate measurement

# Windows doesn't have ps command, so use alternative approach
if RUBY_PLATFORM =~ /mswin|mingw|windows/
  # On Windows, we can use the Windows Management Instrumentation
  require 'win32ole'
  
  def get_process_memory
    wmi = WIN32OLE.connect("winmgmts://")
    process = wmi.ExecQuery("select * from Win32_Process where ProcessId = #{Process.pid}")
    process.each do |p|
      return p.WorkingSetSize / 1024  # Convert to KB
    end
    return 0
  rescue
    return 0  # Return 0 if WMI query fails
  end
  
  before_memory = get_process_memory
else
  # Unix/Linux/macOS
  before_memory = `ps -o rss= -p #{Process.pid}`.to_i
end

before_time = Time.now

# Operation that allocates memory
100_000.times do
  array << "x" * 100
end

after_time = Time.now

if RUBY_PLATFORM =~ /mswin|mingw|windows/
  after_memory = get_process_memory
else
  after_memory = `ps -o rss= -p #{Process.pid}`.to_i
end

GC.enable # Re-enable garbage collection

puts "Time: #{after_time - before_time} seconds"
puts "Memory difference: #{after_memory - before_memory} KB"

########################################################################
# Benchmark.realtime for simple elapsed time measurement

elapsed_time = Benchmark.realtime do
 # Some operation to measure
 sleep(0.5)  # Simulating work
end

puts "\nRealtime measurement:"
puts "Elapsed time: #{elapsed_time} seconds"

########################################################################
# More complex comparison with Benchmark::IPS (Iterations Per Second)
# Note: This requires the benchmark-ips gem to be installed
# gem install benchmark-ips

puts "\nUsing Benchmark::IPS (if available):"

begin
 require 'benchmark/ips'
 
 Benchmark.ips do |x|
   x.report("Array#find") do
     [1, 2, 3, 4, 5].find { |n| n > 3 }
   end
   
   x.report("Array#select.first") do
     [1, 2, 3, 4, 5].select { |n| n > 3 }.first
   end
   
   x.compare!  # Compare the results
 end
rescue LoadError
 puts "benchmark-ips gem not installed. Run: gem install benchmark-ips"
end

########################################################################
# Practical example: Comparing sorting algorithms

def bubble_sort(array)
 arr = array.dup
 n = arr.length
 loop do
   swapped = false
   (n-1).times do |i|
     if arr[i] > arr[i+1]
       arr[i], arr[i+1] = arr[i+1], arr[i]
       swapped = true
     end
   end
   break unless swapped
 end
 arr
end

def insertion_sort(array)
 arr = array.dup
 (1...arr.length).each do |i|
   value = arr[i]
   j = i - 1
   while j >= 0 && arr[j] > value
     arr[j + 1] = arr[j]
     j -= 1
   end
   arr[j + 1] = value
 end
 arr
end

puts "\nComparing sorting algorithms:"
array_sizes = [100, 1000, 5000]

array_sizes.each do |size|
 array = Array.new(size) { rand(10000) }
 
 puts "\nArray size: #{size}"
 Benchmark.bm(20) do |x|
   x.report("Ruby built-in sort:") { array.sort }
   x.report("Bubble sort:") { bubble_sort(array) }
   x.report("Insertion sort:") { insertion_sort(array) }
 end
end

########################################################################
# Benchmark with block parameters to access timing information

puts "\nAccessing timing information directly:"
Benchmark.benchmark(Benchmark::CAPTION, 15) do |x|
 tf = x.report("For loop:") do
   for i in 1..1_000_000
     # Empty loop
   end
 end
 
 tt = x.report("Times method:") do
   1_000_000.times do
     # Empty loop
   end
 end
 
 tu = x.report("Upto method:") do
   1.upto(1_000_000) do
     # Empty loop
   end
 end
 
 # Return the sum of real times as an array
 [tf.real, tt.real, tu.real]
end

########################################################################
# Custom formatting with Benchmark

puts "\nCustom formatted output:"
Benchmark.benchmark(" "*20 + "user     system      total        real\n") do |x|
 x.report("Custom format:") { sleep(0.25) }
 x.report("Another measurement:") { sleep(0.1) }
 nil # Return nil to prevent automatic printing of results array
end

########################################################################
# Measuring code inside a loop

puts "\nMeasuring inside a loop:"
total_time = 0

5.times do |i|
 time = Benchmark.realtime do
   # Operation to measure
   sleep(0.1)
 end
 total_time += time
 puts "Iteration #{i+1}: #{time.round(4)} seconds"
end

puts "Total time: #{total_time.round(4)} seconds"
puts "Average time: #{(total_time / 5).round(4)} seconds"
