defmodule LearnNx do
  import Nx.Defn

  # Define the JIT function at module level
  defn jit_add(x, y) do
    x + y
  end

  def run do
    # Create tensors
    tensor1 = Nx.tensor([[1, 2], [3, 4]])
    IO.puts("Tensor 1:")
    IO.inspect(tensor1)

    # Basic operations
    doubled = Nx.multiply(tensor1, 2)
    IO.puts("\nDoubled tensor:")
    IO.inspect(doubled)

    # Matrix multiplication
    result = Nx.dot(tensor1, tensor1)
    IO.puts("\nMatrix multiplication:")
    IO.inspect(result)

    # Using our JIT compiled function
    t1 = Nx.tensor([1, 2, 3])
    t2 = Nx.tensor([4, 5, 6])

    IO.puts("\nJIT compiled addition:")
    IO.inspect(jit_add(t1, t2))
  end
end
