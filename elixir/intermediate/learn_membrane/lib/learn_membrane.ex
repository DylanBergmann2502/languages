defmodule LearnMembrane do
  @moduledoc """
  Membrane Framework v1.3 — OTP-native multimedia pipeline framework.

  Membrane applies the Actor model to media processing. A pipeline is a
  supervised graph of elements:

    Source → Filter → Filter → Sink

  Each element is a GenServer. Data flows as %Membrane.Buffer{} through
  typed connection points called pads. Pipelines supervise elements and
  restart on failure — OTP semantics applied to media.

  Core abstractions:
    Element  — atomic processing unit (Source, Filter, Sink)
    Pad      — typed input/output port on an element
    Link     — connection between output pad and input pad
    Pipeline — supervisor + coordinator for an element graph
    Bin      — reusable group of elements, usable as a single element

  dep: {:membrane_core, "~> 1.3"}
  """

  def run do
    IO.puts("\n=== Membrane Framework: OTP-native Media Pipelines ===\n")

    otp_mapping()
    buffer_struct()
    pad_api()
    actions_reference()
    live_pipeline_demo()
    filter_chain_demo()
    bin_demo()
    ecosystem()
  end

  # -----------------------------------------------------------------------
  # 1. OTP mapping
  # -----------------------------------------------------------------------
  defp otp_mapping do
    IO.puts("--- OTP Mapping ---")

    mapping = [
      {"GenServer",     "Element — each is a supervised GenServer process"},
      {"Supervisor",    "Pipeline/Bin — supervises element processes"},
      {"message send",  "Buffer flowing through a pad link"},
      {"process link",  "Pad connection — typed and demand-aware"},
    ]

    Enum.each(mapping, fn {otp, membrane} ->
      IO.puts("  #{String.pad_trailing(otp, 14)} →  #{membrane}")
    end)

    IO.puts("""

  Why OTP semantics matter for media:
    - Element crashes independently — pipeline restarts just that element
    - Demand-based flow control prevents buffer memory blow-up
    - Dynamic pipelines: add/remove elements at runtime
    - Elements can run on different cluster nodes
    """)
  end

  # -----------------------------------------------------------------------
  # 2. Membrane.Buffer — the unit of data
  # -----------------------------------------------------------------------
  defp buffer_struct do
    IO.puts("--- Membrane.Buffer ---")

    # Create buffers directly — this is what elements send to each other
    simple = %Membrane.Buffer{payload: "hello membrane"}
    IO.puts("Simple buffer: #{inspect(simple)}")

    # With timestamps (nanoseconds)
    with_pts = %Membrane.Buffer{
      payload:  <<0, 1, 2, 3>>,
      pts:      Membrane.Time.milliseconds(33),   # 33ms presentation time
      dts:      Membrane.Time.milliseconds(30),   # 30ms decode time
      metadata: %{keyframe: true, width: 1920, height: 1080}
    }
    IO.puts("Buffer pts:  #{with_pts.pts} ns (= #{with_pts.pts / 1_000_000} ms)")
    IO.puts("Buffer dts:  #{with_pts.dts} ns")
    IO.puts("Buffer meta: #{inspect(with_pts.metadata)}")

    # Time helpers
    IO.puts("1 second in ns:  #{Membrane.Time.seconds(1)}")
    IO.puts("33ms in ns:      #{Membrane.Time.milliseconds(33)}")

    # Transforming a buffer (common filter pattern)
    transformed = %{with_pts | payload: String.upcase("hello")}
    IO.puts("Transformed payload: #{inspect(transformed.payload)}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. Pad definitions — inspect compiled pad specs from real modules
  # -----------------------------------------------------------------------
  defp pad_api do
    IO.puts("--- Pad Definitions ---")

    # These modules are defined below — inspect their compiled pad specs
    source_pads = DemoSource.__membrane_pads__()
    IO.puts("DemoSource pads: #{inspect(Keyword.keys(source_pads))}")
    {_name, output_spec} = Enum.find(source_pads, fn {name, _} -> name == :output end)
    IO.puts("  :output flow_control: #{output_spec.flow_control}")
    IO.puts("  :output direction:    #{output_spec.direction}")

    filter_pads = DemoFilter.__membrane_pads__()
    IO.puts("DemoFilter pads: #{inspect(Keyword.keys(filter_pads))}")

    sink_pads = DemoSink.__membrane_pads__()
    IO.puts("DemoSink pads:   #{inspect(Keyword.keys(sink_pads))}")

    IO.puts("""

  Pad options reference:
    def_input_pad :input,
      accepted_format: %Membrane.RemoteStream{},  # validates stream format
      flow_control:    :auto,   # :auto | :manual | :push
      availability:    :always  # :always (static) | :on_request (dynamic)

    def_output_pad :output,
      accepted_format: %Membrane.RemoteStream{},
      flow_control:    :manual  # :manual | :push

    flow_control:
      :auto   — Membrane manages demand automatically (good for 1:1 filters)
      :manual — you control demand via {:demand, pad} actions
      :push   — send without backpressure (risk: downstream overflow)
    """)
  end

  # -----------------------------------------------------------------------
  # 4. Actions reference — what callbacks return
  # -----------------------------------------------------------------------
  defp actions_reference do
    IO.puts("--- Actions Reference ---")

    # Actions are keyword lists returned by callbacks as {actions, state}
    # Show each action as a real term that can be inspected

    data_actions = [
      {:buffer,        {:output, %Membrane.Buffer{payload: "data"}}},
      {:stream_format, {:output, %Membrane.RemoteStream{}}},
      {:end_of_stream, :output},
    ]

    demand_actions = [
      {:demand,   :input},
      {:demand,   {:input, 10}},
      {:redemand, :output},
    ]

    general_actions = [
      {:notify_parent, {:progress, 50}},
      {:terminate,     :normal},
    ]

    IO.puts("Data flow actions:")
    Enum.each(data_actions, fn a -> IO.puts("  #{inspect(a)}") end)

    IO.puts("Demand actions:")
    Enum.each(demand_actions, fn a -> IO.puts("  #{inspect(a)}") end)

    IO.puts("General actions:")
    Enum.each(general_actions, fn a -> IO.puts("  #{inspect(a)}") end)

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Live pipeline demo — Source → Sink
  # -----------------------------------------------------------------------
  defp live_pipeline_demo do
    IO.puts("--- Live Pipeline: Source → Sink ---")

    {:ok, _sup, pipeline} = Membrane.Pipeline.start_link(DemoPipeline, [])
    ref = Process.monitor(pipeline)

    # Pipeline terminates itself after processing — wait for it
    receive do
      {:DOWN, ^ref, :process, ^pipeline, reason} ->
        IO.puts("Pipeline finished: #{inspect(reason)}")
    after
      2000 -> IO.puts("Pipeline still running after 2s")
    end

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 6. Filter chain demo — Source → Filter → Sink
  # -----------------------------------------------------------------------
  defp filter_chain_demo do
    IO.puts("--- Live Pipeline: Source → Filter → Sink ---")

    {:ok, _sup, pipeline} = Membrane.Pipeline.start_link(FilterChainPipeline, [])
    ref = Process.monitor(pipeline)

    receive do
      {:DOWN, ^ref, :process, ^pipeline, reason} ->
        IO.puts("Filter chain finished: #{inspect(reason)}")
    after
      2000 -> IO.puts("Filter chain still running after 2s")
    end

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 7. Bin demo — bin used as element inside pipeline
  # -----------------------------------------------------------------------
  defp bin_demo do
    IO.puts("--- Bin: Reusable Element Group ---")

    # A Bin wraps a subgraph behind a single element interface.
    # DemoDoubleFilterBin contains two DemoFilters internally,
    # but appears as a single element from the pipeline's perspective.

    {:ok, _sup, pipeline} = Membrane.Pipeline.start_link(BinPipeline, [])
    ref = Process.monitor(pipeline)

    receive do
      {:DOWN, ^ref, :process, ^pipeline, reason} ->
        IO.puts("Bin pipeline finished: #{inspect(reason)}")
    after
      2000 -> IO.puts("Bin pipeline still running after 2s")
    end

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 8. Ecosystem overview
  # -----------------------------------------------------------------------
  defp ecosystem do
    IO.puts("--- Ecosystem Plugins ---")

    plugins = [
      {"I/O",        ["membrane_file_plugin", "membrane_hackney_plugin",
                      "membrane_rtmp_plugin", "membrane_udp_plugin"]},
      {"Containers", ["membrane_mp4_plugin", "membrane_matroska_plugin",
                      "membrane_ogg_plugin"]},
      {"Codecs",     ["membrane_h264_ffmpeg_plugin", "membrane_opus_plugin",
                      "membrane_aac_plugin"]},
      {"Streaming",  ["membrane_webrtc_plugin", "membrane_hls_plugin",
                      "membrane_rtp_plugin"]},
      {"Utilities",  ["membrane_tee_plugin (1→N fan-out)",
                      "membrane_funnel_plugin (N→1 fan-in)",
                      "membrane_realtimer_plugin"]},
    ]

    Enum.each(plugins, fn {category, pkgs} ->
      IO.puts("  #{category}:")
      Enum.each(pkgs, fn p -> IO.puts("    #{p}") end)
    end)

    IO.puts("""

  Typical production pipeline (WebRTC ingest → HLS output):
    WebRTC source → RTP depayloader → H264 parser → MP4 muxer → HLS sink
    """)
  end
end

# ============================================================
# DemoSource — produces text buffers, signals end of stream
# ============================================================
defmodule DemoSource do
  use Membrane.Source

  def_output_pad :output,
    accepted_format: %Membrane.RemoteStream{},
    flow_control: :manual

  @impl true
  def handle_init(_ctx, opts) do
    messages = Keyword.get(opts, :messages, ["hello", "membrane", "world"])
    {[], %{messages: messages}}
  end

  @impl true
  def handle_demand(:output, _size, _unit, _ctx, %{messages: []} = state) do
    {[end_of_stream: :output], state}
  end

  def handle_demand(:output, _size, _unit, _ctx, %{messages: [msg | rest]} = state) do
    buf = %Membrane.Buffer{payload: msg}
    {[buffer: {:output, buf}], %{state | messages: rest}}
  end
end

# ============================================================
# DemoFilter — transforms each buffer's payload (uppercase)
# ============================================================
defmodule DemoFilter do
  use Membrane.Filter

  def_input_pad  :input,  accepted_format: %Membrane.RemoteStream{}, flow_control: :auto
  def_output_pad :output, accepted_format: %Membrane.RemoteStream{}, flow_control: :push

  @impl true
  def handle_init(_ctx, opts) do
    transform = Keyword.get(opts, :transform, &String.upcase/1)
    {[], %{transform: transform}}
  end

  @impl true
  def handle_buffer(:input, %Membrane.Buffer{payload: data} = buf, _ctx, %{transform: f} = state) do
    transformed = %{buf | payload: f.(data)}
    {[buffer: {:output, transformed}], state}
  end
end

# ============================================================
# DemoSink — receives buffers and prints them
# ============================================================
defmodule DemoSink do
  use Membrane.Sink

  def_input_pad :input,
    accepted_format: %Membrane.RemoteStream{},
    flow_control: :auto

  @impl true
  def handle_init(_ctx, opts) do
    label = Keyword.get(opts, :label, "Sink")
    {[], %{label: label, received: []}}
  end

  @impl true
  def handle_buffer(:input, %Membrane.Buffer{payload: data}, _ctx, state) do
    IO.puts("  [#{state.label}] received: #{inspect(data)}")
    {[], %{state | received: [data | state.received]}}
  end

  @impl true
  def handle_end_of_stream(:input, _ctx, state) do
    IO.puts("  [#{state.label}] end of stream (total: #{length(state.received)} buffers)")
    {[terminate: :normal], state}
  end
end

# ============================================================
# DemoDoubleFilterBin — a Bin wrapping two filters
# Appears as a single element to the pipeline
# ============================================================
defmodule DemoDoubleFilterBin do
  use Membrane.Bin

  def_input_pad  :input,  accepted_format: %Membrane.RemoteStream{}, flow_control: :auto
  def_output_pad :output, accepted_format: %Membrane.RemoteStream{}, flow_control: :push

  @impl true
  def handle_init(_ctx, _opts) do
    spec = [
      bin_input()
      |> child(:filter1, %DemoFilter{transform: &String.upcase/1})
      |> child(:filter2, %DemoFilter{transform: fn s -> "[#{s}]" end})
      |> bin_output()
    ]
    {[spec: spec], %{}}
  end
end

# ============================================================
# Pipelines
# ============================================================
defmodule DemoPipeline do
  use Membrane.Pipeline

  @impl true
  def handle_init(_ctx, _opts) do
    spec = [
      child(:source, %DemoSource{messages: ["alpha", "beta", "gamma"]})
      |> child(:sink, %DemoSink{label: "DemoPipeline"})
    ]
    {[spec: spec], %{}}
  end

  @impl true
  def handle_element_end_of_stream(:sink, :input, _ctx, state) do
    {[terminate: :normal], state}
  end
end

defmodule FilterChainPipeline do
  use Membrane.Pipeline

  @impl true
  def handle_init(_ctx, _opts) do
    spec = [
      child(:source, %DemoSource{messages: ["hello", "world"]})
      |> child(:filter, %DemoFilter{transform: &String.upcase/1})
      |> child(:sink, %DemoSink{label: "FilterChain"})
    ]
    {[spec: spec], %{}}
  end

  @impl true
  def handle_element_end_of_stream(:sink, :input, _ctx, state) do
    {[terminate: :normal], state}
  end
end

defmodule BinPipeline do
  use Membrane.Pipeline

  @impl true
  def handle_init(_ctx, _opts) do
    spec = [
      child(:source, %DemoSource{messages: ["bin", "pipeline", "demo"]})
      |> child(:double_filter, DemoDoubleFilterBin)
      |> child(:sink, %DemoSink{label: "BinPipeline"})
    ]
    {[spec: spec], %{}}
  end

  @impl true
  def handle_element_end_of_stream(:sink, :input, _ctx, state) do
    {[terminate: :normal], state}
  end
end
