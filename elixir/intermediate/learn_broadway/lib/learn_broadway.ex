defmodule LearnBroadway do
  @moduledoc """
  Learning Broadway - a concurrent and multi-stage data ingestion and processing framework
  """

  def run do
    # Start our Broadway pipeline
    {:ok, _pid} = LearnBroadway.Pipeline.start_link()

    # Send some test messages to the pipeline
    for i <- 1..20 do
      message = "Message #{i}"
      LearnBroadway.MessageProducer.push(message)
      Process.sleep(500) # Space out the messages a bit
    end

    # Let the pipeline process all messages
    Process.sleep(5000)
  end

  defmodule MessageProducer do
    @moduledoc """
    A simple message producer that stores messages in memory
    and delivers them to subscribers on demand
    """
    use GenServer

    def start_link(_opts) do
      GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
    end

    def init(:ok) do
      {:ok, %{messages: [], subscribers: []}}
    end

    # Client API to push messages to the producer
    def push(message) do
      GenServer.cast(__MODULE__, {:push, message})
    end

    # Broadway's acknowledgement callback
    def ack(_ack_ref, successful, failed) do
      # Log the results
      unless Enum.empty?(successful) do
        IO.puts("Successfully processed messages: #{inspect(Enum.map(successful, & &1.data))}")
      end

      unless Enum.empty?(failed) do
        IO.puts("Failed messages: #{inspect(Enum.map(failed, & &1.data))}")
      end
    end

    # Handle messages
    def handle_cast({:push, message}, %{messages: messages, subscribers: subs} = state) do
      # If we have subscribers waiting, immediately deliver the new message
      case subs do
        [] ->
          {:noreply, %{state | messages: messages ++ [message]}}

        [subscriber | rest] ->
          send(subscriber, {:messages, [message]})
          {:noreply, %{state | subscribers: rest}}
      end
    end

    # Subscriber demand
    def handle_info({:get_messages, count, subscriber}, %{messages: messages} = state) do
      {messages_to_send, remaining} = Enum.split(messages, count)

      unless Enum.empty?(messages_to_send) do
        send(subscriber, {:messages, messages_to_send})
      end

      subscribers =
        if Enum.empty?(messages_to_send) do
          # If we didn't have enough messages, store the subscriber for later
          [subscriber | state.subscribers]
        else
          state.subscribers
        end

      {:noreply, %{state | messages: remaining, subscribers: subscribers}}
    end
  end

  defmodule BroadwayMessageProducer do
    @moduledoc """
    Custom producer that connects our MessageProducer to Broadway
    """
    use GenStage

    def start_link(opts) do
      GenStage.start_link(__MODULE__, opts)
    end

    def init(_opts) do
      # Start the message producer
      {:ok, _pid} = LearnBroadway.MessageProducer.start_link([])

      # Use a simple reference as the ack_ref
      ack_ref = make_ref()

      {:producer, %{ack_ref: ack_ref, demand: 0}}
    end

    # Handle demand from Broadway
    def handle_demand(incoming_demand, %{demand: demand} = state) do
      new_demand = demand + incoming_demand
      request_messages(new_demand)
      {:noreply, [], %{state | demand: new_demand}}
    end

    # Handle messages from MessageProducer
    def handle_info({:messages, messages}, %{demand: demand, ack_ref: ack_ref} = state) do
      # Convert raw messages to Broadway messages
      broadway_messages = Enum.map(messages, fn msg ->
        %Broadway.Message{
          data: msg,
          metadata: %{},
          acknowledger: {LearnBroadway.MessageProducer, ack_ref, :ok}
        }
      end)

      new_demand = demand - length(messages)

      # If we still have demand, request more messages
      if new_demand > 0 do
        request_messages(new_demand)
      end

      {:noreply, broadway_messages, %{state | demand: new_demand}}
    end

    defp request_messages(demand) when demand > 0 do
      send(LearnBroadway.MessageProducer, {:get_messages, demand, self()})
    end
  end

  defmodule Pipeline do
    @moduledoc """
    A Broadway pipeline that processes messages
    """
    use Broadway

    def start_link(_opts \\ []) do
      Broadway.start_link(__MODULE__,
        name: __MODULE__,
        producer: [
          module: {
            LearnBroadway.BroadwayMessageProducer,
            []  # We'll use make_ref() inside the producer
          },
          concurrency: 1
        ],
        processors: [
          default: [
            concurrency: 2
          ]
        ],
        batchers: [
          odd: [
            batch_size: 5,
            batch_timeout: 1000,
            concurrency: 1
          ],
          even: [
            batch_size: 5,
            batch_timeout: 1000,
            concurrency: 1
          ]
        ]
      )
    end

    # Process individual messages
    @impl Broadway
    def handle_message(:default, message, _context) do
      # Extract the message data
      data = message.data

      # Simulate some processing
      Process.sleep(100)

      # Determine if the message should go to the odd or even batcher
      # based on the message number
      number =
        case Regex.run(~r/Message (\d+)/, data) do
          [_, num] -> String.to_integer(num)
          _ -> 0
        end

      batcher = if rem(number, 2) == 0, do: :even, else: :odd

      # Add some processing result to the message
      message =
        message
        |> Broadway.Message.update_data(fn data ->
          "Processed: #{data} (#{if batcher == :even, do: "even", else: "odd"})"
        end)
        |> Broadway.Message.put_batcher(batcher)

      IO.puts("Processed message: #{inspect(message.data)}")

      message
    end

    # Handle batches of even messages
    @impl Broadway
    def handle_batch(:even, messages, _batch_info, _context) do
      IO.puts("\n--- Batch of EVEN messages processed ---")
      Enum.each(messages, &IO.inspect(&1.data))
      IO.puts("-------------------------------------\n")
      messages
    end

    # Handle batches of odd messages
    @impl Broadway
    def handle_batch(:odd, messages, _batch_info, _context) do
      IO.puts("\n--- Batch of ODD messages processed ---")
      Enum.each(messages, &IO.inspect(&1.data))
      IO.puts("-------------------------------------\n")
      messages
    end
  end
end
