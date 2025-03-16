def sayhi(name = "Mike")
  puts "Hello #{name}!"
end

sayhi
sayhi("Dylan")

def cube(num)
  return num*num*num, 70
end

puts cube(4)[1]
