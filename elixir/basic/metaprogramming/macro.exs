defmodule Math do
  # Define a macro using defmacro
  defmacro unless(condition, do: expression) do
    quote do
      if !unquote(condition) do
        unquote(expression)
      end
    end
  end
end

# Usage
defmodule MacroTest do
  require Math  # We need to require the module containing macros

  def run do
    Math.unless false do
      IO.puts("This will be printed")
    end

    Math.unless true do
      IO.puts("This won't be printed")
    end
  end
end

MacroTest.run()
# Output: "This will be printed"
