defmodule CounterGenServer do
  use GenServer

  # Client API: These are the functions that other processes will call
  # Server Callbacks: These are the functions that handle the actual messages

  # There are three types of interactions:
  # `start_link/1`: Initializes the GenServer
  # `cast`: For asynchronous messages (fire and forget)
  # `call`: For synchronous messages (wait for response)

  # The callbacks follow specific patterns:

  # ``init/1`: Returns `{:ok, state}`
  # `handle_cast/2`: Returns `{:noreply, new_state}`
  # `handle_call/3`: Returns `{:reply, response, new_state}`

  # Client API
  # ---------

  def start_link(initial_count) do
    # Starts the GenServer process and links it to the current process
    GenServer.start_link(__MODULE__, initial_count, name: __MODULE__)
  end

  def increment do
    # Sends a message to increment the counter
    GenServer.cast(__MODULE__, :increment)
  end

  def decrement do
    # Sends a message to decrement the counter
    GenServer.cast(__MODULE__, :decrement)
  end

  def get_count do
    # Sends a synchronous message to get the current count
    GenServer.call(__MODULE__, :get_count)
  end

  # Server Callbacks
  # --------------

  @impl true
  def init(initial_count) do
    # Initialize the server state
    {:ok, initial_count}
  end

  # Casts are asynchronous: the server won't
  # send a response back and therefore
  # the client won't wait for one.
  @impl true
  def handle_cast(:increment, count) do
    # Handle asynchronous increment message
    {:noreply, count + 1}
  end

  @impl true
  def handle_cast(:decrement, count) do
    # Handle asynchronous decrement message
    {:noreply, count - 1}
  end

  # Calls are synchronous and the server must
  # send a response back to such requests.
  # While the server computes the response, the client is waiting.
  @impl true
  def handle_call(:get_count, _from, count) do
    # Handle synchronous get_count message
    {:reply, count, count}
  end

  def run do
    # Let's try it out
    CounterGenServer.start_link(0)
    CounterGenServer.increment()
    CounterGenServer.increment()
    CounterGenServer.decrement()
    IO.inspect(CounterGenServer.get_count())  # 1
  end
end

CounterGenServer.run()

####################################################33
# Compared to `Agent`

defmodule CounterAgent do
  # Notice how the Agent implementation is much simpler
  # this highlights a key principle in Elixir:
  # Agents are designed for simple state storage and retrieval,
  # while GenServers handle more complex scenarios.

  # Start the Agent with an initial count
  def start_link(initial_count) do
    # Agent.start_link takes an anonymous function that returns the initial state
    Agent.start_link(fn -> initial_count end, name: __MODULE__)
  end

  # Increment counter asynchronously
  def increment do
    # Agent.update modifies state without waiting for the result
    # The function passed to update receives the current state and returns new state
    Agent.update(__MODULE__, fn count -> count + 1 end)
  end

  # Decrement counter asynchronously
  def decrement do
    Agent.update(__MODULE__, fn count -> count - 1 end)
  end

  # Get current count synchronously
  def get_count do
    # Agent.get retrieves the current state
    # The function passed to get can transform the state before returning
    Agent.get(__MODULE__, fn count -> count end)
  end

  def run do
    # Let's try it out, just like we did with GenServer
    CounterAgent.start_link(0)
    CounterAgent.increment()
    CounterAgent.increment()
    CounterAgent.decrement()
    IO.inspect(CounterAgent.get_count())  # 1
  end
end

CounterAgent.run()

###########################################################
# Something that `Agent` cannot do

defmodule JobProcessor do
  use GenServer
  require Logger

  # Client API
  # ---------

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{jobs: %{}}, name: __MODULE__)
  end

  def submit_job(job_id, work_fn) do
    GenServer.cast(__MODULE__, {:submit_job, job_id, work_fn})
  end

  def get_job_status(job_id) do
    GenServer.call(__MODULE__, {:get_status, job_id})
  end

  # Server Callbacks
  # --------------

  @impl true
  def init(state) do
    # Schedule periodic cleanup of completed jobs
    schedule_cleanup()
    {:ok, state}
  end

  @impl true
  def handle_cast({:submit_job, job_id, work_fn}, state) do
    # Start the job in a separate process
    Process.spawn(
      fn ->
        # Send the result back to GenServer after completion or timeout
        try do
          result = work_fn.()
          GenServer.cast(__MODULE__, {:job_completed, job_id, result})
        rescue
          error ->
            GenServer.cast(__MODULE__, {:job_failed, job_id, error})
        end
      end,
      []
    )

    # Update state to track the new job
    new_state = put_in(state, [:jobs, job_id], %{
      status: :running,
      started_at: DateTime.utc_now()
    })

    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:job_completed, job_id, result}, state) do
    new_state = put_in(state, [:jobs, job_id], %{
      status: :completed,
      result: result,
      completed_at: DateTime.utc_now()
    })
    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:job_failed, job_id, error}, state) do
    new_state = put_in(state, [:jobs, job_id], %{
      status: :failed,
      error: error,
      failed_at: DateTime.utc_now()
    })
    {:noreply, new_state}
  end

  @impl true
  def handle_call({:get_status, job_id}, _from, state) do
    job = get_in(state, [:jobs, job_id])
    {:reply, job, state}
  end

  @impl true
  def handle_info(:cleanup, state) do
    # Remove jobs older than 1 hour
    now = DateTime.utc_now()

    cleaned_jobs = Enum.filter(state.jobs, fn {_id, job} ->
      case job do
        %{completed_at: completed_at} ->
          DateTime.diff(now, completed_at, :second) < 3600
        %{failed_at: failed_at} ->
          DateTime.diff(now, failed_at, :second) < 3600
        _ -> true
      end
    end) |> Map.new()

    schedule_cleanup()
    {:noreply, %{state | jobs: cleaned_jobs}}
  end

  defp schedule_cleanup do
    Process.send_after(self(), :cleanup, :timer.minutes(5))
  end

  def run do
    # Let's try it out with some example jobs
    JobProcessor.start_link([])

    # Submit a successful job
    JobProcessor.submit_job("job1", fn ->
      Process.sleep(1000)  # Simulate work
      "Success!"
    end)

    # Submit a failing job
    JobProcessor.submit_job("job2", fn ->
      Process.sleep(500)
      raise "Something went wrong"
    end)

    # Wait a bit for jobs to process
    Process.sleep(2000)

    # Check statuses
    IO.inspect(JobProcessor.get_job_status("job1"))
    # %{status: :completed, result: "Success!", completed_at: ~U[2024-01-25 ...]}

    IO.inspect(JobProcessor.get_job_status("job2"))
    # %{status: :failed, error: %RuntimeError{message: "Something went wrong"}, failed_at: ~U[2024-01-25 ...]}
  end
end

JobProcessor.run()
