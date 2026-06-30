defmodule LearnSage.MixProject do
  use Mix.Project

  def project do
    [
      app: :learn_sage,
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
      {:sage, "~> 0.6.3"}
    ]
  end
end
