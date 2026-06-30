defmodule LearnSage do
  @moduledoc """
  Sage v0.6.3 — Distributed transaction / Saga pattern in pure Elixir.

  The Problem: Distributed Transactions
  ======================================
  In a monolith, you wrap everything in one Ecto.Repo.transaction/2 and
  rollback is automatic. In a distributed system (or when steps touch
  external APIs), there's no global transaction coordinator. If step 3 of 5
  fails, you need to manually undo steps 1 and 2 — or leak state.

  The Saga Pattern:
    - Each step has a transaction function (forward) and a compensation function (undo)
    - If any step fails, Sage runs compensations in REVERSE ORDER automatically
    - You define the happy path; Sage handles the cleanup

  Example: Creating a booking
    1. Validate user        ←─ compensation: noop (read-only)
    2. Reserve inventory    ←─ compensation: release_inventory
    3. Charge credit card   ←─ compensation: refund_card
    4. Send email (async)   ←─ compensation: send_cancellation
    5. Create DB record     ←─ compensation: delete_record

  If step 3 fails: compensation 2, then 1 run automatically.
  If step 5 fails: compensation 4, 3, 2, 1 run automatically.

  dep: {:sage, "~> 0.6.3"}
  """

  def run do
    IO.puts("\n=== Sage: Distributed Transaction / Saga Pattern ===\n")

    basic_pipeline()
    compensation_on_failure()
    retry_and_abort()
    async_steps()
    finally_hook()
    reference()
  end

  # -----------------------------------------------------------------------
  # 1. Basic pipeline — happy path
  # -----------------------------------------------------------------------
  defp basic_pipeline do
    IO.puts("--- Basic Pipeline (happy path) ---")

    result =
      Sage.new()
      # Sage.run/2 — no compensation (read-only / noop steps)
      |> Sage.run(:fetch_user, fn _effects, opts ->
        IO.puts("  [1] Fetching user #{opts[:user_id]}")
        {:ok, %{id: opts[:user_id], name: "Alice", email: "alice@example.com"}}
      end)
      # Sage.run/4 — with compensation
      |> Sage.run(
        :reserve_seat,
        fn %{fetch_user: user}, _opts ->
          IO.puts("  [2] Reserving seat for #{user.name}")
          {:ok, %{reservation_id: "RES-001", user_id: user.id}}
        end,
        fn reservation, _effects, _opts ->
          IO.puts("  [COMP] Releasing reservation #{reservation.reservation_id}")
          :ok
        end
      )
      |> Sage.run(
        :create_ticket,
        fn %{fetch_user: user, reserve_seat: res}, _opts ->
          IO.puts("  [3] Creating ticket for #{user.name}, reservation #{res.reservation_id}")
          {:ok, %{ticket_id: "TKT-001", reservation_id: res.reservation_id}}
        end,
        fn ticket, _effects, _opts ->
          IO.puts("  [COMP] Deleting ticket #{ticket.ticket_id}")
          :ok
        end
      )
      # Sage.execute/2 — runs the pipeline, opts passed to all fns
      |> Sage.execute(user_id: 42)

    case result do
      {:ok, last_effect, effects} ->
        IO.puts("  Success! Last effect: #{inspect(last_effect)}")
        IO.puts("  All effects: #{inspect(Map.keys(effects))}")
      {:error, reason} ->
        IO.puts("  Failed: #{inspect(reason)}")
    end

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Compensation runs on failure
  # -----------------------------------------------------------------------
  defp compensation_on_failure do
    IO.puts("--- Compensation on Failure ---")
    IO.puts("  (Step 3 will fail → steps 2 and 1 compensate in reverse)")

    result =
      Sage.new()
      |> Sage.run(
        :step1,
        fn _effects, _opts ->
          IO.puts("  [T1] Creating resource A")
          {:ok, :resource_a}
        end,
        fn effect, _effects, _opts ->
          IO.puts("  [C1] Releasing #{inspect(effect)}")
          :ok
        end
      )
      |> Sage.run(
        :step2,
        fn _effects, _opts ->
          IO.puts("  [T2] Creating resource B")
          {:ok, :resource_b}
        end,
        fn effect, _effects, _opts ->
          IO.puts("  [C2] Releasing #{inspect(effect)}")
          :ok
        end
      )
      |> Sage.run(
        :step3,
        fn _effects, _opts ->
          IO.puts("  [T3] Attempting external API call...")
          {:error, :api_unavailable}
        end,
        fn _effect, _effects, _opts ->
          IO.puts("  [C3] (nothing to clean up — T3 failed before creating anything)")
          :ok
        end
      )
      |> Sage.execute([])

    case result do
      {:ok, _, _} -> IO.puts("  Done.")
      {:error, reason} ->
        IO.puts("  Result: {:error, #{inspect(reason)}} — compensations ran in reverse")
    end

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. Compensation return values — demonstrated with real pipelines
  # -----------------------------------------------------------------------
  defp retry_and_abort do
    IO.puts("--- Compensation Return Values ---")

    # :abort — stop all retrying immediately (unrecoverable failure)
    result =
      Sage.new()
      |> Sage.run(:step1, fn _, _ -> {:ok, :done} end, fn _, _, _ -> :ok end)
      |> Sage.run(
        :charge,
        fn _, _ ->
          IO.puts("  [charge] insufficient funds — aborting")
          {:abort, :insufficient_funds}
        end,
        fn _, _, _ ->
          IO.puts("  [COMP charge] abort — no retry")
          :abort
        end
      )
      |> Sage.execute([])

    IO.puts("  {:abort} result: #{inspect(elem(result, 0))} / #{inspect(elem(result, 1))}")

    # {:retry, opts} — retry the failed transaction with backoff
    # Using a counter in the process dict to simulate transient failure
    Process.put(:attempt, 0)

    result2 =
      Sage.new()
      |> Sage.run(
        :flaky_step,
        fn _, _ ->
          n = Process.get(:attempt) + 1
          Process.put(:attempt, n)
          IO.puts("  [flaky_step] attempt #{n}")
          if n < 3, do: {:error, :transient}, else: {:ok, :success}
        end,
        fn _, _, _ ->
          IO.puts("  [COMP flaky_step] retrying...")
          {:retry, [retry_limit: 5, base_backoff: 10, max_backoff: 100]}
        end
      )
      |> Sage.execute([])

    IO.puts("  {:retry} result: #{inspect(elem(result2, 0))} after #{Process.get(:attempt)} attempts")

    # {:continue, value} — circuit breaker: skip compensation, forward with fallback
    result3 =
      Sage.new()
      |> Sage.run(
        :optional_enrichment,
        fn _, _ ->
          IO.puts("  [enrichment] service down")
          {:error, :service_unavailable}
        end,
        fn _, _, _ ->
          IO.puts("  [COMP enrichment] using fallback, continuing forward")
          {:continue, %{enriched: false, data: %{}}}
        end
      )
      |> Sage.run(:next_step, fn %{optional_enrichment: enrich}, _ ->
        IO.puts("  [next_step] enriched=#{enrich.enriched}")
        {:ok, :done}
      end)
      |> Sage.execute([])

    IO.puts("  {:continue} result: #{inspect(elem(result3, 0))}")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Async steps — run in parallel Tasks
  # -----------------------------------------------------------------------
  defp async_steps do
    IO.puts("--- Async Steps (parallel execution) ---")

    # run_async/5 — execute step in a background Task
    # Multiple async steps run in parallel, awaited before next sync step
    result =
      Sage.new()
      |> Sage.run(:fetch_user, fn _, opts ->
        IO.puts("  [sync] fetch_user #{opts[:user_id]}")
        {:ok, %{id: opts[:user_id], email: "alice@example.com"}}
      end)
      |> Sage.run_async(
        :send_welcome_email,
        fn %{fetch_user: user}, _ ->
          IO.puts("  [async] send_welcome_email to #{user.email}")
          Process.sleep(10)
          {:ok, :email_sent}
        end,
        fn _, _, _ -> :ok end
      )
      |> Sage.run_async(
        :sync_crm,
        fn %{fetch_user: user}, _ ->
          IO.puts("  [async] sync_crm user #{user.id}")
          Process.sleep(5)
          {:ok, :synced}
        end,
        fn _, _, _ -> :ok end
      )
      # This sync step runs AFTER both async steps above are awaited
      |> Sage.run(:create_record, fn effects, _ ->
        IO.puts("  [sync] create_record (async results: #{inspect(Map.keys(effects))})")
        {:ok, :record_created}
      end)
      |> Sage.execute(user_id: 42)

    case result do
      {:ok, _, effects} ->
        IO.puts("  Async pipeline success, effects: #{inspect(Map.keys(effects))}")
        IO.puts("  Note: async steps receive only PRIOR sync effects, not each other's")
      {:error, reason} ->
        IO.puts("  Failed: #{inspect(reason)}")
    end

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Finally hook
  # -----------------------------------------------------------------------
  defp finally_hook do
    IO.puts("--- Finally Hook ---")

    result =
      Sage.new()
      |> Sage.run(:do_work, fn _effects, opts ->
        if opts[:fail], do: {:error, :forced}, else: {:ok, :done}
      end)
      # finally/2 runs regardless of success or failure
      |> Sage.finally(fn status, _opts ->
        IO.puts("  [finally] Pipeline ended with: #{inspect(status)}")
        # return value is ignored — use for logging, metrics, cleanup
      end)
      |> Sage.execute(fail: false)

    IO.puts("  Result: #{inspect(elem(result, 0))}")

    # Also show failure path
    Sage.new()
    |> Sage.run(:do_work, fn _effects, opts ->
      if opts[:fail], do: {:error, :forced}, else: {:ok, :done}
    end)
    |> Sage.finally(fn status, _opts ->
      IO.puts("  [finally] Pipeline ended with: #{inspect(status)}")
    end)
    |> Sage.execute(fail: true)

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 6. Sage API surface — build one of each to show the full interface
  # -----------------------------------------------------------------------
  defp reference do
    IO.puts("--- Full API Surface ---")

    # Build a pipeline using every builder function
    sage =
      Sage.new()
      |> Sage.run(:step_no_comp, fn _, _ -> {:ok, :a} end)
      |> Sage.run(:step_with_comp,
           fn _, _ -> {:ok, :b} end,
           fn _, _, _ -> :ok end)
      |> Sage.run_async(:step_async,
           fn _, _ -> {:ok, :c} end,
           fn _, _, _ -> :ok end,
           timeout: 5_000)
      |> Sage.finally(fn status, _ ->
           IO.puts("  [finally] #{inspect(status)}")
         end)

    IO.puts("Sage struct stages: #{inspect(Enum.map(sage.stages, fn {name, _} -> name end))}")

    # execute/2 — returns {:ok, last_effect, all_effects} | {:error, reason}
    {:ok, last, effects} = Sage.execute(sage, [])
    IO.puts("execute result: last=#{inspect(last)}")
    IO.puts("effects keys: #{inspect(Map.keys(effects))}")

    # Each effect is stored under its step name
    IO.puts("effects[:step_no_comp]   = #{inspect(effects[:step_no_comp])}")
    IO.puts("effects[:step_with_comp] = #{inspect(effects[:step_with_comp])}")
    IO.puts("effects[:step_async]     = #{inspect(effects[:step_async])}")

    IO.puts("""

  When to use Sage vs alternatives:
    Ecto.Multi         — DB-only, automatic SQL rollback. Simpler.
    Sage               — any side effect (APIs, emails, S3), manual compensation.
    Sage.transaction/4 — both: Sage compensations + Ecto DB atomicity.

  Key rules:
    1. Compensation functions must be idempotent (safe to run multiple times)
    2. {:abort} in a tx OR comp stops all retries immediately
    3. async steps receive only effects from prior SYNC steps
    4. finally/2 always runs, even on crashes (errors are logged, not raised)
    """)
  end
end
