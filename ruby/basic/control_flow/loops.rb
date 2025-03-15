# Ruby offers several ways to implement loops and iteration

########################################################################
# while loop - executes as long as the condition is true
counter = 0
while counter < 5
  puts "while loop: #{counter}"
  counter += 1
end

# Inline while (modifier form)
counter = 0
puts "inline while: #{counter}" while (counter += 1) < 5

########################################################################
# until loop - executes as long as the condition is false
# (opposite of while)
counter = 0
until counter >= 5
  puts "until loop: #{counter}"
  counter += 1
end

# Inline until
counter = 0
puts "inline until: #{counter}" until (counter += 1) >= 5

########################################################################
# for loop - iterates over a collection
# Less commonly used in Ruby compared to other languages
numbers = [1, 2, 3, 4, 5]
for num in numbers
  puts "for loop: #{num}"
end

# Using Range objects with for
for i in 1..5
  puts "Range for loop: #{i}"
end

########################################################################
# loop method - creates an infinite loop that must be broken
# This is the simplest looping construct in Ruby
counter = 0
loop do
  puts "loop method: #{counter}"
  counter += 1
  break if counter >= 5  # Exit condition
end

########################################################################
# Control flow in loops: break, next, and redo

# break - exits the loop immediately
puts "\nBreak example:"
counter = 0
while counter < 10
  counter += 1
  break if counter == 6
  puts "With break: #{counter}"
end

# next - skips to the next iteration
puts "\nNext example:"
counter = 0
while counter < 5
  counter += 1
  next if counter == 3
  puts "With next: #{counter}"  # Will print 1, 2, 4, 5
end

# redo - restarts the current iteration
puts "\nRedo example:"
counter = 0
numbers = [1, 2, 3]
for num in numbers
  puts "Before redo: #{num}"
  if num == 2 && counter == 0
    counter = 1
    redo  # Will redo the iteration for num == 2
  end
  puts "After redo: #{num}"
end

########################################################################
# while and until with begin/end - do-while style loops
# These execute at least once

puts "\ndo-while style loop:"
counter = 10
begin
  puts "This runs at least once: #{counter}"
  counter += 1
end while counter < 5  # Condition is false, but the block executed once

########################################################################
# Infinite loops must be handled carefully
puts "\nInfinite loop example (controlled):"
counter = 0
# Uncomment to see an infinite loop in action (with a safety exit)
# loop do
#   puts "Infinite loop iteration: #{counter}"
#   counter += 1
#   break if counter >= 5  # Safety exit
# end
