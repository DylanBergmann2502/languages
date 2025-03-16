print Array.new               #=> []
puts ""
print Array.new(3)            #=> [nil, nil, nil]
puts ""
print Array.new(3, 7)         #=> [7, 7, 7]
puts ""
print Array.new(3, true)      #=> [true, true, true]
puts ""

################################################################
str_array = ["This", "is", "a", "small", "array"]

str_array[0]            #=> "This"
str_array[1]            #=> "is"
str_array[4]            #=> "array"
str_array[-1]           #=> "array"
str_array[-2]           #=> "small"

puts str_array.first          #=> "This"
print str_array.first(2)      #=> ["This", "is"]
puts ""
print str_array.last(2)       #=> ["small", "array"]
puts ""

#################################################################
num_array = [1, 2]

num_array.push(3, 4)      #=> [1, 2, 3, 4]
num_array << 5            #=> [1, 2, 3, 4, 5]
num_array.pop             #=> 5
print num_array           #=> [1, 2, 3, 4]


num_array = [2, 3, 4]

num_array.unshift(1)      #=> [1, 2, 3, 4]
num_array.shift           #=> 1
print num_array           #=> [2, 3, 4]


num_array = [1, 2, 3, 4, 5, 6]

num_array.pop(3)          #=> [4, 5, 6]
num_array.shift(2)        #=> [1, 2]
print num_array           #=> [3]
puts ""

################################################################
a = [1, 2, 3]
b = [3, 4, 5]

print a + b         #=> [1, 2, 3, 3, 4, 5]
print a.concat(b)   #=> [1, 2, 3, 3, 4, 5]
print [1, 1, 1, 2, 2, 3, 4] - [1, 4]  #=> [2, 2, 3]
