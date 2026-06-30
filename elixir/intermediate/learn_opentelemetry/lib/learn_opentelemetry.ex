defmodule LearnOpentelemetry do
  @moduledoc """
  OpenTelemetry v1.7 — Distributed tracing for Elixir/OTP.

  Traces follow a request as it flows through processes, services, and time.

  Key concepts:
    Trace   — the full journey of one request (a tree of spans)
    Span    — one unit of work: name, timestamps, attributes, events, status
    Context — carries the active trace across process/service boundaries

  Three-package split:
    opentelemetry_api  — macros + types only (zero cost if no SDK present)
    opentelemetry      — SDK: processors, samplers, resource detection
    opentelemetry_exporter — OTLP protocol (sends to Jaeger, Honeycomb, etc.)

  For this lesson, configure stdout exporter so spans are visible:

    # config/config.exs
    config :opentelemetry, :processors,
      otel_batch_processor: %{exporter: {:otel_exporter_stdout, []}}

  deps:
    {:opentelemetry_api,      "~> 1.5"}
    {:opentelemetry,          "~> 1.7"}
    {:opentelemetry_exporter, "~> 1.10"}
  """

  require OpenTelemetry.Tracer, as: Tracer
  alias OpenTelemetry.Span

  def run do
    IO.puts("\n=== OpenTelemetry: Distributed Tracing ===\n")

    basic_spans()
    nested_spans()
    attributes_and_events()
    error_handling()
    manual_span_control()
    context_propagation()
    instrumentation_packages()
    production_config()
  end

  # -----------------------------------------------------------------------
  # 1. Basic spans — with_span is the primary API
  # -----------------------------------------------------------------------
  defp basic_spans do
    IO.puts("--- Basic Spans ---")

    # with_span/2,3 — creates span, sets it active, ends it when block exits
    # Return value of the block passes through
    user =
      Tracer.with_span "db.get_user" do
        # Anything here runs inside the span
        Process.sleep(2)  # simulate work
        %{id: 1, name: "Alice"}
      end

    IO.puts("with_span result: #{inspect(user)}")

    # with_span with start options
    Tracer.with_span "http.client", %{
      kind: :client,   # :internal | :server | :client | :producer | :consumer
      attributes: %{"http.method" => "GET", "http.url" => "https://api.example.com/users"}
    } do
      Process.sleep(1)
    end

    IO.puts("Spans emitted (check stdout exporter output above)")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Nested spans — automatic parent/child relationship
  # -----------------------------------------------------------------------
  defp nested_spans do
    IO.puts("--- Nested Spans (parent/child tree) ---")

    # The active span propagates automatically into nested with_span calls
    Tracer.with_span "handle_request" do
      Tracer.set_attribute("http.route", "/users/:id")

      user = Tracer.with_span "db.get_user" do
        Tracer.set_attribute("db.system", "postgresql")
        Tracer.set_attribute("db.statement", "SELECT * FROM users WHERE id = $1")
        Process.sleep(3)
        %{id: 1, name: "Alice"}
      end

      _posts = Tracer.with_span "db.list_posts" do
        Tracer.set_attribute("db.statement", "SELECT * FROM posts WHERE user_id = $1")
        Process.sleep(2)
        []
      end

      IO.puts("Nested spans for user: #{user.name}")
      # Trace visualizer (Jaeger/Honeycomb) shows:
      #   handle_request (5ms)
      #   ├── db.get_user  (3ms)
      #   └── db.list_posts (2ms)
    end

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. Attributes and events
  # -----------------------------------------------------------------------
  defp attributes_and_events do
    IO.puts("--- Attributes and Events ---")

    Tracer.with_span "payment.process" do
      # set_attribute — add key/value metadata to the current span
      # Types: string, integer, float, boolean, list of those
      Tracer.set_attribute("payment.amount", 9999)
      Tracer.set_attribute("payment.currency", "USD")
      Tracer.set_attribute("payment.method", "card")

      # set_attributes — batch version
      Tracer.set_attributes(%{
        "payment.processor" => "stripe",
        "payment.idempotency_key" => "pay_abc123"
      })

      # add_event — timestamped annotation (not a numeric measurement)
      Tracer.add_event("validation_complete", %{rules_checked: 5})

      Process.sleep(5)

      Tracer.add_event("charge_submitted", %{
        "processor.request_id" => "req_xyz"
      })

      IO.puts("Payment span attributes and events added")
    end

    # Direct Span module API — when you have an explicit span context
    span_ctx = Tracer.start_span("audit.log")
    Span.set_attribute(span_ctx, "audit.action", "payment.created")
    Span.set_attribute(span_ctx, "audit.user_id", 42)
    Span.add_event(span_ctx, "written_to_db", %{table: "audit_logs"})
    Span.set_status(span_ctx, :ok)
    Span.end_span(span_ctx)
    IO.puts("Direct span API: span_id=#{Span.hex_span_id(span_ctx)}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Error handling — mark spans as failed, record exceptions
  # -----------------------------------------------------------------------
  defp error_handling do
    IO.puts("--- Error Handling ---")

    # Mark a span as error with a description
    Tracer.with_span "external.api_call" do
      Tracer.set_attribute("http.url", "https://api.example.com/charge")
      result = simulate_api_call()

      case result do
        {:ok, charge_id} ->
          Tracer.set_status(:ok)
          Tracer.set_attribute("charge.id", charge_id)
          IO.puts("API success: #{charge_id}")

        {:error, reason} ->
          Tracer.set_status(:error, "API call failed: #{inspect(reason)}")
          IO.puts("API error span marked: #{inspect(reason)}")
      end
    end

    # Record an exception with full stacktrace
    Tracer.with_span "risky.operation" do
      try do
        raise ArgumentError, "invalid input: nil"
      rescue
        e ->
          # Adds exception.type, exception.message, exception.stacktrace
          # as span attributes (OTel semantic convention)
          Tracer.record_exception(e, __STACKTRACE__)
          Tracer.set_status(:error, Exception.message(e))
          IO.puts("Exception recorded on span: #{Exception.message(e)}")
      end
    end

    IO.puts("")
  end

  defp simulate_api_call, do: {:error, :connection_refused}

  # -----------------------------------------------------------------------
  # 5. Manual span control — start_span / end_span
  # -----------------------------------------------------------------------
  defp manual_span_control do
    IO.puts("--- Manual Span Control ---")

    # Use when the span lifetime doesn't map to a lexical block
    # (e.g. span starts in one GenServer callback, ends in another)
    span_ctx = Tracer.start_span("batch.process")
    _token = Tracer.set_current_span(span_ctx)

    IO.puts("Manual span started: #{Span.hex_span_id(span_ctx)}")

    Span.set_attribute(span_ctx, "batch.size", 100)
    Process.sleep(2)
    Span.add_event(span_ctx, "batch_complete", %{processed: 100, failed: 0})

    # End it explicitly — unlike with_span, this does NOT auto-end
    Span.end_span(span_ctx)
    IO.puts("Manual span ended: is_recording=#{Span.is_recording(span_ctx)}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 6. Context propagation across processes
  # -----------------------------------------------------------------------
  defp context_propagation do
    IO.puts("--- Context Propagation Across Processes ---")

    # Context is stored in the PROCESS DICTIONARY.
    # New processes start with empty context — spans become orphaned roots.

    # Wrong way — the Task's span has no parent:
    Tracer.with_span "parent.wrong" do
      _task = Task.async(fn ->
        # This span is a NEW root trace, not a child of "parent.wrong"
        Tracer.with_span "child.orphaned" do
          :orphaned
        end
      end)
      |> Task.await()
    end
    IO.puts("Wrong: child span is orphaned (separate root trace)")

    # Right way — capture and attach context before spawning:
    Tracer.with_span "parent.correct" do
      ctx = OpenTelemetry.Ctx.get_current()

      result = Task.async(fn ->
        # Attach the parent's context to this new process
        OpenTelemetry.Ctx.attach(ctx)

        Tracer.with_span "child.correct" do
          Tracer.set_attribute("worker.pid", inspect(self()))
          :ok
        end
      end)
      |> Task.await()

      IO.puts("Right: child span correctly parented → #{inspect(result)}")
    end

    # For GenServer — pass context explicitly in the message:
    # def handle_cast({:process, data, otel_ctx}, state) do
    #   OpenTelemetry.Ctx.attach(otel_ctx)
    #   Tracer.with_span "handle_cast.process" do
    #     do_work(data)
    #   end
    #   {:noreply, state}
    # end
    # Caller: GenServer.cast(pid, {:process, data, OpenTelemetry.Ctx.get_current()})

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 7. Instrumentation packages from opentelemetry-erlang-contrib
  # -----------------------------------------------------------------------
  defp instrumentation_packages do
    IO.puts("--- Auto-Instrumentation Packages ---")

    # These are drop-in — add dep, call setup/0, every library call gets a span
    packages = [
      {"opentelemetry_ecto",     "~> 2.0", "every Ecto query → span with db.statement"},
      {"opentelemetry_phoenix",  "~> 1.0", "Phoenix request/controller/LiveView → spans"},
      {"opentelemetry_req",      "~> 0.1", "Req HTTP calls → client span"},
      {"opentelemetry_oban",     "~> 0.1", "Oban job enqueue/execute → spans"},
      {"opentelemetry_bandit",   "~> 0.1", "Bandit HTTP server → server span"},
      {"opentelemetry_finch",    "~> 0.1", "Finch HTTP calls → client span"},
      {"opentelemetry_redix",    "~> 0.1", "Redis via Redix → span"},
      {"opentelemetry_broadway", "~> 0.1", "Broadway pipeline stages → spans"},
    ]

    Enum.each(packages, fn {pkg, ver, desc} ->
      IO.puts("  {:#{pkg}, \"#{ver}\"}  # #{desc}")
    end)

    IO.puts("""

    Setup in Application.start/2:
      OpentelemetryEcto.setup([:my_app, :repo])
      OpentelemetryPhoenix.setup(adapter: :cowboy2)
      # No code changes to your queries/routes needed
    """)
  end

  # -----------------------------------------------------------------------
  # 8. Production configuration reference
  # -----------------------------------------------------------------------
  defp production_config do
    IO.puts("--- Production Config Reference ---")

    IO.puts("""
    # config/config.exs — development (stdout)
    config :opentelemetry, :processors,
      otel_batch_processor: %{exporter: {:otel_exporter_stdout, []}}

    # config/releases.exs — production (OTLP gRPC to local collector)
    config :opentelemetry, :processors,
      otel_batch_processor: %{
        exporter: {:opentelemetry_exporter, %{
          endpoints: [{:http, 'localhost', 4317, []}]
        }}
      }

    # Resource — identifies this service in the backend
    config :opentelemetry, :resource,
      service: [name: "my_app", version: "1.2.3"],
      deployment: [environment: "production"]

    # Sampling — reduce volume in high-traffic services
    config :opentelemetry,
      sampler: {:otel_sampler_trace_id_ratio_based, 0.1}   # 10%

    # mix.exs release config — exporter must start before SDK
    releases: [
      my_app: [
        applications: [opentelemetry_exporter: :permanent, opentelemetry: :temporary]
      ]
    ]

    # Popular SaaS backends just differ in endpoint + headers:
    # Honeycomb: endpoints: [{:https, 'api.honeycomb.io', 443, []}],
    #            headers: [{"x-honeycomb-team", api_key}]
    # Grafana:   endpoints: [{:https, 'otlp-gateway-...grafana.net', 443, []}],
    #            headers: [{"authorization", "Basic \#{token}"}]
    """)
  end
end
