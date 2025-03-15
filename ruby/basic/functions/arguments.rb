############################################################
# Default Arguments
# Ruby allows you to specify default values for parameters
def greet(name = "Guest")
  puts "Hello, #{name}!"
end

greet          # Output: Hello, Guest!
greet("Ruby")  # Output: Hello, Ruby!

# Multiple default arguments
def connect_database(host = "localhost", port = 3306, user = "root")
  puts "Connecting to #{host}:#{port} as #{user}"
end

connect_database                           # Use all defaults
connect_database("db.example.com")         # Override just the host
connect_database("db.example.com", 5432)   # Override host and port

############################################################
# Keyword Arguments
# Ruby 2.0+ supports named parameters using keywords
def register_user(name:, email:, age: nil, admin: false)
  puts "Registering #{name} with email #{email}"
  puts "Age: #{age || "Not provided"}"
  puts "Admin access: #{admin}"
end

register_user(name: "Alice", email: "alice@example.com")
register_user(
  name: "Bob",
  email: "bob@example.com",
  age: 30,
  admin: true,
)

# Required keyword arguments (Ruby 2.1+)
# The parameters without defaults are required
def process_payment(amount:, currency:, method: "credit_card")
  puts "Processing #{currency} #{amount} via #{method}"
end

# process_payment(currency: "USD")  # This would raise an ArgumentError: missing keyword: amount
process_payment(amount: 99.99, currency: "USD")

############################################################
# Variable Length Argument Lists (Splat Operator)
# The * operator collects extra positional arguments into an array
def log(message, *tags)
  puts message
  puts "Tags: #{tags.join(", ")}" unless tags.empty?
end

log("Server started")                          # No tags
log("User logged in", "user", "authentication") # Two tags

# Using splat to explode an array into arguments
def sum(a, b, c)
  a + b + c
end

numbers = [1, 2, 3]
puts sum(*numbers)  # Same as sum(1, 2, 3)

############################################################
# Double Splat Operator (Ruby 2.0+)
# The ** operator collects extra keyword arguments into a hash
def configure(required_option:, **options)
  puts "Required: #{required_option}"
  options.each do |key, value|
    puts "  #{key}: #{value}"
  end
end

configure(
  required_option: "main",
  timeout: 30,
  retry: true,
  env: "production",
)

# Using double splat to explode a hash into keyword arguments
def create_user(name:, email:)
  puts "Created user #{name} with email #{email}"
end

user_data = { name: "Charlie", email: "charlie@example.com" }
create_user(**user_data)  # Same as create_user(name: "Charlie", email: "charlie@example.com")

############################################################
# Block Arguments
# Methods can accept blocks, which are chunks of code
def repeat(count)
  count.times { yield }
end

repeat(3) { puts "Echo!" }  # Output: Echo! (3 times)

# Explicit block parameter with &
def math_operation(a, b, &operation)
  puts "Result: #{operation.call(a, b)}"
end

math_operation(5, 3) { |x, y| x + y }  # Output: Result: 8
math_operation(5, 3) { |x, y| x * y }  # Output: Result: 15

############################################################
# Argument Order (Ruby 2.0+)
# The order of arguments matters:
# 1. Required positional arguments
# 2. Optional arguments (with default values)
# 3. Variable length arguments (*)
# 4. Required keyword arguments
# 5. Optional keyword arguments
# 6. Variable keyword arguments (**)
# 7. Block argument (&)
def complex_method(a, b = 1, *c, d:, e: 2, **f, &g)
  puts "a: #{a}"
  puts "b: #{b}"
  puts "c: #{c}"
  puts "d: #{d}"
  puts "e: #{e}"
  puts "f: #{f}"
  puts "Block given: #{block_given?}"
  g.call if block_given?
end

complex_method(
  10,           # a (required positional)
  20,           # b (optional positional, overriding default)
  30, 40, 50,   # c (variable positional)
  d: 60,        # d (required keyword)
  e: 70,        # e (optional keyword, overriding default)
  f: 80,        # f (variable keyword)
  g: 90, # f (variable keyword)
) { puts "Block executed!" }
