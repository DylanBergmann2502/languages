defmodule LearnSyn.MixProject do
  use Mix.Project

  def project do
    [
      app: :learn_syn,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger, :syn]]
  end

  defp deps do
    [
      {:syn, "~> 3.4"}
    ]
  end
end
