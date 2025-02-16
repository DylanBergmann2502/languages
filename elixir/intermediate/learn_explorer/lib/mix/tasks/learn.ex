defmodule Mix.Tasks.Learn do
  use Mix.Task

  @impl Mix.Task
  def run(_) do
    LearnExplorer.run()
  end
end
