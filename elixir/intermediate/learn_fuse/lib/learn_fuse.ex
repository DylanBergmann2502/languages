defmodule LearnFuse do
  @moduledoc """
  Fuse v2.5 — circuit breaker for Erlang/Elixir.

  A circuit breaker prevents cascading failures: when a dependency
  (DB, API, service) starts failing, the circuit "blows" and calls
  are short-circuited immediately instead of piling up and timing out.

  States:
    :ok     — circuit closed, calls go through
    :blown  — circuit open, calls are rejected immediately

  Three phases (like electrical circuit breakers):
    Closed  → normal operation, failures counted
    Open    → blown, all calls rejected
    Half    → after reset timer, one probe call let through

  Fuse is an Erlang library: use :fuse atoms in Elixir.

  Setup in mix.exs:
    {:fuse, "~> 2.5"}

  In application/0:
    extra_applications: [:fuse]
  """

  require Logger

  def run do
    IO.puts("\n=== Fuse: Circuit Breaker ===\n")

    basic_circuit_breaker()
    fuse_run_helper()
    fault_injection()
    multi_service_example()
  end

  # -----------------------------------------------------------------------
  # 1. Basic circuit breaker
  # -----------------------------------------------------------------------
  defp basic_circuit_breaker do
    IO.puts("--- Basic Circuit Breaker ---")

    fuse_name = :database_fuse

    # install(Name, {Strategy, Refresh})
    # Strategy: {standard, MaxMelts, WindowMs}
    #   → blow if MaxMelts failures happen within WindowMs milliseconds
    # Refresh: {reset, ResetMs}
    #   → after ResetMs, try half-open (one probe)
    :ok = :fuse.install(fuse_name, {{:standard, 3, 10_000}, {:reset, 5_000}})

    IO.puts("Fuse installed: #{fuse_name}")

    # ask(Name, Context) → :ok | :blown | {:error, :not_found}
    # Context: :sync (safe) or :async_dirty (faster, rare race conditions)
    case :fuse.ask(fuse_name, :sync) do
      :ok    -> IO.puts("Circuit closed — proceed with DB call")
      :blown -> IO.puts("Circuit blown — use fallback")
    end

    # melt(Name) — record a failure
    # Call this when your dependency fails
    :fuse.melt(fuse_name)
    :fuse.melt(fuse_name)
    :fuse.melt(fuse_name)
    IO.puts("Melted 3 times (threshold reached)")

    # Now the circuit is blown
    case :fuse.ask(fuse_name, :sync) do
      :ok    -> IO.puts("Still open (unexpected)")
      :blown -> IO.puts("Circuit blown — rejecting calls")
    end

    # reset/1 — manually reset a blown fuse (useful in tests)
    :fuse.reset(fuse_name)
    case :fuse.ask(fuse_name, :sync) do
      :ok    -> IO.puts("After reset: circuit closed again")
      :blown -> IO.puts("Still blown")
    end

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. fuse:run/3 — cleaner API that handles ask + melt together
  # -----------------------------------------------------------------------
  defp fuse_run_helper do
    IO.puts("--- fuse:run/3 (cleaner API) ---")

    :ok = :fuse.install(:api_fuse, {{:standard, 2, 5_000}, {:reset, 3_000}})

    # run(Name, Fun, Context)
    # Fun must return {ok, Result} or {melt, Result}
    # If blown, returns :blown without calling Fun
    result = :fuse.run(:api_fuse, fn ->
      # Simulate a successful API call
      {:ok, %{status: 200, body: "data"}}
    end, :sync)

    IO.puts("Successful call: #{inspect(result)}")

    # Simulate failures
    fail_call = fn ->
      :fuse.run(:api_fuse, fn ->
        # Simulate timeout/error
        {:melt, {:error, :timeout}}
      end, :sync)
    end

    IO.puts("Failure 1: #{inspect(fail_call.())}")
    IO.puts("Failure 2: #{inspect(fail_call.())}")

    # Now blown
    IO.puts("After 2 failures: #{inspect(fail_call.())}")

    :fuse.reset(:api_fuse)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. Fault injection for testing
  # -----------------------------------------------------------------------
  defp fault_injection do
    IO.puts("--- Fault Injection Strategy ---")

    # {fault_injection, Rate, MaxR, MaxT}
    # Rate: 0.0–1.0 probability of injecting a fault on each ask
    # Useful for chaos testing — inject faults at known rate
    :ok = :fuse.install(
      :chaos_fuse,
      {{:fault_injection, 0.5, 10, 60_000}, {:reset, 1_000}}
    )

    results = Enum.map(1..10, fn _ ->
      :fuse.ask(:chaos_fuse, :sync)
    end)

    ok_count    = Enum.count(results, &(&1 == :ok))
    blown_count = Enum.count(results, &(&1 == :blown))
    IO.puts("10 asks with 50% fault injection: #{ok_count} ok, #{blown_count} blown")

    :fuse.reset(:chaos_fuse)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Real-world pattern: multiple fuses per service
  # -----------------------------------------------------------------------
  defp multi_service_example do
    IO.puts("--- Multi-Service Circuit Breaker Pattern ---")

    services = [
      {:payment_service,  {{:standard, 5, 30_000}, {:reset, 60_000}}},
      {:inventory_service, {{:standard, 3, 10_000}, {:reset, 30_000}}},
      {:email_service,    {{:standard, 10, 60_000}, {:reset, 120_000}}}
    ]

    # Install one fuse per external dependency
    Enum.each(services, fn {name, opts} ->
      :fuse.install(name, opts)
    end)

    # Wrapper that integrates fuse with your service calls
    call_service = fn name, work_fn, fallback_fn ->
      case :fuse.ask(name, :sync) do
        :ok ->
          try do
            result = work_fn.()
            {:ok, result}
          rescue
            e ->
              :fuse.melt(name)
              Logger.warning("#{name} failed: #{inspect(e)}, melt recorded")
              {:fallback, fallback_fn.()}
          end
        :blown ->
          Logger.info("#{name} circuit blown, using fallback immediately")
          {:fallback, fallback_fn.()}
      end
    end

    # Use it
    IO.puts(inspect(call_service.(:payment_service,
      fn -> %{transaction_id: "txn_123", status: :approved} end,
      fn -> %{error: :service_unavailable} end
    )))

    # circuit_disable/1 — manually blow a fuse (e.g. during maintenance)
    :fuse.circuit_disable(:email_service)
    IO.puts("email_service disabled: #{inspect(:fuse.ask(:email_service, :sync))}")

    # circuit_enable/1 — re-enable
    :fuse.circuit_enable(:email_service)
    IO.puts("email_service enabled: #{inspect(:fuse.ask(:email_service, :sync))}")

    # Clean up
    Enum.each(services, fn {name, _} -> :fuse.remove(name) end)
    IO.puts("")
  end
end
