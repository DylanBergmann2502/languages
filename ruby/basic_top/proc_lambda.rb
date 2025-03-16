my_name = ->(name) { puts "hello #{name}" }

my_age = lambda { |age| puts "I am #{age} years old" }


my_name.call("tim") #=> hello tim
my_age.call(78)     #=> I am 78 years old

# There are many ways to call lambdas, but best to use call
my_name.call("tim")
my_name.("tim")
my_name["tim"]
my_name.=== "tim"

################################################################
a_proc = Proc.new { |name, age| puts "name: #{name} --- age: #{age}" }
a_proc.call("tim", 80)

a_proc = proc { puts "this is a proc" }
a_proc.call

################################################################
################################################################
# Proc vs lambda
################################################################
# Argument
# Proc doesn’t care if you pass in fewer or more arguments than you specify, or even none at all
b_proc = Proc.new { |a, b| puts "a: #{a} --- b: #{b}" }
b_proc.call("apple") # => a: apple --- b:


# A lambda DOES care and will raise an error if you don’t honor the number of parameters expected
a_lambda = lambda { |a, b| puts "a: #{a} --- b: #{b}" }

# a_lambda.call("apple")
# => wrong number of Arguments (given 1, expected 2) (ArgumentError)

# a_lambda.call("apple", "banana", "cake")
# => wrong number of Arguments (given 3, expected 2) (ArgumentError)

########################################################################
# Return
# write an explicit return inside a lambda, it returns from the lambda block back to the caller
a_lambda = -> { return 1 }

puts a_lambda.call # => 1

# A proc object, however, returns from the context in which it is called
a_proc = Proc.new { return }

# a_proc.call # => localJumpError (unexpected return)

def my_method
  a_proc = Proc.new { return }
  puts "this line will be printed"
  a_proc.call
  puts "this line is never reached"
end

my_method #=> this line will be printed

################################################################
# Default Arguments
my_proc = Proc.new { |name="bob"| puts name }

my_proc.call # => bob

my_lambda = ->(name="r2d2") { puts name }

my_lambda.call # => r2d2

################################################################
# Method parameters
# Both procs and lambdas can be used as arguments to a method.
def my_method(useful_arg)
  useful_arg.call
end

my_lambda = -> { puts "lambda" }
my_proc = Proc.new { puts "proc" }

my_method(my_lambda) # => lambda

my_method(my_proc)   # => proc
