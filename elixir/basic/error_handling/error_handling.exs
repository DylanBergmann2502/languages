defmodule ErrorHandler do
  def process_number(num) do
    try do
      # First check if number is positive
      if num < 0, do: throw({:negative, num})

      # Do some calculations
      result = case num do
        0 -> raise "Cannot process zero"
        n when n > 100 -> throw({:too_large, n})
        n -> n * 2
      end

      # This will only run if no exception was raised
      result
    rescue
      # Handle raised exceptions
      e in RuntimeError ->
        IO.inspect("Rescued runtime error: #{e.message}")
        :error_handled
    catch
      # Handle thrown values
      {:negative, n} ->
        IO.inspect("Caught negative number: #{n}")
        0
      {:too_large, n} ->
        IO.inspect("Caught too large number: #{n}")
        100
    else
      # This runs if no exception occurs (successful case)
      result when result < 50 ->
        IO.inspect("Got small result: #{result}")
        result
      result ->
        IO.inspect("Got large result: #{result}")
        result
    after
      # This always runs, like 'finally' in other languages
      IO.inspect("Cleanup: process completed")
    end
  end
end

# Let's test different scenarios
ErrorHandler.process_number(-5)    # Throws negative
ErrorHandler.process_number(0)     # Raises exception
ErrorHandler.process_number(150)   # Throws too large
ErrorHandler.process_number(20)    # Normal case, small result
ErrorHandler.process_number(40)    # Normal case, large result

# "Caught negative number: -5"
# "Cleanup: process completed"
# #=> 0

# "Rescued runtime error: Cannot process zero"
# "Cleanup: process completed"
# #=> :error_handled

# "Caught too large number: 150"
# "Cleanup: process completed"
# #=> 100

# "Got small result: 40"
# "Cleanup: process completed"
# #=> 40

# "Got large result: 80"
# "Cleanup: process completed"
# #=> 80
