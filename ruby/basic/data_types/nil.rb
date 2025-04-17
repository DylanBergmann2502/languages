# nil is a special value representing the absence of a value or an undefined value
# It is the only instance of the NilClass

# Basic nil value
nil_value = nil
puts "nil value: #{nil_value.inspect}"               # nil
puts "nil class: #{nil_value.class}"                 # NilClass
puts "nil object_id: #{nil_value.object_id}"         # 8 (may vary by Ruby version)

# There's only one nil object in Ruby
puts "\nUniqueness of nil:"
nil_value_2 = nil
puts "Same object? #{nil_value.equal?(nil_value_2)}" # true
puts "nil == nil: #{nil == nil}"                     # true

# nil is falsey in boolean contexts
puts "\nnil in boolean contexts:"
puts "nil in if statement:"
if nil
  puts "  This won't be printed"
else
  puts "  nil is falsey"                             # nil is falsey
end

puts "!nil: #{!nil}"                                 # true
puts "!!nil: #{!!nil}"                               # false

# Only nil and false are falsey in Ruby
puts "\nTruthiness comparison:"
puts "nil is falsey: #{!nil}"                        # true
puts "false is falsey: #{!false}"                    # true
puts "0 is truthy: #{!!0}"                           # true
puts "empty string is truthy: #{!!""}"               # true
puts "empty array is truthy: #{!![]}"                # true

# nil vs. false
puts "\nnil vs. false:"
puts "nil == false: #{nil == false}"                 # false
puts "nil.nil?: #{nil.nil?}"                         # true
puts "false.nil?: #{false.nil?}"                     # false

# Common methods on nil
puts "\nMethods on nil:"
puts "nil.to_s: '#{nil.to_s}'"                       # "" (empty string)
puts "nil.to_i: #{nil.to_i}"                         # 0
puts "nil.to_f: #{nil.to_f}"                         # 0.0
puts "nil.to_a: #{nil.to_a}"                         # []
puts "nil.to_h: #{nil.to_h}"                         # {}
puts "nil.inspect: #{nil.inspect}"                   # "nil"
puts "nil.object_id: #{nil.object_id}"               # 8 (may vary)
puts "nil.hash: #{nil.hash}"                         # 0 or some number

# Common operations with nil
puts "\nCommon operations with nil:"
puts "nil || \"default\": #{nil || "default"}"                # "default"
puts "nil && \"something\": #{nil && "something"}"            # nil
puts "nil + 5 (will raise error)"
begin
  nil + 5
rescue => e
  puts "  Error: #{e.class}: #{e.message}"                   # NoMethodError
end

# nil? method on objects
puts "\nnil? method:"
puts "nil.nil?: #{nil.nil?}"                                  # true
puts "false.nil?: #{false.nil?}"                              # false
puts "0.nil?: #{0.nil?}"                                      # false
puts "\"\".nil?: #{"".nil?}"                                  # false

# nil as default return values
puts "\nnil as default return values:"

# Methods return nil by default
def empty_method
  # No explicit return
end

puts "empty_method returns: #{empty_method.inspect}"          # nil

# nil from array access outside bounds
array = [1, 2, 3]
puts "array[99]: #{array[99].inspect}"                        # nil

# nil from hash access with non-existent key
hash = { a: 1, b: 2 }
puts "hash[:z]: #{hash[:z].inspect}"                          # nil

# Regular expression match failure
puts "No match returns: #("hello" =~ /xyz/).inspect"          # nil

# Common patterns with nil

# 1. Nil checking
puts "\nNil checking patterns:"

value = nil
# Old way
if !value.nil?
  puts "  Value exists"
else
  puts "  Value is nil"                                       # Value is nil
end

# Shorter way
if value
  puts "  Value exists"
else
  puts "  Value is nil"                                       # Value is nil
end

# Using ternary operator
result = value ? "Value exists" : "Value is nil"
puts "  Ternary result: #{result}"                            # Value is nil

# 2. Nil coalescence (default values)
puts "\nNil coalescence (default values):"

# Using || for default values (nil or false trigger default)
username = nil
display_name = username || "Guest"
puts "  Display name: #{display_name}"                        # Guest

# Using conditional assignment
username ||= "Guest"
puts "  Username after ||=: #{username}"                      # Guest

# Safe navigation operator (&.) - Ruby 2.3+
puts "\nSafe navigation operator (&.):"

user = nil
# Traditional way (avoid NoMethodError)
name = user && user.name
puts "  Traditional way: #{name.inspect}"                     # nil

# Using safe navigation
name = user&.name
puts "  Safe navigation: #{name.inspect}"                     # nil

# Deeper chain
address = user&.address&.city
puts "  Deep safe navigation: #{address.inspect}"             # nil

# Dealing with nil in collections
puts "\nDealing with nil in collections:"

array_with_nil = [1, nil, 3, nil, 5]
puts "  Array with nil: #{array_with_nil}"                    # [1, nil, 3, nil, 5]

# Removing nil values
compact_array = array_with_nil.compact
puts "  After compact: #{compact_array}"                      # [1, 3, 5]

# Compact in place
array_with_nil.compact!
puts "  After compact!: #{array_with_nil}"                    # [1, 3, 5]

# nil and conditional flow
puts "\nnil in conditional flow:"

# Case statement with nil
value = nil
case value
when String
  puts "  It's a string"
when Integer
  puts "  It's an integer"
when nil
  puts "  It's nil"                                           # It's nil
else
  puts "  It's something else"
end

# Checking for nil in parameters
puts "\nnil in parameter checking:"

def greet(name = nil)
  if name.nil?
    "Hello, Guest!"
  else
    "Hello, #{name}!"
  end
end

puts "  #{greet()}"                                           # Hello, Guest!
puts "  #{greet("Ruby")}"                                     # Hello, Ruby!

# Type checking
puts "\nType checking:"
puts "nil.is_a?(NilClass): #{nil.is_a?(NilClass)}"            # true
puts "nil.is_a?(Object): #{nil.is_a?(Object)}"                # true
puts "nil.instance_of?(NilClass): #{nil.instance_of?(NilClass)}" # true
