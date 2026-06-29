defmodule LearnMembrane.MixProject do
  use Mix.Project

  def project do
    [
      app: :learn_membrane,
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
      {:membrane_core, "~> 1.3"}
    ]
  end
end
