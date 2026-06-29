defmodule LearnMria.MixProject do
  use Mix.Project

  def project do
    [
      app: :learn_mria,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger, :mnesia]]
  end

  defp deps do
    [
      {:mria, "~> 0.9"}
    ]
  end
end
