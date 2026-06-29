# The Application behaviour is the root of any OTP application.
# Every Mix project has an Application module.
# It starts the supervision tree and manages application-wide configuration.

# In a real Mix project you'd have:
#   mix.exs  ->  def application, do: [mod: {MyApp, []}, ...]
#   lib/my_app.ex  ->  use Application
# Since this is a standalone .exs we simulate the concepts here.

################################################################
# What Application does

# The Application behaviour requires two callbacks:
#   start/2  - called when the application starts
#   stop/1   - called when the application stops

defmodule DemoApp do
  @behaviour Application

  @impl Application
  def start(_start_type, _start_args) do
    IO.puts("DemoApp starting...")

    children = [
      # In a real app you'd put your supervisors/workers here
      # {MyWorker, arg}
    ]

    opts = [strategy: :one_for_one, name: DemoApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl Application
  def stop(_state) do
    IO.puts("DemoApp stopping...")
    :ok
  end
end

################################################################
# Application environment / configuration
# In mix.exs:  config :my_app, key: "value"
# In config/config.exs:  config :my_app, db_url: "postgres://..."

# Application.get_env/3
# Reads from the compile-time or runtime config.
# The third argument is the default if the key is absent.
db_url = Application.get_env(:my_app, :db_url, "postgres://localhost/dev")
IO.inspect(db_url) # "postgres://localhost/dev" (no config set in .exs script)

# Application.put_env/3 - set at runtime (survives for the process lifetime)
Application.put_env(:my_app, :feature_flag, true)
IO.inspect(Application.get_env(:my_app, :feature_flag)) # true

# Application.fetch_env/2 - returns {:ok, value} or :error
IO.inspect(Application.fetch_env(:my_app, :feature_flag)) # {:ok, true}
IO.inspect(Application.fetch_env(:my_app, :missing_key))  # :error

# Application.fetch_env!/2 - raises if missing
IO.inspect(Application.fetch_env!(:my_app, :feature_flag)) # true

# Application.delete_env/2 - remove a key
Application.delete_env(:my_app, :feature_flag)
IO.inspect(Application.get_env(:my_app, :feature_flag, :gone)) # :gone

################################################################
# Application.get_all_env/1 - get all config for an app
all_env = Application.get_all_env(:logger)
IO.puts("Logger config keys: #{inspect(Keyword.keys(all_env))}")

################################################################
# Application metadata

# Which applications are currently running?
started = Application.started_applications()
IO.puts("Running applications count: #{length(started)}")
# Each entry is {app_name, description, version}
{name, _desc, vsn} = List.first(started)
IO.puts("First app: #{name} #{vsn}")

# Loaded (but maybe not started) applications
loaded = Application.loaded_applications()
IO.puts("Loaded applications count: #{length(loaded)}")

# Application spec - metadata from mix.exs
spec = Application.spec(:elixir)
IO.inspect(Keyword.get(spec, :vsn)) # '1.x.x' (as charlist)

################################################################
# Application.app_dir/1 - get the filesystem path of an app

elixir_dir = Application.app_dir(:elixir)
IO.puts("Elixir app dir: #{elixir_dir}")

# Useful for finding bundled static files:
# priv_dir = Application.app_dir(:my_app, "priv")

################################################################
# start_type in start/2

# The start_type argument tells you HOW the app is being started:
#   :normal       - standard startup
#   :takeover     - taking over from another node (distributed)
#   :failover     - failing over from a crashed node
# Most apps only handle :normal.

################################################################
# Application.ensure_all_started/1
# Starts an app and all its dependencies (idempotent)

{:ok, started_apps} = Application.ensure_all_started(:logger)
IO.inspect(started_apps) # [] if already started, or [:logger] if just started

################################################################
# OTP app structure summary
IO.puts("""

OTP Application structure:
  mix.exs
    def application do
      [mod: {MyApp, []}, env: [port: 4000]]
    end

  lib/my_app.ex
    use Application
    def start(_type, _args) do
      children = [MyApp.Repo, MyApp.Endpoint]
      Supervisor.start_link(children, strategy: :one_for_one)
    end

  config/config.exs
    config :my_app, port: 4000

  Runtime access:
    Application.get_env(:my_app, :port)  # => 4000
""")
