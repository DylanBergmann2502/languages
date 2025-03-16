my_hash = {
  "a random word" => "ahoy",
  "Dorothy's math test score" => 94,
  "an array" => [1, 2, 3],
  "an empty hash within a hash" => {}
}

my_hash_2 = Hash.new()  #=> {}
puts my_hash_2

################################################################
shoes = {
  "summer" => "sandals",
  "winter" => "boots"
}

puts shoes["summer"]   #=> "sandals"
# If you try to access a key that doesn’t exist in the hash, it will return nil:
puts shoes["hiking"]   #=> nil

# puts shoes.fetch("hiking")   #=> KeyError: key not found: "hiking"
# Alternatively, this method can return a default value
# instead of raising an error if the given key is not found.
puts shoes.fetch("hiking", "hiking boots") #=> "hiking boots"

shoes["fall"] = "sneakers"
shoes["summer"] = "flip-flops"
puts shoes                     #=> {"summer"=>"flip-flops", "winter"=>"boots", "fall"=>"sneakers"}

shoes.delete("summer")         #=> "flip-flops"
puts shoes                     #=> {"winter"=>"boots", "fall"=>"sneakers"}

#########################################################################
books = {
  "Infinite Jest" => "David Foster Wallace",
  "Into the Wild" => "Jon Krakauer"
}

print books.keys      #=> ["Infinite Jest", "Into the Wild"]
print books.values    #=> ["David Foster Wallace", "Jon Krakauer"]
puts ""

########################################################################
hash1 = { "a" => 100, "b" => 200 }
hash2 = { "b" => 254, "c" => 300 }

# hash2 overrides hash1
puts hash1.merge(hash2)      #=> { "a" => 100, "b" => 254, "c" => 300 }

#######################################################################
# 'Rocket' syntax
american_cars = {
  :chevrolet => "Corvette",
  :ford => "Mustang",
  :dodge => "Ram"
}
# 'Symbols' syntax
japanese_cars = {
  honda: "Accord",
  toyota: "Corolla",
  nissan: "Altima"
}

puts american_cars[:ford]    #=> "Mustang"
puts japanese_cars[:honda]   #=> "Accord"
