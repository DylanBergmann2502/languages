result = Enum.map([1, 2, 3], fn n -> n + 1 end) # => [2, 3, 4]
IO.inspect(result)

# Anonymous functions are created with
# the fn keyword and invoked with a dot (.):
function_variable = fn n -> n + 1 end
function_variable.(1) # => 2

######################################################
# Anonymous functions may be created with the & capture shorthand.
# The initial & declares the start of the capture expression.
# &1, &2, and so on refer to the positional arguments of the anonymous function.

# Instead of:
fn x, y -> abs(x) + abs(y) end

# We can write:
&(abs(&1) + abs(&2))

# Instead of:
fn a, b -> a <= b end

# We can capture the function using its name and arity:
&<=/2

######################################################
# Closures
y = 2

square = fn ->
  x = 3
  x * y
end

square.()
# => 6

######################################################
add = fn a, b -> a + b end
add.(1, 2) # 3

IO.puts(is_function(add))    # => true
IO.puts(is_function(add, 2)) # => true
IO.puts(is_function(add, 1)) # => false

######################################################
# Capture operator
# name/arity
fun = &is_atom/1
IO.puts(is_function(fun)) # true
IO.puts(fun.(:hello))     # true
IO.puts(fun.(123))        # false

fun = &String.length/1
IO.puts(is_function(fun)) # true
IO.puts(fun.("hello"))    # 5

add = &+/2
IO.puts(add.(1, 2))       # 3

fun = &(&1 + 1)
IO.puts(fun.(1))          # 2

greeting = &"Good #{&1}"
IO.puts(greeting.("morning"))  # Good morning

first_elem = &elem(&1, 0)
IO.puts(first_elem.({0, 1}))   # 0

return_list = &[&1, &2]
IO.puts(return_list.(1, 2))    # [1, 2]

return_tuple  = &{&1, &2}
IO.puts(return_tuple .(1, 2))  # {1, 2}
