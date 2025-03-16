# Ruby Metaprogramming: Reflection
# Reflection allows you to examine code during runtime

########################################################################
# Object Inspection: Getting an object's class
puts "STRING".class  # String
puts 42.class        # Integer
puts [1, 2, 3].class # Array

# Getting all instance methods
string_methods = "hello".methods
puts "String has #{string_methods.count} methods"

# List first 5 methods (sorted for consistency)
puts string_methods.sort[0...5].inspect # [:!, :!=, :!~, :%, :*]

########################################################################
# Getting only the methods defined directly on String (not inherited)
string_only_methods = String.instance_methods(false)
puts "String class itself defines #{string_only_methods.count} methods"

# Checking if an object responds to a method
puts "hello".respond_to?(:upcase)  # true
puts "hello".respond_to?(:dance)   # false

########################################################################
# Getting an object's instance variables
class Person
  def initialize(name, age)
    @name = name
    @age = age
  end
end

person = Person.new("Ruby", 30)
puts person.instance_variables.inspect  # [:@name, :@age]

# Getting the value of an instance variable
puts person.instance_variable_get(:@name)  # Ruby
puts person.instance_variable_get(:@age)   # 30

# Setting the value of an instance variable
person.instance_variable_set(:@name, "New Ruby")
puts person.instance_variable_get(:@name)  # New Ruby

########################################################################
# Class inspection
# Getting all ancestors (inheritance chain)
puts String.ancestors.inspect  # [String, Comparable, Object, Kernel, BasicObject]

# Getting all constants defined in a class
puts Math.constants[0...5].inspect  # [:DomainError, :E, :PI, ...]

########################################################################
# Method inspection
# Get a method object
upcase_method = "hello".method(:upcase)
puts upcase_method.class  # Method

# Call the method object
puts upcase_method.call  # HELLO

# Get method parameters and arity
def example_method(required, optional = nil, *rest, keyword:, optional_keyword: nil, **rest_keywords)
end

method = method(:example_method)
puts "Arity: #{method.arity}"  # -3 (negative means variable number of arguments)
puts "Parameters: #{method.parameters.inspect}"
# [[:req, :required], [:opt, :optional], [:rest, :rest], [:keyreq, :keyword], [:key, :optional_keyword], [:keyrest, :rest_keywords]]

########################################################################
# Getting method source location (requires 'method_source' gem)
# Uncomment to run:
# require 'method_source'
# puts method(:example_method).source

########################################################################
# ObjectSpace - accessing all objects
# Count all strings in the system
puts ObjectSpace.each_object(String).count  # number varies

# Find specific objects (careful, this is slow)
example = "find me"
found = ObjectSpace.each_object(String).find { |obj| obj == "find me" }
puts found  # find me

########################################################################
# Caller information
def show_caller
  puts caller[0]  # Shows file and line where this method was called
end

show_caller  # Shows reflection.rb:line_number

########################################################################
# Getting local variables
local_var = "I'm local"
local_variables_list = local_variables
puts local_variables_list.inspect  # [:local_var, :local_variables_list, ...]

# Using binding to access current scope
current_binding = binding
puts current_binding.local_variable_get(:local_var)  # I'm local
current_binding.local_variable_set(:local_var, "Modified local")
puts local_var  # Modified local
