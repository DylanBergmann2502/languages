# Define a custom exception using defexception
defmodule InvalidAgeError do
  defexception message: "Age must be between 0 and 150"
end

# Function that uses the custom exception
defmodule Person do
  def validate_age(age) when is_integer(age) and age >= 0 and age <= 150 do
    {:ok, age}
  end

  def validate_age(age) do
    # We can provide a custom message, instead of using the default one
    raise InvalidAgeError, message: "Got invalid age: #{age}"
  end
end

# Let's try using it
try do
  Person.validate_age(200)
rescue
  e in [InvalidAgeError] ->
    IO.inspect(e) # %InvalidAgeError{message: "Got invalid age: 200"}
    IO.inspect("Caught error: #{e.message}") # "Caught error: Got invalid age: 200"
end

# You can also raise directly
try do
  raise InvalidAgeError
rescue
  e ->
    IO.inspect(e) # %InvalidAgeError{message: "Age must be between 0 and 150"}
    IO.inspect("Default message: #{e.message}") # "Default message: Age must be between 0 and 150"
end
