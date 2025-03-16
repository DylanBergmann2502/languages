# Inheritance allows a class to inherit behavior from another class
# This creates an "is-a" relationship between classes

########################################################################
# Basic Inheritance
########################################################################

# Parent class (superclass, base class)
class Animal
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def speak
    "Some generic animal sound"
  end

  def sleep
    "#{@name} is sleeping."
  end

  def move
    "#{@name} is moving."
  end
end

# Child class (subclass, derived class) inherits from Animal
class Dog < Animal
  # Override the speak method
  def speak
    "Woof!"
  end

  # Add a new method specific to dogs
  def fetch
    "#{@name} is fetching the ball!"
  end
end

# Another child class
class Cat < Animal
  def speak
    "Meow!"
  end

  def purr
    "#{@name} is purring."
  end
end

# Create instances and test
dog = Dog.new("Rex")
cat = Cat.new("Whiskers")

puts "Dog:"
puts dog.name   # Rex (inherited from Animal)
puts dog.speak  # Woof! (overridden)
puts dog.sleep  # Rex is sleeping. (inherited)
puts dog.fetch  # Rex is fetching the ball! (Dog-specific)

puts "\nCat:"
puts cat.name   # Whiskers
puts cat.speak  # Meow! (overridden)
puts cat.purr   # Whiskers is purring. (Cat-specific)

# This would raise an error - cats can't fetch
# puts cat.fetch  # NoMethodError

########################################################################
# Inheritance Hierarchy and Method Lookup
########################################################################

# Ruby searches for methods up the inheritance chain
puts "\nInheritance hierarchy:"
puts Dog.ancestors.inspect  # [Dog, Animal, Object, Kernel, BasicObject]

class Vehicle
  def start_engine
    "Engine starting..."
  end
end

class Car < Vehicle
  def drive
    "Car is driving."
  end
end

class SportsCar < Car
  def drive
    "SportsCar is driving FAST!"
  end
end

sports_car = SportsCar.new
puts sports_car.drive         # SportsCar is driving FAST!
puts sports_car.start_engine  # Engine starting... (inherited from Vehicle)

########################################################################
# The super Keyword
########################################################################

class Parent
  def greet
    "Hello from Parent"
  end

  def introduce(name)
    "Hi #{name}, I'm a parent"
  end

  def report(*items)
    "Parent received: #{items.join(", ")}"
  end
end

class Child < Parent
  # Override greet and call parent's version using super
  def greet
    "#{super} and Child"
  end

  # Override introduce and pass specific arguments to super
  def introduce(name)
    "#{super(name)} and a child"
  end

  # Override report and pass all arguments to super
  def report(*items)
    "Child: #{super}"
  end
end

child = Child.new
puts child.greet      # Hello from Parent and Child
puts child.introduce("Alice")  # Hi Alice, I'm a parent and a child
puts child.report("apple", "banana")  # Child: Parent received: apple, banana

########################################################################
# Constructor Inheritance
########################################################################

class Person
  attr_reader :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def introduce
    "Hi, I'm #{@name} and I'm #{@age} years old."
  end
end

class Student < Person
  attr_reader :university

  # Extend the parent constructor
  def initialize(name, age, university)
    # Call the parent constructor first
    super(name, age)
    # Add our own initialization
    @university = university
  end

  def introduce
    "#{super} I study at #{@university}."
  end
end

student = Student.new("Bob", 20, "Harvard")
puts student.introduce  # Hi, I'm Bob and I'm 20 years old. I study at Harvard.

########################################################################
# Multiple Inheritance (Ruby doesn't support this directly)
########################################################################

# Ruby doesn't support multiple inheritance, but uses modules for similar functionality
# (see modules.rb and mixins.rb for more)

########################################################################
# Inheritance vs. Composition
########################################################################

# Inheritance ("is-a" relationship) example:
# A SportsCar is a Car

# Composition ("has-a" relationship) example:
class Engine
  def start
    "Engine started"
  end

  def stop
    "Engine stopped"
  end
end

class ElectricCar
  # Composition: ElectricCar has an Engine
  def initialize
    @engine = Engine.new
  end

  def start_car
    "Electric car: #{@engine.start}"
  end

  def stop_car
    "Electric car: #{@engine.stop}"
  end
end

electric_car = ElectricCar.new
puts electric_car.start_car  # Electric car: Engine started
puts electric_car.stop_car   # Electric car: Engine stopped

########################################################################
# Method Visibility in Inheritance
########################################################################

class Base
  def public_method
    "This is public"
  end

  protected

  def protected_method
    "This is protected"
  end

  private

  def private_method
    "This is private"
  end
end

class Derived < Base
  def call_methods
    puts public_method       # Works - public methods are accessible anywhere
    puts protected_method    # Works - protected methods are accessible to subclasses
    puts private_method      # Works - private methods are accessible to subclasses in Ruby
  end

  def call_on_other(other_derived)
    puts other_derived.public_method        # Works - public
    puts other_derived.protected_method     # Works - protected methods can be called on other instances of the same class family
    # This would fail:
    # puts other_derived.private_method     # Error - private methods can't be called with an explicit receiver
  end
end

derived1 = Derived.new
derived2 = Derived.new
derived1.call_methods
derived1.call_on_other(derived2)

# This would fail:
# derived1.private_method    # Error - private method
