# objects.rb - Understanding Ruby Objects

# In Ruby, everything is an object
# Even classes themselves are objects of the Class class

########################################################################
# Object Identity
########################################################################

# Every object has a unique object_id
str1 = "hello"
str2 = "hello"
str3 = str1

puts "str1 object_id: #{str1.object_id}"
puts "str2 object_id: #{str2.object_id}"  # Different from str1
puts "str3 object_id: #{str3.object_id}"  # Same as str1

# Symbols with the same name always have the same object_id
sym1 = :hello
sym2 = :hello
puts "sym1 object_id: #{sym1.object_id}"
puts "sym2 object_id: #{sym2.object_id}"  # Same as sym1

########################################################################
# Object State
########################################################################

# Objects encapsulate state (data) and behavior (methods)
class Person
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def to_s
    "Person: #{@name}, #{@age} years old"
  end
end

alice = Person.new("Alice", 30)
puts alice  # Person: Alice, 30 years old

# Changing object state
alice.name = "Alice Smith"
alice.age = 31
puts alice  # Person: Alice Smith, 31 years old

########################################################################
# Object Introspection
########################################################################

# Ruby provides many methods to introspect (examine) objects at runtime

# Check an object's class
puts alice.class  # Person

# Check if an object is an instance of a class
puts alice.is_a?(Person)  # true
puts alice.is_a?(Object)  # true (all objects inherit from Object)
puts alice.is_a?(String)  # false

# Check if an object can respond to a method
puts alice.respond_to?(:name)  # true
puts alice.respond_to?(:fly)   # false

# Get a list of methods an object responds to
puts alice.methods.sort[0..5].inspect  # Sample of 6 methods

# Get instance variables of an object
puts alice.instance_variables.inspect  # [:@name, :@age]

########################################################################
# Object Creation Patterns
########################################################################

# Factory pattern - a method that creates objects
class PersonFactory
  def self.create_adult(name)
    Person.new(name, 18)
  end

  def self.create_child(name)
    Person.new(name, 10)
  end
end

adult = PersonFactory.create_adult("Bob")
child = PersonFactory.create_child("Charlie")

puts adult  # Person: Bob, 18 years old
puts child  # Person: Charlie, 10 years old

# Creating objects with a block
class Car
  attr_accessor :make, :model, :year

  def initialize
    yield self if block_given?
  end

  def to_s
    "Car: #{@year} #{@make} #{@model}"
  end
end

# Create and configure an object in one step
car = Car.new do |c|
  c.make = "Toyota"
  c.model = "Camry"
  c.year = 2023
end

puts car  # Car: 2023 Toyota Camry

########################################################################
# Object Lifecycle
########################################################################

class LifecycleDemo
  attr_reader :name

  def initialize(name)
    @name = name
    puts "#{@name} created"
  end

  # Method called by garbage collector before object is destroyed
  def finalize
    puts "#{@name} being finalized"
  end

  # This ensures our finalize method gets called
  def self.create(name)
    obj = new(name)
    ObjectSpace.define_finalizer(obj, proc { puts "#{name} destroyed" })
    obj
  end
end

# Normal creation
normal_obj = LifecycleDemo.new("Object 1")    # Object 1 created

# Creation with finalizer
final_obj = LifecycleDemo.create("Object 2")  # Object 2 created

puts "Objects created: #{normal_obj.name}, #{final_obj.name}"

# The finalizer would typically run when garbage collection happens
# For demo purposes, we'll manually trigger garbage collection
# Note: In practice, you rarely need to manually trigger GC
puts "Attempting to force garbage collection (may not work in all Ruby implementations)"
ObjectSpace.garbage_collect

########################################################################
# Objects as Closures
########################################################################

def counter_generator
  count = 0

  # Return a Proc object that encloses the count variable
  Proc.new do
    count += 1
  end
end

counter1 = counter_generator
counter2 = counter_generator

puts counter1.call  # 1
puts counter1.call  # 2
puts counter1.call  # 3

puts counter2.call  # 1 (separate count variable)

# A more object-oriented approach to the same idea
class Counter
  def initialize
    @count = 0
  end

  def increment
    @count += 1
  end
end

c1 = Counter.new
c2 = Counter.new

puts c1.increment  # 1
puts c1.increment  # 2
puts c2.increment  # 1 (separate instance)
