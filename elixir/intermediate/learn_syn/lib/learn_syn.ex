defmodule LearnSyn do
  @moduledoc """
  Syn v3.4 — global process registry and pub/sub across a cluster.

  Syn is an Erlang library (used via :syn atoms). It wraps Erlang's :pg
  internally but adds per-scope namespacing, metadata, event callbacks,
  and a cleaner registry API.

  Key concepts:
    - Scope    : a named namespace (atom). Each scope is independent.
    - Registry : map name → {pid, meta}. Names are unique per scope.
    - Groups   : map group_name → [{pid, meta}]. Multiple members allowed.

  Setup in mix.exs:
    {:syn, "~> 3.4"}

  In application/0:
    extra_applications: [:syn]
  """

  require Logger

  def run do
    IO.puts("\n=== Syn: Global Process Registry & PubSub ===\n")

    registry_basics()
    via_tuple_demo()
    process_groups()
    pub_sub()
    metadata_and_updates()
  end

  # -----------------------------------------------------------------------
  # 1. Registry basics
  # -----------------------------------------------------------------------
  defp registry_basics do
    IO.puts("--- Registry Basics ---")

    scope = :devices

    # Register the current process under a name in a scope.
    # register(Scope, Name, Pid) or register(Scope, Name, Pid, Meta)
    :ok = :syn.register(scope, "device:001", self(), %{type: :sensor, location: "room_1"})

    # lookup(Scope, Name) → {pid, meta} | :undefined
    case :syn.lookup(scope, "device:001") do
      {pid, meta} ->
        IO.puts("Found device:001 → pid=#{inspect(pid)}, meta=#{inspect(meta)}")
      :undefined ->
        IO.puts("Not found")
    end

    # Count registrations in a scope
    count = :syn.registry_count(scope)
    IO.puts("Registered in :devices scope: #{count}")

    # update_registry/3 atomically updates metadata
    :syn.update_registry(scope, "device:001", fn {pid, old_meta} ->
      {pid, Map.put(old_meta, :status, :online)}
    end)

    {_pid, updated_meta} = :syn.lookup(scope, "device:001")
    IO.puts("Updated meta: #{inspect(updated_meta)}")

    # Unregister
    :ok = :syn.unregister(scope, "device:001")
    IO.puts("Unregistered. lookup now: #{inspect(:syn.lookup(scope, "device:001"))}")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Via-tuple — use Syn as a GenServer name registry
  # -----------------------------------------------------------------------
  defp via_tuple_demo do
    IO.puts("--- Via-Tuple (GenServer naming via Syn) ---")

    # Start a named GenServer using Syn as the registry.
    # Via-tuple format: {:via, :syn, {Scope, Name}}
    #                or {:via, :syn, {Scope, Name, Meta}}
    {:ok, _pid} = GenServer.start_link(
      DemoWorker,
      %{value: 0},
      name: {:via, :syn, {:workers, "worker:1"}}
    )

    # Call it by via-tuple — Syn resolves the name to the pid
    val = GenServer.call({:via, :syn, {:workers, "worker:1"}}, :get)
    IO.puts("Worker value via via-tuple: #{val}")

    GenServer.cast({:via, :syn, {:workers, "worker:1"}}, {:set, 42})
    val2 = GenServer.call({:via, :syn, {:workers, "worker:1"}}, :get)
    IO.puts("Worker value after cast: #{val2}")

    # Look up the pid directly
    {pid, _meta} = :syn.lookup(:workers, "worker:1")
    IO.puts("Pid from Syn registry: #{inspect(pid)}")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. Process Groups
  # -----------------------------------------------------------------------
  defp process_groups do
    IO.puts("--- Process Groups ---")

    scope   = :chat
    room    = "room:general"

    # Spawn a few fake processes to join a group
    pids = for i <- 1..3 do
      spawn(fn -> Process.sleep(:infinity) end)
      |> tap(fn pid ->
        :ok = :syn.join(scope, room, pid, %{username: "user_#{i}"})
      end)
    end

    # members(Scope, GroupName) → [{pid, meta}]
    members = :syn.members(scope, room)
    IO.puts("Members of #{room}:")
    Enum.each(members, fn {pid, meta} ->
      IO.puts("  #{inspect(pid)} → #{inspect(meta)}")
    end)

    # is_member/3
    first_pid = hd(pids)
    IO.puts("First pid is member? #{:syn.is_member(scope, room, first_pid)}")

    # Update a member's metadata atomically
    :syn.update_member(scope, room, first_pid, fn {pid, old_meta} ->
      {pid, Map.put(old_meta, :role, :moderator)}
    end)
    {_pid, updated} = :syn.member(scope, room, first_pid)
    IO.puts("Updated member meta: #{inspect(updated)}")

    # Leave
    :ok = :syn.leave(scope, room, first_pid)
    IO.puts("After leave, member count: #{length(:syn.members(scope, room))}")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Pub/Sub via publish
  # -----------------------------------------------------------------------
  defp pub_sub do
    IO.puts("--- Pub/Sub via publish ---")

    scope = :events
    topic = :temperature_updates

    # Self subscribes as a group member (this process is the "subscriber")
    :ok = :syn.join(scope, topic, self(), %{subscriber: true})

    # publish/3 sends message to all group members globally
    :syn.publish(scope, topic, {:temp_reading, 23.5, "sensor_A"})

    receive do
      {:temp_reading, temp, sensor} ->
        IO.puts("Received temp reading: #{temp}°C from #{sensor}")
    after
      1000 -> IO.puts("No message received")
    end

    # local_publish/3 — same but only to members on THIS node
    :syn.local_publish(scope, topic, {:temp_reading, 24.0, "sensor_B"})

    receive do
      {:temp_reading, temp, sensor} ->
        IO.puts("Local reading: #{temp}°C from #{sensor}")
    after
      1000 -> IO.puts("No local message received")
    end

    :syn.leave(scope, topic, self())
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Metadata patterns
  # -----------------------------------------------------------------------
  defp metadata_and_updates do
    IO.puts("--- Metadata & Atomic Updates ---")

    scope = :sessions

    # Register with rich metadata
    :ok = :syn.register(scope, "session:abc123", self(), %{
      user_id: 42,
      connected_at: DateTime.utc_now(),
      permissions: [:read, :write]
    })

    # Atomic metadata update (CAS-style, runs on the node owning the name)
    :syn.update_registry(scope, "session:abc123", fn {pid, meta} ->
      {pid, Map.update!(meta, :permissions, &[:admin | &1])}
    end)

    {_pid, final_meta} = :syn.lookup(scope, "session:abc123")
    IO.puts("Final permissions: #{inspect(final_meta.permissions)}")

    # Cluster-level count (useful for monitoring)
    IO.puts("Total sessions: #{:syn.registry_count(scope)}")

    :syn.unregister(scope, "session:abc123")
    IO.puts("")
  end
end

# A minimal GenServer used in the via-tuple demo
defmodule DemoWorker do
  use GenServer

  def init(state), do: {:ok, state}

  def handle_call(:get, _from, %{value: v} = state), do: {:reply, v, state}
  def handle_cast({:set, v}, state), do: {:noreply, %{state | value: v}}
end
