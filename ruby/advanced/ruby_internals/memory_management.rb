#################### Memory Structure ####################

# Ruby's memory is organized in several layers:
# 1. OS Memory (Virtual Memory)
# 2. Ruby's Heap (divided into pages/slots)
# 3. Objects within the heap

puts "Memory Management in Ruby"
puts "========================="

# Show process information
pid = Process.pid
puts "Process ID: #{pid}"

# Get memory usage info (platform-independent approach)
def memory_usage
  # Use GC stats for a basic estimate
  gc_stats = GC.stat

  # Different Ruby versions use different keys
  if gc_stats[:heap_allocated_pages] && gc_stats[:heap_page_size]
    # Ruby 2.x approach
    gc_stats[:heap_allocated_pages] * gc_stats[:heap_page_size] / 1024.0 / 1024.0
  elsif gc_stats[:heap_live_slots]
    # Rough approximation based on live objects
    gc_stats[:heap_live_slots] * 40.0 / 1024.0 / 1024.0  # Assuming ~40 bytes per object
  else
    # Very rough fallback
    gc_stats[:total_allocated_objects] * 40.0 / 1024.0 / 1024.0
  end
end

puts "Initial memory usage: ~#{memory_usage.round(2)} MB (estimate)"

#################### Object Size ####################

# Ruby objects have a memory overhead
puts "\nObject Size in Memory:"

# Integer objects in Ruby 2.4+ are immediate values (no allocation)
num = 42
puts "Integer (#{num}): No heap allocation for small integers"

# Strings allocate memory
str = "Hello, World!"
puts "String '#{str}': Variable size based on content"

# Arrays use memory for the array structure plus contained objects
arr = [1, 2, 3, 4, 5]
puts "Array #{arr}: Size scales with number of elements"

# Hashes use more memory than arrays
hash = { a: 1, b: 2, c: 3 }
puts "Hash #{hash}: Complex structure with keys and values"

#################### Object Allocation and Reuse ####################

puts "\nObject Allocation and Reuse:"

# Object creation before measurement
memory_before = memory_usage

# Create 100,000 similar objects
objects = []
100_000.times do |i|
  objects << "test string #{i % 100}"  # Only 100 unique strings
end

memory_after = memory_usage
puts "Memory after creating 100,000 strings: ~#{memory_after.round(2)} MB"
puts "Difference: ~#{(memory_after - memory_before).round(2)} MB"

# Force objects to be released
objects = nil
GC.start
GC.start  # Second call sometimes needed

memory_final = memory_usage
puts "Memory after cleanup: ~#{memory_final.round(2)} MB"
puts "Freed: ~#{(memory_after - memory_final).round(2)} MB"

#################### Memory Allocation Patterns ####################

puts "\nMemory Allocation Patterns:"

# Different ways to build a string affect memory usage
memory_before = memory_usage

# Inefficient string concatenation
bad_string = ""
1000.times do |i|
  bad_string += "item #{i} "  # Creates a new string each time
end

memory_mid = memory_usage
puts "Memory after inefficient concatenation: ~#{(memory_mid - memory_before).round(2)} MB"

# Efficient string building
good_string = ""
parts = []
1000.times do |i|
  parts << "item #{i} "
end
good_string = parts.join

memory_after = memory_usage
puts "Memory after efficient concatenation: ~#{(memory_after - memory_mid).round(2)} MB"

#################### Symbol Internals ####################

puts "\nSymbol Internals:"

# Symbols are immutable, unique and internally cached
sym1 = :test_symbol
sym2 = :test_symbol

puts "Symbols #{sym1} and #{sym2} are the same object: #{sym1.object_id == sym2.object_id}"

# Starting from Ruby 2.2, symbols can be garbage collected if
# they're created from strings using to_sym and go out of scope
# But symbols directly defined with : are still permanent

# Count current symbols in memory
symbol_count = Symbol.all_symbols.size
puts "Current symbol count: #{symbol_count}"

# Create some symbols from strings
10.times { |i| "dynamic_symbol_#{i}".to_sym }

# Check if symbol count increased
new_symbol_count = Symbol.all_symbols.size
puts "Symbol count after creating dynamic symbols: #{new_symbol_count}"
puts "Difference: #{new_symbol_count - symbol_count}"

#################### Object Internals ####################

puts "\nObject Internals:"

# Ruby objects have an internal structure
class Person
  attr_accessor :name, :age
end

person = Person.new
person.name = "Alice"
person.age = 30

# In MRI Ruby:
# - Every object has a header (CLASS + FLAGS)
# - Instance variables are stored in a table

# We can see the instance variables
puts "Instance variables for person object:"
puts person.instance_variables.inspect

#################### Memory Fragmentation ####################

puts "\nMemory Fragmentation:"

# Memory fragmentation happens when there are many small free spaces
# between allocated objects, making it hard to allocate larger objects

# Create fragmentation pattern
arrays = []
1000.times do
  # Create arrays of different sizes
  arrays << Array.new(rand(1..100)) { rand(1000) }
end

# Delete some random elements to create "holes"
500.times do
  arrays.delete_at(rand(arrays.size)) if arrays.size > 0
end

puts "Created memory fragmentation pattern"

# In Ruby 2.7+, we can compact the heap
if GC.respond_to?(:compact)
  GC.compact
  puts "Heap compaction performed"
else
  puts "Heap compaction not available in this Ruby version"
end

#################### Copy-on-Write ####################

puts "\nCopy-on-Write:"

# Ruby arrays use copy-on-write semantics in some operations
original = Array.new(1000) { "test" }
memory_before = memory_usage

# This doesn't copy all strings initially
copy = original.dup
memory_mid = memory_usage
puts "Memory after duplication: ~#{(memory_mid - memory_before).round(2)} MB"

# Now modify some elements, forcing copies
copy[0] = "modified"
copy[1] = "changed"
memory_after = memory_usage
puts "Memory after modifications: ~#{(memory_after - memory_mid).round(2)} MB"

#################### String Internals ####################

puts "\nString Internals:"

# Strings have complex memory behavior
# Strings in Ruby can be:
# 1. Heap allocated (normal)
# 2. Shared (copy-on-write)
# 3. Frozen (immutable)

str1 = "Hello World"
str2 = "Hello World"
puts "str1 and str2 are different objects: #{str1.object_id != str2.object_id}"

# Frozen strings can be deduped
str3 = "Hello World".freeze
str4 = "Hello World".freeze

# In Ruby 2.5+ with --enable-frozen-string-literal or in Ruby 3+
# identical frozen strings might be deduplicated
puts "Frozen strings may be the same object: #{str3.object_id == str4.object_id}"

puts "\nMemory management exploration complete!"
