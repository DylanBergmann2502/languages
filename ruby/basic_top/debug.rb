require 'pry-byebug'

# p = puts + inspect
def isogram?(string)
  original_length = string.length

  string_array = string.downcase.split("") # without argument split=split(" ")
  p string_array

  unique_length = string_array.uniq.length
  p unique_length

  original_length == unique_length
end

puts isogram?("Odin")

################################################################
puts "Using puts:"
puts []
p "Using p:"
p []

################################################################
def isogram?(string)
  original_length = string.length
  string_array = string.downcase.split

  binding.pry

  unique_length = string_array.uniq.length
  original_length == unique_length
end

puts isogram?("Odin")

# def yell_greeting(string)
#   name = string

#   binding.pry

#   name = name.upcase
#   greeting = "WASSAP, #{name}!"
#   puts greeting
# end

# yell_greeting("bob")
