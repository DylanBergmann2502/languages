# Modules serve multiple purposes in Ruby:
# 1. Namespace - group related code together
# 2. Mixin - add shared behavior to classes
# 3. Utility - container for related methods

########################################################################
# Modules as Namespaces
########################################################################

# Modules help organize code and prevent name conflicts
module Geometry
  PI = 3.14159

  def self.circle_area(radius)
    PI * radius * radius
  end

  def self.circle_circumference(radius)
    2 * PI * radius
  end

  # Nested class within the module
  class Rectangle
    attr_reader :width, :height

    def initialize(width, height)
      @width = width
      @height = height
    end

    def area
      @width * @height
    end

    def perimeter
      2 * (@width + @height)
    end
  end

  # Nested module
  module ThreeDimensional
    def self.cube_volume(side)
      side ** 3
    end

    class Sphere
      def initialize(radius)
        @radius = radius
      end

      def volume
        (4.0 / 3.0) * Geometry::PI * (@radius ** 3)
      end
    end
  end
end

# Accessing constants from a module
puts Geometry::PI  # 3.14159

# Calling module methods
puts Geometry.circle_area(5)  # 78.53975

# Creating an instance of a class inside a module
rect = Geometry::Rectangle.new(3, 4)
puts rect.area  # 12

# Accessing nested modules and classes
puts Geometry::ThreeDimensional.cube_volume(3)  # 27

sphere = Geometry::ThreeDimensional::Sphere.new(2)
puts sphere.volume  # ~33.51

########################################################################
# Modules as Mixins
########################################################################

# Modules can be used to add functionality to classes
module Loggable
  def log(message)
    puts "[LOG] #{Time.now}: #{message}"
  end

  def debug(message)
    puts "[DEBUG] #{message}" if @debug_mode
  end
end

class Product
  # Include the module to add its methods as instance methods
  include Loggable

  attr_reader :name, :price

  def initialize(name, price, debug_mode = false)
    @name = name
    @price = price
    @debug_mode = debug_mode
    log("Created new product: #{name}")
  end

  def discount(percentage)
    discount_amount = price * (percentage / 100.0)
    debug("Discounting #{name} by #{percentage}%")
    @price -= discount_amount
  end
end

product = Product.new("Laptop", 1000, true)
product.discount(10)
product.debug("About to perform operation")  # [DEBUG] About to perform operation

########################################################################
# Module Methods vs. Instance Methods
########################################################################

module Utilities
  # Module method - called directly on the module
  def self.say_hello
    "Hello from module method"
  end

  # Instance method - available when included in a class
  def say_goodbye
    "Goodbye from included method"
  end

  # Both types in the same module
  def self.increment(x)
    x + 1
  end

  def double(x)
    x * 2
  end
end

# Call module method
puts Utilities.say_hello  # Hello from module method
puts Utilities.increment(5)  # 6

class Calculator
  include Utilities
end

calc = Calculator.new
# Instance methods are available on the instance
puts calc.say_goodbye  # Goodbye from included method
puts calc.double(5)    # 10

# This would fail - module methods aren't included
# puts calc.say_hello     # NoMethodError
# puts calc.increment(5)  # NoMethodError

########################################################################
# Extend vs Include
########################################################################

module Formattable
  def format_currency(amount)
    "$#{amount.round(2)}"
  end

  def format_percentage(decimal)
    "#{(decimal * 100).round}%"
  end
end

class Report
  # Include adds methods as instance methods
  include Formattable

  def instance_format_price(price)
    format_currency(price)
  end
end

class PricingCalculator
  # Extend adds methods as class methods
  extend Formattable

  def self.class_format_discount(discount)
    format_percentage(discount)
  end
end

# Methods added by include are available on instances
report = Report.new
puts report.format_currency(29.95)  # $29.95
puts report.instance_format_price(29.95)  # $29.95

# Methods added by extend are available on the class
puts PricingCalculator.format_percentage(0.25)  # 25%
puts PricingCalculator.class_format_discount(0.25)  # 25%

# This would fail:
# puts Report.format_currency(29.95)  # NoMethodError
# puts PricingCalculator.new.format_percentage(0.25)  # NoMethodError

########################################################################
# Using Both Include and Extend
########################################################################

module Multipurpose
  # Methods for the module itself
  module ClassMethods
    def class_helper
      "I'm a class method"
    end
  end

  # Methods for the instances
  def instance_helper
    "I'm an instance method"
  end

  # When this module is included, also extend with ClassMethods
  def self.included(base)
    base.extend(ClassMethods)
  end
end

class MultipurposeUser
  include Multipurpose
end

# Now we have both types of methods
puts MultipurposeUser.class_helper  # I'm a class method
puts MultipurposeUser.new.instance_helper  # I'm an instance method

########################################################################
# Module Callbacks
########################################################################

module CallbackDemo
  def self.included(base)
    puts "#{self} was included in #{base}"
  end

  def self.extended(base)
    puts "#{self} was extended by #{base}"
  end

  def self.prepended(base)
    puts "#{self} was prepended to #{base}"
  end
end

class MyClass
  include CallbackDemo  # CallbackDemo was included in MyClass
end

class AnotherClass
  extend CallbackDemo   # CallbackDemo was extended by AnotherClass
end

########################################################################
# Load Path and Require
########################################################################

# In real applications, modules are often in separate files
# and loaded with require:

# require 'my_module'  # Loads my_module.rb
# require_relative 'my_module'  # Loads from current directory

# Example of how you'd use them:
# module MyModule
#   def self.helper
#     "I'm a helper method"
#   end
# end

# You'd access it with:
# MyModule.helper
