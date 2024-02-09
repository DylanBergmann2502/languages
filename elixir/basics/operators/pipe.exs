# the |> operator can be used to chain function calls together
# in such a way that the value returned by the previous function call
# is passed as the first argument to the next function call.

String.replace_suffix(String.upcase(String.duplicate("go ", 3)), " ", "!")

# versus

"go " |> String.duplicate(3) |> String.upcase() |> String.replace_suffix(" ", "!")


################################################################
# Kernel functions are usually used everywhere without the Kernel module name,
# but the module name is needed when using those functions in a pipe chain.
2 * 3 == 6 # can be written as

2 |> Kernel.*(3) |> Kernel.==(6)


################################################################
### Rules to follow with pipe operator
## Do not use the pipe operator when doing a single function call.

# do
String.split("hello", "")

# don't
"hello" |> String.split("")

## Do not create anonymous functions directly in the pipe chain.

# do
take_n_letters = fn n -> Enum.take(?a..?z, n) end
2 |> Kernel.*(3) |> take_n_letters.()

# don't
2 |> Kernel.*(3) |> (fn n -> Enum.take(?a..?z, n) end).()

## Always start a pipe chain with a variable or literal value, not a function call.

# do
"hello" |> String.upcase() |> String.split("")

# don't
String.upcase("hello") |> String.split("")


################################################################
### Pitfalls
## Operator precedence

String.graphemes "Hello" |> Enum.reverse

# Translates to

String.graphemes("Hello" |> Enum.reverse())

# Adding explicit parentheses resolves the ambiguity:

String.graphemes("Hello") |> Enum.reverse()

# or

"Hello" |> String.graphemes() |> Enum.reverse()

## Elixir always pipes to a function call. Therefore,
## to pipe into an anonymous function, you need to invoke it
