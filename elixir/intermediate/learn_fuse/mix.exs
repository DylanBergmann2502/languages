defmodule LearnFuse.MixProject do
  use Mix.Project

  def project do
    [
      app: :learn_fuse,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger, :fuse]]
  end

  defp deps do
    [
      {:fuse, "~> 2.5"}
    ]
  end
end
