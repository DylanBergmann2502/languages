# First, let's create a simple protocol
defprotocol Greeting do
  def say_hello(data)
end

# Implement it for Any
defimpl Greeting, for: Any do
  def say_hello(data), do: "Hello from #{inspect(data)}"
end

# Create a struct WITH @derive
defmodule Person do
  # This automatically implements Greeting protocol
  # with the Any implementation.
  @derive [Greeting]
  defstruct [:name]

  def run do
    person = %Person{name: "John"}
    IO.inspect Greeting.say_hello(person)  # "Hello from %Person{name: \"John\"}"
    # This works because we used @derive
  end
end

# Create another struct WITHOUT @derive
defmodule Animal do
  defstruct [:type]

  def run do
    animal = %Animal{type: "dog"}
    # This will raise a Protocol.UndefinedError because we didn't derive or implement
    # Greeting for Animal
    IO.inspect Greeting.say_hello(animal)
  end
end

Person.run()
Animal.run()
