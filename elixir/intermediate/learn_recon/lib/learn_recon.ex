defmodule LearnRecon do
  @moduledoc """
  Recon v2.5 — production diagnostics for Erlang/Elixir systems.

  Written by Fred Hebert (author of "Learn You Some Erlang"), recon lets
  you inspect, trace, and diagnose a running BEAM system without stopping
  it. It's the go-to tool when something is wrong in production.

  Recon is an Erlang library. Call it as :recon.* from Elixir.

  Key modules:
    :recon           — process and system info
    :recon_trace     — function call tracing (safe, throttled)
    :recon_alloc     — memory allocator diagnostics
    :recon_lib       — utility functions

  Setup in mix.exs:
    {:recon, "~> 2.5"}
  """

  require Logger

  def run do
    IO.puts("\n=== Recon: Production Diagnostics ===\n")

    process_info()
    top_processes()
    system_info()
    port_inspection()
    tracing_demo()
  end

  # -----------------------------------------------------------------------
  # 1. Process info
  # -----------------------------------------------------------------------
  defp process_info do
    IO.puts("--- Process Info ---")

    # Spawn a process we can inspect
    pid = spawn(fn ->
      receive do
        :stop -> :ok
      end
    end)

    # info(Pid) → [{category, [{key, value}]}]
    # Categories: :meta, :signals, :location, :memory_used, :work
    info = :recon.info(pid)
    IO.puts("Info categories: #{info |> Keyword.keys() |> inspect()}")

    # info(Pid, Category) → [{key, value}]
    meta = :recon.info(pid, :meta)
    IO.puts("Meta info: #{inspect(meta)}")

    memory = :recon.info(pid, :memory_used)
    IO.puts("Memory info: #{inspect(memory)}")

    work = :recon.info(pid, :work)
    IO.puts("Work info: #{inspect(work)}")

    # get_state/1 — extract GenServer/gen_statem state without stopping it
    {:ok, agent} = Agent.start_link(fn -> %{counter: 42, name: "test"} end)
    state = :recon.get_state(agent)
    IO.puts("Agent state via recon: #{inspect(state)}")

    send(pid, :stop)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Top processes (like Unix top, but for BEAM)
  # -----------------------------------------------------------------------
  defp top_processes do
    IO.puts("--- Top Processes ---")

    # proc_count(Attribute, N) — top N processes by attribute
    # Attributes: :memory, :reductions, :message_queue_len,
    #             :total_heap_size, :heap_size, :stack_size
    top_memory = :recon.proc_count(:memory, 5)
    IO.puts("Top 5 by memory:")
    Enum.each(top_memory, fn {pid, value, info} ->
      name = Keyword.get(info, :registered_name, pid)
      IO.puts("  #{inspect(name)}: #{value} bytes")
    end)

    top_reductions = :recon.proc_count(:reductions, 3)
    IO.puts("\nTop 3 by reductions (CPU work):")
    Enum.each(top_reductions, fn {pid, value, info} ->
      name = Keyword.get(info, :registered_name, pid)
      IO.puts("  #{inspect(name)}: #{value} reductions")
    end)

    # proc_window(Attribute, N, Ms)
    # Measures attribute delta over Ms milliseconds — shows ACTIVE processes
    # (proc_count shows cumulative, proc_window shows recent activity)
    IO.puts("\nTop 3 by reductions over 500ms window:")
    active = :recon.proc_window(:reductions, 3, 500)
    Enum.each(active, fn {pid, value, info} ->
      name = Keyword.get(info, :registered_name, pid)
      IO.puts("  #{inspect(name)}: #{value} reductions/window")
    end)

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. System-wide stats
  # -----------------------------------------------------------------------
  defp system_info do
    IO.puts("--- System Info ---")

    # scheduler_usage(Ms) — CPU utilization per scheduler
    usage = :recon.scheduler_usage(200)
    IO.puts("Scheduler usage (#{length(usage)} schedulers):")
    Enum.take(usage, 4) |> Enum.each(fn {id, util} ->
      IO.puts("  Scheduler #{id}: #{Float.round(util * 100, 1)}%")
    end)

    # bin_leak(MinBytes) — detect refc binary leaks
    # Returns processes holding binaries larger than MinBytes
    # that may indicate leaks (binaries not GC'd because of refs)
    IO.puts("\nRefc binary holders (>= 1024 bytes):")
    leaks = :recon.bin_leak(1024)
    IO.puts("  #{length(leaks)} processes holding large binaries")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Port inspection (sockets, file handles)
  # -----------------------------------------------------------------------
  defp port_inspection do
    IO.puts("--- Port Inspection ---")

    # tcp/0, udp/0, sctp/0, files/0 — list ports by type
    tcp_ports  = :recon.tcp()
    file_ports = :recon.files()

    IO.puts("Open TCP ports: #{length(tcp_ports)}")
    IO.puts("Open file handles: #{length(file_ports)}")

    # port_info(Port) — detailed info on a port
    # (similar to :erlang.port_info but with better formatting)
    if length(tcp_ports) > 0 do
      port = hd(tcp_ports)
      info = :recon.port_info(port)
      IO.puts("First TCP port info keys: #{info |> Keyword.keys() |> inspect()}")
    end

    # inet_count(Attr, N) — top N inet connections by attribute
    IO.puts("Top 3 inet connections by recv_oct:")
    inet_top = :recon.inet_count(:recv_oct, 3)
    IO.puts("  #{inspect(inet_top)}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Tracing with recon_trace
  # -----------------------------------------------------------------------
  defp tracing_demo do
    IO.puts("--- recon_trace: Safe Function Call Tracing ---")

    # recon_trace is the safe alternative to :dbg/:sys — it automatically
    # stops after N calls so you can't flood a production system.

    # calls({Module, Function, Arity | :_}, MaxCalls)
    # calls({Module, Function, Arity | :_}, MaxCalls, Opts)
    #
    # Example: trace up to 5 calls to String.upcase/1
    # Uncomment to run (will print trace output):
    #
    #   :recon_trace.calls({String, :upcase, 1}, 5)
    #   String.upcase("hello")
    #   String.upcase("world")
    #   :recon_trace.clear()

    # With return values:
    #   :recon_trace.calls({String, :upcase, 1}, 5, return_to: true)

    # With a match spec (only trace calls where arg matches pattern):
    #   :recon_trace.calls({Map, :get, 2}, 10, [{:_, [{:"=:=", {:element, 1, :"$1"}, :name}], []}])

    # Tracing across all nodes in cluster:
    #   :recon_trace.calls({String, :upcase, 1}, {5, 100}, scope: :global)
    #   # {MaxPerNode, MaxTotal}

    IO.puts("""
    recon_trace.calls/2-3 examples:
      # Trace 10 calls to Map.get/3
      :recon_trace.calls({Map, :get, 3}, 10)

      # Trace with return values
      :recon_trace.calls({String, :split, 2}, 5, return_to: true)

      # Trace ALL calls to any function in a module
      :recon_trace.calls({MyModule, :_, :_}, 20)

      # Stop tracing
      :recon_trace.clear()

    Key safety property: tracing stops after MaxCalls — can't flood prod.
    """)

    IO.puts("")
  end
end
