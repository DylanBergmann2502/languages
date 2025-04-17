# Ruby YAML Library
# YAML (YAML Ain't Markup Language) is a human-friendly data serialization format
# It's commonly used for configuration files and data exchange between languages

require "yaml"

########################################################################
# Basic YAML Serialization (Ruby objects to YAML)

# Let's create a simple Ruby hash
user = {
  "name" => "Alice",
  "age" => 28,
  "roles" => ["admin", "developer"],
  "active" => true,
}

# Convert Ruby object to YAML string
yaml_string = user.to_yaml
puts "YAML String:"
puts yaml_string

# Write YAML to a file
File.write("user.yaml", yaml_string)
puts "Wrote YAML to user.yaml"

########################################################################
# Basic YAML Deserialization (YAML to Ruby objects)

# Load YAML from a string - using safe_load with permitted classes
loaded_user = YAML.safe_load(yaml_string)
puts "\nLoaded from string:"
p loaded_user

# Load YAML from a file - using safe_load with permitted classes
file_user = YAML.safe_load(File.read("user.yaml"))
puts "\nLoaded from file:"
p file_user

# Verify the loaded object is identical to the original
puts "\nOriginal user == loaded user: #{user == loaded_user}"

########################################################################
# YAML supports complex nested structures

complex_data = {
  "users" => [
    { "name" => "Alice", "age" => 28 },
    { "name" => "Bob", "age" => 32 },
  ],
  "settings" => {
    "theme" => "dark",
    "notifications" => true,
    "limits" => {
      "max_users" => 100,
      "max_projects" => 25,
    },
  },
  "version" => 2.1,
  "active" => true,
  # Using a string representation of time instead of Time object
  "last_update" => Time.now.to_s,
}

complex_yaml = complex_data.to_yaml
puts "\nComplex YAML:"
puts complex_yaml

# YAML preserves data types for safe types
loaded_complex = YAML.safe_load(complex_yaml)
puts "\nString representation of time: #{loaded_complex["last_update"]}"
puts "Float preserved? #{loaded_complex["version"].is_a?(Float)}"

########################################################################
# Explicitly permitting classes with safe_load

# Create a new complex data with Time object
time_data = {
  "event_name" => "Conference",
  "timestamp" => Time.now,
}

time_yaml = time_data.to_yaml
puts "\nYAML with Time object:"
puts time_yaml

# Using safe_load with permitted_classes
loaded_with_time = YAML.safe_load(time_yaml, permitted_classes: [Time])
puts "\nLoaded with Time class permitted:"
p loaded_with_time
puts "Time object preserved? #{loaded_with_time["timestamp"].is_a?(Time)}"

########################################################################
# Safe Loading - YAML.safe_load

# YAML.load can be dangerous as it can deserialize arbitrary Ruby objects
# YAML.safe_load is more secure but has limitations on what it can deserialize

# Create a file with a custom class
class MyClass
  attr_accessor :data

  def initialize(data)
    @data = data
  end
end

unsafe_obj = { "my_obj" => MyClass.new("secret data") }
File.write("unsafe.yaml", unsafe_obj.to_yaml)

begin
  # This will fail with safe_load by default
  YAML.safe_load(File.read("unsafe.yaml"))
rescue Exception => e
  puts "\nSafe load error: #{e.message}"
end

# You can permit certain classes with safe_load
safe_obj = YAML.safe_load(File.read("unsafe.yaml"), permitted_classes: [MyClass])
puts "Safe load with permitted classes: #{safe_obj.inspect}"

########################################################################
# YAML.dump vs to_yaml

# YAML.dump and to_yaml are mostly equivalent
dump_yaml = YAML.dump(user)
to_yaml_yaml = user.to_yaml

puts "\nYAML.dump output:"
puts dump_yaml
puts "\nto_yaml output:"
puts to_yaml_yaml
puts "YAML.dump == to_yaml: #{dump_yaml == to_yaml_yaml}"

########################################################################
# Working with YAML Documents (multiple documents in one file)

# Create multiple YAML documents
doc1 = { "name" => "Document 1", "id" => 1 }
doc2 = { "name" => "Document 2", "id" => 2 }

# Combine them with the YAML document separator
multi_doc = doc1.to_yaml + "---\n" + doc2.to_yaml
File.write("multi_doc.yaml", multi_doc)

puts "\nMulti-document YAML file created"

# Load multiple documents
docs = []
YAML.load_stream(File.read("multi_doc.yaml")) do |doc|
  docs << doc if doc # Only add non-nil documents
end

puts "Number of documents loaded: #{docs.size}"
puts "Document IDs: #{docs.compact.map { |doc| doc["id"] }.join(", ")}"

# Alternative: Process each document directly
puts "\nProcessing each document directly:"
YAML.load_stream(File.read("multi_doc.yaml")) do |doc|
  puts "Document: #{doc.inspect}" if doc
end

########################################################################
# YAML Aliases and Anchors

# YAML has a feature to avoid repetition using anchors (&) and aliases (*)
yaml_with_alias = <<~YAML
  default: &default
    adapter: sqlite3
    timeout: 5000
    
  development:
    <<: *default
    database: dev.sqlite3
    
  test:
    <<: *default
    database: test.sqlite3
YAML

config = YAML.safe_load(yaml_with_alias, aliases: true)
puts "\nUsing YAML anchors and aliases:"
puts "Development adapter: #{config["development"]["adapter"]}"
puts "Test timeout: #{config["test"]["timeout"]}"

########################################################################
# Customizing YAML output

# You can customize how Ruby objects are serialized to YAML
class Person
  attr_accessor :name, :age, :secret

  def initialize(name, age, secret)
    @name = name
    @age = age
    @secret = secret
  end

  # Custom YAML serialization
  def encode_with(coder)
    coder["name"] = @name
    coder["age"] = @age
    # Intentionally not including @secret
  end
end

person = Person.new("Dave", 35, "top secret info")
person_yaml = person.to_yaml

puts "\nCustomized YAML serialization:"
puts person_yaml
puts "Secret is not included in the YAML output"

# Clean up temp files
File.delete("user.yaml") if File.exist?("user.yaml")
File.delete("unsafe.yaml") if File.exist?("unsafe.yaml")
File.delete("multi_doc.yaml") if File.exist?("multi_doc.yaml")
