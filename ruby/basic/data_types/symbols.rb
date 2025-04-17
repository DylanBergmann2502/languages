# Creating symbols
name_symbol = :name
status_symbol = :active
empty_symbol = :""
space_symbol = :"with space"
interpolated_symbol = :"user_#{1 + 1}"
from_string = "string".to_sym

puts "Creating symbols:"
puts "Basic symbol: #{name_symbol}"                # :name
puts "Symbol with empty string: #{empty_symbol}"   # :""
puts "Symbol with spaces: #{space_symbol}"         # :"with space"
puts "Interpolated symbol: #{interpolated_symbol}" # :user_2
puts "From string: #{from_string}"                 # :string

# Symbol properties
puts "\nSymbol properties:"
puts "Symbol class: #{name_symbol.class}"          # Symbol
puts "Symbol object ID: #{name_symbol.object_id}"  # Some fixed number
puts "Symbol same object ID for same symbol: #{:name.object_id == name_symbol.object_id}"  # true

# Symbols vs Strings
name_string = "name"
duplicate_string = "name"
duplicate_symbol = :name

puts "\nSymbols vs Strings:"
puts "String object IDs same? #{name_string.object_id == duplicate_string.object_id}"  # false
puts "Symbol object IDs same? #{name_symbol.object_id == duplicate_symbol.object_id}"  # true
puts "Symbol to string: #{name_symbol.to_s}"       # "name"
puts "String to symbol: #{name_string.to_sym}"     # :name

# Memory efficiency
puts "\nMemory efficiency:"
puts "Symbol inspect: #{name_symbol.inspect}"      # :name
puts "String inspect: #{name_string.inspect}"      # "name"

# Symbols are immutable
puts "\nSymbols are immutable:"
begin
  :name[0] = "N"
rescue => e
  puts "Error changing symbol: #{e.class}" # FrozenError or similar
end

# Common uses of symbols

# 1. Hash keys
person = {
  name: "John",      # New syntax with symbols (Ruby 1.9+)
  :age => 30,        # Traditional hash rocket syntax
  "city" => "New York", # String key for comparison
}

puts "\nHash keys:"
puts "Hash with symbol keys: #{person}"
puts "Access with symbol: #{person[:name]}"        # "John"
puts "Symbol key exists? #{person.key?(:name)}"    # true
puts "String to symbol access: #{person[:"name"]}" # "John"

# 2. Method parameters (keyword arguments)
def configure(host: "localhost", port: 8080)
  puts "Configured with host: #{host}, port: #{port}"
end

puts "\nKeyword arguments:"
configure(port: 3000)                             # Configured with host: localhost, port: 3000

# 3. As method names for metaprogramming
puts "\nSymbols as method names:"
method_name = :upcase
puts "hello".send(method_name)                    # "HELLO"

# 4. In Ruby's metaprogramming
puts "\nMetaprogramming with symbols:"

class Dog
  attr_accessor :name, :breed
end

dog = Dog.new
dog.name = "Rex"
puts "Dog name: #{dog.name}"                     # "Rex"

# 5. For callbacks and hooks in frameworks
puts "\nSymbols for enum values (Rails-like):"

class Order
  def self.statuses
    { pending: 0, processing: 1, shipped: 2, delivered: 3 }
  end

  def status=(status_symbol)
    @status = self.class.statuses[status_symbol]
  end

  def status
    self.class.statuses.key(@status)
  end
end

order = Order.new
order.status = :processing
puts "Order status: #{order.status}"              # :processing

# Symbol operators
puts "\nSymbol operators:"
puts "Symbol equality: #{:name == :name}"         # true
puts "Symbol equality with string: #{:name == "name"}"  # false
puts "Symbol to proc (&:method):"
numbers = [1, 2, 3, 4, 5]
squares = numbers.map(&:to_s)                    # Equivalent to: numbers.map { |n| n.to_s }
puts "squares: #{squares}"                       # ["1", "2", "3", "4", "5"]

# Symbol methods
puts "\nSymbol methods:"
puts "Capitalize: #{:hello.capitalize}"          # :Hello
puts "Upcase: #{:hello.upcase}"                  # :HELLO
puts "Downcase: #{:HELLO.downcase}"              # :hello
puts "Succ (next): #{:a.succ}"                   # :b
puts "Symbol slice: #{:hello[1..3]}"             # "ell" (returns string)
puts "Symbol length: #{:hello.length}"           # 5
puts "All symbols include?: #{:hello.include?("e")}"  # true

# Symbol to Proc - a powerful feature
puts "\nSymbol to Proc pattern:"
words = ["apple", "banana", "cherry"]
upcased = words.map(&:upcase)
lengths = words.map(&:length)

puts "Original: #{words}"                        # ["apple", "banana", "cherry"]
puts "Upcased: #{upcased}"                       # ["APPLE", "BANANA", "CHERRY"]
puts "Lengths: #{lengths}"                       # [5, 6, 6]

# Comparing symbol performance vs strings
puts "\nPerformance comparison (conceptual):"
require "benchmark"

iterations = 1_000_000
Benchmark.bm do |x|
  x.report("String comparison:") do
    iterations.times do
      "name" == "name"
    end
  end

  x.report("Symbol comparison:") do
    iterations.times do
      :name == :name
    end
  end
end
# Symbols are generally faster for comparison operations

# Getting all symbols (can be dangerous in production)
# Limited output for demonstration
puts "\nSome system symbols:"
some_symbols = Symbol.all_symbols.first(5)
puts "First 5 symbols: #{some_symbols}"

# Symbol garbage collection (Ruby 2.2+)
puts "\nSymbol garbage collection (Ruby 2.2+):"
puts "Symbols can now be garbage collected if not referenced"
puts "This helps prevent memory leaks with dynamically created symbols"

# Type checking
puts "\nType checking:"
puts ":name.is_a?(Symbol): #{:name.is_a?(Symbol)}"       # true
puts ":name.kind_of?(Symbol): #{:name.kind_of?(Symbol)}" # true
puts "'name'.is_a?(Symbol): #{"name".is_a?(Symbol)}"     # false
