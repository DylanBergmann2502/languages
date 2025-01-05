# if/2 is actually a macro, not a language construct
# One liner
if(foo, do: bar, else: baz)

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
  x = x + 1
end

x # 1

# In said cases, if you want to change a value,
# you must return the value from the if:
x = 1
x = if true do
  x + 1
else
  x
end # 2
