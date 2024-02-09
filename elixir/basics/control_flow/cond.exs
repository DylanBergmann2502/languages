# cond follows the first path that evaluates to true.
# At least one clause should evaluate to true
# or a run-time error will be raised.
cond do
  x > 10 -> :this_might_be_the_way
  y < 7 -> :or_that_might_be_the_way
  true -> :this_is_the_default_way
end

# The COND conditional is usually used when there are more than two logical branches
# and each branch has a condition based on different variables.
# If all the conditions are based on the same variables,
# a CASE conditional is a better fit.
# If there are only two logical branches, use an IF conditional instead.
def classify_number(number) do
  cond do
    is_integer(number) and rem(number, 2) == 0 ->
      "Even integer"

    is_integer(number) and rem(number, 2) != 0 ->
      "Odd integer"

    is_float(number) ->
      "Floating-point number"

    true ->
      "Not a valid number"
  end
end

# note cond considers any value besides nil and false to be true:
cond do
  hd([1, 2, 3]) ->
    "1 is considered as true"
end # "1 is considered as true"
