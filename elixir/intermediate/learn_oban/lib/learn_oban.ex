defmodule LearnOban do
  @moduledoc """
  Oban v2.23 — persistent job queue backed by a database.

  Stores jobs in a DB (Postgres / SQLite / MySQL) and executes them in
  supervised worker processes. Survives restarts, retries on failure, and
  guarantees exactly-once execution via DB-level uniqueness.

  Advantages over Quantum (cron):
    - Persistence — jobs survive node restarts
    - Automatic retries with exponential backoff
    - Uniqueness constraints (no duplicate jobs)
    - Priority queues, scheduling, dead-letter queue
    - Web UI via Oban.Web (separate package)

  deps:
    {:oban,         "~> 2.23"}
    {:ecto_sqlite3, "~> 0.18"}

  This lesson uses an in-memory SQLite DB + Oban.Engines.Lite so everything
  runs standalone without any external services.
  """

  def run do
    IO.puts("\n=== Oban: Persistent Job Queue ===\n")

    # Spin up the Repo + Oban once for all demos
    start_infrastructure()

    basic_worker_demo()
    return_values_demo()
    scheduling_demo()
    uniqueness_demo()
    job_struct_demo()
    testing_pattern()
    configuration_reference()
  end

  defp start_infrastructure do
    # Start the in-memory SQLite repo
    {:ok, _} = LearnOban.Repo.start_link()

    # Run Oban's migrations on the in-memory DB
    Oban.Migration.up(repo: LearnOban.Repo, version: 12)

    # Start Oban with SQLite engine
    {:ok, _} = Oban.start_link(
      repo: LearnOban.Repo,
      engine: Oban.Engines.Lite,
      queues: [default: 5, mailers: 2, media: 1]
    )

    IO.puts("Oban + SQLite started\n")
  end

  # -----------------------------------------------------------------------
  # 1. Basic worker and job insertion
  # -----------------------------------------------------------------------
  defp basic_worker_demo do
    IO.puts("--- Basic Worker (insert and execute) ---")

    # Insert a job
    {:ok, job} =
      %{user_id: 1, template: "welcome"}
      |> LearnOban.Workers.SendEmail.new()
      |> Oban.insert()

    IO.puts("Inserted job id=#{job.id} state=#{job.state} queue=#{job.queue}")

    # Oban executes jobs in background — wait a moment
    Process.sleep(200)

    # Check job state in DB
    job = LearnOban.Repo.get(Oban.Job, job.id)
    IO.puts("Job state after execution: #{job.state}")

    # insert! — raises on failure
    job2 =
      %{image_id: 99}
      |> LearnOban.Workers.ProcessImage.new()
      |> Oban.insert!()

    IO.puts("Inserted job2 id=#{job2.id}")

    # insert_all — batch insert in one DB call
    jobs =
      Enum.map([10, 11, 12], fn id ->
        LearnOban.Workers.SendEmail.new(%{user_id: id, template: "newsletter"})
      end)

    {count, _} = Oban.insert_all(jobs)
    IO.puts("Batch inserted #{count} jobs")

    Process.sleep(300)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. perform/1 return values
  # -----------------------------------------------------------------------
  defp return_values_demo do
    IO.puts("--- perform/1 Return Values ---")

    # :ok → success, job moves to :completed
    {:ok, j1} = LearnOban.Workers.ReturnDemo.new(%{result: "ok"}) |> Oban.insert()
    Process.sleep(100)
    IO.puts(":ok job state: #{LearnOban.Repo.get(Oban.Job, j1.id).state}")

    # {:error, reason} → moves to :retryable (if attempts remain) or :discarded
    {:ok, j2} = LearnOban.Workers.ReturnDemo.new(%{result: "error"}) |> Oban.insert()
    Process.sleep(100)
    state = LearnOban.Repo.get(Oban.Job, j2.id).state
    IO.puts("{:error, _} job state: #{state}  (retryable or discarded)")

    # {:cancel, reason} → moves to :cancelled, no more retries
    {:ok, j3} = LearnOban.Workers.ReturnDemo.new(%{result: "cancel"}) |> Oban.insert()
    Process.sleep(100)
    IO.puts("{:cancel, _} job state: #{LearnOban.Repo.get(Oban.Job, j3.id).state}")

    # {:snooze, seconds} → re-schedules job, does NOT count as attempt
    {:ok, j4} = LearnOban.Workers.ReturnDemo.new(%{result: "snooze"}) |> Oban.insert()
    Process.sleep(100)
    IO.puts("{:snooze, _} job state: #{LearnOban.Repo.get(Oban.Job, j4.id).state}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. Scheduling
  # -----------------------------------------------------------------------
  defp scheduling_demo do
    IO.puts("--- Scheduling ---")

    # schedule_in: seconds from now
    {:ok, job} =
      LearnOban.Workers.SendEmail.new(
        %{user_id: 5, template: "reminder"},
        schedule_in: 3600   # run in 1 hour
      )
      |> Oban.insert()

    IO.puts("Scheduled job state: #{job.state}  (should be 'scheduled')")
    IO.puts("Scheduled at: #{job.scheduled_at}")

    # schedule_in with tuple syntax
    {:ok, job2} =
      LearnOban.Workers.SendEmail.new(
        %{user_id: 6, template: "digest"},
        schedule_in: {24, :hours}
      )
      |> Oban.insert()

    IO.puts("Scheduled in 24h state: #{job2.state}")

    # priority: 0 (highest) to 9 (lowest)
    {:ok, urgent} =
      LearnOban.Workers.SendEmail.new(
        %{user_id: 7, template: "password_reset"},
        priority: 0,
        queue: :mailers
      )
      |> Oban.insert()

    Process.sleep(200)
    IO.puts("Priority-0 job state: #{LearnOban.Repo.get(Oban.Job, urgent.id).state}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Uniqueness constraints
  # -----------------------------------------------------------------------
  defp uniqueness_demo do
    IO.puts("--- Uniqueness (Exactly-Once) ---")

    # LearnOban.Workers.DailyReport has unique: [period: 300, keys: [:report_date]]
    {:ok, j1} =
      LearnOban.Workers.DailyReport.new(%{report_date: "2026-06-30"})
      |> Oban.insert()

    {:ok, j2} =
      LearnOban.Workers.DailyReport.new(%{report_date: "2026-06-30"})
      |> Oban.insert()

    IO.puts("First insert:  job_id=#{j1.id}")
    IO.puts("Second insert: job_id=#{j2.id}  conflict?=#{j2.conflict?}")
    IO.puts("Same ID? #{j1.id == j2.id}")  # true — deduped at DB level

    # Different date → different job
    {:ok, j3} =
      LearnOban.Workers.DailyReport.new(%{report_date: "2026-07-01"})
      |> Oban.insert()

    IO.puts("Different date: job_id=#{j3.id} (new job, id != #{j1.id})")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Oban.Job struct fields
  # -----------------------------------------------------------------------
  defp job_struct_demo do
    IO.puts("--- Oban.Job Struct Fields ---")

    {:ok, job} =
      LearnOban.Workers.SendEmail.new(
        %{user_id: 99, template: "onboarding"},
        tags: ["email", "onboarding"],
        meta: %{source: "api", version: 2}
      )
      |> Oban.insert()

    Process.sleep(200)
    job = LearnOban.Repo.get(Oban.Job, job.id)

    IO.puts("id:           #{job.id}")
    IO.puts("state:        #{job.state}")
    IO.puts("queue:        #{job.queue}")
    IO.puts("worker:       #{job.worker}")
    IO.puts("args:         #{inspect(job.args)}")
    IO.puts("meta:         #{inspect(job.meta)}")
    IO.puts("tags:         #{inspect(job.tags)}")
    IO.puts("attempt:      #{job.attempt} / #{job.max_attempts}")
    IO.puts("priority:     #{job.priority}")
    IO.puts("inserted_at:  #{job.inserted_at}")
    IO.puts("errors:       #{inspect(job.errors)}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 6. Testing pattern (explained — Oban.Testing runs in ExUnit context)
  # -----------------------------------------------------------------------
  defp testing_pattern do
    IO.puts("--- Testing Pattern ---")

    IO.puts("""
    In tests, use Oban.Testing to assert on enqueued jobs without
    actually executing them:

      # test/test_helper.exs
      use Oban.Testing, repo: MyApp.Repo

      # In your test:
      test "enqueues welcome email on user creation" do
        MyApp.Accounts.create_user(%{email: "test@example.com"})

        assert_enqueued worker: MyApp.Workers.SendEmail,
                        args: %{template: "welcome"}
      end

      test "perform/1 sends the email" do
        :ok = perform_job(MyApp.Workers.SendEmail, %{
          user_id: 1,
          template: "welcome"
        })
      end

      test "nothing enqueued for invalid input" do
        MyApp.Accounts.create_user(%{email: nil})
        refute_enqueued worker: MyApp.Workers.SendEmail
      end

    perform_job/2,3 is the key function — it runs perform/1 directly,
    bypassing the queue, so tests are synchronous and don't need sleep.
    """)
  end

  # -----------------------------------------------------------------------
  # 7. Full configuration reference
  # -----------------------------------------------------------------------
  defp configuration_reference do
    IO.puts("--- Configuration Reference ---")

    IO.puts("""
    # config/config.exs
    config :my_app, Oban,
      repo:   MyApp.Repo,
      engine: Oban.Engines.Basic,   # Basic (Postgres), Lite (SQLite), Dolphin (MySQL)
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
           {"0 9 * * 1",   MyApp.Workers.WeeklyReport},
           {"*/5 * * * *", MyApp.Workers.Heartbeat},
           {"@daily",      MyApp.Workers.Cleanup, args: %{retain_days: 30}}
         ]}
      ]

    # Application.start/2:
    children = [
      MyApp.Repo,
      {Oban, Application.fetch_env!(:my_app, Oban)}
    ]

    # Migration (one-time):
    # mix ecto.gen.migration add_oban_jobs_table
    # def up,   do: Oban.Migration.up(version: 12)
    # def down, do: Oban.Migration.down(version: 1)
    """)
  end
end

# ============================================================
# Repo — in-memory SQLite for the lesson demo
# ============================================================
defmodule LearnOban.Repo do
  use Ecto.Repo, otp_app: :learn_oban, adapter: Ecto.Adapters.SQLite3

  def start_link(opts \\ []) do
    opts = Keyword.merge([database: ":memory:", pool_size: 5], opts)
    super(opts)
  end
end

# ============================================================
# Workers
# ============================================================

defmodule LearnOban.Workers.SendEmail do
  use Oban.Worker,
    queue: :mailers,
    max_attempts: 3,
    priority: 1,
    tags: ["email"]

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"user_id" => uid, "template" => tpl}}) do
    IO.puts("  [SendEmail] user_id=#{uid} template=#{tpl}")
    :ok
  end

  def perform(%Oban.Job{args: args}) do
    IO.puts("  [SendEmail] args=#{inspect(args)}")
    :ok
  end
end

defmodule LearnOban.Workers.ProcessImage do
  use Oban.Worker, queue: :media, max_attempts: 3

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"image_id" => id}, attempt: n}) do
    IO.puts("  [ProcessImage] image_id=#{id} attempt=#{n}")
    :ok
  end
end

defmodule LearnOban.Workers.ReturnDemo do
  use Oban.Worker, queue: :default, max_attempts: 2

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"result" => "ok"}}) do
    IO.puts("  [ReturnDemo] returning :ok")
    :ok
  end

  def perform(%Oban.Job{args: %{"result" => "error"}}) do
    IO.puts("  [ReturnDemo] returning {:error, ...}")
    {:error, "simulated failure"}
  end

  def perform(%Oban.Job{args: %{"result" => "cancel"}}) do
    IO.puts("  [ReturnDemo] returning {:cancel, ...}")
    {:cancel, "permanent failure, stop retrying"}
  end

  def perform(%Oban.Job{args: %{"result" => "snooze"}}) do
    IO.puts("  [ReturnDemo] returning {:snooze, 300}")
    {:snooze, 300}
  end
end

defmodule LearnOban.Workers.DailyReport do
  use Oban.Worker,
    queue: :default,
    unique: [
      period: 300,           # unique within 5 min window (short for demo)
      fields: [:args],
      keys: [:report_date]
    ]

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"report_date" => date}}) do
    IO.puts("  [DailyReport] generating report for #{date}")
    :ok
  end
end
