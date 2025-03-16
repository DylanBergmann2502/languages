#################### Basic GC Concepts ####################

# Ruby uses automatic memory management through garbage collection
# to reclaim memory occupied by objects that are no longer in use

# Force garbage collection to run
GC.start
puts "GC has been manually triggered"

# Get current GC statistics
stats = GC.stat
puts "Total GC runs: #{stats[:count]}"

# Not all Ruby versions track total_time the same way
if stats[:total_time]
  puts "Total time spent in GC: #{stats[:total_time] / 1000000.0} seconds"
else
  puts "Total time spent in GC: Not available in this Ruby version"
end

#################### Memory Allocation ####################

# Memory allocation tracking (without external gems)
# Create objects and observe GC behavior
array = []

puts "\nCreating 100,000 string objects..."
memory_before = GC.stat[:malloc_increase]
100_000.times do |i|
  array << "item #{i}"
end
memory_after = GC.stat[:malloc_increase]
memory_diff = memory_after - memory_before if memory_before && memory_after

if memory_diff
  puts "Memory increase: #{memory_diff / 1024.0} KB"
else
  puts "Memory tracking not available in this Ruby version"
end

#################### GC Tuning ####################

# Ruby's GC can be configured through environment variables
# Example: RUBY_GC_MALLOC_LIMIT, RUBY_GC_OLDMALLOC_LIMIT, etc.

puts "\nGC Configuration:"
# Check if these constants are available (may vary by Ruby version)
constants = {
  heap_growth_factor: defined?(GC::HEAP_GROWTH_FACTOR),
  heap_init_slots: defined?(GC::HEAP_INIT_SLOTS),
  heap_free_slots: defined?(GC::HEAP_FREE_SLOTS),
  heap_growth_max_slots: defined?(GC::HEAP_GROWTH_MAX_SLOTS),
}

constants.each do |name, defined|
  if defined
    puts "#{name}: #{GC.const_get(name.to_s.upcase)}"
  else
    puts "#{name}: Not defined in this Ruby version"
  end
end

# Check for auto_compact support (Ruby 3.0+)
if GC.respond_to?(:auto_compact)
  puts "Auto compaction supported: #{GC.auto_compact}"
else
  puts "Auto compaction not supported in this Ruby version"
end

#################### Mark and Sweep ####################

# Ruby uses a generational garbage collector called "RGenGC"
# (Restricted Generational Garbage Collector)

# Objects are initially allocated in the young generation
# and promoted to the old generation if they survive GC cycles

# Get the count of objects in Ruby's heap
object_space_count = ObjectSpace.count_objects
puts "\nCurrent objects in memory:"
puts "Total: #{object_space_count[:TOTAL]}"
puts "Free: #{object_space_count[:FREE]}"
puts "T_OBJECT: #{object_space_count[:T_OBJECT]}"
puts "T_STRING: #{object_space_count[:T_STRING]}"
puts "T_ARRAY: #{object_space_count[:T_ARRAY]}"
puts "T_HASH: #{object_space_count[:T_HASH]}"

#################### Object Finalization ####################

# You can define finalizers that run when objects are garbage collected
class FinalizableObject
  def initialize(name)
    @name = name
    # Important: we use self.class.finalize to avoid creating a closure
    # that would reference self, preventing garbage collection
    ObjectSpace.define_finalizer(self, self.class.finalize(@name))
  end

  def self.finalize(name)
    proc { puts "Finalizing object: #{name}" }
  end
end

# Create some objects that will be finalized
puts "\nCreating objects with finalizers:"
3.times do |i|
  FinalizableObject.new("Object #{i}")
end

# Force GC to see finalizers in action
puts "Running GC to trigger finalizers..."
GC.start
GC.start  # Sometimes needed twice to see the effect

#################### Weak References ####################

# Ruby provides WeakRef for creating references that don't prevent GC
require "weakref"

# Create an object and a weak reference to it
original = "This is a large string that we'll reference weakly"
weak = WeakRef.new(original)

# The weak reference works as long as the original object exists
puts "\nWeak reference test:"
puts "Weak reference value: #{weak.weakref_alive? ? weak : "Reference is dead"}"

# If we remove the reference to the original object
original = nil
GC.start  # Force garbage collection
GC.start  # Sometimes needed twice to see the effect

# Attempt to use the weak reference may raise error or return nil
begin
  puts "After GC: #{weak.weakref_alive? ? weak : "Reference is dead"}"
rescue WeakRef::RefError => e
  puts "WeakRef error: #{e.message}"
end

#################### Debugging Memory Leaks ####################

# To debug memory leaks, you can use ObjectSpace to trace object allocation
puts "\nTop 10 classes by instance count:"
counts = Hash.new(0)

# Count instances of each class
ObjectSpace.each_object do |obj|
  counts[obj.class] += 1
end

# Show top classes by instance count
counts.sort_by { |k, v| -v }.first(10).each do |klass, count|
  puts "#{klass}: #{count} instances"
end

#################### Compaction ####################

# Ruby 2.7+ has compaction which reduces memory fragmentation
if GC.respond_to?(:compact)
  puts "\nCompacting the heap..."
  GC.compact
  puts "Heap compaction complete"
else
  puts "\nHeap compaction not supported in this Ruby version"
end

puts "\nGarbage collection exploration complete!"
