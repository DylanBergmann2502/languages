# CSV (Comma-Separated Values) is a common format for data interchange
# Ruby's standard library includes a CSV module for parsing and generating CSV data
require "csv"

###########################################################################
# Writing CSV data
###########################################################################

# Simple CSV writing
puts "Writing simple CSV:"
CSV.open("sample.csv", "w") do |csv|
  csv << ["Name", "Age", "Language"]
  csv << ["Alice", 28, "Ruby"]
  csv << ["Bob", 34, "Python"]
  csv << ["Charlie", 42, "JavaScript"]
end
puts "File created: sample.csv"

# Writing an array of arrays to CSV
puts "\nWriting arrays to CSV:"
data = [
  ["ID", "Product", "Price"],
  [1, "Laptop", 899.99],
  [2, "Phone", 499.99],
  [3, "Tablet", 299.99],
]
CSV.open("products.csv", "w") do |csv|
  data.each do |row|
    csv << row
  end
end
puts "File created: products.csv"

# Writing an array of hashes to CSV
puts "\nWriting array of hashes to CSV:"
people = [
  { name: "David", age: 31, city: "New York" },
  { name: "Emma", age: 27, city: "London" },
  { name: "Frank", age: 39, city: "Tokyo" },
]

CSV.open("people.csv", "w", headers: people.first.keys, write_headers: true) do |csv|
  people.each do |person|
    csv << person.values
  end
end
puts "File created: people.csv"

###########################################################################
# Reading CSV data
###########################################################################

# Reading CSV as array of arrays
puts "\nReading CSV as arrays:"
CSV.foreach("sample.csv") do |row|
  p row
end
# ["Name", "Age", "Language"]
# ["Alice", "28", "Ruby"]
# ["Bob", "34", "Python"]
# ["Charlie", "42", "JavaScript"]

# Reading CSV with headers
puts "\nReading CSV with headers:"
CSV.foreach("people.csv", headers: true) do |row|
  puts "#{row["name"]} is #{row["age"]} years old and lives in #{row["city"]}"
end
# David is 31 years old and lives in New York
# Emma is 27 years old and lives in London
# Frank is 39 years old and lives in Tokyo

# Converting each row to a hash
puts "\nConverting rows to hashes:"
CSV.foreach("people.csv", headers: true) do |row|
  p row.to_h
end
# {"name"=>"David", "age"=>"31", "city"=>"New York"}
# {"name"=>"Emma", "age"=>"27", "city"=>"London"}
# {"name"=>"Frank", "age"=>"39", "city"=>"Tokyo"}

# Reading entire CSV file at once
puts "\nReading entire CSV file:"
content = CSV.read("sample.csv")
p content
# [["Name", "Age", "Language"], ["Alice", "28", "Ruby"], ["Bob", "34", "Python"], ["Charlie", "42", "JavaScript"]]

# Reading as array of hashes
puts "\nReading as array of hashes:"
products = CSV.read("products.csv", headers: true, header_converters: :symbol)
p products.map(&:to_h)
# [{:id=>"1", :product=>"Laptop", :price=>"899.99"},
#  {:id=>"2", :product=>"Phone", :price=>"499.99"},
#  {:id=>"3", :product=>"Tablet", :price=>"299.99"}]

###########################################################################
# Working with CSV data in memory
###########################################################################

puts "\nWorking with CSV in memory:"
csv_string = "Item,Quantity,Price\nBook,5,9.99\nPen,10,1.99\nNotebook,3,4.99"

# Parsing a CSV string
parsed_csv = CSV.parse(csv_string)
p parsed_csv
# [["Item", "Quantity", "Price"], ["Book", "5", "9.99"], ["Pen", "10", "1.99"], ["Notebook", "3", "4.99"]]

# Parsing with headers
parsed_with_headers = CSV.parse(csv_string, headers: true)
parsed_with_headers.each do |row|
  puts "#{row["Quantity"]} #{row["Item"]}(s) at $#{row["Price"]} each"
end
# 5 Book(s) at $9.99 each
# 10 Pen(s) at $1.99 each
# 3 Notebook(s) at $4.99 each

# Generating CSV string
puts "\nGenerating CSV string:"
new_csv_string = CSV.generate do |csv|
  csv << ["Name", "Score"]
  csv << ["Alice", 95]
  csv << ["Bob", 87]
end
puts new_csv_string
# Name,Score
# Alice,95
# Bob,87

###########################################################################
# Advanced CSV options
###########################################################################

# Custom column separators (tab-separated values)
puts "\nCustom column separators (TSV):"
tsv_data = "Name\tAge\tCity\nAlice\t28\tSeattle\nBob\t34\tChicago"
CSV.parse(tsv_data, col_sep: "\t").each do |row|
  p row
end
# ["Name", "Age", "City"]
# ["Alice", "28", "Seattle"]
# ["Bob", "34", "Chicago"]

# Handling quotes in data
puts "\nHandling quotes in data:"
quoted_csv = 'Item,Description
Book,"Programming in Ruby, 3rd Edition"
Journal,"Personal notes, ideas, and plans"'

CSV.parse(quoted_csv).each do |row|
  p row
end
# ["Item", "Description"]
# ["Book", "Programming in Ruby, 3rd Edition"]
# ["Journal", "Personal notes, ideas, and plans"]

# Type conversion
puts "\nType conversion:"
numbers_csv = "ID,Value\n1,10\n2,15.5\n3,20"

# Converting string numbers to actual numbers
CSV.parse(numbers_csv, headers: true, converters: :numeric).each do |row|
  sum = row["ID"] + row["Value"]
  puts "ID #{row["ID"]} + Value #{row["Value"]} = #{sum} (#{sum.class})"
end
# ID 1 + Value 10 = 11 (Integer)
# ID 2 + Value 15.5 = 17.5 (Float)
# ID 3 + Value 20 = 23 (Integer)

# Custom converters
puts "\nCustom converters:"
CSV::Converters[:boolean] = lambda do |field|
  case field.downcase
  when "true", "yes", "y", "1"
    true
  when "false", "no", "n", "0"
    false
  else
    field
  end
end

bool_csv = "Name,Active\nAlice,true\nBob,false\nCharlie,yes\nDavid,no"
CSV.parse(bool_csv, headers: true, converters: [:boolean]).each do |row|
  puts "#{row["Name"]} is #{row["Active"] ? "active" : "inactive"}"
end
# Alice is active
# Bob is inactive
# Charlie is active
# David is inactive

###########################################################################
# Error handling
###########################################################################

puts "\nError handling:"
begin
  CSV.parse('unclosed quote," bad data')
rescue CSV::MalformedCSVError => e
  puts "CSV parsing error: #{e.message}"
end
# CSV parsing error: Illegal quoting in line 1.

# Clean up temporary files
File.delete("sample.csv") if File.exist?("sample.csv")
File.delete("products.csv") if File.exist?("products.csv")
File.delete("people.csv") if File.exist?("people.csv")
