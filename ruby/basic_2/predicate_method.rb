numbers = [21, 42, 303, 499, 550, 811]

puts numbers.any? { |number| number > 500 }    #=> true

###########################################################
fruits = ["apple", "banana", "strawberry", "pineapple"]
empty = {}
null = [nil]

puts fruits.all? { |fruit| fruit.length > 3 }   #=> true
puts fruits.all? { |fruit| fruit.length > 6 }   #=> false
# empty arrays/hashes are true by default
puts empty.all?                                 #=> true
puts null.all?                                  #=> false

###########################################################
puts fruits.none? { |fruit| fruit.length > 10 } #=> true

puts fruits.none? { |fruit| fruit.length > 6 }  #=> false
