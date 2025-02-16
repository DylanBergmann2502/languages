# lib/mix/tasks/learn.ex
defmodule Mix.Tasks.Learn do
  use Mix.Task

  def run(_) do
    LearnJason.run()
  end
end
