# Guards begin with the when keyword, followed by a boolean expression.
# Guard expressions are special functions which:
#   Must be pure and not mutate any global states.
#   Must return strict true or false values.
defmodule ListUtils do
  def empty?(list) when is_list(list) and length(list) == 0 do
    true
  end
  def empty?(_), do: false
end

IO.puts ListUtils.empty?([])   # true
IO.puts ListUtils.empty?([1])  # false

# List of allowed functions and operators
#   Type checks: is_integer/1, is_list/1, is_nil/1 etc.
#   Arithmetic operators: +/2, -/2 etc.
#   Comparison operators (==, !=, ===, !==, <, <=, >, >=)
#   Strictly boolean operators (and, or, not). Note &&, ||, and ! sibling operators are not allowed as they're not strictly boolean - meaning they don't require arguments to be booleans
#   Membership operator: (not) in/2

# You can define your own guard with defguard
# guard names should start with is_
defmodule HTTP do
  defguard is_success(code) when code >= 200 and code < 300

  def handle_response(code) when is_success(code) do
    :ok
  end
end

#########################################################################
# Non-passing guards
defmodule HeadCheck do
  def not_nil_head?([head | _]) when head, do: true
  def not_nil_head?(_), do: false

  # Even though the head of the list is not nil, the first clause
  # for not_nil_head?/1 fails because the expression does not evaluate to true

  def not_nil_head_fixed?([head | _]) when head != nil, do: true
  def not_nil_head_fixed?(_), do: false
end

IO.puts HeadCheck.not_nil_head?(["some_value", "another_value"])
#=> false

IO.puts HeadCheck.not_nil_head_fixed?(["some_value", "another_value"])
#=> true

#########################################################################
# Errors in guards
# tuple_size("hello") # ** (ArgumentError) argument error
case "hello" do
  something when tuple_size(something) == 2 ->
    :worked
  _anything_else ->
    :failed
end
# :failed

# In many cases, we can take advantage of this. In the code above,
# we used tuple_size/1 to both check that the given value is a tuple
# and check its size (instead of using is_tuple(something) and tuple_size(something) == 2).

# if your guard has multiple conditions, such as checking for tuples or maps,
# it is best to call type-check functions like is_tuple/1before tuple_size/1,
# otherwise the whole guard will fail if a tuple is not given.

#########################################################################
# Multiple guards in the same clause
defmodule TypeCheck do
  def is_number_or_nil(term) when is_integer(term) or is_float(term) or is_nil(term),
    do: :maybe_number
  def is_number_or_nil(_other),
    do: :something_else
end

# But
defmodule Check do
  # If given a tuple, map_size/1 will raise, and tuple_size/1 will not be evaluated
  def empty?(val) when map_size(val) == 0 or tuple_size(val) == 0, do: true
  def empty?(_val), do: false
end

IO.inspect Check.empty?(%{}) #=> true
IO.inspect Check.empty?({})  #=> false (surprising! map_size raised, short-circuit killed second check)

# These are different: using separate when clauses (each guard is tried independently)
defmodule Check2 do
  def empty?(val)
      when map_size(val) == 0
      when tuple_size(val) == 0,
      do: true

  def empty?(_val), do: false
end

IO.inspect Check2.empty?(%{}) #=> true
IO.inspect Check2.empty?({})  #=> true
