# Advanced techniques with Ruby's Enumerable module

# The Enumerable module is one of Ruby's most powerful features
# It provides collection classes with several traversal and searching methods
# and with the ability to sort

# To demonstrate these methods, let's create a sample collection
people = [
  { name: "Alice", age: 28, city: "New York" },
  { name: "Bob", age: 23, city: "Boston" },
  { name: "Charlie", age: 31, city: "Chicago" },
  { name: "Diana", age: 24, city: "Denver" },
  { name: "Eliza", age: 35, city: "New York" },
]

puts "Original collection:"
puts people.map { |person| "#{person[:name]}, #{person[:age]}, #{person[:city]}" }
# [
#   "Alice, 28, New York",
#   "Bob, 23, Boston",
#   "Charlie, 31, Chicago",
#   "Diana, 24, Denver",
#   "Eliza, 35, New York"
# ]
puts "-" * 40

#################################################################
# Advanced Filtering with #select, #reject, and #grep

puts "\n--- ADVANCED FILTERING ---"

# #select returns elements for which the block returns true
puts "\nPeople from New York:"
new_yorkers = people.select { |person| person[:city] == "New York" }
puts new_yorkers.map { |person| person[:name] }
# ["Alice", "Eliza"]

# #reject returns elements for which the block returns false (opposite of select)
puts "\nPeople not in their 20s:"
not_twenties = people.reject { |person| person[:age] >= 20 && person[:age] < 30 }
puts not_twenties.map { |person| "#{person[:name]}, #{person[:age]}" }
# ["Charlie, 31", "Eliza, 35"]

# #grep selects elements that match a pattern
puts "\nPeople whose names start with 'A' to 'C':"
a_to_c_names = people.grep_v(nil).select { |person| person[:name].match?(/^[A-C]/) }
puts a_to_c_names.map { |person| person[:name] }
# ["Alice", "Bob", "Charlie"]

#################################################################
# Transformation with #map, #flat_map, and #each_with_object

puts "\n--- ADVANCED TRANSFORMATION ---"

# #map transforms each element according to the block
puts "\nFormatted names and ages:"
formatted = people.map { |person| "#{person[:name]} (#{person[:age]})" }
puts formatted
# [
#   "Alice (28)",
#   "Bob (23)",
#   "Charlie (31)",
#   "Diana (24)",
#   "Eliza (35)"
# ]

# #flat_map is like map followed by flatten(1)
puts "\nCities with resident count (using flat_map):"
cities_with_people = people
  .group_by { |person| person[:city] }
  .flat_map { |city, residents| ["#{city}: #{residents.size} resident(s)", residents.map { |r| "- #{r[:name]}" }] }
  .flatten
puts cities_with_people
# [
#   "New York: 2 resident(s)",
#   "- Alice",
#   "- Eliza",
#   "Boston: 1 resident(s)",
#   "- Bob",
#   "Chicago: 1 resident(s)",
#   "- Charlie",
#   "Denver: 1 resident(s)",
#   "- Diana"
# ]

# #each_with_object maintains an object during iteration
puts "\nPeople grouped by age range:"
age_groups = people.each_with_object({}) do |person, groups|
  decade = (person[:age] / 10) * 10
  groups[decade] ||= []
  groups[decade] << person[:name]
end
# {
#   20 => ["Alice", "Bob", "Diana"],
#   30 => ["Charlie", "Eliza"]
# }

age_groups.each do |decade, names|
  puts "#{decade}s: #{names.join(", ")}"
end

#################################################################
# Finding Elements with #find, #find_all, and #detect

puts "\n--- FINDING ELEMENTS ---"

# #find/#detect returns the first element for which the block returns true
puts "\nFirst person in their 30s:"
thirty_something = people.find { |person| person[:age] >= 30 }
puts "#{thirty_something[:name]}, #{thirty_something[:age]}"
# "Charlie, 31"

# #find_all is an alias for #select
puts "\nAll people older than 25:"
older_than_25 = people.find_all { |person| person[:age] > 25 }
puts older_than_25.map { |person| "#{person[:name]}, #{person[:age]}" }
# [
#   "Alice, 28",
#   "Charlie, 31",
#   "Eliza, 35"
# ]

#################################################################
# Checking Conditions with #any?, #all?, #none?, and #one?

puts "\n--- CHECKING CONDITIONS ---"

# #any? returns true if at least one element meets the condition
puts "\nAny person older than 30? #{people.any? { |person| person[:age] > 30 }}"
# true

# #all? returns true if all elements meet the condition
puts "All people younger than 40? #{people.all? { |person| person[:age] < 40 }}"
# true

# #none? returns true if no elements meet the condition
puts "No one from Los Angeles? #{people.none? { |person| person[:city] == "Los Angeles" }}"
# true

# #one? returns true if exactly one element meets the condition
puts "Exactly one person from Chicago? #{people.one? { |person| person[:city] == "Chicago" }}"
# true

#################################################################
# Aggregation with #reduce/#inject

puts "\n--- AGGREGATION ---"

# #reduce/#inject accumulates a value across iterations
puts "\nTotal age of all people:"
total_age = people.reduce(0) { |sum, person| sum + person[:age] }
puts total_age
# 141

# More complex reduce example - building a hash of cities and their residents
puts "\nCities with lists of residents:"
cities = people.reduce({}) do |result, person|
  city = person[:city]
  result[city] ||= []
  result[city] << person[:name]
  result
end
# {
#   "New York" => ["Alice", "Eliza"],
#   "Boston" => ["Bob"],
#   "Chicago" => ["Charlie"],
#   "Denver" => ["Diana"]
# }

cities.each do |city, residents|
  puts "#{city}: #{residents.join(", ")}"
end

#################################################################
# Sorting and Comparing with #sort_by and #min_max

puts "\n--- SORTING AND COMPARING ---"

# #sort_by sorts based on the block's return value
puts "\nPeople sorted by age (youngest to oldest):"
by_age = people.sort_by { |person| person[:age] }
puts by_age.map { |person| "#{person[:name]}, #{person[:age]}" }
# [
#   "Bob, 23",
#   "Diana, 24",
#   "Alice, 28",
#   "Charlie, 31",
#   "Eliza, 35"
# ]

# #min and #max find extreme values
puts "\nYoungest person:"
youngest = people.min_by { |person| person[:age] }
puts "#{youngest[:name]}, #{youngest[:age]}"
# "Bob, 23"

# #min_by and #max_by with multiple criteria
puts "\nOldest person from each city:"
oldest_by_city = people
  .group_by { |person| person[:city] }
  .map { |city, residents| residents.max_by { |person| person[:age] } }
  .sort_by { |person| person[:city] }
# [
#   {:name=>"Bob", :age=>23, :city=>"Boston"},
#   {:name=>"Charlie", :age=>31, :city=>"Chicago"},
#   {:name=>"Diana", :age=>24, :city=>"Denver"},
#   {:name=>"Eliza", :age=>35, :city=>"New York"}
# ]

puts oldest_by_city.map { |person| "#{person[:city]}: #{person[:name]}, #{person[:age]}" }

# #minmax returns both min and max in one call
puts "\nAge range (youngest and oldest):"
youngest, oldest = people.minmax_by { |person| person[:age] }
puts "Youngest: #{youngest[:name]}, #{youngest[:age]}"
# "Youngest: Bob, 23"
puts "Oldest: #{oldest[:name]}, #{oldest[:age]}"
# "Oldest: Eliza, 35"

#################################################################
# Partitioning and Grouping with #partition and #group_by

puts "\n--- PARTITIONING AND GROUPING ---"

# #partition splits a collection into two arrays
puts "\nPeople partitioned by age > 25:"
young, older = people.partition { |person| person[:age] <= 25 }
# young = [
#   {:name=>"Bob", :age=>23, :city=>"Boston"},
#   {:name=>"Diana", :age=>24, :city=>"Denver"}
# ]
# older = [
#   {:name=>"Alice", :age=>28, :city=>"New York"},
#   {:name=>"Charlie", :age=>31, :city=>"Chicago"},
#   {:name=>"Eliza", :age=>35, :city=>"New York"}
# ]
puts "25 or younger: #{young.map { |p| p[:name] }.join(", ")}"
puts "Older than 25: #{older.map { |p| p[:name] }.join(", ")}"

# #group_by creates a hash of arrays grouped by the block's return value
puts "\nPeople grouped by city:"
by_city = people.group_by { |person| person[:city] }
# {
#   "New York" => [
#     {:name=>"Alice", :age=>28, :city=>"New York"},
#     {:name=>"Eliza", :age=>35, :city=>"New York"}
#   ],
#   "Boston" => [
#     {:name=>"Bob", :age=>23, :city=>"Boston"}
#   ],
#   "Chicago" => [
#     {:name=>"Charlie", :age=>31, :city=>"Chicago"}
#   ],
#   "Denver" => [
#     {:name=>"Diana", :age=>24, :city=>"Denver"}
#   ]
# }
by_city.each do |city, residents|
  puts "#{city}: #{residents.map { |p| p[:name] }.join(", ")}"
end

#################################################################
# Chain methods for complex operations

puts "\n--- CHAINING METHODS ---"

puts "\nNames of people in their 20s, sorted alphabetically:"
twenties = people
  .select { |person| person[:age] >= 20 && person[:age] < 30 }
  .sort_by { |person| person[:name] }
  .map { |person| person[:name] }
# ["Alice", "Bob", "Diana"]
puts twenties

# Calculate average age per city
puts "\nAverage age by city:"
avg_age_by_city = people
  .group_by { |person| person[:city] }
  .map do |city, residents|
  avg = residents.sum { |person| person[:age] }.to_f / residents.size
  [city, avg.round(1)]
end
  .to_h
# {
#   "New York" => 31.5,
#   "Boston" => 23.0,
#   "Chicago" => 31.0,
#   "Denver" => 24.0
# }

avg_age_by_city.each do |city, avg|
  puts "#{city}: #{avg}"
end
