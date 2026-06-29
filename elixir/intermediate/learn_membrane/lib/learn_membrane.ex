defmodule LearnMembrane do
  @moduledoc """
  Membrane Framework v1.3 — OTP-native multimedia pipeline framework.

  Membrane brings the Actor model to media processing. Instead of writing
  a monolithic audio/video pipeline, you compose small, supervised elements:

    Source → Filter → Filter → Sink

  Each element is a GenServer. They communicate through typed pads
  (not direct messages). Pipelines supervise elements and restart them
  on failure — the OTP way, applied to media.

  Core abstractions:
    Element  — atomic processing unit (Source, Filter, Sink, Endpoint)
    Pad      — typed input/output port on an element
    Link     — connection between a compatible output pad and input pad
    Pipeline — supervisor + coordinator for a graph of elements
    Bin      — reusable group of elements (nestable in a pipeline)

  Membrane handles: WebRTC, RTSP, RTMP, HLS, MP4, MKV, Opus, AAC,
  H.264, H.265, and much more via its plugin ecosystem.

  Setup in mix.exs:
    {:membrane_core, "~> 1.3"}
  """

  def run do
    IO.puts("\n=== Membrane Framework: OTP-native Media Pipelines ===\n")

    core_concepts()
    element_types()
    pad_definitions()
    buffer_struct()
    actions_reference()
    pipeline_dsl()
    live_pipeline_demo()
    bin_concept()
    ecosystem()
  end

  # -----------------------------------------------------------------------
  # 1. Core concepts
  # -----------------------------------------------------------------------
  defp core_concepts do
    IO.puts("--- Core Concepts ---")

    IO.puts("""
    Membrane maps the OTP supervision model onto media processing:

      GenServer      →  Element (each element is a supervised process)
      Supervisor     →  Pipeline / Bin
      Message send   →  Buffer flowing through a link
      Process link   →  Pad connection (typed, demand-aware)

    Why this works well for media:
      - Each element crashes independently — pipeline can restart just it
      - Demand-based flow control prevents memory blow-up (backpressure)
      - Dynamic pipelines: add/remove elements at runtime
      - Cluster-aware: elements can run on different nodes

    Data flow is always:
      Source (produces) → Filter (transforms) → Sink (consumes)

    Elements never send messages directly to each other.
    They only send Buffers through pads → links → pads.
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Element types
  # -----------------------------------------------------------------------
  defp element_types do
    IO.puts("--- Element Types ---")

    IO.puts("""
    # Membrane.Source — produces data (only output pads)
    defmodule MyApp.FileSource do
      use Membrane.Source

      def_output_pad :output,
        accepted_format: %Membrane.RemoteStream{},
        flow_control: :manual   # produce only when demanded

      def handle_init(_ctx, %{path: path}) do
        {:ok, file} = File.open(path, [:read, :binary])
        {[], %{file: file}}
      end

      def handle_demand(:output, size, :buffers, _ctx, %{file: file} = state) do
        buffers = for _ <- 1..size do
          case IO.binread(file, 4096) do
            :eof  -> nil
            chunk -> %Membrane.Buffer{payload: chunk}
          end
        end |> Enum.reject(&is_nil/1)

        actions = if length(buffers) < size do
          [buffer: {:output, buffers}, end_of_stream: :output]
        else
          [buffer: {:output, buffers}]
        end

        {actions, state}
      end
    end

    # Membrane.Filter — transforms data (input + output pads)
    defmodule MyApp.VolumeFilter do
      use Membrane.Filter

      def_input_pad  :input,  accepted_format: %MyApp.RawAudio{}, flow_control: :auto
      def_output_pad :output, accepted_format: %MyApp.RawAudio{}, flow_control: :push

      def handle_init(_ctx, %{gain: gain}), do: {[], %{gain: gain}}

      def handle_buffer(:input, %Membrane.Buffer{payload: audio} = buf, _ctx, %{gain: g} = state) do
        amplified = amplify(audio, g)
        {[buffer: {:output, %{buf | payload: amplified}}], state}
      end

      defp amplify(pcm, gain), do: pcm   # placeholder
    end

    # Membrane.Sink — consumes data (only input pads)
    defmodule MyApp.FileSink do
      use Membrane.Sink

      def_input_pad :input, accepted_format: %Membrane.RemoteStream{}, flow_control: :auto

      def handle_init(_ctx, %{path: path}) do
        {:ok, file} = File.open(path, [:write, :binary])
        {[], %{file: file}}
      end

      def handle_buffer(:input, %{payload: data}, _ctx, %{file: file} = state) do
        IO.binwrite(file, data)
        {[], state}
      end

      def handle_end_of_stream(:input, _ctx, %{file: file} = state) do
        File.close(file)
        {[terminate: :normal], state}
      end
    end
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. Pad definitions
  # -----------------------------------------------------------------------
  defp pad_definitions do
    IO.puts("--- Pad Definitions ---")

    IO.puts("""
    # def_input_pad and def_output_pad define typed connection points.

    def_input_pad :input,
      accepted_format: MyFormat,         # required — validates stream format
      flow_control: :auto,               # :auto | :manual | :push
      availability: :always,             # :always (static) | :on_request (dynamic)
      demand_unit: :buffers,             # :buffers | :bytes
      options: [mute: [default: false]]  # custom per-pad options

    def_output_pad :output,
      accepted_format: MyFormat,
      flow_control: :manual,             # :manual | :push (output pads)
      availability: :always,
      demand_unit: :buffers

    # flow_control values:
    #   :auto   — Membrane automatically manages demand between input/output
    #             (use for filter-like elements that transform 1:1)
    #   :manual — you control demand via {:demand, pad_ref} actions
    #             (use for sources or elements with non-1:1 buffer ratio)
    #   :push   — producer sends as fast as possible, no backpressure
    #             (careful: can overflow downstream if not rate-limited)

    # Dynamic pads (availability: :on_request) — created per link:
    def_input_pad :input,
      availability: :on_request,       # created when a link is established
      accepted_format: _any,           # match any format
      flow_control: :auto

    # Access a dynamic pad instance with Pad.ref/2:
    # Pad.ref(:input, some_unique_id)
    # e.g. Pad.ref(:input, :microphone_1)

    # accepted_format matching:
    accepted_format: %Membrane.RawAudio{}              # exact struct
    accepted_format: %Membrane.RawAudio{channels: 2}   # with constraints
    accepted_format: %Membrane.RemoteStream{}           # any remote stream
    accepted_format: Membrane.H264                      # module name
    accepted_format: _any                               # wildcard
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Buffer struct
  # -----------------------------------------------------------------------
  defp buffer_struct do
    IO.puts("--- Membrane.Buffer ---")

    IO.puts("""
    # The unit of data flowing between elements.

    %Membrane.Buffer{
      payload:  bitstring() | Membrane.Payload.t(),  # the actual data (required)
      pts:      non_neg_integer() | nil,              # presentation timestamp (nanoseconds)
      dts:      non_neg_integer() | nil,              # decode timestamp (nanoseconds)
      metadata: %{}                                   # arbitrary metadata map
    }

    # Creating buffers:
    %Membrane.Buffer{payload: <<1, 2, 3, 4>>}

    %Membrane.Buffer{
      payload:  compressed_frame,
      dts:      frame_number * frame_duration_ns,
      pts:      presentation_time_ns,
      metadata: %{keyframe: true, width: 1920, height: 1080}
    }

    # Timestamps use Membrane.Time helpers:
    Membrane.Time.milliseconds(33)   #=> 33_000_000 (33ms in nanoseconds)
    Membrane.Time.seconds(1)         #=> 1_000_000_000
    Membrane.Time.nanoseconds(pts)   #=> pts (identity)

    # Passing buffers through a filter (common pattern):
    def handle_buffer(:input, buffer, _ctx, state) do
      processed = %{buffer | payload: transform(buffer.payload)}
      {[buffer: {:output, processed}], state}
    end
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Actions reference
  # -----------------------------------------------------------------------
  defp actions_reference do
    IO.puts("--- Actions Reference ---")

    IO.puts("""
    # Callbacks return {[action], new_state}.
    # Actions are the ONLY way elements interact with the world.

    ## Data flow actions (elements with pads):
    {:buffer,           {:output, %Membrane.Buffer{...}}}      # send one buffer
    {:buffer,           {:output, [buf1, buf2]}}               # send multiple
    {:stream_format,    {:output, %MyFormat{}}}                 # declare stream format
    {:event,            {:output, %SomeEvent{}}}                # send event
    {:end_of_stream,    :output}                                # signal EOS

    ## Demand actions (manual flow control):
    {:demand,           :input}                                 # demand 1 buffer
    {:demand,           {:input, 10}}                           # demand N buffers
    {:redemand,         :output}                                # re-call handle_demand
    {:pause_auto_demand, :input}                                # pause auto demand
    {:resume_auto_demand, :input}                               # resume

    ## Pipeline/Bin actions:
    {:spec,             [child(:a, A) |> child(:b, B)]}         # add children
    {:remove_child,     :child_name}                            # remove child
    {:remove_children,  [:child_a, :child_b]}                   # remove multiple

    ## General actions (all components):
    {:notify_parent,    {:my_event, data}}                      # notify parent
    {:terminate,        :normal}                                # terminate cleanly
    {:terminate,        {:error, reason}}                       # terminate with error
    {:start_timer,      {:my_timer, Membrane.Time.seconds(1)}}  # start timer
    {:stop_timer,       :my_timer}                              # stop timer
    {:reply_to_sync,    {:ok, response}}                        # reply to synchronous call

    ## Pipeline start action (handle_init only):
    {:spec, children_spec}                                      # declare initial graph
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 6. Pipeline DSL
  # -----------------------------------------------------------------------
  defp pipeline_dsl do
    IO.puts("--- Pipeline DSL ---")

    IO.puts("""
    # Pipelines define their element graph in handle_init via :spec action.

    defmodule MyApp.TranscodePipeline do
      use Membrane.Pipeline

      @impl true
      def handle_init(_ctx, %{input: input_path, output: output_path}) do
        spec = [
          # child(name, module_or_struct) — spawn a named element
          child(:source, %MyApp.FileSource{path: input_path})
          |> child(:demuxer,  MyApp.MP4Demuxer)
          |> child(:decoder,  MyApp.H264Decoder)
          |> child(:scaler,   %MyApp.VideoScaler{width: 1280, height: 720})
          |> child(:encoder,  %MyApp.H264Encoder{bitrate: 2_000_000})
          |> child(:muxer,    MyApp.MP4Muxer)
          |> child(:sink,     %MyApp.FileSink{path: output_path})
        ]

        {[spec: spec], %{}}
      end

      # Notified when any element signals EOS on a pad
      @impl true
      def handle_element_end_of_stream(:sink, :input, _ctx, state) do
        {[terminate: :normal], state}
      end

      # Notified when a child sends {:notify_parent, msg}
      @impl true
      def handle_child_notification(msg, child, _ctx, state) do
        IO.puts("#{child} says: #{inspect msg}")
        {[], state}
      end
    end

    # Start the pipeline:
    {:ok, _sup, pipeline} = Membrane.Pipeline.start_link(MyApp.TranscodePipeline, %{
      input:  "/tmp/input.mp4",
      output: "/tmp/output.mp4"
    })

    # Add more elements at runtime:
    Membrane.Pipeline.call(pipeline, :add_overlay)

    # Terminate:
    Membrane.Pipeline.terminate(pipeline)

    ## Specifying non-default pads with via_in/via_out:
    child(:source, MySource)
    |> via_out(:video)                           # use :video output pad
    |> via_in(:raw_input, options: [mute: true]) # use :raw_input with options
    |> child(:encoder, MyEncoder)

    ## Dynamic child names (for multiple instances):
    for i <- 1..4 do
      child({:worker, i}, %MyApp.Worker{index: i})
      |> child({:sink, i}, %MyApp.FileSink{path: "/tmp/out_\#{i}.mp4"})
    end

    ## get_child/1 — reference an already-started child:
    get_child(:demuxer)
    |> via_out(:audio)
    |> child(:audio_encoder, MyApp.AACEncoder)
    |> child(:audio_sink, %MyApp.FileSink{path: "/tmp/audio.aac"})
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 7. Live pipeline demo (compilable)
  # -----------------------------------------------------------------------
  defp live_pipeline_demo do
    IO.puts("--- Live Pipeline Demo ---")

    # Start and immediately terminate a minimal pipeline to show it works
    {:ok, _sup, pipeline} = Membrane.Pipeline.start_link(DemoPipeline, [])
    Process.sleep(200)
    Membrane.Pipeline.terminate(pipeline)
    IO.puts("Pipeline ran and terminated cleanly.")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 8. Bin concept
  # -----------------------------------------------------------------------
  defp bin_concept do
    IO.puts("--- Bins: Reusable Element Groups ---")

    IO.puts("""
    # A Bin is like a Pipeline, but it can be used AS an element inside
    # another pipeline. Great for packaging reusable subgraphs.

    defmodule MyApp.AudioProcessingBin do
      use Membrane.Bin

      def_input_pad  :input,  accepted_format: %Membrane.RawAudio{}, flow_control: :auto
      def_output_pad :output, accepted_format: %Membrane.RawAudio{}, flow_control: :push

      @impl true
      def handle_init(_ctx, opts) do
        spec = [
          bin_input()                            # connect bin's :input pad to
          |> child(:normalizer, MyApp.Normalizer)
          |> child(:compressor, %MyApp.Compressor{threshold: opts.threshold})
          |> child(:limiter,    MyApp.Limiter)
          |> bin_output()                        # connect to bin's :output pad
        ]
        {[spec: spec], %{}}
      end
    end

    # Use the bin as if it were a single element:
    child(:mic, MyApp.MicrophoneSource)
    |> child(:audio_processing, %MyApp.AudioProcessingBin{threshold: -6.0})
    |> child(:encoder, MyApp.OpusEncoder)
    |> child(:sink, MyApp.RTPSink)

    # From outside the pipeline, :audio_processing looks like a Filter.
    # The internal structure is hidden — encapsulation.
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 9. Ecosystem
  # -----------------------------------------------------------------------
  defp ecosystem do
    IO.puts("--- Membrane Ecosystem ---")

    IO.puts("""
    Membrane plugins (all on hex.pm):

    I/O:
      membrane_file_plugin       — read/write files
      membrane_hackney_plugin    — HTTP source/sink
      membrane_rtmp_plugin       — RTMP server/client
      membrane_rtsp_plugin       — RTSP client
      membrane_udp_plugin        — UDP source/sink

    Containers / Muxing:
      membrane_mp4_plugin        — MP4 muxer/demuxer
      membrane_matroska_plugin   — MKV muxer/demuxer
      membrane_flv_plugin        — FLV (Flash video)
      membrane_ogg_plugin        — Ogg container

    Codecs:
      membrane_h264_ffmpeg_plugin   — H.264 encode/decode via FFmpeg
      membrane_h265_ffmpeg_plugin   — H.265 encode/decode
      membrane_opus_plugin          — Opus audio (libopus)
      membrane_aac_plugin           — AAC (FDK-AAC)
      membrane_raw_audio_parser_plugin

    Streaming:
      membrane_webrtc_plugin        — WebRTC (signaling + media)
      membrane_hls_plugin           — HLS output
      membrane_rtp_plugin           — RTP/RTCP

    Utilities:
      membrane_tee_plugin           — fan-out (1 input → N outputs)
      membrane_realtimer_plugin     — real-time pacing
      membrane_funnel_plugin        — fan-in (N inputs → 1 output)
      membrane_stream_sync_plugin   — sync multiple streams by PTS

    Typical real-world pipeline (WebRTC ingest → HLS output):
      WebRTC → RTP Depay → H264 Parser → MP4 Muxer → HLS Sink
    """)
    IO.puts("")
  end
end

# ---- Minimal compilable pipeline for the live demo ----

defmodule DemoSource do
  use Membrane.Source

  def_output_pad :output,
    accepted_format: %Membrane.RemoteStream{},
    flow_control: :manual

  @impl true
  def handle_init(_ctx, _opts), do: {[], %{sent: false}}

  @impl true
  def handle_demand(:output, _size, _unit, _ctx, %{sent: false} = state) do
    buf = %Membrane.Buffer{payload: "hello membrane"}
    {[buffer: {:output, buf}, end_of_stream: :output], %{state | sent: true}}
  end

  def handle_demand(:output, _size, _unit, _ctx, state), do: {[], state}
end

defmodule DemoSink do
  use Membrane.Sink

  def_input_pad :input,
    accepted_format: %Membrane.RemoteStream{},
    flow_control: :auto

  @impl true
  def handle_init(_ctx, _opts), do: {[], %{}}

  @impl true
  def handle_buffer(:input, buf, _ctx, state) do
    IO.puts("  Sink received: #{inspect buf.payload}")
    {[], state}
  end

  @impl true
  def handle_end_of_stream(:input, _ctx, state) do
    {[terminate: :normal], state}
  end
end

defmodule DemoPipeline do
  use Membrane.Pipeline

  @impl true
  def handle_init(_ctx, _opts) do
    spec = [child(:source, DemoSource) |> child(:sink, DemoSink)]
    {[spec: spec], %{}}
  end

  @impl true
  def handle_element_end_of_stream(:sink, :input, _ctx, state) do
    {[terminate: :normal], state}
  end
end
