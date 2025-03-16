teacher_mailboxes = [
  ["Adams", "Baker", "Clark", "Davis"],
  ["Jones", "Lewis", "Lopez", "Moore"],
  ["Perez", "Scott", "Smith", "Young"]
]

=begin
If you try to access an index of a nonexistent nested element,
  it will raise an NoMethodError, because the nil class does not have a [] method.
However, just like a regular array, if you try to access
  a nonexistent index inside of an existing nested element, it will return nil.
=end

# puts teacher_mailboxes[3][0] #=> NoMethodError
puts teacher_mailboxes[0][4]   #=> nil

# if you wanna a nil value return for both of the above way of indexing a nested array
puts teacher_mailboxes.dig(3, 0)    #=> nil
puts teacher_mailboxes.dig(0, 4)    #=> nil

############################################################
# If you create a nested array using the second optional argument
# the change in one nested array will affect the others
mutable = Array.new(3, Array.new(2))      #=> [[nil, nil], [nil, nil], [nil, nil]]
mutable[0][0] = 10
print mutable, "\n"                       #=> [[1000, nil], [1000, nil], [1000, nil]]

immutable = Array.new(3) { Array.new(2) } #=> [[nil, nil], [nil, nil], [nil, nil]]
immutable[0][0] = 10
print immutable, "\n"

###########################################################
test_scores = [
  [97, 76, 79, 93],
  [79, 84, 76, 79],
  [88, 67, 64, 76],
  [94, 55, 67, 81]
]

test_scores << [100, 99, 98, 97]
#=> [[97, 76, 79, 93], [79, 84, 76, 79], [88, 67, 64, 76], [94, 55, 67, 81], [100, 99, 98, 97]]

test_scores[0].push(100)
#=> [97, 76, 79, 93, 100]

test_scores.pop
#=> [100, 99, 98, 97]

test_scores[0].pop
#=> 100

print test_scores, "\n"
#=> [[97, 76, 79, 93], [79, 84, 76, 79], [88, 67, 64, 76], [94, 55, 67, 81]]

################################################################
teacher_mailboxes.each_with_index do |row, row_index|
  puts "Row:#{row_index} = #{row}"
end

teacher_mailboxes.each_with_index do |row, row_index|
  row.each_with_index do |teacher, column_index|
    puts "Row:#{row_index} Column:#{column_index} = #{teacher}"
  end
end

# flatten can be used if you only need each value in the nested array
teacher_mailboxes.flatten.each do |teacher|
  puts "#{teacher} is amazing!"
end
#=> ["Adams", "Baker", "Clark", "Davis", "Jones", "Lewis", "Lopez",
#    "Moore", "Perez", "Scott", "Smith", "Young"]





