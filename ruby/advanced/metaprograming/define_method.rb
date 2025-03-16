# Ruby Metaprogramming: define_method
# define_method creates methods dynamically at runtime

########################################################################
# Basic define_method example
class Greeter
  define_method :hello do |name|
    "Hello, #{name}!"
  end
end

greeter = Greeter.new
puts greeter.hello("Ruby")  # Hello, Ruby!

########################################################################
# Generating multiple methods with define_method
class MathOperations
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

math = MathOperations.new
puts math.add(5, 3)       # 8
puts math.subtract(5, 3)  # 2
puts math.multiply(5, 3)  # 15
puts math.divide(6, 3)    # 2

########################################################################
# Creating attribute accessors with define_method
class Person
  def self.attributes(*names)
    names.each do |name|
      # Define getter
      define_method(name) do
        instance_variable_get("@#{name}")
      end

      # Define setter
      define_method("#{name}=") do |value|
        instance_variable_set("@#{name}", value)
      end
    end
  end

  attributes :name, :age, :location
end

person = Person.new
person.name = "Ruby"
person.age = 30
person.location = "Programming Land"
puts "#{person.name} is a #{person.age}-year-old from #{person.location}"
# Ruby is a 30-year-old from Programming Land

########################################################################
# Accessing local variables in define_method
class Counter
  [1, 2, 3].each do |number|
    define_method("count_#{number}") do
      "Counting to #{number}"
    end
  end
end

counter = Counter.new
puts counter.count_1  # Counting to 1
puts counter.count_2  # Counting to 2
puts counter.count_3  # Counting to 3

########################################################################
# Using define_method with a block
class Calculator
  def initialize(initial_value = 0)
    @value = initial_value
  end

  def value
    @value
  end

  def self.define_operation(name, &operation)
    define_method(name) do |operand|
      @value = operation.call(@value, operand)
      self  # Return self for method chaining
    end
  end

  define_operation(:add) { |value, operand| value + operand }
  define_operation(:subtract) { |value, operand| value - operand }
  define_operation(:multiply) { |value, operand| value * operand }
  define_operation(:divide) { |value, operand| value / operand }
end

calc = Calculator.new(10)
puts calc.add(5).multiply(2).subtract(7).divide(3).value  # 6

########################################################################
# Using define_method with method delegation
module MethodImporter
  def import_methods_from(source)
    # Store the source object as a class variable
    @source_object = source

    # Get methods defined specifically on the source's class (not inherited ones)
    source.class.instance_methods(false).each do |method_name|
      # Define a method that delegates to the source object
      define_method(method_name) do |*args, &block|
        self.class.instance_variable_get(:@source_object).send(method_name, *args, &block)
      end
    end
  end
end

class MethodSource
  def special_greeting(name)
    "Special hello to #{name}!"
  end

  def magic_number
    42
  end
end

# Create a new class with the imported methods
class MethodDestination
  extend MethodImporter
end

# Create instances and test
source = MethodSource.new
MethodDestination.import_methods_from(source)
dest = MethodDestination.new

puts dest.special_greeting("Ruby")  # Should print: Special hello to Ruby!
puts dest.magic_number              # Should print: 42

########################################################################
# Using define_method in a module for mixins
module Loggable
  def self.included(base)
    base.class_eval do
      base.instance_methods(false).each do |method_name|
        original_method = instance_method(method_name)

        define_method(method_name) do |*args, &block|
          puts "Calling #{method_name} with #{args.inspect}"
          result = original_method.bind(self).call(*args, &block)
          puts "#{method_name} returned #{result.inspect}"
          result
        end
      end
    end
  end
end

class SimpleCalculator
  def add(a, b)
    a + b
  end

  include Loggable  # This will wrap all methods with logging
end

simple_calc = SimpleCalculator.new
simple_calc.add(3, 4)
# Calling add with [3, 4]
# add returned 7

########################################################################
# define_method vs class_eval with def
# 1. define_method can close over variables in its scope
# 2. define_method is often clearer for dynamic method generation
# 3. class_eval with def is more like writing normal Ruby code

# Example with class_eval
class DynamicMethods
  # This creates methods using class_eval and def
  (1..3).each do |i|
    class_eval <<-RUBY
        def multiply_by_#{i}(value)
          value * #{i}
        end
      RUBY
  end
end

dynamic = DynamicMethods.new
puts dynamic.multiply_by_1(5)  # 5
puts dynamic.multiply_by_2(5)  # 10
puts dynamic.multiply_by_3(5)  # 15
