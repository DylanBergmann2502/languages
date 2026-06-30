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
  # 3. Retry and abort from compensation
  # -----------------------------------------------------------------------
  defp retry_and_abort do
    IO.puts("--- Compensation Return Values ---")

    IO.puts("""
      Compensation functions return:
        :ok               — effect undone, continue compensating previous steps
        :abort            — effect undone, stop retrying (unrecoverable)
        {:retry, opts}    — retry the FAILED transaction with backoff
        {:continue, val}  — circuit breaker: skip undo, forward with new value

      Retry options:
        retry_limit: 3         — max attempts (default unlimited)
        base_backoff: 100      — base ms for exponential backoff
        max_backoff: 5_000     — cap on backoff delay
        enable_jitter: true    — randomize delay to avoid thundering herd

      Example — retry with backoff:
        fn reservation, _effects, _opts ->
          case release_reservation(reservation.id) do
            :ok                  -> :ok
            {:error, :not_found} -> :ok      # idempotent — already gone
            {:error, _reason}    ->
              {:retry, [retry_limit: 3, base_backoff: 100, max_backoff: 5_000]}
          end
        end

      Example — abort on unrecoverable error in transaction:
        fn _effects, _opts ->
          case charge_card(card, amount) do
            {:ok, charge}                   -> {:ok, charge}
            {:error, :insufficient_funds}   -> {:abort, :insufficient_funds}
            {:error, reason}                -> {:error, reason}
          end
        end
        # {:abort, reason} stops forward progress AND disables retries
        # Use it when you know retrying won't help

      Example — circuit breaker (continue with fallback value):
        fn _failed_effect, _effects, _opts ->
          # Instead of undoing, provide a safe default and continue forward
          {:continue, %{id: nil, status: :skipped}}
        end
    """)
  end

  # -----------------------------------------------------------------------
  # 4. Async steps
  # -----------------------------------------------------------------------
  defp async_steps do
    IO.puts("--- Async Steps ---")

    IO.puts("""
      Sage.run_async/5 — run a step in a background Task.
      Async steps run in parallel with each other and are awaited
      before the next synchronous step.

        Sage.new()
        |> Sage.run(:user, &fetch_user/2, &noop/3)
        |> Sage.run_async(
             :send_email,
             fn %{user: user}, _opts ->
               EmailService.send_welcome(user.email)
               {:ok, :email_sent}
             end,
             fn _effect, _effects, _opts -> :ok end,
             timeout: 5_000   # wait up to 5s (default: 5000)
           )
        |> Sage.run_async(
             :sync_crm,
             fn %{user: user}, _opts ->
               CRMApi.upsert(user)
               {:ok, :synced}
             end,
             fn _effect, _effects, _opts -> :ok end,
             timeout: 10_000
           )
        |> Sage.run(:finish, &create_record/2, &delete_record/3)
        # ↑ awaits both async steps before running

      Key rule: async steps receive only effects from PRIOR SYNCHRONOUS
      steps, not from other async steps running in parallel.

      Custom supervisor:
        run_async(..., supervisor: MyApp.TaskSupervisor)
    """)
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
  # 6. Quick reference
  # -----------------------------------------------------------------------
  defp reference do
    IO.puts("--- Quick Reference ---")

    IO.puts("""
      Build the pipeline:
        Sage.new()
        |> Sage.run(name, tx_fn)                          # no compensation
        |> Sage.run(name, tx_fn, comp_fn)                 # with compensation
        |> Sage.run_async(name, tx_fn, comp_fn, opts)     # async + compensation
        |> Sage.finally(final_fn)                         # always runs
        |> Sage.with_compensation_error_handler(module)   # handle comp errors

      Execute:
        Sage.execute(sage, opts)         # -> {:ok, last_effect, effects} | {:error, reason}
        Sage.transaction(sage, Repo, opts)  # wraps in Ecto.Repo.transaction

      Transaction fn signature:
        fn effects_so_far, opts ->
          {:ok, value}       # success — value stored in effects[name]
          {:error, reason}   # failure — compensations run
          {:abort, reason}   # failure — compensations run, no retry
        end

      Compensation fn signature:
        fn effect, effects_so_far, opts ->
          :ok
          :abort
          {:retry, [retry_limit: 3, base_backoff: 100, max_backoff: 5_000]}
          {:continue, fallback_value}
        end

      Finally fn signature:
        fn :ok | :error, opts -> any() end   # return ignored

      When to use Sage:
        - Multi-step workflows touching external APIs (payment, email, SMS)
        - Fan-out creates in multiple services
        - Any place where "undo on failure" is currently a manual mess
        - Where Ecto.Multi doesn't work (non-DB side effects)

      Sage vs Ecto.Multi:
        Ecto.Multi  — DB only, automatic rollback via SQL transaction
        Sage        — any side effect, manual compensation, works cross-service
        Sage.transaction(sage, Repo) — both: Sage for side effects, Ecto for DB atomicity
    """)
  end
end
