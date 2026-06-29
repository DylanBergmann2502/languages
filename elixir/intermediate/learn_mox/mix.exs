defmodule LearnMox.MixProject do
  use Mix.Project

  def project do
    [
      app: :learn_mox,
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
      {:mox, "~> 1.2", only: :test}
    ]
  end
end
