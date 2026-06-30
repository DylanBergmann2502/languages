defmodule LearnLibcluster do
  @moduledoc """
  libcluster v3.5 — automatic Erlang cluster formation.

  libcluster discovers and connects BEAM nodes automatically.
  Without it: manually call Node.connect/1 on every node.
  With it: configure a strategy, nodes find each other.

  Built-in strategies:
    Cluster.Strategy.Epmd           — static host list via epmd
    Cluster.Strategy.LocalEpmd      — discover nodes on local machine
    Cluster.Strategy.Gossip         — UDP multicast (LAN/Docker)
    Cluster.Strategy.Kubernetes.DNS — K8s headless service DNS (most common)
    Cluster.Strategy.Kubernetes     — K8s metadata API + label selectors

  dep: {:libcluster, "~> 3.5"}

  Real clustering requires multiple named nodes:
    iex --sname node1 -S mix
    iex --sname node2 -S mix
  """

  def run do
    IO.puts("\n=== libcluster: Automatic Node Discovery ===\n")

    node_fundamentals()
    cluster_supervisor_demo()
    node_watcher_demo()
    strategy_guide()
    config_reference()
  end

  # -----------------------------------------------------------------------
  # 1. Node fundamentals — what libcluster builds on top of
  # -----------------------------------------------------------------------
  defp node_fundamentals do
    IO.puts("--- Node Fundamentals ---")

    IO.puts("Self:            #{Node.self()}")
    IO.puts("Alive?           #{Node.alive?()}")
    IO.puts("Connected nodes: #{inspect(Node.list())}")
    IO.puts("All nodes:       #{inspect([Node.self() | Node.list()])}")

    # Node.connect/1 is what libcluster calls automatically
    # In a real cluster: Node.connect(:"other@host") returns true/false
    IO.puts("Node.connect returns: #{Node.connect(Node.self())}")  # connecting to self = true

    # :net_kernel.monitor_nodes/2 — what NodeWatcher uses
    # We subscribe, then immediately unsubscribe to show the API
    :net_kernel.monitor_nodes(true, [node_type: :all])
    :net_kernel.monitor_nodes(false)
    IO.puts("net_kernel.monitor_nodes: subscribed and unsubscribed")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Cluster.Supervisor — the actual libcluster entry point
  # -----------------------------------------------------------------------
  defp cluster_supervisor_demo do
    IO.puts("--- Cluster.Supervisor (live demo) ---")

    # This is exactly what you put in Application.start/2
    # On a single node, it starts fine — just has no peers to connect to
    topologies = [
      example: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"node1@localhost", :"node2@localhost"]]
      ]
    ]

    {:ok, sup} = Cluster.Supervisor.start_link(topologies, name: LearnLibcluster.ClusterSup)
    IO.puts("Cluster.Supervisor started: #{inspect(sup)}")

    # List children of the cluster supervisor
    children = Supervisor.which_children(sup)
    IO.puts("Cluster.Supervisor children: #{length(children)}")
    Enum.each(children, fn {id, pid, type, _} ->
      IO.puts("  #{inspect(id)} #{inspect(pid)} (#{type})")
    end)

    Supervisor.stop(sup)
    IO.puts("Cluster.Supervisor stopped")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. NodeWatcher — react to membership changes
  # -----------------------------------------------------------------------
  defp node_watcher_demo do
    IO.puts("--- NodeWatcher GenServer (live demo) ---")

    {:ok, watcher} = NodeWatcher.start_link([])
    IO.puts("NodeWatcher started: #{inspect(watcher)}")
    IO.puts("NodeWatcher state: #{inspect(NodeWatcher.get_nodes(watcher))}")

    # Simulate a nodeup event (libcluster sends these when nodes join)
    send(watcher, {:nodeup, :"fake@node", []})
    Process.sleep(20)
    IO.puts("After nodeup:  #{inspect(NodeWatcher.get_nodes(watcher))}")

    send(watcher, {:nodedown, :"fake@node", []})
    Process.sleep(20)
    IO.puts("After nodedown: #{inspect(NodeWatcher.get_nodes(watcher))}")

    GenServer.stop(watcher)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Strategy selection guide
  # -----------------------------------------------------------------------
  defp strategy_guide do
    IO.puts("--- Strategy Selection Guide ---")

    strategies = [
      {"Local dev (2+ nodes)",  "LocalEpmd",      "zero config, auto-discovers local nodes"},
      {"Fixed IPs / static",    "Epmd",            "simple, predictable host list"},
      {"Docker / LAN",          "Gossip",          "UDP multicast, no static IPs needed"},
      {"Kubernetes (simple)",   "Kubernetes.DNS",  "headless service + DNS polling"},
      {"Kubernetes (advanced)", "Kubernetes",      "metadata API + label selectors"},
    ]

    IO.puts(String.pad_trailing("Environment", 26) <>
            String.pad_trailing("Strategy", 22) <>
            "Why")
    IO.puts(String.duplicate("-", 72))
    Enum.each(strategies, fn {env, strat, why} ->
      IO.puts(String.pad_trailing(env, 26) <>
              String.pad_trailing(strat, 22) <>
              why)
    end)

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Config reference (genuinely config-file content)
  # -----------------------------------------------------------------------
  defp config_reference do
    IO.puts("--- Config Reference ---")

    IO.puts("""
    # config/config.exs

    ## Epmd — static host list
    config :libcluster,
      topologies: [
        my_app: [
          strategy: Cluster.Strategy.Epmd,
          config: [hosts: [:"node1@192.168.1.10", :"node2@192.168.1.11"]]
        ]
      ]

    ## Gossip — UDP multicast (LAN/Docker)
    config :libcluster,
      topologies: [
        my_app: [
          strategy: Cluster.Strategy.Gossip,
          config: [port: 45892, multicast_addr: "230.1.1.251", secret: "s3cr3t"]
        ]
      ]

    ## Kubernetes DNS — most common in production
    config :libcluster,
      topologies: [
        my_app: [
          strategy: Cluster.Strategy.Kubernetes.DNS,
          config: [
            service: "my-app-headless",
            application_name: "my_app",
            namespace: "production",
            polling_interval: 5_000
          ]
        ]
      ]

    ## In Application.start/2:
    children = [
      {Cluster.Supervisor, [topologies, [name: MyApp.ClusterSupervisor]]},
      MyApp.Repo,
      MyApp.Endpoint,
    ]
    """)
  end
end

# ============================================================
# NodeWatcher — GenServer that reacts to node up/down events
# This is the pattern you use alongside libcluster in production
# ============================================================
defmodule NodeWatcher do
  use GenServer

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts)
  def get_nodes(pid),   do: GenServer.call(pid, :get_nodes)

  @impl GenServer
  def init(_opts) do
    # Subscribe to node events — libcluster triggers these
    :net_kernel.monitor_nodes(true, [node_type: :all])
    {:ok, %{nodes: MapSet.new()}}
  end

  @impl GenServer
  def handle_call(:get_nodes, _from, state) do
    {:reply, MapSet.to_list(state.nodes), state}
  end

  @impl GenServer
  def handle_info({:nodeup, node, _info}, state) do
    IO.puts("  [NodeWatcher] #{node} joined the cluster")
    # Real app: re-sync Horde members, warm up caches, etc.
    {:noreply, %{state | nodes: MapSet.put(state.nodes, node)}}
  end

  @impl GenServer
  def handle_info({:nodedown, node, _info}, state) do
    IO.puts("  [NodeWatcher] #{node} left the cluster")
    # Real app: handle redistribution, alert oncall, etc.
    {:noreply, %{state | nodes: MapSet.delete(state.nodes, node)}}
  end
end
