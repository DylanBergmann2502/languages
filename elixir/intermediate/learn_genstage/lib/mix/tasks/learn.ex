defmodule Mix.Tasks.Learn do
  use Mix.Task

  @shortdoc "Runs the GenStage example"

  def run(_) do
    # Make sure GenStage is started
    Application.ensure_all_started(:gen_stage)

    # Run our example
    LearnGenStage.run()
  end
end
