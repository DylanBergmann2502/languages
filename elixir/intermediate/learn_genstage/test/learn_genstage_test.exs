defmodule LearnGenstageTest do
  use ExUnit.Case
  doctest LearnGenstage

  test "greets the world" do
    assert LearnGenstage.hello() == :world
  end
end
