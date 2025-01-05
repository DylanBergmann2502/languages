# The basic format of an Elixir AST (Abstract Syntax Tree) node is:
# {operator, metadata, arguments}
ast = quote do
  sum = 1 + 2
end

IO.inspect ast
# {:=, [],
#  [
#    {:sum, [], Elixir},
#    {:+, [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]], [1, 2]}
#  ]
# }

# Sometimes, when working with quoted expressions,
# it may be useful to get the textual code representation back.
# This can be done with Macro.to_string/1:
IO.puts Macro.to_string(ast) # sum = 1 + 2


ast2 = quote do
  if age >= 18 do
    "Adult"
  else
    "Minor"
  end
end
IO.inspect(ast2)
# {:if, [context: Elixir, imports: [{2, Kernel}]],
#  [
#    {:>=, [context: Elixir, imports: [{2, Kernel}]], [{:age, [], Elixir}, 18]},
#    [do: "Adult", else: "Minor"]
#  ]
# }
