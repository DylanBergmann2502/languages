# Ruby is dynamically typed, but has methods for verifying types

# Basic data types for demonstration
num_integer = 42
num_float = 3.14
text = "Hello, Ruby!"
symbol = :ruby
arr = [1, 2, 3]
hash = { name: "Ruby", year: 1995 }
range = 1..10
regex = /\d+/
a_proc = Proc.new { |x| x * 2 }
bool_true = true
bool_false = false
nil_value = nil

# 1. Using .class to determine the class
puts "Using .class to check types:"
puts "#{num_integer.inspect} is a #{num_integer.class}"  # 42 is a Integer
puts "#{num_float.inspect} is a #{num_float.class}"      # 3.14 is a Float
puts "#{text.inspect} is a #{text.class}"                # "Hello, Ruby!" is a String
puts "#{symbol.inspect} is a #{symbol.class}"            # :ruby is a Symbol
puts "#{arr.inspect} is a #{arr.class}"                  # [1, 2, 3] is a Array
puts "#{hash.inspect} is a #{hash.class}"                # {:name=>"Ruby", :year=>1995} is a Hash
puts "#{range.inspect} is a #{range.class}"              # 1..10 is a Range
puts "#{regex.inspect} is a #{regex.class}"              # /\d+/ is a Regexp
puts "#{a_proc.inspect} is a #{a_proc.class}"            # #<Proc:0x...> is a Proc
puts "#{bool_true.inspect} is a #{bool_true.class}"      # true is a TrueClass
puts "#{bool_false.inspect} is a #{bool_false.class}"    # false is a FalseClass
puts "#{nil_value.inspect} is a #{nil_value.class}"      # nil is a NilClass

# 2. Using .is_a? to check if an object is of a specific class or its subclasses
puts "\nUsing .is_a? to check types:"
puts "Is integer an Integer? #{num_integer.is_a?(Integer)}"    # true
puts "Is integer a Numeric? #{num_integer.is_a?(Numeric)}"     # true (Integer inherits from Numeric)
puts "Is float a Float? #{num_float.is_a?(Float)}"             # true
puts "Is float an Integer? #{num_float.is_a?(Integer)}"        # false
puts "Is text a String? #{text.is_a?(String)}"                 # true
puts "Is hash a Hash? #{hash.is_a?(Hash)}"                     # true
puts "Is hash an Array? #{hash.is_a?(Array)}"                  # false

# 3. Using .kind_of? (alias for is_a?)
puts "\nUsing .kind_of? (same as is_a?):"
puts "Is integer an Integer? #{num_integer.kind_of?(Integer)}" # true
puts "Is integer a Numeric? #{num_integer.kind_of?(Numeric)}"  # true

# 4. Using .instance_of? to check direct class (not parent classes)
puts "\nUsing .instance_of? to check direct class:"
puts "Is integer an Integer? #{num_integer.instance_of?(Integer)}" # true
puts "Is integer a Numeric? #{num_integer.instance_of?(Numeric)}"  # false (Integer inherits from Numeric)

# 5. Using .respond_to? to check if an object can handle a specific method
puts "\nUsing .respond_to? to check available methods:"
puts "Does string respond to upcase? #{text.respond_to?(:upcase)}"   # true
puts "Does integer respond to upcase? #{num_integer.respond_to?(:upcase)}" # false
puts "Does array respond to each? #{arr.respond_to?(:each)}"         # true
puts "Does hash respond to keys? #{hash.respond_to?(:keys)}"         # true

# 6. Class hierarchy investigation with .ancestors
puts "\nClass hierarchy with .ancestors:"
puts "Integer ancestors: #{Integer.ancestors}"
# [Integer, Numeric, Comparable, Object, Kernel, BasicObject]
puts "String ancestors: #{String.ancestors}"
# [String, Comparable, Object, Kernel, BasicObject]
puts "Hash ancestors: #{Hash.ancestors}"
# [Hash, Enumerable, Object, Kernel, BasicObject]

# 7. Checking inheritance with
puts "\nInheritance relationships:"
puts "Is Integer < Numeric? #{Integer < Numeric}"  # true
puts "Is Float < Numeric? #{Float < Numeric}"      # true
puts "Is String < Numeric? #{String < Numeric rescue "No relationship"}"  # No relationship

# 8. Type checking methods for specific data types
puts "\nSpecific type checking methods:"
puts "Is integer a number? #{num_integer.is_a?(Numeric)}"    # true
puts "Is float a number? #{num_float.is_a?(Numeric)}"        # true
puts "Is text a number? #{text.is_a?(Numeric)}"              # false

puts "Is integer an integer? #{num_integer.integer?}"        # true (Integer method)
puts "Is float an integer? #{num_float.integer?}"            # false (Float method)
puts "Is float a float? #{num_float.is_a?(Float)}"           # true

puts "Is range a range? #{range.is_a?(Range)}"               # true
puts "Is regex a regex? #{regex.is_a?(Regexp)}"              # true

# 9. Duck typing - checking behavior rather than class
puts "\nDuck typing example:"

class Duck
  def quack
    "Quack!"
  end

  def swim
    "Swimming"
  end
end

class Person
  def quack
    "I'm pretending to be a duck!"
  end

  def swim
    "I can swim too!"
  end
end

def make_it_quack(object)
  if object.respond_to?(:quack)
    puts "This object quacks: #{object.quack}"
  else
    puts "This object cannot quack!"
  end
end

duck = Duck.new
person = Person.new
integer = 42

make_it_quack(duck)    # This object quacks: Quack!
make_it_quack(person)  # This object quacks: I'm pretending to be a duck!
make_it_quack(integer) # This object cannot quack!

# 10. Type checking collections
puts "\nChecking collection elements:"
mixed_array = [1, "two", :three, 4.0, [5], { six: 6 }]
mixed_array.each do |item|
  puts "#{item.inspect} is a #{item.class}"
end
# 1 is a Integer
# "two" is a String
# :three is a Symbol
# 4.0 is a Float
# [5] is a Array
# {:six=>6} is a Hash

# 11. Checking for nil and empty values
puts "\nChecking for nil and empty values:"
puts "Is nil_value nil? #{nil_value.nil?}"                 # true
puts "Is num_integer nil? #{num_integer.nil?}"             # false
puts "Is empty string nil? #{"".nil?}"                     # false
puts "Is empty string empty? #{"".empty?}"                 # true
puts "Is empty array empty? #{[].empty?}"                  # true
puts "Is empty hash empty? #{{}.empty?}"                   # true

# 12. Using custom type checking
puts "\nCustom type checking:"

class Animal
  def speak
    "Generic animal sound"
  end
end

class Dog < Animal
  def speak
    "Woof!"
  end
end

class Cat < Animal
  def speak
    "Meow!"
  end
end

def describe_animal(animal)
  if !animal.is_a?(Animal)
    puts "This is not an animal!"
  elsif animal.instance_of?(Dog)
    puts "This is specifically a dog, and it says: #{animal.speak}"
  elsif animal.instance_of?(Cat)
    puts "This is specifically a cat, and it says: #{animal.speak}"
  else
    puts "This is some kind of animal, and it says: #{animal.speak}"
  end
end

animal = Animal.new
dog = Dog.new
cat = Cat.new
not_animal = "I'm a string"

describe_animal(animal)  # This is some kind of animal, and it says: Generic animal sound
describe_animal(dog)     # This is specifically a dog, and it says: Woof!
describe_animal(cat)     # This is specifically a cat, and it says: Meow!
describe_animal(not_animal) # This is not an animal!

# 13. Using case with types
puts "\nUsing case with type checking:"

def what_is_it(obj)
  case obj
  when String
    "It's a string of length #{obj.length}"
  when Integer
    "It's an integer with value #{obj}"
  when Float
    "It's a float with value #{obj}"
  when Array
    "It's an array with #{obj.length} elements"
  when Hash
    "It's a hash with #{obj.keys.length} keys"
  when nil
    "It's nil"
  else
    "It's something else: #{obj.class}"
  end
end

puts what_is_it("Hello")        # It's a string of length 5
puts what_is_it(42)             # It's an integer with value 42
puts what_is_it(3.14)           # It's a float with value 3.14
puts what_is_it([1, 2, 3])      # It's an array with 3 elements
puts what_is_it({ a: 1, b: 2 })   # It's a hash with 2 keys
puts what_is_it(nil)            # It's nil
puts what_is_it(Time.now)       # It's something else: Time
