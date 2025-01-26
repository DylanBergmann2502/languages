# Enum forcibly evaluates the entire range immediately
IO.puts("Using Enum:")
1..3
|> Enum.map(&IO.inspect(&1))
|> Enum.map(&(&1 * 2))
|> Enum.map(&IO.inspect(&1))

# Output will be:
# 1
# 2
# 3

# 2
# 4
# 6

# Stream evaluates each element individually
IO.puts("\nUsing Stream:")
1..3
|> Stream.map(&IO.inspect(&1))
|> Stream.map(&(&1 * 2))
|> Stream.map(&IO.inspect(&1))
|> Enum.to_list()  # This forces evaluation

# Output will be:
# 1
# 2

# 2
# 4

# 3
# 6
