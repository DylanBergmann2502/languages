friends = ["Kevin", "Karen", "Oscar", "Angela", "Andy"]
for friend in friends
  puts friend
end

friends.each do |friend|
  puts friend
end

friends.each { |friend| puts friend }

for num in 1..5
  puts num
end

6.times do |num|
  puts num
end
