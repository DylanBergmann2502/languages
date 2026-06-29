defmodule LearnHorde.MixProject do
  use Mix.Project

  def project do
    [
      app: :learn_horde,
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
      {:horde, "~> 0.10.0"}
    ]
  end
end
