friends = ['Sharon', 'Leo', 'Leila', 'Brian', 'Arun']
invited_list = []

for friend in friends do
  if friend != 'Brian'
  invited_list.push(friend)
  end
end

print invited_list, "\n"
print friends.select { |friend| friend != 'Brian' }, "\n"
print friends.reject { |friend| friend == 'Brian' }, "\n"

########################################################################
# each is used to iterate through arrays/hashes
friends.each { |friend| puts "Hello, " + friend }

# For complex actions, use "do..end" instead of "{ }"
my_array = [1, 2]

my_array.each do |num|
  num *= 2
  puts "The new number is #{num}."
end

# each for hashes is a bit more complicated
my_hash = { "one" => 1, "two" => 2 }

my_hash.each { |key, value| puts "#{key} is #{value}" }
my_hash.each { |pair| puts "the pair is #{pair}" }

# each returns the original array or hash regardless of what happens inside the code block
print friends.each { |friend| friend.upcase }, "\n"

#=> ['Sharon', 'Leo', 'Leila', 'Brian', 'Arun']
#=> ['SHARON', 'LEO', 'LEILA', 'BRIAN', 'ARUN'] NOOOOOOOOOOOOOOOOOOOOOOOOOOOO

##################################################################
# each_with_index
fruits = ["apple", "banana", "strawberry", "pineapple"]

fruits.each_with_index { |fruit, index| puts fruit if index.even? }

#################################################################
shouting_at_friends = []

friends.each { |friend| shouting_at_friends.push(friend.upcase) }
print shouting_at_friends, "\n"

# map is used for transformed arrays
print friends.map { |friend| friend.upcase }, "\n"

my_order = ['medium Big Mac', 'medium fries', 'medium milkshake']

print my_order.map { |item| item.gsub('medium', 'extra large') }, "\n"

################################################################
# select (aka filter) is used for conditional filtering of arrays/hashes
responses = { 'Sharon' => 'yes', 'Leo' => 'no', 'Leila' => 'no', 'Arun' => 'yes' }

print responses.select { |person, response| response == 'yes'}, "\n"
print responses.filter { |person, response| response == 'yes'}, "\n"

################################################################
# reduce (aka inject) is used when you want to get an output of a single value
my_numbers = [5, 6, 7, 8]
sum = 0

my_numbers.each { |number| sum += number }
puts sum

# "sum" here is called the "accumulator"
print my_numbers.reduce { |sum, number| sum + number }, "\n"
# you can set an initial value for the accumulator
print my_numbers.reduce(1000) { |sum, number| sum + number }, "\n"

################################################################
votes = ["Bob's Dirty Burger Shack", "St. Mark's Bistro", "Bob's Dirty Burger Shack"]

result = votes.reduce(Hash.new(0)) do |result, vote|
  result[vote] += 1
  result
end

puts result

################################################################
# wrap enumerable in a local variable or a method
def invited_friends(friends)
  friends.select { |friend| friend != 'Brian' }
end

print invited_friends(friends), "\n"

################################################################
# Bang method: map!, select!
friends.map! { |friend| friend.upcase }

print friends, "\n"
