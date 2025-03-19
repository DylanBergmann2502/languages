# Variables in Ruby
# Variables are used to store data for later use

########################################################################
# Creating variables (no declaration keyword needed)
name = "Alice"
age = 30
height = 5.8
is_student = true

puts name      # Alice
puts age       # 30
puts height    # 5.8
puts is_student # true

########################################################################
# Variable naming conventions
# Variables in Ruby use snake_case by convention
first_name = "Bob"
last_name = "Smith"
full_name = first_name + " " + last_name

puts full_name # Bob Smith

# Variable names can contain letters, numbers, and underscores
# But must start with a lowercase letter or underscore
user1 = "User One"
_hidden_variable = "I start with an underscore"

########################################################################
# Variable reassignment
# Variables can be reassigned to different values or even different types
x = 10
puts x  # 10

x = "now I'm a string"
puts x  # now I'm a string

########################################################################
# Parallel assignment
# You can assign multiple variables at once
a, b, c = 1, 2, 3
puts a  # 1
puts b  # 2
puts c  # 3

# Swapping values is easy with parallel assignment
a, b = b, a
puts a  # 2
puts b  # 1

########################################################################
# Constants
# Constants start with an uppercase letter
# By convention, constants are ALL_CAPS
PI = 3.14159
GRAVITY = 9.8

puts PI       # 3.14159
puts GRAVITY  # 9.8

# Ruby will warn if you try to change a constant, but will allow it
PI = 3.14
puts PI  # 3.14 (with a warning message)

########################################################################
# Variable scope indicators
# Local variables - start with lowercase or underscore
local_var = "I'm local"

# Global variables - start with $
$global_var = "I'm global"

# Instance variables and class variables need to be within a class
# Here's an example using a class:
class Person
  @instance_var = "I'm an instance variable"  # Instance variable
  @@class_var = "I'm a class variable"        # Class variable

  def self.print_class_var
    puts @@class_var
  end

  def print_instance_var
    puts @instance_var || "Instance variable not set for this instance"
  end
end

# Using the variables from the class
puts local_var    # I'm local
puts $global_var  # I'm global
Person.print_class_var  # I'm a class variable
person = Person.new
person.print_instance_var  # Instance variable not set for this instance

########################################################################
# Special variables
# Ruby has some built-in special variables
puts __FILE__  # Prints the name of the current file
puts __LINE__  # Prints the current line number

# nil is Ruby's "nothing" value (similar to null in other languages)
empty = nil
puts empty       # nil
puts empty.nil?  # true
