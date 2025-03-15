# Ruby's if statement allows you to execute code conditionally

########################################################################
# Basic if statement
if true
  puts "This code will always run"
end

# if with else
if false
  puts "This won't run"
else
  puts "This will run instead"
end

# if with elsif and else
x = 10
if x < 5
  puts "x is less than 5"
elsif x <= 10
  puts "x is between 5 and 10"
else
  puts "x is greater than 10"
end

########################################################################
# Inline if (postfix notation)
puts "x is 10" if x == 10

# unless is the opposite of if
unless x > 20
  puts "x is not greater than 20"
end

# Inline unless
puts "x is not 5" unless x == 5

########################################################################
# if as an expression (returns a value)
result = if x > 5
    "x is greater than 5"
  else
    "x is not greater than 5"
  end
puts result  # "x is greater than 5"

########################################################################
# In Ruby, only false and nil are considered falsy
# Everything else is truthy, including 0, empty strings, and empty arrays
puts "0 is truthy" if 0
puts "Empty string is truthy" if ""
puts "Empty array is truthy" if []

# Testing specific values
if nil
  puts "This won't run because nil is falsy"
end

if !nil
  puts "This will run because !nil is true"
end

########################################################################
# Ternary operator for compact conditionals
age = 18
status = age >= 18 ? "adult" : "minor"
puts status  # "adult"

########################################################################
# Combining conditions with AND (&&) and OR (||)
if x > 5 && x < 15
  puts "x is between 5 and 15"
end

if x < 5 || x > 15
  puts "x is either less than 5 or greater than 15"
else
  puts "x is between 5 and 15 (inclusive)"
end

# Short-circuit evaluation
# && will not evaluate the right side if the left side is false
# || will not evaluate the right side if the left side is true
nil_value = nil
result = nil_value && (puts "This won't be printed")
result = true || (puts "This won't be printed either")

# The 'and' and 'or' keywords work similarly but with lower precedence
# Usually, && and || are preferred
