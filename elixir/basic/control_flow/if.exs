# if/2 is actually a macro, not a language construct
# One liner - foo/bar/baz are expressions, so we use real values to demonstrate:
foo = true
bar = "truthy branch"
baz = "falsy branch"
IO.puts(if(foo, do: bar, else: baz)) # "truthy branch"

# Block
if true do
  "This works!"
else
  "This won't be seen"
end # "This works!"

unless true do
  "This will never be seen"
end # nil

# If any variable is declared or changed inside if, case, and similar constructs,
# the declaration and change will only be visible inside the construct.
x = 1

if true do
  _x = x + 1  # rebinding inside if is local - has no effect outside
end

IO.puts(x) # 1 (unchanged)

# In said cases, if you want to change a value,
# you must return the value from the if:
x = 1
x = if true do
  x + 1
else
  x
end # 2

IO.puts(x) # 2
