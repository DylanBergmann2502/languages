defmodule LearnOpentelemetry.MixProject do
  use Mix.Project

  def project do
    [
      app: :learn_opentelemetry,
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
      # API — zero-cost stub if no SDK present (safe in library deps)
      {:opentelemetry_api, "~> 1.5"},
      # SDK — actual trace collection engine
      {:opentelemetry, "~> 1.7"},
      # OTLP exporter — sends spans to collectors (Jaeger, Honeycomb, etc.)
      {:opentelemetry_exporter, "~> 1.10"},

      # Instrumentation (pick what you use):
      # {:opentelemetry_ecto,    "~> 2.0"},   # Ecto query tracing
      # {:opentelemetry_phoenix, "~> 1.0"},   # Phoenix HTTP tracing
      # {:opentelemetry_req,     "~> 0.1"},   # Req HTTP client tracing
      # {:opentelemetry_oban,    "~> 0.1"},   # Oban job queue tracing
      # {:opentelemetry_bandit,  "~> 0.1"},   # Bandit HTTP server
    ]
  end
end
