defmodule Mix.Tasks.Learn do
  use Mix.Task

  @shortdoc "Runs the LearnFlow examples"
  def run(_) do
    IO.puts("Running Flow examples...")
    LearnFlow.run()
  end
end
