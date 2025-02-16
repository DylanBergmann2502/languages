defmodule Mix.Tasks.Learn do
  use Mix.Task

  @shortdoc "Runs the HTTPoison learning examples"
  def run(_) do
    Application.ensure_all_started(:httpoison)
    LearnHttpoison.run()
  end
end
