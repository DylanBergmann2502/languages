defmodule Mix.Tasks.Learn do
  use Mix.Task

  @shortdoc "Learn Broadway"

  @impl Mix.Task
  def run(_args) do
    # Start any required applications
    Application.ensure_all_started(:broadway)

    # Run our example
    LearnBroadway.run()
  end
end
