defmodule Mix.Tasks.Learn do
  use Mix.Task

  def run(_) do
    LearnNx.run()
  end
end
