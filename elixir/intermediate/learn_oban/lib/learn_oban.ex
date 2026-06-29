defmodule LearnOban do
  @moduledoc """
  Oban v2.23 — persistent job queue for Elixir.

  Oban stores jobs in a database (Postgres, SQLite, MySQL) and executes
  them in supervised worker processes. Unlike Quantum (cron-style),
  Oban gives you:
    - Persistence across restarts
    - Automatic retries with backoff
    - Exactly-once execution (uniqueness constraints)
    - Job prioritization
    - Scheduled / delayed execution
    - Dead letter queue (discarded jobs)
    - Web UI (Oban.Web, separate package)

  Setup in mix.exs:
    {:oban, "~> 2.23"},
    {:ecto_sqlite3, "~> 0.18"}  # or {:postgrex, ...} for Postgres

  Requires a database and Ecto repo.
  """

  def run do
    IO.puts("\n=== Oban: Persistent Job Queue ===\n")

    worker_definition()
    job_insertion()
    job_options()
    uniqueness()
    scheduling()
    error_handling()
    testing_pattern()
    configuration()
  end

  # -----------------------------------------------------------------------
  # 1. Defining workers
  # -----------------------------------------------------------------------
  defp worker_definition do
    IO.puts("--- Defining Workers ---")

    IO.puts("""
    defmodule MyApp.Workers.SendEmail do
      use Oban.Worker,
        queue: :mailers,        # which queue to run in
        max_attempts: 5,        # retry up to 5 times (default: 20)
        priority: 0,            # 0 (highest) to 9 (lowest), default: 0
        tags: ["email"],        # for filtering/monitoring
        unique: [               # uniqueness options (see below)
          period: 300,          # unique within 5 minutes
          fields: [:args]       # uniqueness based on args
        ]

      @impl Oban.Worker
      def perform(%Oban.Job{args: %{"user_id" => user_id, "template" => template}}) do
        # Your actual work here
        user = MyApp.Repo.get!(MyApp.User, user_id)
        MyApp.Mailer.send(user.email, template)

        # Return values:
        :ok                          # success
        {:ok, result}                # success with result
        {:error, reason}             # failure, retry if attempts remain
        {:cancel, reason}            # cancel, no more retries
        {:snooze, 300}               # retry in 300 seconds
        {:snooze, {1, :hour}}        # retry in 1 hour
      end
    end

    # Simpler worker (args accessed via pattern or Map.get)
    defmodule MyApp.Workers.ProcessImage do
      use Oban.Worker, queue: :media, max_attempts: 3

      @impl Oban.Worker
      def perform(%Oban.Job{args: args, attempt: attempt}) do
        image_id = args["image_id"]
        IO.puts("Processing image \#{image_id}, attempt \#{attempt}")
        :ok
      end
    end
    """)
  end

  # -----------------------------------------------------------------------
  # 2. Inserting jobs
  # -----------------------------------------------------------------------
  defp job_insertion do
    IO.puts("--- Inserting Jobs ---")

    IO.puts("""
    # Basic insert
    %{user_id: 123, template: "welcome"}
    |> MyApp.Workers.SendEmail.new()
    |> Oban.insert()
    # Returns: {:ok, %Oban.Job{}} or {:error, changeset}

    # Bang version (raises on failure)
    %{image_id: 456}
    |> MyApp.Workers.ProcessImage.new()
    |> Oban.insert!()

    # Insert many at once (in a single DB call)
    jobs = Enum.map(user_ids, fn id ->
      MyApp.Workers.SendEmail.new(%{user_id: id, template: "newsletter"})
    end)
    Oban.insert_all(jobs)

    # Inside an Ecto transaction (atomically queue job with DB change)
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:user, User.changeset(%User{}, attrs))
    |> Oban.insert(:welcome_email, fn %{user: user} ->
      MyApp.Workers.SendEmail.new(%{user_id: user.id, template: "welcome"})
    end)
    |> MyApp.Repo.transaction()
    """)
  end

  # -----------------------------------------------------------------------
  # 3. Job options
  # -----------------------------------------------------------------------
  defp job_options do
    IO.puts("--- Job Options ---")

    IO.puts("""
    # Options passed to .new/2:

    MyApp.Workers.SendEmail.new(%{user_id: 1}, [
      queue:        :urgent,           # override queue
      max_attempts: 10,                # override retry count
      priority:     1,                 # 0-9, lower = higher priority
      scheduled_at: DateTime.utc_now() |> DateTime.add(3600, :second),
      # OR:
      schedule_in:  3600,              # seconds from now
      schedule_in:  {1, :hour},        # cleaner syntax
      tags:         ["critical", "email"],
      meta:         %{source: "api"},  # arbitrary metadata (not used for uniqueness)
    ])

    # Oban.Job struct fields you can inspect:
    %Oban.Job{
      id:           integer(),
      state:        "available" | "scheduled" | "executing" | "retryable" | "completed" | "discarded" | "cancelled",
      queue:        string(),
      worker:       string(),   # "MyApp.Workers.SendEmail"
      args:         map(),
      meta:         map(),
      tags:         [string()],
      errors:       [%{at: datetime, attempt: int, error: string}],
      attempt:      integer(),  # current attempt number (1-based)
      max_attempts: integer(),
      priority:     0..9,
      inserted_at:  datetime(),
      scheduled_at: datetime(),
      attempted_at: datetime() | nil,
      completed_at: datetime() | nil,
      discarded_at: datetime() | nil,
    }
    """)
  end

  # -----------------------------------------------------------------------
  # 4. Uniqueness
  # -----------------------------------------------------------------------
  defp uniqueness do
    IO.puts("--- Uniqueness (Exactly-Once) ---")

    IO.puts("""
    # Prevent duplicate jobs from being inserted.
    # Uniqueness is enforced at the DB level.

    defmodule MyApp.Workers.DailyReport do
      use Oban.Worker,
        queue: :reports,
        unique: [
          period:  86_400,                        # 24h window
          fields:  [:worker, :args],              # what makes a job unique
          states:  [:available, :scheduled,
                    :executing, :retryable],      # which states count as "active"
          keys:    [:report_date]                 # only these args keys matter
        ]

      def perform(%Oban.Job{args: %{"report_date" => date}}) do
        MyApp.Reports.generate(date)
        :ok
      end
    end

    # Insert once per day for the same date:
    %{report_date: "2026-06-29"}
    |> MyApp.Workers.DailyReport.new()
    |> Oban.insert()
    # {:ok, job}

    # Try inserting again with same args:
    %{report_date: "2026-06-29"}
    |> MyApp.Workers.DailyReport.new()
    |> Oban.insert()
    # {:ok, job}  ← same job returned (not a new one)
    # job.conflict? == true
    """)
  end

  # -----------------------------------------------------------------------
  # 5. Scheduled jobs
  # -----------------------------------------------------------------------
  defp scheduling do
    IO.puts("--- Scheduled & Recurring Jobs ---")

    IO.puts("""
    # One-time scheduled job (run in 10 minutes):
    MyApp.Workers.Reminder.new(%{user_id: 1}, schedule_in: {10, :minutes})
    |> Oban.insert()

    # Recurring via cron plugin (add to config):
    config :my_app, Oban,
      plugins: [
        {Oban.Plugins.Cron,
         crontab: [
           {"0 9 * * 1", MyApp.Workers.WeeklyReport},
           {"*/5 * * * *", MyApp.Workers.Heartbeat},
           {"@daily", MyApp.Workers.DailyCleanup, args: %{retain_days: 30}}
         ]}
      ]

    # Pruner plugin (clean up old completed jobs):
    {Oban.Plugins.Pruner, max_age: 3600}  # keep for 1 hour

    # Lifeline plugin (rescue stuck jobs):
    {Oban.Plugins.Lifeline, rescue_after: :timer.minutes(30)}
    """)
  end

  # -----------------------------------------------------------------------
  # 6. Error handling and retries
  # -----------------------------------------------------------------------
  defp error_handling do
    IO.puts("--- Error Handling & Retries ---")

    IO.puts("""
    defmodule MyApp.Workers.Resilient do
      use Oban.Worker, queue: :default, max_attempts: 5

      @impl Oban.Worker
      def perform(%Oban.Job{args: args, attempt: attempt, max_attempts: max}) do
        case do_work(args) do
          {:ok, result} ->
            :ok

          {:error, :temporary} when attempt < max ->
            # Will be retried with exponential backoff:
            # attempt 1: ~16s, attempt 2: ~31s, attempt 3: ~1min, etc.
            {:error, "temporary failure, will retry"}

          {:error, :permanent} ->
            # Cancel immediately — no more retries
            {:cancel, "permanent failure, giving up"}

          {:error, :rate_limited} ->
            # Snooze for 5 minutes (re-schedule, doesn't count as attempt)
            {:snooze, {5, :minutes}}
        end
      end

      # Backoff formula (default): round(trunc(:math.pow(attempt, 4) + 15 + rand()))
      # You can override:
      @impl Oban.Worker
      def backoff(%Oban.Job{attempt: attempt}) do
        # Linear backoff: 30s, 60s, 90s, ...
        attempt * 30
      end
    end
    """)
  end

  # -----------------------------------------------------------------------
  # 7. Testing
  # -----------------------------------------------------------------------
  defp testing_pattern do
    IO.puts("--- Testing with Oban.Testing ---")

    IO.puts("""
    # In test_helper.exs:
    Oban.Testing.start_supervised_oban!(repo: MyApp.Repo)

    # In your test module:
    use Oban.Testing, repo: MyApp.Repo

    test "sends welcome email on user creation" do
      MyApp.Accounts.create_user(%{email: "test@example.com", name: "Alice"})

      assert_enqueued worker: MyApp.Workers.SendEmail,
                      args: %{template: "welcome"}

      # Or with timeout:
      assert_enqueued [worker: MyApp.Workers.SendEmail], 1000
    end

    test "email worker sends the email" do
      perform_job(MyApp.Workers.SendEmail, %{
        user_id: insert(:user).id,
        template: "welcome"
      })
    end

    test "nothing enqueued for invalid users" do
      refute_enqueued worker: MyApp.Workers.SendEmail
    end

    test "all enqueued jobs" do
      all_enqueued(worker: MyApp.Workers.SendEmail)
      |> Enum.each(&assert &1.args["template"] != nil)
    end
    """)
  end

  # -----------------------------------------------------------------------
  # 8. Full configuration
  # -----------------------------------------------------------------------
  defp configuration do
    IO.puts("--- Full Configuration ---")

    IO.puts("""
    # config/config.exs
    config :my_app, Oban,
      repo: MyApp.Repo,
      engine: Oban.Engines.Basic,       # Basic (default), Lite (SQLite), Dolphin (MySQL)
      queues: [
        default:  10,   # 10 concurrent workers
        mailers:  20,
        media:    5,
        critical: 50
      ],
      plugins: [
        {Oban.Plugins.Pruner,   max_age: 3600},
        {Oban.Plugins.Lifeline, rescue_after: :timer.minutes(30)},
        {Oban.Plugins.Cron,
         crontab: [
           {"@daily", MyApp.Workers.DailyCleanup}
         ]}
      ]

    # For SQLite (ecto_sqlite3):
    config :my_app, Oban,
      engine: Oban.Engines.Lite,  # SQLite-specific engine
      repo: MyApp.Repo,
      queues: [default: 10]

    # In Application.start/2:
    children = [
      MyApp.Repo,
      {Oban, Application.fetch_env!(:my_app, Oban)}
    ]

    # Migrations (create oban_jobs table):
    # mix ecto.gen.migration add_oban_jobs_table
    # defmodule MyApp.Repo.Migrations.AddObanJobsTable do
    #   use Ecto.Migration
    #   def up, do: Oban.Migration.up(version: 12)
    #   def down, do: Oban.Migration.down(version: 1)
    # end
    """)
  end
end
