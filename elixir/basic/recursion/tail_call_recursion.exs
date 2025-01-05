# Tail call recursion is a type of recursion
# where the recursive call is the last operation
# in the function. In Elixir (and Erlang),
# the compiler optimizes tail recursive calls
# so they don't grow the stack, effectively
# turning them into a loop at the machine level.

defmodule NonTailRecursiveFactorial do
  def compute(0), do: 1

  # Must wait for `compute(n-1)` before multiplying with `number`
  def compute(number), do: number * compute(number - 1)
end

# In order to achieve tail call recursion in Elixir,
# an accumulator is often required because of data immutability rules.
defmodule TailRecursiveFactorial do
  def compute(number, accumulator \\ 1)
  def compute(0, accumulator), do: accumulator
  def compute(number, accumulator), do: compute(number - 1, number * accumulator)
end

# Let's try them
IO.inspect(NonTailRecursiveFactorial.compute(5)) # 120
# NonTailRecursiveFactorial.compute(5)
# = 5 * NonTailRecursiveFactorial.compute(4)
# = 5 * (4 * NonTailRecursiveFactorial.compute(3))
# = 5 * (4 * (3 * NonTailRecursiveFactorial.compute(2)))
# = 5 * (4 * (3 * (2 * NonTailRecursiveFactorial.compute(1))))
# = 5 * (4 * (3 * (2 * (1 * NonTailRecursiveFactorial.compute(0)))))
# = 5 * (4 * (3 * (2 * (1 * 1))))
# = 5 * (4 * (3 * (2 * 1)))
# = 5 * (4 * (3 * 2))
# = 5 * (4 * 6)
# = 5 * 24
# = 120

IO.inspect(TailRecursiveFactorial.compute(5))    # 120
# TailRecursiveFactorial.compute(5)
# = TailRecursiveFactorial.compute(5, 1)
# = TailRecursiveFactorial.compute(4, 5)
# = TailRecursiveFactorial.compute(3, 20)
# = TailRecursiveFactorial.compute(2, 60)
# = TailRecursiveFactorial.compute(1, 120)
# = TailRecursiveFactorial.compute(0, 120)
# = 120
