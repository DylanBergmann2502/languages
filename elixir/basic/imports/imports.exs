# alias: For creating shortcuts to avoid typing full module names.
#        Very common for keeping code clean and readable
# import: Brings functions directly into scope
#         so you can call them without the module name.
#         Helpful for frequently used functions but should be used sparingly.
# require: Ensures a module is compiled and available,
#          necessary for using macros.
#          Mainly for macro usage.
# use: A macro that allows a module to
#      inject code into your current module like mixins.
#      Common in Phoenix and other frameworks for extending module functionality.

# Creating 2 simple modules to demonstrate
defmodule Calculator do
  def add(a, b), do: a + b
  def subtract(a, b), do: a - b
end

defmodule Foo.Bar.Baz do

end

# 1. alias - creates a shortcut for module names
defmodule Alias do
  # Without alias we'd need to use: Calculator.add(1, 2)
  alias Calculator, as: Calc

  # alias Foo.Bar.Baz
  ## This is the same as
  # alias Foo.Bar.Baz, as: Baz

  def run do
    result = Calc.add(1, 2)
    IO.inspect(result) # 3
  end
end

Alias.run()

# 2. import - brings functions directly into current scope
defmodule Import do
  # This will import everything from Calculator
  import Calculator

  # This will only import add/2
  import Calculator, only: [add: 2]

  # This will will everything but subtract/2
  import Calculator, except: [subtract: 2]

  def run do
    result = add(5, 3) # directly using add without module name
    IO.inspect(result) # 8
  end
end

Import.run()

# 3. require - ensures module is compiled and loaded
# Mainly used when you need to use macros from a module
defmodule MyMath do
  defmacro is_zero(value) do
    quote do
      unquote(value) == 0
    end
  end
end

defmodule WithoutRequire do
  def check_zero(_n) do
    # This will fail because macro is not required
    # MyMath.is_zero(n)
  end
end

defmodule Require do
  require MyMath  # This makes macros available
  require Integer # Integer has macros like is_even/1

  def check_zero(n) do
    result = MyMath.is_zero(n)
    IO.inspect(result)
  end

  def run do
    check_zero(0) # true
    check_zero(1) # false

    # is_even is a macro, not a regular function
    result = Integer.is_even(4)
    IO.inspect(result) # true
  end
end

Require.run()

# 4. use - invokes custom code during compilation
# First, let's create a module that defines behavior we want to reuse
defmodule Greeter do
  # This macro will be called when another module "uses" Greeter
  defmacro __using__(_opts) do
    quote do
      # This function will be injected into any module that uses Greeter
      def hello(name) do
        "Hello, #{name}!"
      end

      # Let's add another function to show multiple injections
      def goodbye(name) do
        "Goodbye, #{name}!"
      end

      # This allows child modules to override the default behavior
      defoverridable hello: 1, goodbye: 1
    end
  end
end

# Now let's create a module that uses our Greeter
defmodule EnglishPerson do
  use Greeter  # This injects hello/1 and goodbye/1 functions

  def run do
    greeting = hello("John")
    farewell = goodbye("John")

    IO.inspect(greeting)   # "Hello, John!"
    IO.inspect(farewell)   # "Goodbye, John!"
  end
end

# We can use Greeter in multiple modules
defmodule FrenchPerson do
  use Greeter

  # We can even override the injected functions
  def hello(name) do
    "Bonjour, #{name}!"
  end
end

# Try it out
EnglishPerson.run()
IO.inspect(FrenchPerson.hello("Marie"))  # "Bonjour, Marie!"
IO.inspect(FrenchPerson.goodbye("Marie")) # "Goodbye, Marie!"
