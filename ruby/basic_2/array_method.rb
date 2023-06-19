puts [].empty?               #=> true
puts [[]].empty?             #=> false
puts [1, 2].empty?           #=> false

puts [1, 2, 3].length        #=> 3

print [1, 2, 3].reverse       #=> [3, 2, 1]
puts ""

puts [1, 2, 3].include?(3)   #=> true
puts [1, 2, 3].include?("3") #=> false

puts [1, 2, 3].join          #=> "123"
puts [1, 2, 3].join("-")     #=> "1-2-3"
