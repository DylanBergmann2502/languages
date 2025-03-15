############################################################
# Basic Method Definition
# Methods in Ruby are defined with the 'def' keyword
def greet
  puts "Hello, world!"
end

# Call the method
greet  # Output: Hello, world!

############################################################
# Methods with Parameters
def greet_person(name)
  puts "Hello, #{name}!"
end

greet_person("Ruby")  # Output: Hello, Ruby!

# Multiple parameters
def greet_with_time(name, time_of_day)
  puts "Good #{time_of_day}, #{name}!"
end

greet_with_time("Dev", "morning")  # Output: Good morning, Dev!

############################################################
# Return Values
# Methods implicitly return the value of the last expression
def add(a, b)
  a + b  # No explicit return statement needed
end

sum = add(5, 3)
puts "Sum: #{sum}"  # Output: Sum: 8

# Explicit return statement
def check_age(age)
  return "Too young" if age < 18
  return "Just right" if age >= 18 && age < 65
  "Senior citizen"
end

puts check_age(15)  # Output: Too young
puts check_age(25)  # Output: Just right
puts check_age(70)  # Output: Senior citizen

############################################################
# Method Naming Conventions
# Ruby methods can end with ?, !, or =

# Methods ending with ? typically return boolean values
def adult?(age)
  age >= 18
end

puts "Is 20 an adult age? #{adult?(20)}"  # Output: Is 20 an adult age? true

# Methods ending with ! typically modify the object they're called on
def upcase_name!(name)
  name.upcase!  # The ! on upcase! modifies the string in place
end

my_name = "ruby"
upcase_name!(my_name)
puts "Modified name: #{my_name}"  # Output: Modified name: RUBY

# Method with = at the end (setter method)
class Person
  def name=(new_name)
    @name = new_name
  end

  def name
    @name
  end
end

person = Person.new
person.name = "Alice"  # This calls the name= method
puts "Person's name: #{person.name}"  # Output: Person's name: Alice

############################################################
# Method Chaining
# Method calls can be chained when each method returns an object
sentence = "hello ruby world"
puts sentence.split.map(&:capitalize).join(" ")  # Output: Hello Ruby World

############################################################
# Method Visibility
# Ruby has three visibility levels: public, private, and protected
class Example
  def public_method
    puts "This is a public method"
    private_method  # Private methods can be called within the class
  end

  private

  def private_method
    puts "This is a private method"
  end

  protected

  def protected_method
    puts "This is a protected method"
  end
end

example = Example.new
example.public_method
# example.private_method  # This would raise an error
# example.protected_method  # This would also raise an error

############################################################
# Method Aliasing
# You can create an alias for an existing method
class String
  alias_method :original_upcase, :upcase

  def upcase
    "#{original_upcase} (upcased)"
  end
end

puts "hello".upcase  # Output: HELLO (upcased)

############################################################
# Method Missing
# Ruby allows you to catch calls to undefined methods
class DynamicMethods
  def method_missing(method_name, *args)
    puts "You called '#{method_name}' with arguments: #{args.join(", ")}"
  end
end

dynamic = DynamicMethods.new
dynamic.any_method(1, 2, 3)  # Output: You called 'any_method' with arguments: 1, 2, 3
