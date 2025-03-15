defmodule Mix.Tasks.Learn do
  use Mix.Task

  @shortdoc "Learn the Telemetry library"

  @impl Mix.Task
  def run(_) do
    # Start Logger
    Application.ensure_all_started(:logger)

    # Start the Telemetry application
    Application.ensure_all_started(:telemetry)

    LearnTelemetry.run()
  end
end
