defmodule LearnBroadwayTest do
  use ExUnit.Case
  doctest LearnBroadway

  test "greets the world" do
    assert LearnBroadway.hello() == :world
  end
end
