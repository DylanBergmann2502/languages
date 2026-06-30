defmodule LearnGenStatem do
  @moduledoc """
  :gen_statem — Erlang's state machine behaviour (OTP built-in, no deps).

  gen_statem is GenServer's more powerful sibling. Where GenServer has
  one handle_call/handle_cast for all messages, gen_statem routes every
  event through the CURRENT STATE — different states handle the same
  message differently, and the compiler warns you about missed transitions.

  When to use gen_statem over GenServer:
    - You have distinct modes that change how messages are handled
      (locked/unlocked, connecting/connected/disconnected)
    - You have protocol parsers, connection managers, workflows
    - You need timer-driven state transitions
    - You want impossible states to be unrepresentable in code

  Two callback modes:
    :state_functions  — one function per state, very structured
    :handle_event_function — one function for all, more flexible

  No extra deps — it's in OTP.
  """

  def run do
    IO.puts("\n=== :gen_statem — OTP State Machines ===\n")

    coin_locker_demo()
    connection_fsm_demo()
    traffic_light_demo()
    advanced_features()
  end

  # -----------------------------------------------------------------------
  # 1. Classic example: coin-operated locker (:state_functions mode)
  # -----------------------------------------------------------------------
  defp coin_locker_demo do
    IO.puts("--- Coin-Operated Locker (:state_functions mode) ---")

    {:ok, locker} = CoinLocker.start_link([])

    IO.puts("State: #{CoinLocker.state(locker)}")        # :locked

    :ok = CoinLocker.insert_coin(locker)
    IO.puts("After coin: #{CoinLocker.state(locker)}")   # :unlocked

    :ok = CoinLocker.push(locker)
    IO.puts("After push: #{CoinLocker.state(locker)}")   # :locked

    # Push when locked — ignored
    :locked = CoinLocker.push(locker)
    IO.puts("Push locked: #{CoinLocker.state(locker)}")  # :locked

    GenServer.stop(locker)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Connection manager (:handle_event_function mode)
  # -----------------------------------------------------------------------
  defp connection_fsm_demo do
    IO.puts("--- Connection Manager (:handle_event_function mode) ---")

    {:ok, conn} = ConnectionManager.start_link(host: "localhost", port: 5432)

    IO.puts("Initial state: #{ConnectionManager.state(conn)}")  # :disconnected

    ConnectionManager.connect(conn)
    Process.sleep(50)
    IO.puts("After connect: #{ConnectionManager.state(conn)}")  # :connected

    ConnectionManager.send_query(conn, "SELECT 1")
    Process.sleep(50)

    ConnectionManager.disconnect(conn)
    Process.sleep(50)
    IO.puts("After disconnect: #{ConnectionManager.state(conn)}")  # :disconnected

    GenServer.stop(conn)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. Traffic light (timer-driven transitions)
  # -----------------------------------------------------------------------
  defp traffic_light_demo do
    IO.puts("--- Traffic Light (timer-driven transitions) ---")

    {:ok, light} = TrafficLight.start_link([])

    for _ <- 1..4 do
      IO.puts("Light: #{TrafficLight.current(light)}")
      Process.sleep(120)
    end

    GenServer.stop(light)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Advanced features explained
  # -----------------------------------------------------------------------
  defp advanced_features do
    IO.puts("--- Advanced Features ---")

    IO.puts("""
    ## Postpone events
    # Events that can't be handled in current state are queued and
    # re-delivered when the state changes. GenServer has no equivalent.
    {:keep_state, data, [{:postpone, true}]}

    ## Internal events
    # Fire an event to yourself without going through the mailbox:
    {:next_state, :processing, data, [{:next_event, :internal, :start_work}]}

    ## State timeout
    # Fires {:timeout, :state, :name} if state doesn't change in time:
    {:next_state, :connecting, data, [{:state_timeout, 5000, :give_up}]}

    def connecting(:state_timeout, :give_up, data) do
      {:next_state, :disconnected, %{data | error: :timeout}}
    end

    ## Event timeout
    # Resets on every event (like an inactivity timer):
    {:keep_state, data, [{:timeout, 30_000, :idle}]}

    ## Generic timeout
    # Named timer, independent of events:
    {:keep_state, data, [{{:timeout, :heartbeat}, 5000, :ping}]}

    ## :keep_state vs :next_state
    # :keep_state          — stay in same state, update data
    # :next_state          — transition to new state, update data
    # :keep_state_and_data — stay in same state, don't change data
    # :repeat_state        — re-enter current state (calls state_enter)

    ## State enter callbacks
    # Called when entering a state — great for setup/teardown:
    def callback_mode, do: [:state_functions, :state_enter]

    def locked(:enter, _old_state, data) do
      IO.puts("Entered locked state")
      {:keep_state, data}
    end

    ## gen_statem vs GenServer summary:
    # GenServer:   one process, messages dispatched by shape only
    # gen_statem:  one process, messages dispatched by shape AND current state
    #              impossible transitions = unreachable code paths
    """)
    IO.puts("")
  end
end

# ============================================================
# Example 1: Coin-operated locker — :state_functions mode
# ============================================================
# In :state_functions mode, each state is a function.
# callback_mode/0 returns :state_functions.
# Events are: {:call, from} | :cast | :info | :timeout | :internal
defmodule CoinLocker do
  @behaviour :gen_statem

  def start_link(opts), do: :gen_statem.start_link(__MODULE__, opts, [])

  def insert_coin(pid), do: :gen_statem.call(pid, :coin)
  def push(pid),        do: :gen_statem.call(pid, :push)
  def state(pid),       do: :gen_statem.call(pid, :state)

  @impl :gen_statem
  def callback_mode, do: :state_functions

  @impl :gen_statem
  def init(_opts) do
    # {initial_state, data}
    {:ok, :locked, %{coins: 0}}
  end

  # ---- State: :locked ----
  # Pattern: state_name(event_type, event_content, data)
  def locked({:call, from}, :coin, data) do
    # Transition to :unlocked, reply :ok to caller
    {:next_state, :unlocked, %{data | coins: data.coins + 1},
     [{:reply, from, :ok}]}
  end

  def locked({:call, from}, :push, data) do
    # Can't push when locked — stay in state, reply :locked
    {:keep_state, data, [{:reply, from, :locked}]}
  end

  def locked({:call, from}, :state, data) do
    {:keep_state, data, [{:reply, from, :locked}]}
  end

  # ---- State: :unlocked ----
  def unlocked({:call, from}, :push, data) do
    # Lock again after push
    {:next_state, :locked, data, [{:reply, from, :ok}]}
  end

  def unlocked({:call, from}, :coin, data) do
    # Extra coin — stay unlocked, collect it
    {:keep_state, %{data | coins: data.coins + 1}, [{:reply, from, :ok}]}
  end

  def unlocked({:call, from}, :state, data) do
    {:keep_state, data, [{:reply, from, :unlocked}]}
  end
end

# ============================================================
# Example 2: Connection manager — :handle_event_function mode
# ============================================================
# In :handle_event_function mode, one function handles all events.
# Good when states share lots of common event handling.
defmodule ConnectionManager do
  @behaviour :gen_statem

  def start_link(opts),    do: :gen_statem.start_link(__MODULE__, opts, [])
  def connect(pid),        do: :gen_statem.cast(pid, :connect)
  def disconnect(pid),     do: :gen_statem.cast(pid, :disconnect)
  def send_query(pid, q),  do: :gen_statem.cast(pid, {:query, q})
  def state(pid),          do: :gen_statem.call(pid, :state)

  @impl :gen_statem
  def callback_mode, do: :handle_event_function

  @impl :gen_statem
  def init(opts) do
    data = %{host: opts[:host], port: opts[:port], socket: nil, pending: []}
    {:ok, :disconnected, data}
  end

  # handle_event(event_type, event_content, current_state, data)
  @impl :gen_statem
  def handle_event(:cast, :connect, :disconnected, data) do
    # Simulate async connect
    IO.puts("  [Conn] Connecting to #{data.host}:#{data.port}...")
    Process.sleep(10)
    IO.puts("  [Conn] Connected.")
    {:next_state, :connected, %{data | socket: :fake_socket}}
  end

  def handle_event(:cast, :connect, :connected, data) do
    # Already connected — ignore
    {:keep_state, data}
  end

  def handle_event(:cast, {:query, q}, :connected, data) do
    IO.puts("  [Conn] Executing: #{q}")
    {:keep_state, data}
  end

  def handle_event(:cast, {:query, q}, :disconnected, data) do
    # Queue query for when we reconnect
    IO.puts("  [Conn] Queuing query (disconnected): #{q}")
    {:keep_state, %{data | pending: [q | data.pending]}}
  end

  def handle_event(:cast, :disconnect, :connected, data) do
    IO.puts("  [Conn] Disconnecting.")
    {:next_state, :disconnected, %{data | socket: nil}}
  end

  def handle_event(:cast, :disconnect, :disconnected, data) do
    {:keep_state, data}
  end

  def handle_event({:call, from}, :state, state, data) do
    {:keep_state, data, [{:reply, from, state}]}
  end

  # Catch-all — ignore unknown events in any state
  def handle_event(_type, _event, _state, data) do
    {:keep_state, data}
  end
end

# ============================================================
# Example 3: Traffic light — timer-driven state transitions
# ============================================================
defmodule TrafficLight do
  @behaviour :gen_statem

  # Durations in ms (short for demo)
  @green_ms  100
  @yellow_ms  50
  @red_ms    100

  def start_link(opts), do: :gen_statem.start_link(__MODULE__, opts, [])
  def current(pid),     do: :gen_statem.call(pid, :current)

  @impl :gen_statem
  # :state_enter causes the state function to be called with :enter
  # when entering each state — perfect for starting timers
  def callback_mode, do: [:state_functions, :state_enter]

  @impl :gen_statem
  def init(_opts), do: {:ok, :green, %{}}

  # ---- :green ----
  def green(:enter, _old, data) do
    # State timeout: if still :green after @green_ms, fire :timeout
    {:keep_state, data, [{:state_timeout, @green_ms, :change}]}
  end

  def green(:state_timeout, :change, data) do
    {:next_state, :yellow, data}
  end

  def green({:call, from}, :current, data) do
    {:keep_state, data, [{:reply, from, :green}]}
  end

  # ---- :yellow ----
  def yellow(:enter, _old, data) do
    {:keep_state, data, [{:state_timeout, @yellow_ms, :change}]}
  end

  def yellow(:state_timeout, :change, data) do
    {:next_state, :red, data}
  end

  def yellow({:call, from}, :current, data) do
    {:keep_state, data, [{:reply, from, :yellow}]}
  end

  # ---- :red ----
  def red(:enter, _old, data) do
    {:keep_state, data, [{:state_timeout, @red_ms, :change}]}
  end

  def red(:state_timeout, :change, data) do
    {:next_state, :green, data}
  end

  def red({:call, from}, :current, data) do
    {:keep_state, data, [{:reply, from, :red}]}
  end
end
