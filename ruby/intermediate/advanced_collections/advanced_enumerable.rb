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
puts "-" * 40

#################################################################
# Advanced Filtering with #select, #reject, and #grep

puts "\n--- ADVANCED FILTERING ---"

# #select returns elements for which the block returns true
puts "\nPeople from New York:"
new_yorkers = people.select { |person| person[:city] == "New York" }
puts new_yorkers.map { |person| person[:name] }

# #reject returns elements for which the block returns false (opposite of select)
puts "\nPeople not in their 20s:"
not_twenties = people.reject { |person| person[:age] >= 20 && person[:age] < 30 }
puts not_twenties.map { |person| "#{person[:name]}, #{person[:age]}" }

# #grep selects elements that match a pattern
puts "\nPeople whose names start with 'A' to 'C':"
a_to_c_names = people.grep_v(nil).select { |person| person[:name].match?(/^[A-C]/) }
puts a_to_c_names.map { |person| person[:name] }

#################################################################
# Transformation with #map, #flat_map, and #each_with_object

puts "\n--- ADVANCED TRANSFORMATION ---"

# #map transforms each element according to the block
puts "\nFormatted names and ages:"
formatted = people.map { |person| "#{person[:name]} (#{person[:age]})" }
puts formatted

# #flat_map is like map followed by flatten(1)
puts "\nCities with resident count (using flat_map):"
cities_with_people = people
  .group_by { |person| person[:city] }
  .flat_map { |city, residents| ["#{city}: #{residents.size} resident(s)", residents.map { |r| "- #{r[:name]}" }] }
  .flatten
puts cities_with_people

# #each_with_object maintains an object during iteration
puts "\nPeople grouped by age range:"
age_groups = people.each_with_object({}) do |person, groups|
  decade = (person[:age] / 10) * 10
  groups[decade] ||= []
  groups[decade] << person[:name]
end

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

# #find_all is an alias for #select
puts "\nAll people older than 25:"
older_than_25 = people.find_all { |person| person[:age] > 25 }
puts older_than_25.map { |person| "#{person[:name]}, #{person[:age]}" }

#################################################################
# Checking Conditions with #any?, #all?, #none?, and #one?

puts "\n--- CHECKING CONDITIONS ---"

# #any? returns true if at least one element meets the condition
puts "\nAny person older than 30? #{people.any? { |person| person[:age] > 30 }}"

# #all? returns true if all elements meet the condition
puts "All people younger than 40? #{people.all? { |person| person[:age] < 40 }}"

# #none? returns true if no elements meet the condition
puts "No one from Los Angeles? #{people.none? { |person| person[:city] == "Los Angeles" }}"

# #one? returns true if exactly one element meets the condition
puts "Exactly one person from Chicago? #{people.one? { |person| person[:city] == "Chicago" }}"

#################################################################
# Aggregation with #reduce/#inject

puts "\n--- AGGREGATION ---"

# #reduce/#inject accumulates a value across iterations
puts "\nTotal age of all people:"
total_age = people.reduce(0) { |sum, person| sum + person[:age] }
puts total_age

# More complex reduce example - building a hash of cities and their residents
puts "\nCities with lists of residents:"
cities = people.reduce({}) do |result, person|
  city = person[:city]
  result[city] ||= []
  result[city] << person[:name]
  result
end

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

# #min and #max find extreme values
puts "\nYoungest person:"
youngest = people.min_by { |person| person[:age] }
puts "#{youngest[:name]}, #{youngest[:age]}"

# #min_by and #max_by with multiple criteria
puts "\nOldest person from each city:"
oldest_by_city = people
  .group_by { |person| person[:city] }
  .map { |city, residents| residents.max_by { |person| person[:age] } }
  .sort_by { |person| person[:city] }

puts oldest_by_city.map { |person| "#{person[:city]}: #{person[:name]}, #{person[:age]}" }

# #minmax returns both min and max in one call
puts "\nAge range (youngest and oldest):"
youngest, oldest = people.minmax_by { |person| person[:age] }
puts "Youngest: #{youngest[:name]}, #{youngest[:age]}"
puts "Oldest: #{oldest[:name]}, #{oldest[:age]}"

#################################################################
# Partitioning and Grouping with #partition and #group_by

puts "\n--- PARTITIONING AND GROUPING ---"

# #partition splits a collection into two arrays
puts "\nPeople partitioned by age > 25:"
young, older = people.partition { |person| person[:age] <= 25 }
puts "25 or younger: #{young.map { |p| p[:name] }.join(", ")}"
puts "Older than 25: #{older.map { |p| p[:name] }.join(", ")}"

# #group_by creates a hash of arrays grouped by the block's return value
puts "\nPeople grouped by city:"
by_city = people.group_by { |person| person[:city] }
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

avg_age_by_city.each do |city, avg|
  puts "#{city}: #{avg}"
end
