defmodule LearnOpentelemetry do
  @moduledoc """
  OpenTelemetry v1.7 — Distributed tracing for Elixir/OTP.

  OpenTelemetry is the CNCF standard for observability: traces, metrics, logs.
  This lesson covers tracing — following a request as it flows through processes,
  services, and time.

  Key concepts:
    Trace   — the full journey of one request (a tree of spans)
    Span    — one unit of work: name, start/end timestamps, attributes, events
    Context — carries the trace ID across process/service boundaries

  Three-package design:
    opentelemetry_api  — macros + types only; safe to add to library deps
    opentelemetry      — SDK: span processors, samplers, resource detection
    opentelemetry_exporter — OTLP protocol; sends spans to a collector

  deps:
    {:opentelemetry_api,      "~> 1.5"}
    {:opentelemetry,          "~> 1.7"}
    {:opentelemetry_exporter, "~> 1.10"}
  """

  require OpenTelemetry.Tracer, as: Tracer

  alias OpenTelemetry.Span

  def run do
    IO.puts("\n=== OpenTelemetry: Distributed Tracing ===\n")

    setup_note()
    basic_spans()
    nested_spans()
    attributes_and_events()
    error_handling()
    context_propagation()
    instrumentation_packages()
    configuration_reference()
  end

  # -----------------------------------------------------------------------
  # 0. Setup note
  # -----------------------------------------------------------------------
  defp setup_note do
    IO.puts("--- Setup ---")
    IO.puts("""
      For this lesson, spans are printed to stdout (no collector needed):

      config :opentelemetry, :processors,
        otel_batch_processor: %{
          exporter: {:otel_exporter_stdout, []}
        }

      For production (sending to Jaeger / Honeycomb / Grafana Tempo / Datadog):

      config :opentelemetry, :processors,
        otel_batch_processor: %{
          exporter: {:opentelemetry_exporter, %{
            endpoints: [{:http, 'localhost', 4317, []}]   # OTLP gRPC
          }}
        }

      Release order matters — exporter must start before SDK:

      releases: [
        my_app: [
          applications: [opentelemetry_exporter: :permanent, opentelemetry: :temporary]
        ]
      ]
    """)
  end

  # -----------------------------------------------------------------------
  # 1. Basic spans
  # -----------------------------------------------------------------------
  defp basic_spans do
    IO.puts("--- Basic Spans ---")

    # with_span — creates a span, sets it as active, ends it when block exits
    # This is the most common pattern — prefer it over start_span/end_span
    result =
      Tracer.with_span "user.fetch" do
        IO.puts("  Inside span 'user.fetch'")
        %{id: 1, name: "Alice"}
      end

    IO.puts("  Result: #{inspect(result)}")

    # with_span with options
    Tracer.with_span "payment.charge", %{
      kind: :client,                          # :internal | :server | :client | :producer | :consumer
      attributes: [amount: 99, currency: "USD"]
    } do
      IO.puts("  Inside span 'payment.charge'")
    end

    # start_span / end_span — manual control
    # Use when span lifetime doesn't map to a lexical block
    span_ctx = Tracer.start_span("manual.span")
    old_ctx = Tracer.set_current_span(span_ctx)
    IO.puts("  Manual span started")
    Tracer.end_span()
    # Restore previous context
    _ = old_ctx

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Nested spans — automatic parent/child
  # -----------------------------------------------------------------------
  defp nested_spans do
    IO.puts("--- Nested Spans (automatic parent/child) ---")

    IO.puts("""
      Nested with_span calls automatically form a parent/child tree.
      The trace visualizer shows them as a flame graph.

        Tracer.with_span "handle_request" do
          user = Tracer.with_span "db.get_user" do
            Repo.get(User, 1)
          end

          posts = Tracer.with_span "db.list_posts" do
            Repo.all(from p in Post, where: p.user_id == ^user.id)
          end

          # "db.get_user" and "db.list_posts" appear as children of
          # "handle_request" in Jaeger / Tempo / Honeycomb
        end

      The active span propagates through with_span automatically.
      You only need manual context attachment for async Tasks (see below).
    """)
  end

  # -----------------------------------------------------------------------
  # 3. Attributes and events
  # -----------------------------------------------------------------------
  defp attributes_and_events do
    IO.puts("--- Attributes and Events ---")

    Tracer.with_span "enriched.operation" do
      # set_attribute — add a single key/value to the current span
      # Supported types: string, integer, float, boolean, list of those
      Tracer.set_attribute("http.method", "GET")
      Tracer.set_attribute("http.status_code", 200)
      Tracer.set_attribute("cache.hit", true)

      # set_attributes — batch version (map or keyword list)
      Tracer.set_attributes(%{
        "db.system" => "postgresql",
        "db.name" => "myapp_prod",
        "net.peer.name" => "db.internal"
      })

      # add_event — a timestamped annotation on the span
      # Good for "this happened at this point", not for numeric values
      Tracer.add_event("cache_miss", %{key: "user:1:profile"})
      Process.sleep(5)
      Tracer.add_event("db_query_complete", %{rows: 1, duration_ms: 5})

      IO.puts("  Span has attributes and events")
    end

    # Direct Span API (when you have an explicit span_ctx)
    span_ctx = Tracer.start_span("explicit.span")
    Span.set_attribute(span_ctx, "explicit.key", "value")
    Span.add_event(span_ctx, "something_happened", %{detail: "info"})
    Span.set_status(span_ctx, :ok)
    Span.end_span(span_ctx)

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Error handling
  # -----------------------------------------------------------------------
  defp error_handling do
    IO.puts("--- Error Handling ---")

    IO.puts("""
      Mark spans as failed and record exceptions:

        Tracer.with_span "risky.operation" do
          result = external_api_call()

          case result do
            {:ok, data} ->
              Tracer.set_status(:ok)
              data

            {:error, reason} ->
              Tracer.set_status(:error, "External API failed: \#{inspect(reason)}")
              raise "API error: \#{inspect(reason)}"
          end
        rescue
          e ->
            # record_exception adds exception.type, exception.message,
            # exception.stacktrace as span attributes (OTel semantic convention)
            Tracer.record_exception(e, __STACKTRACE__)
            Tracer.set_status(:error, Exception.message(e))
            reraise e, __STACKTRACE__
        end

      Status codes:
        :unset  — default, no explicit outcome set
        :ok     — explicit success (overrides :unset)
        :error  — operation failed

      Note: status :ok only makes sense when you explicitly want to signal
      success — the default :unset already means "no problem observed".
      Always set :error on failures; it changes how tools color the span.
    """)
  end

  # -----------------------------------------------------------------------
  # 5. Context propagation across processes
  # -----------------------------------------------------------------------
  defp context_propagation do
    IO.puts("--- Context Propagation (Tasks / GenServers) ---")

    IO.puts("""
      Context is stored in the PROCESS DICTIONARY.
      Spawned processes start with an empty context — spans become orphaned.

      Wrong — span in Task becomes a root span, not child of parent:
        Tracer.with_span "parent" do
          Task.async(fn ->
            Tracer.with_span "child" do   # ← orphan! no parent
              do_work()
            end
          end)
        end

      Right — capture and attach context before spawning:
        Tracer.with_span "parent" do
          ctx = OpenTelemetry.Ctx.get_current()

          Task.async(fn ->
            OpenTelemetry.Ctx.attach(ctx)   # ← restores the trace context

            Tracer.with_span "child" do     # ← now correctly parented
              do_work()
            end
          end)
          |> Task.await()
        end

      For GenServer — pass context in the message:
        def handle_cast({:process, data, otel_ctx}, state) do
          OpenTelemetry.Ctx.attach(otel_ctx)

          Tracer.with_span "process_job" do
            do_work(data)
          end

          {:noreply, state}
        end

        # Caller:
        otel_ctx = OpenTelemetry.Ctx.get_current()
        GenServer.cast(pid, {:process, data, otel_ctx})

      For HTTP (cross-service propagation):
        # Outbound request — inject trace headers
        headers = :otel_propagator_text_map.inject([])
        Req.get!(url, headers: headers)

        # Inbound request — extract trace headers (Phoenix does this automatically
        # via opentelemetry_phoenix)
        :otel_propagator_text_map.extract(conn.req_headers)
    """)
  end

  # -----------------------------------------------------------------------
  # 6. Instrumentation packages
  # -----------------------------------------------------------------------
  defp instrumentation_packages do
    IO.puts("--- Instrumentation Packages (from opentelemetry-erlang-contrib) ---")

    IO.puts("""
      Drop-in tracing for common libraries — no code changes needed:

      {:opentelemetry_ecto,    "~> 2.0"}    # every Ecto query → span
      {:opentelemetry_phoenix, "~> 1.0"}    # Phoenix request/controller → span
      {:opentelemetry_req,     "~> 0.1"}    # Req HTTP client calls → span
      {:opentelemetry_oban,    "~> 0.1"}    # Oban jobs → span
      {:opentelemetry_bandit,  "~> 0.1"}    # Bandit HTTP server
      {:opentelemetry_finch,   "~> 0.1"}    # Finch HTTP client
      {:opentelemetry_redix,   "~> 0.1"}    # Redis (Redix)
      {:opentelemetry_broadway,"~> 0.1"}    # Broadway pipeline stages

      Setup (in application.ex):
        def start(_type, _args) do
          OpentelemetryEcto.setup([:my_app, :repo])
          OpentelemetryPhoenix.setup(adapter: :cowboy2)
          # ...
        end

      Once set up, every Ecto query and Phoenix request generates spans
      automatically with semantic convention attributes (db.statement,
      http.method, http.route, etc.).
    """)
  end

  # -----------------------------------------------------------------------
  # 7. Configuration reference
  # -----------------------------------------------------------------------
  defp configuration_reference do
    IO.puts("--- Configuration Reference ---")

    IO.puts("""
      ## config/config.exs (development — print to stdout)

      config :opentelemetry, :processors,
        otel_batch_processor: %{
          exporter: {:otel_exporter_stdout, []}
        }

      ## config/releases.exs (production — OTLP gRPC to local collector)

      config :opentelemetry, :processors,
        otel_batch_processor: %{
          exporter: {:opentelemetry_exporter, %{
            endpoints: [{:http, 'localhost', 4317, []}]
          }}
        }

      ## OTLP HTTP (port 4318) instead of gRPC (port 4317)

      config :opentelemetry, :processors,
        otel_batch_processor: %{
          exporter: {:opentelemetry_exporter, %{
            endpoints: ["http://localhost:4318"],
            protocol: :http_protobuf
          }}
        }

      ## Resource attributes (identify this service in the backend)

      config :opentelemetry, :resource,
        service: [name: "my_app", version: "1.2.3"],
        deployment: [environment: "production"]

      ## Sampling (reduce volume in high-traffic services)

      config :opentelemetry,
        sampler: {:otel_sampler_trace_id_ratio_based, 0.1}  # 10% of traces
        # or:
        # sampler: :otel_sampler_always_on    (100%, default)
        # sampler: :otel_sampler_always_off   (0%, disable)

      ## Popular SaaS backends

      # Honeycomb
      config :opentelemetry, :processors,
        otel_batch_processor: %{
          exporter: {:opentelemetry_exporter, %{
            endpoints: [{:https, 'api.honeycomb.io', 443, []}],
            headers: [{"x-honeycomb-team", System.fetch_env!("HONEYCOMB_API_KEY")}]
          }}
        }

      # Grafana Cloud
      config :opentelemetry, :processors,
        otel_batch_processor: %{
          exporter: {:opentelemetry_exporter, %{
            endpoints: [{:https, 'otlp-gateway-prod-us-east-0.grafana.net', 443, []}],
            headers: [{"authorization", "Basic \#{System.fetch_env!("GRAFANA_TOKEN")}"}]
          }}
        }
    """)
  end
end
