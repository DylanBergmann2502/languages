defmodule LearnQuantum do
  @moduledoc """
  Quantum v3.5 — cron-style job scheduler for Elixir.

  Quantum schedules in-process tasks using cron expressions.
  Unlike Oban (which is DB-backed and survives restarts),
  Quantum is in-memory — jobs are defined at compile time or
  added at runtime, but are lost on node restart unless you
  add a persistent storage adapter.

  When to use Quantum vs Oban:
    Quantum — lightweight cron-style scheduling, no DB needed,
              simple recurring tasks (heartbeats, cleanup, reports)
    Oban    — job queue with persistence, retries, deduplication,
              complex workflows, exactly-once execution

  Setup in mix.exs:
    {:quantum, "~> 3.5"}
  """

  def run do
    IO.puts("\n=== Quantum: Cron Scheduler ===\n")

    scheduler_setup()
    cron_syntax()
    runtime_job_management()
    run_strategies()
  end

  # -----------------------------------------------------------------------
  # 1. Scheduler setup
  # -----------------------------------------------------------------------
  defp scheduler_setup do
    IO.puts("--- Scheduler Setup ---")

    IO.puts("""
    # Step 1: Create your scheduler module
    defmodule MyApp.Scheduler do
      use Quantum, otp_app: :my_app
    end

    # Step 2: Add to supervision tree
    defmodule MyApp.Application do
      def start(_type, _args) do
        children = [
          MyApp.Scheduler,
          # ... other children
        ]
        Supervisor.start_link(children, strategy: :one_for_one)
      end
    end

    # Step 3: Configure jobs in config.exs
    config :my_app, MyApp.Scheduler,
      timezone: "UTC",
      overlap: false,    # prevent overlapping runs (default: true)
      debug_logging: false,
      jobs: [
        # Format: {cron_expression, {Module, :function, [args]}}
        {"@daily",    {MyApp.Jobs.Backup,  :run, []}},
        {"@hourly",   {MyApp.Jobs.Cleanup, :run, []}},
        {"*/5 * * * *", {MyApp.Jobs.Heartbeat, :ping, []}},

        # Named job (can be managed at runtime)
        report: [
          schedule: "0 9 * * 1",   # Monday 9am
          task: {MyApp.Jobs.Report, :weekly, []},
          timezone: "America/New_York",
          overlap: false
        ],

        # Anonymous function job
        [
          schedule: "* * * * *",
          task: fn -> Logger.info("Tick") end
        ]
      ]
    """)
  end

  # -----------------------------------------------------------------------
  # 2. Cron expression syntax
  # -----------------------------------------------------------------------
  defp cron_syntax do
    IO.puts("--- Cron Expression Syntax ---")

    IO.puts("""
    Standard cron: "minute hour day_of_month month day_of_week"

    ┌─────────────── minute        (0-59)
    │ ┌───────────── hour          (0-23)
    │ │ ┌─────────── day of month  (1-31)
    │ │ │ ┌───────── month         (1-12 or JAN-DEC)
    │ │ │ │ ┌─────── day of week   (0-6 or SUN-SAT, 0=Sunday)
    │ │ │ │ │
    * * * * *

    Examples:
      "* * * * *"        every minute
      "*/15 * * * *"     every 15 minutes
      "0 * * * *"        every hour (at :00)
      "0 9 * * *"        every day at 9am
      "0 9 * * 1"        every Monday at 9am
      "0 9 * * 1-5"      every weekday at 9am
      "0 9,17 * * *"     at 9am and 5pm daily
      "0 0 1 * *"        first day of every month at midnight
      "0 0 1 1 *"        January 1st at midnight (yearly)
      "*/5 9-17 * * 1-5" every 5 minutes during business hours

    Shortcuts:
      "@yearly"    → "0 0 1 1 *"
      "@monthly"   → "0 0 1 * *"
      "@weekly"    → "0 0 * * 0"
      "@daily"     → "0 0 * * *"
      "@midnight"  → "0 0 * * *"
      "@hourly"    → "0 * * * *"
      "@reboot"    → run once on scheduler start
    """)
  end

  # -----------------------------------------------------------------------
  # 3. Runtime job management
  # -----------------------------------------------------------------------
  defp runtime_job_management do
    IO.puts("--- Runtime Job Management ---")

    IO.puts("""
    # All job management goes through your Scheduler module:

    # Add a job at runtime
    job = MyApp.Scheduler.new_job()
    |> Quantum.Job.set_name(:dynamic_report)
    |> Quantum.Job.set_schedule(Crontab.CronExpression.Parser.parse!("0 * * * *"))
    |> Quantum.Job.set_task({MyApp.Jobs.HourlyReport, :run, []})
    |> Quantum.Job.set_overlap(false)
    |> Quantum.Job.set_timezone("Europe/London")
    |> Quantum.Job.set_state(:active)

    MyApp.Scheduler.add_job(job)

    # Find a job
    MyApp.Scheduler.find_job(:report)

    # Deactivate (pause) without deleting
    MyApp.Scheduler.deactivate_job(:report)

    # Reactivate
    MyApp.Scheduler.activate_job(:report)

    # Delete
    MyApp.Scheduler.delete_job(:report)

    # Delete ALL jobs
    MyApp.Scheduler.delete_all_jobs()

    # List all jobs
    MyApp.Scheduler.jobs()
    # Returns: [{name, %Quantum.Job{}}]
    """)
  end

  # -----------------------------------------------------------------------
  # 4. Run strategies
  # -----------------------------------------------------------------------
  defp run_strategies do
    IO.puts("--- Run Strategies (Cluster-Aware Scheduling) ---")

    IO.puts("""
    # By default jobs run on every node. In a cluster you usually
    # want a job to run on exactly ONE node.

    config :my_app, MyApp.Scheduler,
      run_strategy: {Quantum.RunStrategy.Random, :cluster}
    # :cluster = pick a random node from the whole cluster
    # :node    = pick a random node from the current node's peers

    # Per-job override:
    report: [
      schedule: "@daily",
      task: {MyApp.Jobs.Report, :run, []},
      run_strategy: {Quantum.RunStrategy.Random, :cluster},
      overlap: false
    ]

    # Available strategies:
    #   Quantum.RunStrategy.All    — run on ALL nodes (default)
    #   Quantum.RunStrategy.Random — pick ONE node at random
    #   Quantum.RunStrategy.NodeList — run on specific named nodes

    # NodeList example:
    run_strategy: {Quantum.RunStrategy.NodeList, [:"worker@host1", :"worker@host2"]}

    # Tip: combine with overlap: false to prevent double-runs
    # even if the scheduler starts up on multiple nodes simultaneously
    """)
  end
end
