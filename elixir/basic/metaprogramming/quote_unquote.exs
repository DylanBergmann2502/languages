# Basic quote example
x = 10
ast = quote do
  x + 20
end

IO.puts Macro.to_string(ast)  # Output: x + 20
IO.inspect ast                # Output: {:+, [context: Elixir, imports: [{1, Kernel}]], [{:x, [], Elixir}, 20]}

# Using unquote to inject values
ast_with_unquote = quote do
  unquote(x) + 20
end

IO.puts Macro.to_string(ast_with_unquote)  # Output: 10 + 20
IO.inspect ast_with_unquote                # Output: {:+, [context: Elixir, imports: [{1, Kernel}]], [10, 20]}

# Unquote in string interpolation
name = "Alice"
ast_string = quote do
  "Hello #{unquote(name)}"
end

IO.puts Macro.to_string(ast_string)        # Output: "Hello Alice"
IO.inspect ast_string                      # Shows the string is now interpolated with the actual value

# Unquote with list manipulation
numbers = [1, 2, 3]
ast_list = quote do
  [unquote_splicing(numbers), 4, 5]
end

IO.puts Macro.to_string(ast_list)          # Output: [1, 2, 3, 4, 5]
IO.inspect ast_list                        # Shows how the list was spliced
