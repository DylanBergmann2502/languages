plus = 1 + 2 # 3
IO.puts("plus: #{plus}")

multiply = 5 * 5 # 25
IO.puts("multiply: #{multiply}")

divide = 10 / 2 # 5.0
IO.puts("divide: #{divide}")

div_result = div(10, 2) # 5
IO.puts("div_result: #{div_result}")

div_result = div 10, 2 # 5
IO.puts("div_result: #{div_result}")

rem_result = rem(10, 3) # 1
IO.puts("rem_result: #{rem_result}")

round_result = round(3.58) # 4
IO.puts("round_result: #{round_result}")

trunc_result = trunc(3.58) # 3
IO.puts("trunc_result: #{trunc_result}")

is_integer(1) # true
is_integer(2.0) # false
