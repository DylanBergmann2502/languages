# Creating hashes
empty_hash = {}
grades = { "Alice" => 92, "Bob" => 85, "Charlie" => 78 }
symbol_keys = { first_name: "John", last_name: "Doe", age: 30 }
mixed_hash = { "name" => "Ruby", version: 3.1, features: ["blocks", "objects"] }

puts "Empty hash: #{empty_hash}"  # {}
puts "Grades hash: #{grades}"  # {"Alice"=>92, "Bob"=>85, "Charlie"=>78}
puts "Symbol keys hash: #{symbol_keys}"  # {:first_name=>"John", :last_name=>"Doe", :age=>30}
puts "Mixed hash: #{mixed_hash}"  # {"name"=>"Ruby", :version=>3.1, :features=>["blocks", "objects"]}

# Note: symbol_keys is equivalent to { :first_name => "John", :last_name => "Doe", :age => 30 }
puts "\nSymbol hash equality:"
puts({ first_name: "John" } == { :first_name => "John" })  # true

# Creating hashes with Hash constructor
puts "\nHash constructor:"
default_zero = Hash.new(0)  # Default value for non-existent keys is 0
puts "Hash.new(0): #{default_zero}"  # {}
puts "Accessing non-existent key: #{default_zero["unknown"]}"  # 0

# Be careful with mutable objects as default values
default_array = Hash.new([])
puts "Hash.new([]) before: #{default_array}"  # {}
default_array["key"] << "modified"
puts "Accessing non-existent key: #{default_array["another_key"]}"  # ["modified"]

# Proper way to use mutable defaults with a block
proper_default = Hash.new { |hash, key| hash[key] = [] }
puts "Hash.new with block before: #{proper_default}"  # {}
proper_default["key"] << "modified"
puts "First key array: #{proper_default["key"]}"  # ["modified"]
puts "Second key array: #{proper_default["another_key"]}"  # []

# Accessing hash elements
puts "\nAccessing elements:"
puts "Alice's grade: #{grades["Alice"]}"  # 92
puts "First name: #{symbol_keys[:first_name]}"  # "John"
puts "Non-existent key: #{grades["David"]}"  # nil

# Hash methods for access
puts "Get with default: #{grades.fetch("David", "Not found")}"  # "Not found"
begin
  grades.fetch("David")  # Raises KeyError
rescue KeyError => e
  puts "Error with fetch: #{e.message}"  # "key not found: \"David\""
end

puts "Has key 'Alice'?: #{grades.key?("Alice")}"  # true
puts "Has value 92?: #{grades.value?(92)}"  # true

# Getting all keys and values
puts "\nGetting keys and values:"
puts "Keys: #{grades.keys}"  # ["Alice", "Bob", "Charlie"]
puts "Values: #{grades.values}"  # [92, 85, 78]
puts "Key-value pairs: #{grades.to_a}"  # [["Alice", 92], ["Bob", 85], ["Charlie", 78]]

# Modifying hashes
puts "\nModifying hashes:"
grades["David"] = 88
puts "After adding David: #{grades}"  # {"Alice"=>92, "Bob"=>85, "Charlie"=>78, "David"=>88}
grades["Alice"] = 94  # Overwrites existing value
puts "After updating Alice: #{grades}"  # {"Alice"=>94, "Bob"=>85, "Charlie"=>78, "David"=>88}
deleted_grade = grades.delete("Charlie")
puts "Deleted Charlie's grade: #{deleted_grade}"  # 78
puts "After deleting Charlie: #{grades}"  # {"Alice"=>94, "Bob"=>85, "David"=>88}

# Merging hashes
puts "\nMerging hashes:"
hash1 = { a: 1, b: 2 }
hash2 = { b: 3, c: 4 }
puts "hash1.merge(hash2): #{hash1.merge(hash2)}"  # {:a=>1, :b=>3, :c=>4}
puts "hash1 after merge: #{hash1}"  # {:a=>1, :b=>2}
hash1.merge!(hash2)  # Destructive version
puts "hash1 after merge!: #{hash1}"  # {:a=>1, :b=>3, :c=>4}

# Iterating over hashes
puts "\nIterating over hashes:"
person = { name: "Alice", age: 30, city: "New York" }

puts "Using each:"
person.each do |key, value|
  puts "#{key}: #{value}"
end
# name: Alice
# age: 30
# city: New York

puts "\nUsing each_key:"
person.each_key do |key|
  puts "Key: #{key}"
end
# Key: name
# Key: age
# Key: city

puts "\nUsing each_value:"
person.each_value do |value|
  puts "Value: #{value}"
end
# Value: Alice
# Value: 30
# Value: New York

# Transforming hashes
puts "\nTransforming hashes:"
numbers = { a: 1, b: 2, c: 3 }
squared = numbers.transform_values { |v| v * v }
puts "Original: #{numbers}"  # {:a=>1, :b=>2, :c=>3}
puts "Squared values: #{squared}"  # {:a=>1, :b=>4, :c=>9}

upcased_keys = person.transform_keys(&:upcase)
puts "Upcased symbol keys: #{upcased_keys}"  # {"NAME"=>"Alice", "AGE"=>30, "CITY"=>"New York"}

stringified = person.transform_keys(&:to_s)
puts "Stringified keys: #{stringified}"  # {"name"=>"Alice", "age"=>30, "city"=>"New York"}

# Selecting entries
puts "\nSelecting entries:"
numbers = { a: 1, b: 2, c: 3, d: 4, e: 5 }
evens = numbers.select { |k, v| v.even? }
puts "Even values: #{evens}"  # {:b=>2, :d=>4}
odds = numbers.reject { |k, v| v.even? }
puts "Odd values: #{odds}"  # {:a=>1, :c=>3, :e=>5}

# Checking for emptiness
puts "\nChecking for emptiness:"
puts "Empty hash empty?: #{{}.empty?}"  # true
puts "Non-empty hash empty?: #{numbers.empty?}"  # false

# Default values and blocks
puts "\nDefault values and blocks:"
counter = Hash.new(0)
words = ["apple", "banana", "apple", "cherry", "banana", "apple"]
words.each { |word| counter[word] += 1 }
puts "Word counts: #{counter}"  # {"apple"=>3, "banana"=>2, "cherry"=>1}

# More complex behavior with default proc
grouper = Hash.new { |hash, key| hash[key] = [] }
[1, 2, 3, 4, 5, 6].each { |num| grouper[num.even? ? :even : :odd] << num }
puts "Grouped numbers: #{grouper}"  # {:odd=>[1, 3, 5], :even=>[2, 4, 6]}

# Hash as the last argument in a method call
def configure(options = {})
  puts "Database: #{options[:database] || "default"}"
  puts "Host: #{options[:host] || "localhost"}"
  puts "Port: #{options[:port] || 3306}"
end

puts "\nHash as method argument:"
configure(database: "myapp", port: 5432)
# Database: myapp
# Host: localhost
# Port: 5432

# Ruby 2.7+ keyword arguments vs hash syntax
def modern_config(database: "default", host: "localhost", port: 3306)
  puts "Database: #{database}"
  puts "Host: #{host}"
  puts "Port: #{port}"
end

puts "\nKeyword arguments:"
modern_config(database: "myapp", port: 5432)
# Database: myapp
# Host: localhost
# Port: 5432

# Converting to/from arrays
puts "\nConverting to/from arrays:"
hash = { a: 1, b: 2, c: 3 }
array = hash.to_a
puts "Hash to array: #{array.inspect}"  # [[:a, 1], [:b, 2], [:c, 3]]
back_to_hash = array.to_h
puts "Array to hash: #{back_to_hash}"  # {:a=>1, :b=>2, :c=>3}

# Hash comparison
puts "\nHash comparison:"
hash1 = { a: 1, b: 2 }
hash2 = { b: 2, a: 1 }
hash3 = { a: 1, b: 3 }
puts "hash1 == hash2: #{hash1 == hash2}"  # true (order doesn't matter)
puts "hash1 == hash3: #{hash1 == hash3}"  # false (different values)

# Hash slicing (Ruby 2.5+)
puts "\nHash slicing:"
person = { name: "John", age: 30, city: "New York", country: "USA" }
location = person.slice(:city, :country)
puts "Person: #{person}"  # {:name=>"John", :age=>30, :city=>"New York", :country=>"USA"}
puts "Location slice: #{location}"  # {:city=>"New York", :country=>"USA"}