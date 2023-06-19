puts 6.even?
puts 6.odd?

################################################################
# With the plus operator:
puts "Welcome " + "to " + "Odin!"    #=> "Welcome to Odin!"

# With the shovel operator:
puts "Welcome " << "to " << "Odin!"  #=> "Welcome to Odin!"

# With the concat method:
puts "Welcome ".concat("to ").concat("Odin!")  #=> "Welcome to Odin!"

################################################################
puts "hello"[0]      #=> "h"

puts "hello"[0..1]   #=> "he"

puts "hello"[0...1]   #=> "he"

puts "hello"[0, 4]   #=> "hell"

puts "hello"[-1]     #=> "o"

################################################################
=begin
\\  #=> Need a backslash in your string?
\b  #=> Backspace
\r  #=> Carriage return, for those of you that love typewriters
\n  #=> Newline. You'll likely use this one the most.
\s  #=> Space
\t  #=> Tab
\"  #=> Double quotation mark
\'  #=> Single quotation mark
=end

################################################################
name = "Odin"
puts "Hello, #{name}" #=> "Hello, Odin"
puts 'Hello, #{name}' #=> "Hello, #{name}"

###############################################################
puts "hello".capitalize #=> "Hello"

puts "hello".include?("lo")  #=> true

puts "hello".upcase  #=> "HELLO"

puts "Hello".downcase  #=> "hello"

puts "hello".empty?  #=> false
puts "".empty?       #=> true

puts "hello".length  #=> 5

puts "hello".reverse  #=> "olleh"

puts "hello world".split  #=> ["hello", "world"]
puts "hello".split("")    #=> ["h", "e", "l", "l", "o"]

puts " hello, world   ".strip  #=> "hello, world"

puts "he77o".sub("7", "l")           #=> "hel7o"
puts "he77o".gsub("7", "l")          #=> "hello"
puts "hello".insert(-1, " dude")     #=> "hello dude"
puts "hello world".delete("l")       #=> "heo word"
puts "!".prepend("hello, ", "world") #=> "hello, world!"

puts nil.to_s      #=> ""
puts :symbol.to_s  #=> "symbol"

################################################################
# Symbol vs string
puts "string" == "string"  #=> true

puts "string".object_id == "string".object_id  #=> false

puts :symbol.object_id == :symbol.object_id    #=> true
