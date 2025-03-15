defmodule LearnFlowTest do
  use ExUnit.Case
  doctest LearnFlow

  test "greets the world" do
    assert LearnFlow.hello() == :world
  end
end
