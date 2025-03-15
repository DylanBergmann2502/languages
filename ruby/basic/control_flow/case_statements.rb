# Ruby's case statement provides a clean way to handle multiple conditions

########################################################################
# Basic case statement
day = "Tuesday"

case day
when "Monday"
  puts "Start of the work week"
when "Tuesday"
  puts "Second day of the work week"
when "Wednesday"
  puts "Hump day"
when "Thursday"
  puts "Almost Friday"
when "Friday"
  puts "TGIF!"
else
  puts "It's the weekend!"
end

########################################################################
# Case statements use the === operator for comparison
# For classes, === checks if the right side is an instance of the left side

value = 15

case value
when String
  puts "Value is a string"
when Integer
  puts "Value is an integer"
when 1..10
  puts "Value is between 1 and 10"
when 11..20
  puts "Value is between 11 and 20"
else
  puts "Value is something else"
end

# Notice that even though value is 15 (an Integer),
# the when Integer case didn't trigger because the when 11..20 came first
# Case statements evaluate from top to bottom

########################################################################
# Multiple conditions in a when clause
grade = 85

case grade
when 90..100
  puts "A grade"
when 80..89
  puts "B grade"
when 70..79
  puts "C grade"
when 60..69
  puts "D grade"
when 0..59
  puts "F grade"
else
  puts "Invalid grade"
end

########################################################################
# Case statements as expressions (return values)
color = "blue"

message = case color
  when "red"
    "Stop!"
  when "yellow"
    "Caution!"
  when "green"
    "Go!"
  else
    "Unknown signal"
  end

puts "The signal says: #{message}"

########################################################################
# Case without a value - acts like an if-elsif chain
temperature = 75

case
when temperature < 32
  puts "It's freezing"
when temperature < 50
  puts "It's cold"
when temperature < 70
  puts "It's cool"
when temperature < 85
  puts "It's warm"
else
  puts "It's hot"
end

########################################################################
# Case with array matching
coordinates = [3, 5]

case coordinates
when [0, 0]
  puts "At the origin"
when [0, Integer]
  puts "On the y-axis"
when [Integer, 0]
  puts "On the x-axis"
when Array
  puts "At point (#{coordinates[0]}, #{coordinates[1]})"
else
  puts "Not a valid point"
end

# Simple hash matching
data = { name: "Alice", age: 30, role: "Developer" }

result = case data
  when { name: "Bob" }
    "Found Bob"
  when { role: "Manager" }
    "Found a manager"
  else
    # We can still use the hash normally
    if data[:name].is_a?(String) && data[:age].is_a?(Integer) && data[:age] > 20
      "Found #{data[:name]}, who is older than 20"
    else
      "No match found"
    end
  end

puts result
