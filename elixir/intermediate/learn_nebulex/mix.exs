defmodule LearnNebulex.MixProject do
  use Mix.Project

  def project do
    [
      app: :learn_nebulex,
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
      {:nebulex,       "~> 3.0"},
      {:nebulex_local, "~> 3.0"},   # Local adapter (in-process ETS cache)
      {:decorator,     "~> 1.4"},   # optional: for @cacheable / @cache_evict decorators
      {:telemetry,     "~> 1.0"}    # optional: for stats via telemetry events
    ]
  end
end
