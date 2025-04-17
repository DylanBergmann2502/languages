# 1. Basic constant declaration and naming
# Constants in Ruby start with an uppercase letter
# By convention, constants are written in ALL_CAPS with underscores
PI = 3.14159
MAX_LOGIN_ATTEMPTS = 3
AppName = "Ruby Learning"  # Valid but not conventional style

puts "Basic constants:"
puts "PI = #{PI}"                     # 3.14159
puts "MAX_LOGIN_ATTEMPTS = #{MAX_LOGIN_ATTEMPTS}"  # 3
puts "AppName = #{AppName}"           # Ruby Learning

# 2. Constants are globally accessible
puts "\nAccessing constants:"

def print_pi
  puts "PI inside method: #{PI}"
end

print_pi  # PI inside method: 3.14159

# 3. Constants can be redefined (with a warning)
puts "\nRedefining constants:"
MAX_LOGIN_ATTEMPTS = 5  # This will produce a warning
puts "New MAX_LOGIN_ATTEMPTS = #{MAX_LOGIN_ATTEMPTS}"  # 5

# 4. Constants within classes and modules
puts "\nConstants in classes and modules:"

module MathConstants
  PI = 3.14159265359
  E = 2.71828
end

class Circle
  PI = 3.14  # This is a different constant than the top-level PI

  def self.area(radius)
    PI * radius * radius
  end
end

puts "Top-level PI: #{PI}"                 # 3.14159
puts "MathConstants::PI: #{MathConstants::PI}"  # 3.14159265359
puts "Circle::PI: #{Circle::PI}"           # 3.14
puts "Circle.area(5): #{Circle.area(5)}"   # 78.5

# 5. Accessing constants from other scopes
puts "\nAccessing constants across scopes:"
puts "Access module constant: #{MathConstants::E}"  # 2.71828

# 6. Nesting and inheritance of constants
puts "\nConstant inheritance:"

class Shape
  SIDES = 0
end

class Triangle < Shape
  SIDES = 3
end

class Rectangle < Shape
  SIDES = 4
end

class Square < Rectangle
  # Inherits SIDES from Rectangle
end

puts "Shape::SIDES: #{Shape::SIDES}"         # 0
puts "Triangle::SIDES: #{Triangle::SIDES}"   # 3
puts "Rectangle::SIDES: #{Rectangle::SIDES}" # 4
puts "Square::SIDES: #{Square::SIDES}"       # 4

# 7. Constant lookup path
puts "\nConstant lookup path:"

module Geometry
  PI = 3.1416

  class Calculator
    def self.circle_area(radius)
      PI * radius * radius  # Finds PI in the Geometry module
    end

    def self.triangle_area(base, height)
      0.5 * base * height
    end
  end
end

puts "Geometry::Calculator.circle_area(5): #{Geometry::Calculator.circle_area(5)}"  # ~78.54

# 8. Constants as collections
puts "\nConstants as collections:"

ALLOWED_ROLES = ["admin", "user", "guest"].freeze
WEEK_DAYS = {
  monday: 1,
  tuesday: 2,
  wednesday: 3,
  thursday: 4,
  friday: 5,
  saturday: 6,
  sunday: 7,
}.freeze

puts "ALLOWED_ROLES: #{ALLOWED_ROLES.inspect}"  # ["admin", "user", "guest"]
puts "WEEK_DAYS[:wednesday]: #{WEEK_DAYS[:wednesday]}"  # 3

# 9. Freezing constants
puts "\nFreezing constants:"

IMMUTABLE_ARRAY = [1, 2, 3].freeze
puts "IMMUTABLE_ARRAY: #{IMMUTABLE_ARRAY}"  # [1, 2, 3]

begin
  IMMUTABLE_ARRAY << 4  # This will raise an error
rescue RuntimeError => e
  puts "Error: #{e.message}"  # can't modify frozen Array
end

# Elements inside can still be mutable
NESTED_ARRAY = [[1, 2], [3, 4]].freeze
begin
  NESTED_ARRAY[0] << 3  # This works!
  puts "Modified nested array: #{NESTED_ARRAY.inspect}"  # [[1, 2, 3], [3, 4]]
rescue RuntimeError => e
  puts "Error: #{e.message}"
end

# For deep freezing
require "ice_nine"
# DEEP_FROZEN = IceNine.deep_freeze([[1, 2], [3, 4]])  # Uncomment if you install the ice_nine gem

# 10. Checking if a constant is defined
puts "\nChecking if constants exist:"
puts "PI defined? #{defined?(PI) ? "Yes" : "No"}"  # Yes
puts "UNKNOWN_CONSTANT defined? #{defined?(UNKNOWN_CONSTANT) ? "Yes" : "No"}"  # No

# 11. Listing all constants
puts "\nListing constants:"
puts "Top-level constants: #{Module.constants.sort.take(10)}"  # [list of constants]

puts "Constants in Math module: #{Math.constants}"  # [E, PI, ...]

# 12. Removing constants (rarely needed)
puts "\nRemoving constants:"
TEMP_CONSTANT = "I'll be removed"
puts "TEMP_CONSTANT: #{TEMP_CONSTANT}"  # I'll be removed

Object.send(:remove_const, :TEMP_CONSTANT)
puts "TEMP_CONSTANT defined? #{defined?(TEMP_CONSTANT) ? "Yes" : "No"}"  # No

# 13. Constants performance
puts "\nConstants vs variables performance:"
# Constants are slightly faster to access than local variables
require "benchmark"

CONST_VALUE = 42
var_value = 42

n = 10_000_000
Benchmark.bm(15) do |x|
  x.report("Constant:") { n.times { CONST_VALUE } }
  x.report("Local variable:") { n.times { var_value } }
end

# 14. Best practices
puts "\nConstants best practices:"
puts "- Use ALL_CAPS for constants"
puts "- Freeze mutable objects assigned to constants"
puts "- Use constants for values that should not change or rarely change"
puts "- Group related constants in modules"
puts "- Be aware that constants are actually mutable in Ruby"
