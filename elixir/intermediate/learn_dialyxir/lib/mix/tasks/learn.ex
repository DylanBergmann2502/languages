defmodule Mix.Tasks.Learn do
  @moduledoc "Mix task to run dialyxir learning examples"
  use Mix.Task

  @impl Mix.Task
  def run(_) do
    LearnDialyxir.run()
  end
end
