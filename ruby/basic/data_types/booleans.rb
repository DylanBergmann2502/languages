# In Ruby, there are only two boolean values: true and false
# They are instances of TrueClass and FalseClass respectively

# Basic boolean values
true_value = true
false_value = false

puts "Basic boolean values:"
puts "true value: #{true_value}"                   # true
puts "false value: #{false_value}"                 # false
puts "true class: #{true_value.class}"             # TrueClass
puts "false class: #{false_value.class}"           # FalseClass
puts "Is true an object? #{true_value.is_a?(Object)}"  # true
puts "Is false an object? #{false_value.is_a?(Object)}"  # true

# Boolean operators
puts "\nBoolean operators:"
puts "AND: true && true = #{true && true}"         # true
puts "AND: true && false = #{true && false}"       # false
puts "AND: false && true = #{false && true}"       # false
puts "AND: false && false = #{false && false}"     # false

puts "OR: true || true = #{true || true}"          # true
puts "OR: true || false = #{true || false}"        # true
puts "OR: false || true = #{false || true}"        # true
puts "OR: false || false = #{false || false}"      # false

puts "NOT: !true = #{!true}"                       # false
puts "NOT: !false = #{!false}"                     # true

puts "XOR: true ^ true = #{true ^ true}"           # false
puts "XOR: true ^ false = #{true ^ false}"         # true
puts "XOR: false ^ true = #{false ^ true}"         # true
puts "XOR: false ^ false = #{false ^ false}"       # false

# Short-circuit evaluation
puts "\nShort-circuit evaluation:"

def side_effect
  puts "  Side effect executed!"
  return true
end

puts "true && side_effect():"
result = true && side_effect()     # Side effect executed!
puts "Result: #{result}"           # true

puts "false && side_effect():"
result = false && side_effect()    # Side effect NOT executed!
puts "Result: #{result}"           # false

puts "false || side_effect():"
result = false || side_effect()    # Side effect executed!
puts "Result: #{result}"           # true

puts "true || side_effect():"
result = true || side_effect()     # Side effect NOT executed!
puts "Result: #{result}"           # true

# Alternative operators: 'and', 'or', 'not'
# These have lower precedence than &&, ||, !
puts "\nAlternative operators (and, or, not):"
puts "true and true = #{true and true}"            # true
puts "true or false = #{true or false}"            # true
puts "not true = #{not true}"                      # false

# Precedence differences between && and 'and'
a = false && true
puts "a = false && true: #{a}"                     # false

# With 'and', assignment happens first, then boolean op
b = false and true
puts "b = false and true: #{b}"                    # false
# (This is equivalent to: (b = false) and true)

# Truthiness: In Ruby, only false and nil are falsey
# Everything else is truthy
puts "\nTruthiness in Ruby:"
puts "Is false truthy? #{!!false}"                 # false
puts "Is nil truthy? #{!!nil}"                     # false
puts "Is 0 truthy? #{!!0}"                         # true (unlike some languages)
puts "Is empty string truthy? #{!!""}"             # true (unlike some languages)
puts "Is empty array truthy? #{!![]}"              # true

# Comparison operators that return booleans
puts "\nComparison operators:"
puts "Equal: 5 == 5 is #{5 == 5}"                  # true
puts "Not equal: 5 != 6 is #{5 != 6}"              # true
puts "Greater than: 7 > 6 is #{7 > 6}"             # true
puts "Less than: 5 < 10 is #{5 < 10}"              # true
puts "Greater or equal: 7 >= 7 is #{7 >= 7}"       # true
puts "Less or equal: 5 <= 4 is #{5 <= 4}"          # false

# Object comparison
puts "\nObject comparison:"
puts "5.eql?(5) = #{5.eql?(5)}"                    # true (same type and value)
puts "5.eql?(5.0) = #{5.eql?(5.0)}"                # false (different types)
puts "5.equal?(5) = #{5.equal?(5)}"                # true (same object id)
puts "\"hello\".equal?(\"hello\") = #{"hello".equal?("hello")}"  # false (different object ids)

str1 = "hello"
str2 = str1
puts "str1.equal?(str2) = #{str1.equal?(str2)}"    # true (same object)

# Predicates (methods that return booleans)
puts "\nPredicate methods:"
puts "5.even? = #{5.even?}"                        # false
puts "6.even? = #{6.even?}"                        # true
puts "5.odd? = #{5.odd?}"                          # true
puts "[1, 2, 3].empty? = #{[1, 2, 3].empty?}"      # false
puts "[].empty? = #{[].empty?}"                    # true
puts "nil.nil? = #{nil.nil?}"                      # true
puts "\"hello\".nil? = #{"hello".nil?}"            # false
puts "'hello'.include?('e') = #{"hello".include?("e")}"  # true

# Conditional assignment with ||=
puts "\nConditional assignment:"
a = nil
a ||= "default value"
puts "a after ||= assignment: #{a}"                # "default value"

a ||= "new value"  # Won't change a since it's not nil or false
puts "a after second ||= assignment: #{a}"         # "default value"

# Common conditional patterns
puts "\nConditional patterns:"

# Using ternary operator
age = 20
status = age >= 18 ? "adult" : "minor"
puts "Status: #{status}"                           # "adult"

# Using inline if/unless
puts "Can vote" if age >= 18                       # "Can vote"
puts "Cannot vote" unless age >= 18                # (not printed)

# Using && for conditional execution
user = { name: "John", admin: true }
puts "Admin privileges granted" && true if user[:admin]  # "Admin privileges granted"

# Using || for default values
name = nil
display_name = name || "Guest"
puts "Welcome, #{display_name}"                    # "Welcome, Guest"

# Using !! to convert to boolean
puts "String to boolean: #{!!"hello"}"             # true
puts "nil to boolean: #{!!nil}"                    # false
puts "0 to boolean: #{!!0}"                        # true

# Type checking
puts "\nType checking:"
puts "true.is_a?(TrueClass): #{true.is_a?(TrueClass)}"    # true
puts "false.is_a?(FalseClass): #{false.is_a?(FalseClass)}"  # true
puts "true.class == TrueClass: #{true.class == TrueClass}"  # true

# Converting to boolean
puts "\nConverting to boolean:"
puts "1.to_s: #{1.to_s}"                           # "1"
puts "true.to_s: #{true.to_s}"                     # "true"
puts "false.to_s: #{false.to_s}"                   # "false"
puts "\"true\".to_sym == :true: #{"true".to_sym == :true}"  # true
