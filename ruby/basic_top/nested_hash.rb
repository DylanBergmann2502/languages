vehicles = {
  alice: {year: 2019, make: "Toyota", model: "Corolla"},
  blake: {year: 2020, make: "Volkswagen", model: "Beetle"},
  caleb: {year: 2020, make: "Honda", model: "Accord"}
}

puts vehicles[:blake][:make]

# puts vehicles[:zoe][:year]         #=> NoMethodError
puts vehicles[:alice][:color]      #=> nil

puts vehicles.dig(:zoe, :year)     #=> nil
puts vehicles.dig(:alice, :color)  #=> nil

#####################################################################
vehicles[:dave] = {year: 2021, make: "Ford", model: "Escape"}
puts vehicles

vehicles[:dave][:color] = "red"
puts vehicles

vehicles.delete(:blake)
puts vehicles

vehicles[:dave].delete(:color)
puts vehicles

#####################################################################
puts vehicles.select { |name, data| data[:year] >= 2020 }
print vehicles.collect { |name, data| name if data[:year] >= 2020 }, "\n"
print vehicles.collect { |name, data| name if data[:year] >= 2020 }.compact, "\n"
print vehicles.filter_map { |name, data| name if data[:year] >= 2020 }, "\n"



