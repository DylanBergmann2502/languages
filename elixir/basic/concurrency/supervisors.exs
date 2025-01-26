defmodule Calculator do
  use GenServer

  def start_link(initial_value) do
    GenServer.start_link(__MODULE__, initial_value)
  end

  def init(initial_value) do
    {:ok, initial_value}
  end

  def handle_call(:divide_by_zero, _from, state) do
    # This will crash the process
    result = state / 0
    {:reply, result, state}
  end
end

defmodule CalculatorSupervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      %{
        id: Calculator,
        start: {Calculator, :start_link, [10]},
        restart: :permanent,
        shutdown: 5000,
        type: :worker
      }
    ]

    # Supervisor options
    # :one_for_one - if a child crashes, only that child is restarted
    # :rest_for_one - if a child crashes, that child and all children after it are restarted
    # :one_for_all - if a child crashes, all children are restarted
    Supervisor.init(children, strategy: :one_for_one)
  end

  def run do
    # Start the supervision tree
    {:ok, sup_pid} = CalculatorSupervisor.start_link([])
    IO.puts("Supervisor started with PID: #{inspect(sup_pid)}")

    # Get the child pid
    [{_id, child_pid, _type, _modules}] = Supervisor.which_children(CalculatorSupervisor)
    IO.puts("Child started with PID: #{inspect(child_pid)}")

    # Instead of using try-catch, we'll spawn a separate process to make the call
    spawn(fn ->
      # This process can crash without affecting our main process
      GenServer.call(child_pid, :divide_by_zero)
    end)

    # Wait a moment for the supervisor to restart the worker
    :timer.sleep(100)

    # Check the new child pid
    [{_id, new_child_pid, _type, _modules}] = Supervisor.which_children(CalculatorSupervisor)
    IO.puts("New child PID after restart: #{inspect(new_child_pid)}")

    # Print whether the child was actually restarted
    IO.puts("Was child restarted? #{child_pid != new_child_pid}")
  end
end

CalculatorSupervisor.run()
