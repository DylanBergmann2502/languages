lucky_nums = [1, 2, 3, 4, 5]

begin
  lucky_nums["dog"]
  num = 10/0
rescue Exception => e
  puts e
end
