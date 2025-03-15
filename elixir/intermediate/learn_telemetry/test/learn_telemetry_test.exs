defmodule LearnTelemetryTest do
  use ExUnit.Case
  doctest LearnTelemetry

  test "greets the world" do
    assert LearnTelemetry.hello() == :world
  end
end
