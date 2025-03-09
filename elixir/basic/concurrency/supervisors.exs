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

defmodule CalculatorDynamicSupervisor do
  # Regular Supervisor:
  # - Children are defined at startup in the init/1 callback
  # DynamicSupervisor:
  # - Starts with no children, and you add them dynamically as needed

  # Use DynamicSupervisor instead of Supervisor
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    # We only specify supervisor options (no children)
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # Function to dynamically start a calculator
  def start_calculator(initial_value) do
    # Define the child specification
    child_spec = %{
      id: Calculator,
      start: {Calculator, :start_link, [initial_value]},
      restart: :permanent,
      shutdown: 5000
    }

    # Start the child under the dynamic supervisor
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def run do
    IO.puts("###########################################################")

    # Start the dynamic supervisor
    {:ok, sup_pid} = CalculatorDynamicSupervisor.start_link([])
    IO.puts("Dynamic Supervisor started with PID: #{inspect(sup_pid)}")

    # No children initially
    IO.puts("Initial child count: #{DynamicSupervisor.count_children(CalculatorDynamicSupervisor).active}")

    # Dynamically start some calculators
    {:ok, calc1_pid} = start_calculator(10)
    {:ok, calc2_pid} = start_calculator(20)

    IO.puts("Calculator 1 started with PID: #{inspect(calc1_pid)}")
    IO.puts("Calculator 2 started with PID: #{inspect(calc2_pid)}")
    IO.puts("Child count after adding: #{DynamicSupervisor.count_children(CalculatorDynamicSupervisor).active}")

    # Crash one of the calculators
    spawn(fn ->
      GenServer.call(calc1_pid, :divide_by_zero)
    end)

    # Wait a moment for restart
    :timer.sleep(100)

    # Check if restarted
    current_children = DynamicSupervisor.which_children(CalculatorDynamicSupervisor)
    IO.puts("Children after crash: #{inspect(current_children)}")
    IO.puts("Child count after crash: #{DynamicSupervisor.count_children(CalculatorDynamicSupervisor).active}")
  end
end

defmodule CalculatorPartitionSupervisor do
  # The PartitionSupervisor in Elixir is designed to
  # solve scalability challenges when you need to
  # manage a large number of dynamic processes.
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      {PartitionSupervisor,
       child_spec: DynamicSupervisor,  # Each partition is a DynamicSupervisor
       name: CalculatorPartitions,
       partitions: System.schedulers_online() * 2}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  # Function to start a calculator in a specific partition
  def start_calculator(initial_value, partition_key \\ nil) do
    # If no partition key provided, use a random value
    key = partition_key || :rand.uniform(1000)

    # Child spec for the calculator
    child_spec = %{
      id: Calculator,
      start: {Calculator, :start_link, [initial_value]},
      restart: :permanent
    }

    # Use via tuple to route through PartitionSupervisor to a DynamicSupervisor partition
    DynamicSupervisor.start_child(
      {:via, PartitionSupervisor, {CalculatorPartitions, key}},
      child_spec
    )
  end

  def run do
    IO.puts("###########################################################")

    # Start the top-level supervisor
    {:ok, sup_pid} = CalculatorPartitionSupervisor.start_link([])
    IO.puts("Partition Supervisor started with PID: #{inspect(sup_pid)}")

    # Get information about partitions
    partition_count = PartitionSupervisor.partitions(CalculatorPartitions)
    IO.puts("Number of partitions: #{partition_count}")

    # Start calculators across different partitions
    calculators = for i <- 1..10 do
      {:ok, pid} = start_calculator(i * 10, i)
      pid
    end

    IO.puts("Started #{length(calculators)} calculators")

    # Check distribution
    partition_info = PartitionSupervisor.which_children(CalculatorPartitions)

    for {partition_id, partition_pid, _, _} <- partition_info do
      # Each partition is a DynamicSupervisor
      child_count = DynamicSupervisor.count_children(partition_pid).active
      IO.puts("Partition #{partition_id} has #{child_count} children")
    end

    # Crash a calculator
    crash_pid = Enum.at(calculators, 3)
    IO.puts("Crashing calculator with PID: #{inspect(crash_pid)}")

    spawn(fn ->
      GenServer.call(crash_pid, :divide_by_zero)
    end)

    # Wait a moment for restart
    :timer.sleep(100)

    # Check partitions again
    IO.puts("\nAfter crash:")
    partition_info = PartitionSupervisor.which_children(CalculatorPartitions)

    for {partition_id, partition_pid, _, _} <- partition_info do
      child_count = DynamicSupervisor.count_children(partition_pid).active
      IO.puts("Partition #{partition_id} has #{child_count} children")
    end
  end
end

CalculatorSupervisor.run()
CalculatorDynamicSupervisor.run()
CalculatorPartitionSupervisor.run()
