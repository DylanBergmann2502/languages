x = 1 # 1
# Notice that 1 = x is a valid expression,
# and it matched because both the left and
# right side are equal to 1. When the sides
# do not match, a MatchError is raised.
1 = x # 1

# 2 = x would raise ** (MatchError) no match of right hand side value: 1
# We wrap it in try/rescue to demonstrate the error without crashing the script:
try do
  2 = x
rescue
  e in MatchError -> IO.puts("Caught MatchError: #{inspect(e.term)}")
end
