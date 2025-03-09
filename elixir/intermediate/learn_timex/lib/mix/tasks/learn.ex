defmodule Mix.Tasks.Learn do
  use Mix.Task

  @shortdoc "Runs the Timex examples"
  def run(_) do
    # Make sure the Timex library is started
    Application.ensure_all_started(:timex)

    LearnTimex.run()
  end
end
