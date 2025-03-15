############################################################
# Local Variables
# Variables defined within a method are local to that method
def demonstrate_local_scope
  local_var = "I'm local to this method"
  puts local_var
end

demonstrate_local_scope  # Output: I'm local to this method
# puts local_var  # This would raise an error: undefined local variable

############################################################
# Method Parameters
# Parameters are also local variables within the method
def greet(name)
  puts "Hello, #{name}!"
  # name is only available inside this method
end

greet("Ruby")  # Output: Hello, Ruby!
# puts name  # This would raise an error: undefined local variable

############################################################
# Global Variables
# Variables that start with $ are global
$app_name = "Ruby Scope Demo"

def show_app_name
  puts "App name: #{$app_name}"
end

show_app_name  # Output: App name: Ruby Scope Demo
$app_name = "Changed App Name"
show_app_name  # Output: App name: Changed App Name

############################################################
# Instance Variables
# Variables that start with @ are instance variables
class Person
  def initialize(name)
    @name = name  # Instance variable
  end

  def introduce
    puts "Hi, I'm #{@name}"
  end

  def change_name(new_name)
    @name = new_name
  end
end

person = Person.new("Alice")
person.introduce       # Output: Hi, I'm Alice
person.change_name("Bob")
person.introduce       # Output: Hi, I'm Bob

############################################################
# Class Variables
# Variables that start with @@ are class variables
class Counter
  @@count = 0  # Class variable shared across all instances

  def initialize
    @@count += 1
  end

  def self.count
    @@count
  end

  def count
    @@count
  end
end

puts "Initial count: #{Counter.count}"  # Output: Initial count: 0
counter1 = Counter.new
puts "After first instance: #{Counter.count}"  # Output: After first instance: 1
counter2 = Counter.new
puts "After second instance: #{counter1.count}"  # Output: After second instance: 2

############################################################
# Constants
# Constants start with a capital letter
PI = 3.14159

def calculate_circle_area(radius)
  PI * radius ** 2
end

puts "Area of circle: #{calculate_circle_area(5)}"  # Output: Area of circle: 78.53975

# Constants defined within a class or module
class MathConstants
  PI = 3.14159
  E = 2.71828

  def self.print_constants
    puts "PI: #{PI}, E: #{E}"
  end
end

MathConstants.print_constants  # Output: PI: 3.14159, E: 2.71828
puts MathConstants::PI  # Output: 3.14159

############################################################
# Block Scope
# Blocks can access variables from their surrounding scope
def block_scope_demo
  outer_var = "I'm from the outer scope"

  # The block can access outer_var
  1.times do
    puts "Inside block: #{outer_var}"
    inner_var = "I'm defined inside the block"
    puts "Inside block: #{inner_var}"
  end

  # puts inner_var  # This would raise an error: undefined local variable
  puts "Outside block: #{outer_var}"
end

block_scope_demo
# Output:
# Inside block: I'm from the outer scope
# Inside block: I'm defined inside the block
# Outside block: I'm from the outer scope

############################################################
# Blocks and Variable Shadowing
# Block parameters shadow variables of the same name in the outer scope
def demonstrate_shadowing
  value = "outer"

  puts "Before block: #{value}"

  # Here, value is a block parameter that shadows the outer value
  [1, 2, 3].each do |value|
    puts "Block parameter: #{value}"
    # This refers to the block parameter, not the outer variable
  end

  puts "After block: #{value}"  # Still refers to the outer value
end

demonstrate_shadowing
# Output:
# Before block: outer
# Block parameter: 1
# Block parameter: 2
# Block parameter: 3
# After block: outer

############################################################
# Closures and Scope
# Ruby blocks, procs, and lambdas create closures
def create_counter
  count = 0

  # This proc maintains a reference to the count variable
  Proc.new do
    count += 1
    puts "Count is now: #{count}"
  end
end

counter = create_counter
counter.call  # Output: Count is now: 1
counter.call  # Output: Count is now: 2
counter.call  # Output: Count is now: 3

############################################################
# Method Binding and self
# The self keyword refers to the current object
class SelfDemo
  def show_self
    puts "Inside instance method, self is: #{self}"
  end

  def self.class_method
    puts "Inside class method, self is: #{self}"
  end
end

demo = SelfDemo.new
demo.show_self       # Output: Inside instance method, self is: #<SelfDemo:0x...>
SelfDemo.class_method  # Output: Inside class method, self is: SelfDemo
