# exceptions.rb

#############################################################
# Ruby Error Handling - Exceptions
#############################################################

# Basic exception handling with begin/rescue
begin
  # Code that might raise an exception
  puts "Attempting division by zero..."
  result = 10 / 0
  puts "This line will never be executed"
rescue
  puts "An error occurred!"
end

# Output when running the above code:
# Attempting division by zero...
# An error occurred!

#############################################################
# Catching specific exception types
begin
  # ZeroDivisionError
  result = 10 / 0
rescue ZeroDivisionError
  puts "You can't divide by zero!"
rescue TypeError
  puts "Type error occurred"
end

# You can also catch multiple exception types in one rescue clause
begin
  # Choose which error to raise for testing
  error_type = :zero_division  # Change to :type or :name to test other errors

  case error_type
  when :zero_division
    10 / 0
  when :type
    "5" + 5
  when :name
    undefined_variable
  end
rescue ZeroDivisionError, TypeError
  puts "Either division by zero or type error occurred"
rescue NameError
  puts "You referenced an undefined variable or method"
end

#############################################################
# Accessing the exception object
begin
  puts "Attempting to convert 'hello' to integer..."
  "hello".to_i!  # This method doesn't exist
rescue NoMethodError => e
  puts "Error message: #{e.message}"
  puts "Error class: #{e.class}"
  puts "Backtrace: "
  puts e.backtrace[0..2]  # Show just the first 3 lines
end

#############################################################
# The else clause - executed when no exception occurs
begin
  puts "Performing safe calculation..."
  result = 10 / 5
  puts "Result: #{result}"
rescue ZeroDivisionError
  puts "Division by zero!"
else
  puts "Calculation completed successfully with no errors"
end

# Output:
# Performing safe calculation...
# Result: 2
# Calculation completed successfully with no errors

#############################################################
# The ensure clause - always executed, regardless of exceptions
begin
  puts "Opening file (simulated)..."
  # Simulate file operation with possible failure
  random_failure = [true, false].sample
  raise "File not found" if random_failure
  puts "File operations completed successfully"
rescue => e
  puts "Error: #{e.message}"
ensure
  puts "Closing file (simulated)..."
  # This code always runs, with or without exception
end

#############################################################
# Retry - attempt the operation again
attempts = 0

begin
  attempts += 1
  puts "Attempt #{attempts}"

  # Simulate an operation that fails on first attempts but succeeds later
  if attempts < 3
    raise "Temporary failure"
  end

  puts "Operation successful on attempt #{attempts}"
rescue => e
  puts "Error: #{e.message}"
  retry if attempts < 3  # Try again for up to 3 attempts
end

#############################################################
# Using raise to generate exceptions
def validate_age(age)
  raise ArgumentError, "Age must be positive" if age < 0
  raise TypeError, "Age must be a number" unless age.is_a?(Numeric)
  puts "Age #{age} is valid"
end

# Test the validation
begin
  validate_age(-5)  # Will raise ArgumentError
rescue => e
  puts "Validation error: #{e.message}"
end

begin
  validate_age("twenty")  # Will raise TypeError
rescue => e
  puts "Validation error: #{e.message}"
end

begin
  validate_age(25)  # No exception
rescue => e
  puts "This shouldn't happen"
end

#############################################################
# Exception hierarchy
puts "Ruby Exception Hierarchy:"
puts "StandardError"
exceptions = [ArgumentError, TypeError, RuntimeError, NameError, NoMethodError]
exceptions.each do |exception|
  puts "  └── #{exception}"
end

# ArgumentError, TypeError, etc. are all subclasses of StandardError
puts "NoMethodError is a subclass of NameError: #{NoMethodError.superclass == NameError}"
puts "NameError is a subclass of StandardError: #{NameError.superclass == StandardError}"
puts "StandardError is a subclass of Exception: #{StandardError.superclass == Exception}"
