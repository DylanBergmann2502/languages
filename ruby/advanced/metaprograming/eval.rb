# Ruby Metaprogramming: eval and friends
# eval executes strings or blocks as Ruby code

########################################################################
# Basic eval
result = eval("2 + 2")
puts result  # 4

name = "Ruby"
result = eval("'Hello, ' + name + '!'")
puts result  # Hello, Ruby!

########################################################################
# Security warning: NEVER use eval with user input
# This creates a serious security vulnerability (code injection)
# puts eval(gets.chomp)  # NEVER DO THIS!

########################################################################
# Different types of eval

# 1. eval - evaluates string in current context
x = 10
result = eval("x * 2")
puts result  # 20

# 2. instance_eval - evaluates in the context of an object
class Person
  def initialize(name)
    @name = name
  end
end

person = Person.new("Ruby")
# Access private instance variable
result = person.instance_eval { @name }
puts result  # Ruby

# 3. class_eval / module_eval - evaluates in the context of a class/module
Person.class_eval do
  def greeting
    "Hello, my name is #{@name}"
  end
end

puts person.greeting  # Hello, my name is Ruby

# 4. binding.eval - evaluates in the context of a binding
def create_binding(value)
  local_var = value
  return binding
end

b = create_binding(123)
result = b.eval("local_var")
puts result  # 123

########################################################################
# Using instance_eval to create DSLs (Domain Specific Languages)
class House
  attr_accessor :rooms, :square_feet, :address

  def initialize
    @rooms = 0
    @square_feet = 0
    @address = ""
  end

  def self.build(&block)
    house = new
    house.instance_eval(&block)
    house
  end
end

my_house = House.build do
  self.rooms = 5
  self.square_feet = 2000
  self.address = "123 Ruby Lane"
end

puts "My house has #{my_house.rooms} rooms and is #{my_house.square_feet} square feet"
# My house has 5 rooms and is 2000 square feet

########################################################################
# Using class_eval to add methods to existing classes
String.class_eval do
  def reverse_and_upcase
    self.reverse.upcase
  end
end

puts "hello".reverse_and_upcase  # OLLEH

########################################################################
# binding - captures current execution context
def get_binding(param)
  local_var = "local"
  binding
end

b1 = get_binding("hello")
b2 = get_binding("world")

puts b1.eval("param")      # hello
puts b2.eval("param")      # world
puts b1.eval("local_var")  # local

########################################################################
# eval with File.read - loading code from a file
# Assuming we have a file called 'example.rb' with the content: "puts 'Hello from file!'"
# eval(File.read("example.rb"))

########################################################################
# Alternative to eval: Using send for safer metaprogramming
class Calculator
  def add(a, b)
    a + b
  end

  def subtract(a, b)
    a - b
  end
end

calc = Calculator.new
method_name = "add"  # This could come from user input or elsewhere
if calc.respond_to?(method_name)
  result = calc.send(method_name, 5, 3)
  puts result  # 8
end

########################################################################
# Using define_method instead of eval
class DynamicClass
  ["add", "subtract", "multiply", "divide"].each do |operation|
    define_method(operation) do |a, b|
      case operation
      when "add"
        a + b
      when "subtract"
        a - b
      when "multiply"
        a * b
      when "divide"
        a / b
      end
    end
  end
end

dynamic = DynamicClass.new
puts dynamic.add(10, 5)       # 15
puts dynamic.subtract(10, 5)  # 5
puts dynamic.multiply(10, 5)  # 50
puts dynamic.divide(10, 5)    # 2

########################################################################
# Using Object#instance_exec - like instance_eval but allows parameters
class Greeter
  def initialize(greeting)
    @greeting = greeting
  end
end

greeter = Greeter.new("Hello")
result = greeter.instance_exec("Ruby") { |name| "#{@greeting}, #{name}!" }
puts result  # Hello, Ruby!

########################################################################
# Safer alternatives summary:
# 1. Use Object#send for method calls
# 2. Use define_method for method creation
# 3. Use instance_variable_get/set for instance variables
# 4. Use Module#const_get/set for constants
# 5. Use binding.local_variable_get/set for local variables

# Example of safer metaprogramming
class SaferMetaprogramming
  def initialize
    @data = {}
  end

  def method_missing(method_name, *args)
    method_str = method_name.to_s

    if method_str.end_with?("=")
      # Setter
      key = method_str.chop
      @data[key] = args.first
      # Dynamically define the method for future calls
      self.class.define_method(method_name) do |value|
        @data[key] = value
      end
    else
      # Getter
      value = @data[method_str]
      # Dynamically define the method for future calls
      self.class.define_method(method_name) do
        @data[method_str]
      end
      value
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    true
  end
end

obj = SaferMetaprogramming.new
obj.name = "Ruby"
puts obj.name  # Ruby
