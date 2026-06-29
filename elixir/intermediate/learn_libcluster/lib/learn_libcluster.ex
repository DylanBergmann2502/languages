defmodule LearnLibcluster do
  @moduledoc """
  libcluster v3.5 — automatic Erlang cluster formation.

  libcluster discovers and connects BEAM nodes automatically.
  Without it, you'd have to manually call Node.connect/1 on every node.
  With it, you configure a strategy and nodes find each other.

  Strategies (built-in):
    Cluster.Strategy.Epmd          — static list of hosts via epmd
    Cluster.Strategy.LocalEpmd     — discover nodes on local machine
    Cluster.Strategy.ErlangHosts   — use .hosts.erlang file
    Cluster.Strategy.Gossip        — UDP multicast (LAN)
    Cluster.Strategy.Kubernetes    — K8s metadata API
    Cluster.Strategy.Kubernetes.DNS — K8s DNS-based (most common in prod)

  Setup in mix.exs:
    {:libcluster, "~> 3.5"}

  This file shows config patterns and how to integrate libcluster
  into a supervision tree. Full clustering requires multiple nodes
  (run with: iex --sname node1 -S mix, iex --sname node2 -S mix).
  """

  def run do
    IO.puts("\n=== libcluster: Automatic Node Discovery ===\n")

    config_patterns()
    supervision_tree_integration()
    strategy_guide()
    node_monitoring()
  end

  # -----------------------------------------------------------------------
  # 1. Configuration patterns for every strategy
  # -----------------------------------------------------------------------
  defp config_patterns do
    IO.puts("--- Configuration Patterns ---")

    IO.puts("""
    # config/config.exs

    ## Strategy 1: Epmd (static list — good for dev/staging)
    config :libcluster,
      topologies: [
        my_app: [
          strategy: Cluster.Strategy.Epmd,
          config: [
            hosts: [:"node1@192.168.1.10", :"node2@192.168.1.11"]
          ]
        ]
      ]

    ## Strategy 2: Gossip (UDP multicast — good for LAN/Docker)
    config :libcluster,
      topologies: [
        my_app: [
          strategy: Cluster.Strategy.Gossip,
          config: [
            port: 45892,
            if_addr: "0.0.0.0",
            multicast_addr: "230.1.1.251",
            multicast_ttl: 1,
            secret: "mysecret"  # optional shared secret
          ]
        ]
      ]

    ## Strategy 3: Kubernetes DNS (most common in production)
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

    ## Strategy 4: Kubernetes Metadata API
    config :libcluster,
      topologies: [
        my_app: [
          strategy: Cluster.Strategy.Kubernetes,
          config: [
            kubernetes_selector: "app=my-app",
            kubernetes_node_basename: "my_app",
            polling_interval: 10_000
          ]
        ]
      ]

    ## Multiple topologies (e.g. dev + prod in same config)
    config :libcluster,
      topologies: [
        local: [
          strategy: Cluster.Strategy.LocalEpmd
        ],
        production: [
          strategy: Cluster.Strategy.Kubernetes.DNS,
          config: [service: "my-app-headless", namespace: "prod"]
        ]
      ]
    """)
  end

  # -----------------------------------------------------------------------
  # 2. Supervision tree integration
  # -----------------------------------------------------------------------
  defp supervision_tree_integration do
    IO.puts("--- Supervision Tree Integration ---")

    IO.puts("""
    # In your Application module:
    defmodule MyApp.Application do
      use Application

      def start(_type, _args) do
        topologies = Application.get_env(:libcluster, :topologies, [])

        children = [
          # Cluster.Supervisor discovers & connects nodes
          {Cluster.Supervisor, [topologies, [name: MyApp.ClusterSupervisor]]},

          # Your app's supervised processes come after
          MyApp.Repo,
          MyApp.Endpoint,
          # Horde.Registry and Horde.DynamicSupervisor go here too
        ]

        Supervisor.start_link(children, strategy: :one_for_one)
      end
    end

    # Cluster.Supervisor options:
    #   name:       atom — name for the supervisor process
    #   strategy:   :one_for_one (default)
    """)

    # Demonstrate what Node-related functions libcluster uses internally
    IO.puts("Current node: #{Node.self()}")
    IO.puts("Connected nodes: #{inspect(Node.list())}")
    IO.puts("Node alive? #{Node.alive?()}")
  end

  # -----------------------------------------------------------------------
  # 3. Strategy selection guide
  # -----------------------------------------------------------------------
  defp strategy_guide do
    IO.puts("\n--- Strategy Selection Guide ---")

    IO.puts("""
    ┌─────────────────────────┬──────────────────────┬──────────────────────┐
    │ Environment             │ Recommended Strategy  │ Why                  │
    ├─────────────────────────┼──────────────────────┼──────────────────────┤
    │ Local dev (2+ nodes)    │ LocalEpmd            │ Zero config          │
    │ Fixed IPs / static env  │ Epmd                 │ Simple, predictable  │
    │ Docker / LAN            │ Gossip               │ No static IPs needed │
    │ Kubernetes (simple)     │ Kubernetes.DNS       │ Uses headless svc    │
    │ Kubernetes (advanced)   │ Kubernetes           │ Label selector based │
    │ Rancher                 │ Rancher              │ Metadata API         │
    └─────────────────────────┴──────────────────────┴──────────────────────┘

    Custom strategy: implement Cluster.Strategy behaviour
      use Cluster.Strategy
      def start_link(opts), do: ...
      def handle_info(:connect, state), do: ...
    """)
  end

  # -----------------------------------------------------------------------
  # 4. Node monitoring patterns (what to do once nodes connect)
  # -----------------------------------------------------------------------
  defp node_monitoring do
    IO.puts("--- Node Monitoring After Cluster Forms ---")

    IO.puts("""
    # Monitor node up/down events:
    defmodule MyApp.NodeWatcher do
      use GenServer

      def start_link(_), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

      def init(_) do
        :net_kernel.monitor_nodes(true, [node_type: :all])
        {:ok, %{}}
      end

      def handle_info({:nodeup, node, _info}, state) do
        Logger.info("Node joined cluster: \#{node}")
        # Re-sync Horde members, warm up caches, etc.
        {:noreply, state}
      end

      def handle_info({:nodedown, node, _info}, state) do
        Logger.warning("Node left cluster: \#{node}")
        # Handle redistribution, alert, etc.
        {:noreply, state}
      end
    end

    # Combined pattern: libcluster + Horde + NodeWatcher
    # libcluster    → connects nodes
    # Horde         → distributes processes across nodes
    # NodeWatcher   → reacts to membership changes
    # Syn           → global pub/sub across cluster
    """)
  end
end
