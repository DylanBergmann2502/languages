# JSON (JavaScript Object Notation) is a lightweight data interchange format
# Ruby's standard library includes a JSON module for parsing and generating JSON data
require 'json'

#########################################################################
# Parsing JSON (Converting JSON string to Ruby objects)
#########################################################################

# Simple JSON string to Ruby hash
puts "Converting JSON string to Ruby hash:"
json_string = '{"name":"Ruby","age":30,"is_programming_language":true}'
parsed_data = JSON.parse(json_string)
p parsed_data  # {"name"=>"Ruby", "age"=>30, "is_programming_language"=>true}

# Note that keys are strings by default
puts "Keys are strings by default:"
puts parsed_data["name"]  # Ruby
puts parsed_data[:name].nil?  # true - can't access with symbols by default

# Converting keys to symbols using symbolize_names option
puts "\nConverting keys to symbols:"
parsed_with_symbols = JSON.parse(json_string, symbolize_names: true)
p parsed_with_symbols  # {:name=>"Ruby", :age=>30, :is_programming_language=>true}
puts parsed_with_symbols[:name]  # Ruby

# Parsing nested JSON
puts "\nParsing nested JSON:"
nested_json = '{"person":{"name":"Ruby","hobbies":["coding","debugging"]}}'
nested_data = JSON.parse(nested_json)
p nested_data  # {"person"=>{"name"=>"Ruby", "hobbies"=>["coding", "debugging"]}}
puts nested_data["person"]["hobbies"][0]  # coding

#########################################################################
# Generating JSON (Converting Ruby objects to JSON strings)
#########################################################################

# Converting hash to JSON string
puts "\nConverting Ruby hash to JSON string:"
ruby_hash = {name: "Ruby", version: 3.2, features: ["blocks", "procs", "lambdas"]}
json_output = ruby_hash.to_json
puts json_output  # {"name":"Ruby","version":3.2,"features":["blocks","procs","lambdas"]}

# Using JSON.generate (alternative to to_json)
puts "\nUsing JSON.generate:"
json_output2 = JSON.generate(ruby_hash)
puts json_output2  # {"name":"Ruby","version":3.2,"features":["blocks","procs","lambdas"]}

# Pretty printing JSON
puts "\nPretty-printing JSON:"
pretty_json = JSON.pretty_generate(ruby_hash)
puts pretty_json
# {
#   "name": "Ruby",
#   "version": 3.2,
#   "features": [
#     "blocks",
#     "procs",
#     "lambdas"
#   ]
# }

#########################################################################
# Working with JSON in files
#########################################################################

# Writing JSON to a file
puts "\nWriting JSON to a file:"
File.write("data.json", JSON.pretty_generate(ruby_hash))
puts "File written successfully"

# Reading JSON from a file
puts "\nReading JSON from a file:"
file_data = File.read("data.json")
parsed_file_data = JSON.parse(file_data)
p parsed_file_data  # {"name"=>"Ruby", "version"=>3.2, "features"=>["blocks", "procs", "lambdas"]}

#########################################################################
# JSON with custom objects
#########################################################################

puts "\nJSON with custom objects:"
class Person
  attr_accessor :name, :age
  
  def initialize(name, age)
    @name = name
    @age = age
  end
  
  # Method to convert object to hash for JSON serialization
  def to_json(*args)
    {name: @name, age: @age}.to_json(*args)
  end
  
  # Class method to create a Person from JSON
  def self.from_json(json_str)
    data = JSON.parse(json_str)
    new(data["name"], data["age"])
  end
end

# Create a Person and convert to JSON
person = Person.new("John", 25)
person_json = person.to_json
puts person_json  # {"name":"John","age":25}

# Create a Person from JSON
new_person = Person.from_json(person_json)
puts "Name: #{new_person.name}, Age: #{new_person.age}"  # Name: John, Age: 25

#########################################################################
# Advanced JSON Parsing Options
#########################################################################

puts "\nAdvanced parsing options:"

# max_nesting - limit nesting depth
deep_nested = '{"a":{"b":{"c":{"d":{"e":"value"}}}}}'
begin
  JSON.parse(deep_nested, max_nesting: 3)
rescue JSON::NestingError => e
  puts "Nesting error: #{e.message}"  # Nesting error: nesting of 4 is too deep
end

# allow_nan - parse special floating point values
special_values = '{"value1": NaN, "value2": Infinity, "value3": -Infinity}'
special_parsed = JSON.parse(special_values, allow_nan: true)
p special_parsed  # {"value1"=>NaN, "value2"=>Infinity, "value3"=>-Infinity}

#########################################################################
# Handling Errors
#########################################################################

puts "\nHandling JSON errors:"

# Invalid JSON
begin
  JSON.parse('{"incomplete": "json"')
rescue JSON::ParserError => e
  puts "Parser error: #{e.message}"  # Parser error: unexpected token at '{"incomplete": "json"'
end

# Clean up by deleting the temporary file
File.delete("data.json") if File.exist?("data.json")
