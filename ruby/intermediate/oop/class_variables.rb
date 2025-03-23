# Class variables are shared across all instances of a class
# They start with @@ and are accessible from class and instance methods

########################################################################
# Basic Class Variables
########################################################################

class Counter
  # Class variable initialized at class definition time
  @@count = 0

  def initialize
    @@count += 1
  end

  # Instance method that accesses the class variable
  def report
    "I'm instance ##{@@count}"
  end

  # Class method that accesses the class variable
  def self.count
    @@count
  end

  # Reset the counter
  def self.reset
    @@count = 0
  end
end

puts "Initial count: #{Counter.count}"  
# Initial count: 0

counter1 = Counter.new
counter2 = Counter.new
counter3 = Counter.new

puts "After creating 3 instances, count: #{Counter.count}"  
# After creating 3 instances, count: 3
puts "Counter 1 says: #{counter1.report}"  
# Counter 1 says: I'm instance #3
puts "Counter 2 says: #{counter2.report}"  
# Counter 2 says: I'm instance #3
puts "Counter 3 says: #{counter3.report}"  
# Counter 3 says: I'm instance #3

Counter.reset
puts "After reset, count: #{Counter.count}"  
# After reset, count: 0

########################################################################
# Class Variables vs. Instance Variables in Class Methods
########################################################################

class Example
  # Class variable - shared by all instances and the class itself
  @@class_var = "I'm a class variable"

  # Instance variable of the class object (not shared with instances)
  @class_instance_var = "I'm an instance variable of the class"

  def self.class_var
    @@class_var
  end

  def self.class_instance_var
    @class_instance_var
  end

  def self.change_class_var(value)
    @@class_var = value
  end

  def self.change_class_instance_var(value)
    @class_instance_var = value
  end

  # Instance method accessing class variable
  def instance_access_class_var
    @@class_var
  end

  # Instance method trying to access class instance variable (won't work)
  def instance_access_class_instance_var
    # This returns nil because @class_instance_var belongs to the class object,
    # not the instance
    @class_instance_var
  end

  # Instance method setting its own instance variable
  def set_instance_var(value)
    @instance_var = value
  end

  def get_instance_var
    @instance_var
  end
end

puts "\nClass Variables vs. Instance Variables in Class Methods:"
puts "Class var: #{Example.class_var}"  
# Class var: I'm a class variable
puts "Class instance var: #{Example.class_instance_var}"  
# Class instance var: I'm an instance variable of the class

# Change the values
Example.change_class_var("Updated class var")
Example.change_class_instance_var("Updated class instance var")

puts "Updated class var: #{Example.class_var}"  
# Updated class var: Updated class var
puts "Updated class instance var: #{Example.class_instance_var}"  
# Updated class instance var: Updated class instance var

# Create instance and try accessing the variables
ex = Example.new
puts "Instance accessing class var: #{ex.instance_access_class_var}"  
# Instance accessing class var: Updated class var
puts "Instance accessing class instance var: #{ex.instance_access_class_instance_var.inspect}"  
# Instance accessing class instance var: nil

# Set instance's own instance variable
ex.set_instance_var("My instance var")
puts "Instance var: #{ex.get_instance_var}"  
# Instance var: My instance var

########################################################################
# Class Variables with Inheritance
########################################################################

class Parent
  @@class_var = "Parent value"

  def self.class_var
    @@class_var
  end

  def self.change_class_var(value)
    @@class_var = value
  end

  def instance_access_class_var
    @@class_var
  end
end

class Child < Parent
  # This actually changes the SAME variable as in Parent
  @@class_var = "Child value"

  def child_specific
    "I'm a child method, and class_var is: #{@@class_var}"
  end
end

class AnotherChild < Parent
  # No explicit override, but still shares the same class variable
end

puts "\nClass Variables with Inheritance:"
puts "Parent class_var: #{Parent.class_var}"  
# Parent class_var: Child value
puts "Child class_var: #{Child.class_var}"    
# Child class_var: Child value
puts "AnotherChild class_var: #{AnotherChild.class_var}"  
# AnotherChild class_var: Child value

parent = Parent.new
child = Child.new
another = AnotherChild.new

puts "Parent instance: #{parent.instance_access_class_var}"  
# Parent instance: Child value
puts "Child instance: #{child.instance_access_class_var}"    
# Child instance: Child value
puts "Child specific: #{child.child_specific}"              
# Child specific: I'm a child method, and class_var is: Child value

# Change from the Parent class
Parent.change_class_var("New value from Parent")
puts "After Parent change:"
puts "Parent class_var: #{Parent.class_var}"        
# Parent class_var: New value from Parent
puts "Child class_var: #{Child.class_var}"          
# Child class_var: New value from Parent
puts "AnotherChild class_var: #{AnotherChild.class_var}"  
# AnotherChild class_var: New value from Parent

########################################################################
# Alternatives to Class Variables
########################################################################

# 1. Class instance variables (don't share across inheritance chain)
class BetterParent
  @class_instance_var = "Parent value"

  class << self
    attr_accessor :class_instance_var
  end
end

class BetterChild < BetterParent
  @class_instance_var = "Child value"
end

puts "\nClass Instance Variables Alternative:"
puts "BetterParent class_instance_var: #{BetterParent.class_instance_var}"  
# BetterParent class_instance_var: Parent value
puts "BetterChild class_instance_var: #{BetterChild.class_instance_var}"    
# BetterChild class_instance_var: Child value

# Change from parent
BetterParent.class_instance_var = "New Parent value"
puts "After change:"
puts "BetterParent class_instance_var: #{BetterParent.class_instance_var}"  
# BetterParent class_instance_var: New Parent value
puts "BetterChild class_instance_var: #{BetterChild.class_instance_var}"    
# BetterChild class_instance_var: Child value (unchanged)

# 2. Using a module to namespace class variables
module CounterNamespace
  @@count = 0

  def self.increment
    @@count += 1
  end

  def self.count
    @@count
  end

  def self.reset
    @@count = 0
  end
end

puts "\nNamespaced Class Variables:"
puts "Initial count: #{CounterNamespace.count}"  
# Initial count: 0
CounterNamespace.increment
CounterNamespace.increment
puts "After incrementing: #{CounterNamespace.count}"  
# After incrementing: 2
CounterNamespace.reset
puts "After reset: #{CounterNamespace.count}"  
# After reset: 0

########################################################################
# When to Use Class Variables
########################################################################

class User
  # Track total user count
  @@user_count = 0

  # Store application-wide configuration
  @@config = {
    max_login_attempts: 3,
    session_timeout: 3600,
    default_timezone: "UTC",
  }

  def initialize(username)
    @username = username
    @@user_count += 1
  end

  def self.user_count
    @@user_count
  end

  def self.get_config(key)
    @@config[key]
  end

  def self.update_config(key, value)
    @@config[key] = value
  end

  def max_login_attempts
    @@config[:max_login_attempts]
  end
end

puts "\nPractical Class Variable Usage:"
puts "Initial user count: #{User.user_count}"  
# Initial user count: 0
puts "Max login attempts: #{User.get_config(:max_login_attempts)}"  
# Max login attempts: 3

user1 = User.new("alice")
user2 = User.new("bob")
puts "User count after creating users: #{User.user_count}"  
# User count after creating users: 2
puts "User's max login attempts: #{user1.max_login_attempts}"  
# User's max login attempts: 3

User.update_config(:max_login_attempts, 5)
puts "Updated max login attempts: #{User.get_config(:max_login_attempts)}"  
# Updated max login attempts: 5
puts "User's updated max login attempts: #{user1.max_login_attempts}"  
# User's updated max login attempts: 5

########################################################################
# Cautions and Best Practices
########################################################################

# Key cautions with class variables:
# 1. They're shared in inheritance (which can be surprising)
# 2. They can lead to hard-to-debug issues
# 3. They make testing more difficult (state persists between tests)

# Best practices:
# 1. Use class instance variables (@var) instead of class variables (@@var) when possible
# 2. Consider using a module to namespace variables if needed
# 3. Reset class variables between tests
# 4. Use class variables sparingly and for clearly global concepts

# Example of a singleton pattern using class methods instead of class variables
class Logger
  @instance = nil
  @log_level = :info

  private_class_method :new

  def self.instance
    @instance ||= new
  end

  def self.log_level
    @log_level
  end

  def self.log_level=(level)
    @log_level = level
  end

  def log(message, level = :info)
    return unless valid_level?(level)
    puts "[#{level.upcase}] #{message}"
  end

  private

  def valid_level?(level)
    levels = { :debug => 0, :info => 1, :warn => 2, :error => 3 }
    levels[level] >= levels[self.class.log_level]
  end
end

puts "\nSingleton Pattern Alternative:"
logger = Logger.instance
logger.log("This is an info message")  
# [INFO] This is an info message
logger.log("This is a debug message", :debug)  
# (No output - debug message not displayed because below default level)

Logger.log_level = :debug
logger.log("Now debug is visible", :debug)  
# [DEBUG] Now debug is visible

# This would fail:
# Logger.new  # private method `new' called