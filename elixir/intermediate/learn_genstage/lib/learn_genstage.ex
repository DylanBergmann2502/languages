defmodule LearnGenStage do
  @moduledoc """
  Learning GenStage - a specification for exchanging events between producers and consumers
  """

  def run do
    # Start the supervisor which will start all our GenStage processes
    {:ok, _pid} = LearnGenStage.AppSupervisor.start_link()

    # Allow processes to run for a while
    Process.sleep(10000)
  end

  defmodule Producer do
    use GenStage

    def start_link(initial_state) do
      GenStage.start_link(__MODULE__, initial_state, name: __MODULE__)
    end

    def init(counter) do
      {:producer, counter}
    end

    def handle_demand(demand, counter) when demand > 0 do
      # Generate events based on demand
      events = Enum.map(counter..(counter + demand - 1), & &1)

      # Update the counter for next time
      new_counter = counter + demand

      # Return events and new state
      {:noreply, events, new_counter}
    end
  end

  defmodule ProducerConsumer do
    use GenStage

    def start_link(_initial) do
      GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
    end

    def init(:ok) do
      # Subscribe to the producer
      {:producer_consumer, :ok, subscribe_to: [{LearnGenStage.Producer, max_demand: 10}]}
    end

    def handle_events(events, _from, state) do
      # Transform events (filter only even numbers)
      filtered_events = Enum.filter(events, fn event -> rem(event, 2) == 0 end)

      # Return transformed events
      {:noreply, filtered_events, state}
    end
  end

  defmodule Consumer do
    use GenStage

    def start_link(_initial) do
      GenStage.start_link(__MODULE__, :ok)
    end

    def init(:ok) do
      # Subscribe to the producer-consumer
      {:consumer, :ok, subscribe_to: [{LearnGenStage.ProducerConsumer, max_demand: 5}]}
    end

    def handle_events(events, _from, state) do
      # Process events
      Process.sleep(1000) # Simulate work

      # Print the events
      IO.inspect(events, label: "Received events", charlists: :as_lists)

      # Consumers don't emit events
      {:noreply, [], state}
    end
  end
end

# Define supervisor outside the LearnGenStage module to avoid naming conflict
defmodule LearnGenStage.AppSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      {LearnGenStage.Producer, 0},
      {LearnGenStage.ProducerConsumer, []},
      # Give unique IDs to each consumer
      Supervisor.child_spec({LearnGenStage.Consumer, []}, id: :consumer_1),
      Supervisor.child_spec({LearnGenStage.Consumer, []}, id: :consumer_2)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
