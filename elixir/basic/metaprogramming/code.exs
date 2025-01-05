# Code.eval_string/1 - Evaluates Elixir code from a string
result = Code.eval_string("2 + 3")
IO.inspect(result)  # {5, []}  (returns a tuple with result and bindings)

# Using with bindings
x = 10
result = Code.eval_string("x + 5", [x: x])
IO.inspect(result)  # {15, [x: 10]}

# Code.string_to_quoted/1 - Converts string to AST (Abstract Syntax Tree)
ast = Code.string_to_quoted!("1 + 2")
IO.inspect(ast)  # {:+, [context: Elixir, import: Kernel], [1, 2]}

# Code.eval_quoted/1 - Evaluates AST directly
quoted_expr = quote do: 1 + 2
result = Code.eval_quoted(quoted_expr)
IO.inspect(result)  # {3, []}

# A more practical example: Dynamic function creation
str_code = """
defmodule MyDynamicModule do
  def hello, do: "Hello, Dynamic!"
end
"""

Code.eval_string(str_code)
IO.inspect(MyDynamicModule.hello())  # "Hello, Dynamic!"
