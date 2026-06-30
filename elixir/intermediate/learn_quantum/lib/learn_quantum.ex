defmodule LearnQuantum do
  @moduledoc """
  Quantum v3.5 — cron-style in-process job scheduler.

  Quantum schedules tasks using cron expressions. Unlike Oban (DB-backed,
  persistent), Quantum is in-memory — no DB needed, but jobs are lost on restart.

  When to use Quantum vs Oban:
    Quantum — lightweight recurring tasks (heartbeats, cache warming, cleanup).
              No DB dependency. Simple cron semantics.
    Oban    — persistent jobs, retries, exactly-once, complex workflows.

  dep: {:quantum, "~> 3.5"}
  """

  def run do
    IO.puts("\n=== Quantum: Cron Scheduler ===\n")

    start_scheduler()
    runtime_job_management()
    cron_syntax_reference()
    run_strategies()
  end

  # -----------------------------------------------------------------------
  # 1. Start a real Quantum scheduler and configure jobs
  # -----------------------------------------------------------------------
  defp start_scheduler do
    IO.puts("--- Starting Scheduler (live demo) ---")

    # Start the scheduler defined below
    {:ok, _} = LearnQuantum.Scheduler.start_link([])
    IO.puts("Scheduler started: #{inspect(LearnQuantum.Scheduler)}")

    # List compile-time configured jobs (from scheduler config below)
    jobs = LearnQuantum.Scheduler.jobs()
    IO.puts("Configured jobs (#{length(jobs)}):")
    Enum.each(jobs, fn {name, job} ->
      IO.puts("  #{name}: #{inspect(job.schedule)} overlap=#{job.overlap}")
    end)

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Runtime job management — add, pause, resume, delete
  # -----------------------------------------------------------------------
  defp runtime_job_management do
    IO.puts("--- Runtime Job Management ---")

    # Add a job at runtime
    job =
      LearnQuantum.Scheduler.new_job()
      |> Quantum.Job.set_name(:dynamic_job)
      |> Quantum.Job.set_schedule(Crontab.CronExpression.Parser.parse!("* * * * *"))
      |> Quantum.Job.set_task(fn -> IO.puts("  [dynamic_job] tick") end)
      |> Quantum.Job.set_overlap(false)
      |> Quantum.Job.set_state(:active)

    LearnQuantum.Scheduler.add_job(job)
    IO.puts("Added :dynamic_job")

    # find_job/1 — look up a job by name
    found = LearnQuantum.Scheduler.find_job(:dynamic_job)
    IO.puts("Found: #{inspect(found.name)} state=#{found.state}")

    # deactivate_job/1 — pause without deleting
    LearnQuantum.Scheduler.deactivate_job(:dynamic_job)
    paused = LearnQuantum.Scheduler.find_job(:dynamic_job)
    IO.puts("After deactivate: state=#{paused.state}")

    # activate_job/1 — resume
    LearnQuantum.Scheduler.activate_job(:dynamic_job)
    resumed = LearnQuantum.Scheduler.find_job(:dynamic_job)
    IO.puts("After activate: state=#{resumed.state}")

    # delete_job/1 — remove entirely
    LearnQuantum.Scheduler.delete_job(:dynamic_job)
    IO.puts("After delete: #{inspect(LearnQuantum.Scheduler.find_job(:dynamic_job))}")

    # jobs/0 — list all current jobs
    all = LearnQuantum.Scheduler.jobs()
    IO.puts("All jobs after delete: #{Enum.map(all, fn {n, _} -> n end) |> inspect()}")

    # delete_all_jobs/0
    LearnQuantum.Scheduler.delete_all_jobs()
    IO.puts("After delete_all: #{length(LearnQuantum.Scheduler.jobs())} jobs")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. Cron expression syntax reference
  # -----------------------------------------------------------------------
  defp cron_syntax_reference do
    IO.puts("--- Cron Expression Syntax ---")

    # Parse and display some cron expressions
    expressions = [
      {"* * * * *",       "every minute"},
      {"*/15 * * * *",    "every 15 minutes"},
      {"0 * * * *",       "every hour at :00"},
      {"0 9 * * *",       "daily at 9am"},
      {"0 9 * * 1",       "every Monday at 9am"},
      {"0 9 * * 1-5",     "weekdays at 9am"},
      {"0 9,17 * * *",    "at 9am and 5pm daily"},
      {"0 0 1 * *",       "first of every month"},
      {"*/5 9-17 * * 1-5", "every 5m during business hours"},
    ]

    IO.puts("  Expression              Description")
    IO.puts("  " <> String.duplicate("-", 55))
    Enum.each(expressions, fn {expr, desc} ->
      case Crontab.CronExpression.Parser.parse(expr) do
        {:ok, _parsed} ->
          IO.puts("  #{String.pad_trailing(expr, 24)} #{desc}")
        {:error, _} ->
          IO.puts("  #{expr} [parse error]")
      end
    end)

    # Shortcuts
    IO.puts("\n  Shortcuts:")
    shortcuts = [
      {"@yearly",   "0 0 1 1 *"},
      {"@monthly",  "0 0 1 * *"},
      {"@weekly",   "0 0 * * 0"},
      {"@daily",    "0 0 * * *"},
      {"@hourly",   "0 * * * *"},
      {"@reboot",   "run once on scheduler start"},
    ]
    Enum.each(shortcuts, fn {shortcut, equiv} ->
      IO.puts("  #{String.pad_trailing(shortcut, 12)} → #{equiv}")
    end)

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Run strategies (cluster-aware scheduling)
  # -----------------------------------------------------------------------
  defp run_strategies do
    IO.puts("--- Run Strategies (Cluster-Aware) ---")

    strategies = [
      {"Quantum.RunStrategy.All",      "run on EVERY node (default)"},
      {"Quantum.RunStrategy.Random",   "pick ONE node at random from :cluster or :node"},
      {"Quantum.RunStrategy.NodeList", "run only on specific named nodes"},
    ]

    IO.puts("  Strategy                          Behavior")
    IO.puts("  " <> String.duplicate("-", 60))
    Enum.each(strategies, fn {mod, desc} ->
      IO.puts("  #{String.pad_trailing(mod, 34)} #{desc}")
    end)

    IO.puts("""

  Config examples:

    # Global: run on one random cluster node
    config :my_app, MyApp.Scheduler,
      run_strategy: {Quantum.RunStrategy.Random, :cluster}

    # Per-job override: run on specific nodes only
    report: [
      schedule: "@daily",
      task: {MyApp.Jobs.Report, :run, []},
      run_strategy: {Quantum.RunStrategy.NodeList, [:"worker@host1"]},
      overlap: false
    ]

  Tip: combine run_strategy: Random + overlap: false for exactly-once
  execution across a cluster (only one node runs, no concurrent runs).
    """)
  end
end

# ============================================================
# Quantum scheduler module
# ============================================================
defmodule LearnQuantum.Scheduler do
  use Quantum, otp_app: :learn_quantum

  # Compile-time jobs are set via config — but we can also add at runtime.
  # For the lesson, we rely on runtime API since we have no config file.
end
