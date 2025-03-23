# Deep dive into specialized collection methods in Ruby

# Ruby provides many specialized methods to work with collections
# This file explores methods beyond the common ones, showing practical use cases

#################################################################
# Array Manipulation Beyond the Basics

puts "--- ADVANCED ARRAY METHODS ---"

# Let's start with a sample array
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
letters = ["a", "b", "c", "d", "e"]

# Combination generates all combinations of a specific size
puts "\nAll combinations of 3 numbers from #{numbers[0..4]}:"
combinations = numbers[0..4].combination(3).to_a
puts combinations.map { |combo| combo.inspect }
# [
#   [1, 2, 3],
#   [1, 2, 4],
#   [1, 2, 5],
#   [1, 3, 4],
#   [1, 3, 5],
#   [1, 4, 5],
#   [2, 3, 4],
#   [2, 3, 5],
#   [2, 4, 5],
#   [3, 4, 5]
# ]

# Permutation generates all permutations of a specific size
puts "\nAll permutations of 2 letters from #{letters[0..2]}:"
permutations = letters[0..2].permutation(2).to_a
puts permutations.map { |perm| perm.inspect }
# [
#   ["a", "b"],
#   ["a", "c"],
#   ["b", "a"],
#   ["b", "c"],
#   ["c", "a"],
#   ["c", "b"]
# ]

# Product creates a Cartesian product with another array
puts "\nCartesian product of #{[1, 2]} and #{["a", "b"]}:"
product = [1, 2].product(["a", "b"])
puts product.map { |pair| pair.inspect }
# [
#   [1, "a"],
#   [1, "b"],
#   [2, "a"],
#   [2, "b"]
# ]

# Multiple products can be calculated at once
puts "\nCartesian product of #{[1, 2]}, #{["a", "b"]}, and #{[:x, :y]}:"
multi_product = [1, 2].product(["a", "b"], [:x, :y])
puts multi_product.map { |triplet| triplet.inspect }
# [
#   [1, "a", :x],
#   [1, "a", :y],
#   [1, "b", :x],
#   [1, "b", :y],
#   [2, "a", :x],
#   [2, "a", :y],
#   [2, "b", :x],
#   [2, "b", :y]
# ]

# Repeated permutation and combination
puts "\nRepeated combinations of 2 items from [1, 2, 3]:"
repeated_combinations = [1, 2, 3].repeated_combination(2).to_a
puts repeated_combinations.map { |combo| combo.inspect }
# [
#   [1, 1],
#   [1, 2],
#   [1, 3],
#   [2, 2],
#   [2, 3],
#   [3, 3]
# ]

puts "\nRepeated permutations of 2 items from [1, 2, 3]:"
repeated_permutations = [1, 2, 3].repeated_permutation(2).to_a
puts repeated_permutations.map { |perm| perm.inspect }
# [
#   [1, 1],
#   [1, 2],
#   [1, 3],
#   [2, 1],
#   [2, 2],
#   [2, 3],
#   [3, 1],
#   [3, 2],
#   [3, 3]
# ]

# Slicing arrays with advanced techniques
array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

puts "\nDifferent ways to slice arrays:"
puts "Values at indexes 2, 4, and 7: #{array.values_at(2, 4, 7).inspect}"
# [3, 5, 8]
puts "Every second element: #{array.select.with_index { |_, i| i.even? }.inspect}"
# [1, 3, 5, 7, 9]
puts "Every third element: #{array.select.with_index { |_, i| i % 3 == 0 }.inspect}"
# [1, 4, 7, 10]

# Take and drop for working with portions of arrays
puts "\nTaking and dropping elements:"
puts "First 3 elements: #{array.take(3).inspect}"
# [1, 2, 3]
puts "Elements after dropping first 7: #{array.drop(7).inspect}"
# [8, 9, 10]
puts "Elements until a condition is met: #{array.take_while { |n| n < 5 }.inspect}"
# [1, 2, 3, 4]
puts "Elements after condition fails: #{array.drop_while { |n| n < 5 }.inspect}"
# [5, 6, 7, 8, 9, 10]

# The #bsearch method for efficient searching in sorted arrays
puts "\nBinary search in a sorted array:"
sorted = [2, 5, 8, 11, 14, 17, 20, 23, 26, 29]

# Find a specific value
result = sorted.bsearch { |x| x >= 14 }
puts "First element >= 14: #{result}"
# 14

# Find index of a value
index = sorted.bsearch_index { |x| x >= 17 }
puts "Index of first element >= 17: #{index}"
# 5

#################################################################
# Advanced Hash Techniques

puts "\n--- ADVANCED HASH METHODS ---"

# A sample hash to work with
person = {
  name: "Ruby Developer",
  skills: ["Ruby", "Rails", "Testing"],
  experience: 5,
  location: "Remote",
  contact: {
    email: "dev@example.com",
    phone: "555-1234",
  },
}

# Fetching with defaults
puts "\nFetching with defaults:"
puts "Skills: #{person.fetch(:skills).join(", ")}"
# "Ruby, Rails, Testing"
puts "Salary: #{person.fetch(:salary, "Not specified")}"
# "Not specified"

# Fetching with a block for complex defaults
puts "Age: #{person.fetch(:age) { |key| "#{key} not available" }}"
# "age not available"

# Transforming keys and values
puts "\nTransforming hashes:"
upcase_keys = person.transform_keys { |k| k.to_s.upcase.to_sym }
puts "Keys transformed to uppercase: #{upcase_keys.keys.inspect}"
# [:NAME, :SKILLS, :EXPERIENCE, :LOCATION, :CONTACT]

string_values = person.transform_values { |v| v.is_a?(Array) ? v.join(", ") : v.to_s }
puts "Values transformed to strings: #{string_values.inspect}"
# {
#   :name=>"Ruby Developer",
#   :skills=>"Ruby, Rails, Testing",
#   :experience=>"5",
#   :location=>"Remote",
#   :contact=>"{:email=>\"dev@example.com\", :phone=>\"555-1234\"}"
# }

# Merging hashes with different strategies
defaults = { experience: 0, skills: [], location: "Unknown" }

puts "\nMerging hash with defaults (original takes precedence):"
merged = defaults.merge(person)
puts merged.select { |k, _| [:experience, :skills, :location].include?(k) }.inspect
# {:experience=>5, :skills=>["Ruby", "Rails", "Testing"], :location=>"Remote"}

puts "Merging hash with defaults (defaults take precedence):"
merged_reverse = person.merge(defaults) { |key, old_val, new_val| old_val }
puts merged_reverse.select { |k, _| [:experience, :skills, :location].include?(k) }.inspect
# {:experience=>5, :skills=>["Ruby", "Rails", "Testing"], :location=>"Remote"}

# Working with nested hashes using dig
puts "\nAccessing nested values with dig:"
puts "Email: #{person.dig(:contact, :email)}"
# "dev@example.com"
puts "Safely accessing non-existent nested key: #{person.dig(:contact, :address, :city).inspect}"
# nil

# Slicing a hash to get only certain keys
puts "\nSlicing hash to get specific keys:"
puts person.slice(:name, :experience, :location).inspect
# {:name=>"Ruby Developer", :experience=>5, :location=>"Remote"}

# Except to get everything but certain keys
puts "\nExcluding specific keys with except:"
puts person.except(:contact, :skills).inspect if person.respond_to?(:except)
# {:name=>"Ruby Developer", :experience=>5, :location=>"Remote"}

# If except isn't available (it's in Rails), we can implement it
unless Hash.method_defined?(:except)
  class Hash
    def except(*keys)
      dup.tap { |hash| keys.each { |key| hash.delete(key) } }
    end
  end

  puts person.except(:contact, :skills).inspect
  # {:name=>"Ruby Developer", :experience=>5, :location=>"Remote"}
end

#################################################################
# Set Operations

puts "\n--- SET OPERATIONS ---"

require "set"

# Creating sets
set_a = Set.new([1, 2, 3, 4, 5])
set_b = Set.new([4, 5, 6, 7, 8])

puts "\nSet A: #{set_a.inspect}"
# #<Set: {1, 2, 3, 4, 5}>
puts "Set B: #{set_b.inspect}"
# #<Set: {4, 5, 6, 7, 8}>

# Basic set operations
puts "\nUnion (A | B): #{(set_a | set_b).inspect}"
# #<Set: {1, 2, 3, 4, 5, 6, 7, 8}>
puts "Intersection (A & B): #{(set_a & set_b).inspect}"
# #<Set: {4, 5}>
puts "Difference (A - B): #{(set_a - set_b).inspect}"
# #<Set: {1, 2, 3}>
puts "Symmetric Difference (A ^ B): #{(set_a ^ set_b).inspect}"
# #<Set: {1, 2, 3, 6, 7, 8}>

# Checking set relationships
puts "\nIs A a subset of B? #{set_a.subset?(set_b)}"
# false
puts "Is A a proper subset of B? #{set_a.proper_subset?(set_b)}"
# false
puts "Does A contain 3? #{set_a.include?(3)}"
# true

# Converting between Set and other collections
array = [1, 2, 2, 3, 3, 3, 4]
puts "\nConverting array with duplicates to Set:"
unique_set = Set.new(array)
puts "Original array: #{array.inspect}"
# [1, 2, 2, 3, 3, 3, 4]
puts "Set (no duplicates): #{unique_set.inspect}"
# #<Set: {1, 2, 3, 4}>
puts "Back to array: #{unique_set.to_a.inspect}"
# [1, 2, 3, 4]

# SortedSet keeps elements in sorted order
if defined?(SortedSet)
  sorted = SortedSet.new([3, 1, 4, 1, 5, 9, 2, 6])
  puts "\nSorted Set: #{sorted.inspect}"
  # #<SortedSet: {1, 2, 3, 4, 5, 6, 9}>
else
  puts "\nSortedSet not available in this Ruby version"
end

#################################################################
# Working with Nested Collections

puts "\n--- NESTED COLLECTIONS ---"

# A complex nested structure
organization = {
  name: "TechCorp",
  departments: [
    {
      name: "Engineering",
      teams: [
        { name: "Frontend", members: ["Alice", "Bob"] },
        { name: "Backend", members: ["Charlie", "Diana"] },
        { name: "DevOps", members: ["Eve"] },
      ],
    },
    {
      name: "Marketing",
      teams: [
        { name: "Digital", members: ["Frank", "Grace"] },
        { name: "Content", members: ["Heidi"] },
      ],
    },
  ],
}

# Navigating and transforming nested structures
puts "\nAll team names across departments:"
team_names = organization[:departments].flat_map do |dept|
  dept[:teams].map { |team| team[:name] }
end
puts team_names.inspect
# ["Frontend", "Backend", "DevOps", "Digital", "Content"]

puts "\nAll members across all teams:"
all_members = organization[:departments].flat_map do |dept|
  dept[:teams].flat_map { |team| team[:members] }
end
puts all_members.inspect
# ["Alice", "Bob", "Charlie", "Diana", "Eve", "Frank", "Grace", "Heidi"]

puts "\nTeams with exactly one member:"
solo_teams = organization[:departments].flat_map do |dept|
  dept[:teams].select { |team| team[:members].size == 1 }
    .map { |team| "#{team[:name]} (#{dept[:name]})" }
end
puts solo_teams.inspect
# ["DevOps (Engineering)", "Content (Marketing)"]

# Creating a mapping of department to member count
puts "\nMember count by department:"
dept_counts = organization[:departments].map do |dept|
  member_count = dept[:teams].sum { |team| team[:members].size }
  [dept[:name], member_count]
end.to_h
puts dept_counts.inspect
# {"Engineering"=>5, "Marketing"=>3}

# Finding the department with the most members
if dept_counts.any?
  max_dept = dept_counts.max_by { |_, count| count }
  puts "\nDepartment with most members: #{max_dept[0]} (#{max_dept[1]} members)"
  # "Department with most members: Engineering (5 members)"
end

# Build a mapping of member to their team and department
puts "\nMapping of members to their team and department:"
member_mapping = {}

organization[:departments].each do |dept|
  dept[:teams].each do |team|
    team[:members].each do |member|
      member_mapping[member] = { department: dept[:name], team: team[:name] }
    end
  end
end
# {
#   "Alice"=>{:department=>"Engineering", :team=>"Frontend"},
#   "Bob"=>{:department=>"Engineering", :team=>"Frontend"},
#   "Charlie"=>{:department=>"Engineering", :team=>"Backend"},
#   "Diana"=>{:department=>"Engineering", :team=>"Backend"},
#   "Eve"=>{:department=>"Engineering", :team=>"DevOps"},
#   "Frank"=>{:department=>"Marketing", :team=>"Digital"},
#   "Grace"=>{:department=>"Marketing", :team=>"Digital"},
#   "Heidi"=>{:department=>"Marketing", :team=>"Content"}
# }

member_mapping.each do |member, info|
  puts "#{member} works in the #{info[:team]} team of #{info[:department]}"
end

#################################################################
# Collection Pipeline Pattern

puts "\n--- COLLECTION PIPELINE PATTERN ---"

# The collection pipeline pattern chains operations on collections
# This is a functional programming approach that improves code readability

# A list of books with various attributes
books = [
  { title: "Practical Object-Oriented Design in Ruby", author: "Sandi Metz", pages: 272, genres: ["Programming", "Ruby"] },
  { title: "Eloquent Ruby", author: "Russ Olsen", pages: 448, genres: ["Programming", "Ruby"] },
  { title: "The Pragmatic Programmer", author: "Dave Thomas & Andy Hunt", pages: 352, genres: ["Programming", "Software Engineering"] },
  { title: "Clean Code", author: "Robert C. Martin", pages: 464, genres: ["Programming", "Software Engineering"] },
  { title: "Ruby Under a Microscope", author: "Pat Shaughnessy", pages: 360, genres: ["Programming", "Ruby", "Computer Science"] },
]

# Find average page count of Ruby books
puts "\nAverage page count of Ruby books:"
ruby_book_avg_pages = books
  .select { |book| book[:genres].include?("Ruby") }
  .map { |book| book[:pages] }
  .then { |pages| pages.sum.to_f / pages.size }
puts ruby_book_avg_pages.round(1)
# 360.0

# Group books by author and count
puts "\nBooks per author:"
author_counts = books
  .group_by { |book| book[:author] }
  .transform_values { |books| books.size }
  .sort_by { |_, count| -count }
  .to_h
# {
#   "Sandi Metz"=>1,
#   "Russ Olsen"=>1,
#   "Dave Thomas & Andy Hunt"=>1,
#   "Robert C. Martin"=>1,
#   "Pat Shaughnessy"=>1
# }
author_counts.each { |author, count| puts "#{author}: #{count}" }

# Find all unique genres across all books
puts "\nAll unique genres across books:"
all_genres = books
  .flat_map { |book| book[:genres] }
  .uniq
  .sort
puts all_genres.join(", ")
# "Computer Science, Programming, Ruby, Software Engineering"

# Find books with the most genres
puts "\nBooks with the most genres:"
max_genre_count = books.map { |book| book[:genres].size }.max
books_with_most_genres = books
  .select { |book| book[:genres].size == max_genre_count }
  .map { |book| "#{book[:title]} (#{book[:genres].join(", ")})" }
puts books_with_most_genres
# ["Ruby Under a Microscope (Programming, Ruby, Computer Science)"]

# Advanced: Partition books by page count and create summary
puts "\nBooks categorized by length:"
short, medium, long = books
  .group_by { |book|
  case book[:pages]
  when 0...300 then :short
  when 300...400 then :medium
  else :long
  end
}
  .values_at(:short, :medium, :long)
  .map { |category| category || [] }
# short = [
#   {:title=>"Practical Object-Oriented Design in Ruby", :author=>"Sandi Metz", :pages=>272, :genres=>["Programming", "Ruby"]}
# ]
# medium = [
#   {:title=>"The Pragmatic Programmer", :author=>"Dave Thomas & Andy Hunt", :pages=>352, :genres=>["Programming", "Software Engineering"]},
#   {:title=>"Ruby Under a Microscope", :author=>"Pat Shaughnessy", :pages=>360, :genres=>["Programming", "Ruby", "Computer Science"]}
# ]
# long = [
#   {:title=>"Eloquent Ruby", :author=>"Russ Olsen", :pages=>448, :genres=>["Programming", "Ruby"]},
#   {:title=>"Clean Code", :author=>"Robert C. Martin", :pages=>464, :genres=>["Programming", "Software Engineering"]}
# ]

puts "Short books (<300 pages): #{(short || []).map { |b| b[:title] }.join(", ")}"
puts "Medium books (300-399 pages): #{(medium || []).map { |b| b[:title] }.join(", ")}"
puts "Long books (400+ pages): #{(long || []).map { |b| b[:title] }.join(", ")}"
