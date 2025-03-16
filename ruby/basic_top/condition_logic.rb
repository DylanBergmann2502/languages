# eql? : checks both the value type and the actual value it holds.
puts 5.eql?(5.0) #=> false; although they are the same value, one is an integer and the other is a float
puts 5.eql?(5)   #=> true

# equal?: checks whether both values are the exact same object in memory.
# Two variables pointing to the same number will usually return true.
a = 5
b = 5
puts a.equal?(b) #=> true

a = "hello"
b = "hello"
puts a.equal?(b) #=> false

########################################################################
puts 5 <=> 10    #=> -1
puts 10 <=> 10   #=> 0
puts 10 <=> 5    #=> 1

########################################################################
# and/or
if 1 < 2 && 5 < 6
  puts "Party at Kevin's!"
end
# This can also be written as
if 1 < 2 and 5 < 6
  puts "Party at Kevin's!"
end


if 10 < 2 || 5 < 6
  puts "Party at Kevin's!"
end
# This can also be written as
if 10 < 2 or 5 < 6
  puts "Party at Kevin's!"
end

################################################################
age = 19
puts "Welcome to a life of debt." unless age < 18

unless age < 18
  puts "Down with that sort of thing."
else
  puts "Careful now!"
end

response = age < 18 ? "You still have your entire life ahead of you." : "You're all grown up."
puts response #=> "You're all grown up."
