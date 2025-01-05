# case allows us to compare a value against
# many patterns until we find a matching one:

case {1, 2, 3} do
  {4, 5, 6} ->
    "This clause won't match"
  {1, x, 3} when x > 0 ->
    "This clause will match and bind x to 2 in this clause"
  _ ->
    "This clause would match any value"
end
# => "This clause will match and bind x to 2 in this clause"

# If you want to pattern match against an existing variable,
# you need to use the ^ operator:
x = 1

case 10 do
  ^x -> "Won't match"
  _ -> "Will match"
end
# => "Will match"
