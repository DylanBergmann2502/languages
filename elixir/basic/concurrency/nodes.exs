# Distributed Elixir: connecting multiple BEAM nodes.
# Nodes are separate OS processes (possibly on different machines)
# that can communicate as if they were one system.
# This is one of Elixir/Erlang's defining strengths.

# NOTE: To actually connect nodes, you must start elixir with a name:
#   iex --sname alice
#   iex --sname bob
# Then connect them with Node.connect(:bob@hostname)

# This file teaches the concepts and APIs; the live demo section
# at the bottom only works when run as a named node.

################################################################
# Node identity

# The current node's name
IO.inspect(Node.self())
# :nonode@nohost when run without --sname/--name
# :alice@mymachine when started with --sname alice

# Check if the node is alive (has a name and can connect to others)
IO.inspect(Node.alive?()) # false when run as plain script

################################################################
# Connecting nodes

# Node.connect/1 - establish a connection to another node
# Returns true on success, false on failure, :ignored if not alive.
# result = Node.connect(:"bob@192.168.1.2")

# Node.disconnect/1 - disconnect a node
# Node.disconnect(:"bob@192.168.1.2")

# Node.list/0 - list all connected nodes (not including self)
IO.inspect(Node.list()) # [] when not connected to anything

# Node.list(:connected) - only fully connected nodes (same as Node.list())
# Node.list(:visible)   - connected + hidden nodes
# Node.list(:hidden)    - hidden nodes only (used for monitoring tools)

################################################################
# Sending messages to processes on other nodes

# send/2 works with {registered_name, node} tuples:
# send({:some_server, :"bob@host"}, :hello)

# spawn/2 and spawn/4 work across nodes:
# pid = Node.spawn(:"bob@host", fn -> IO.puts("running on bob!") end)
# pid = Node.spawn(:"bob@host", Module, :function, [args])

################################################################
# Remote procedure calls

# :rpc.call/4 - synchronous remote call (blocks until result)
# result = :rpc.call(:"bob@host", String, :upcase, ["hello"])
# # => "HELLO"

# :rpc.cast/4 - async remote call (fire and forget)
# :rpc.cast(:"bob@host", IO, :puts, ["hello from alice"])

# :rpc.multicall/4 - call all connected nodes at once
# {results, bad_nodes} = :rpc.multicall(String, :upcase, ["hello"])

################################################################
# Process registration across nodes

# Register a process globally (visible across all nodes)
# :global.register_name(:my_server, self())
# pid = :global.whereis_name(:my_server)
# send(pid, :hello)

# Elixir's Registry is node-local. For distributed registry use :global or
# the `syn` or `horde` libraries.

################################################################
# Node monitoring

# Monitor a node - receive {:nodedown, node} when it goes away
# Node.monitor(:"bob@host", true)
# receive do
#   {:nodedown, node} -> IO.puts("#{node} went down")
# end

# You can also use :net_kernel.monitor_nodes/1
# :net_kernel.monitor_nodes(true)
# receive do
#   {:nodeup, node}   -> IO.puts("#{node} connected")
#   {:nodedown, node} -> IO.puts("#{node} disconnected")
# end

################################################################
# Node cookies - security

# Nodes only connect to each other if they share the same "magic cookie".
# The cookie is a secret atom.
IO.inspect(Node.get_cookie())  # :"some-atom" (your system default)
# Node.set_cookie(:"my-secret-cookie")

################################################################
# Practical: distributed counter simulation

defmodule DistributedConcepts do
  def explain do
    IO.puts("""
    How distributed Elixir works:

    1. Start nodes with names:
       Terminal 1:  iex --sname alice
       Terminal 2:  iex --sname bob

    2. Connect from alice's iex:
       Node.connect(:"bob@your-hostname")
       Node.list()  # => [:"bob@your-hostname"]

    3. Send messages to bob's registered processes:
       send({:my_server, :"bob@your-hostname"}, {:hello, self()})

    4. Spawn work on bob from alice:
       Node.spawn(:"bob@your-hostname", fn ->
         result = expensive_computation()
         send(caller_pid, result)
       end)

    5. Remote procedure call:
       :rpc.call(:"bob@your-hostname", MyModule, :my_function, [args])

    Key facts:
    - PIDs are globally unique across nodes (they encode node info)
    - All Elixir data types are transparently serialized across nodes
    - Links and monitors work across nodes
    - GenServers can be registered globally with :global.register_name/2
    - The BEAM handles reconnection, but your app must handle :nodedown
    """)
  end
end

DistributedConcepts.explain()

################################################################
# Local simulation: multiple processes acting like "nodes"

defmodule FakeCluster do
  # Simulates what a distributed GenServer might look like.
  # In production, each node would run one of these.

  def start do
    # In real distributed Elixir, each node runs one coordinator.
    # Here we simulate with processes.
    coordinator = spawn(fn -> coordinator_loop(%{}) end)
    Process.register(coordinator, :coordinator)
    IO.puts("Coordinator started: #{inspect(coordinator)}")
    coordinator
  end

  defp coordinator_loop(state) do
    receive do
      {:store, key, value, from} ->
        send(from, :ok)
        coordinator_loop(Map.put(state, key, value))

      {:fetch, key, from} ->
        send(from, Map.get(state, key))
        coordinator_loop(state)

      :stop ->
        IO.puts("Coordinator stopping")
    end
  end

  def store(key, value) do
    send(:coordinator, {:store, key, value, self()})
    receive do :ok -> :ok end
  end

  def fetch(key) do
    send(:coordinator, {:fetch, key, self()})
    receive do value -> value end
  end
end

FakeCluster.start()
FakeCluster.store(:greeting, "hello distributed world")
IO.inspect(FakeCluster.fetch(:greeting)) # "hello distributed world"
send(:coordinator, :stop)
