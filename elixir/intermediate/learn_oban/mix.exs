defmodule LearnOban.MixProject do
  use Mix.Project

  def project do
    [
      app: :learn_oban,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:oban, "~> 2.23"},
      {:ecto_sqlite3, "~> 0.18"}
    ]
  end
end
