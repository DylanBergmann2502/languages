ExUnit.start()

defmodule MathTest do
  use ExUnit.Case, async: true

  # Basic test example
  test "addition works" do
    assert 2 + 2 == 4
  end

  # Using describe blocks for grouping
  describe "multiplication" do
    test "basic multiplication" do
      assert 3 * 3 == 9
    end

    test "multiplication with zero" do
      assert 5 * 0 == 0
    end
  end

  # Using setup for shared setup
  setup do
    {:ok, number: 10}
  end

  test "using setup context", %{number: n} do
    assert n * 2 == 20
  end

  # Setup with tags
  @tag important: true
  test "tagged test" do
    assert true
  end

  # Assertions
  test "different assertions" do
    # Equality
    assert 5 == 5

    # Inequality
    refute 5 == 6

    # Exception testing - fix the ArithmeticError issue
    assert_raise ArithmeticError, fn ->
      # This will properly raise an ArithmeticError in Elixir
      Kernel.div(1, 0)
    end

    # Membership
    assert 5 in [1, 2, 3, 4, 5]

    # Match
    assert {:ok, value} = {:ok, "success"}
    assert value == "success"
  end

  # Test with timeout
  # 1 second timeout
  @tag timeout: 1000
  test "test with timeout" do
    # This test will pass if it completes within 1 second
    :timer.sleep(500)
    assert true
  end

  # Skipping tests
  @tag :skip
  test "this test is skipped" do
    flunk("This shouldn't run")
  end

  # Using test fixtures with setup_all
  setup_all do
    # This runs once before all tests in the module
    {:ok, global_value: 100}
  end

  test "accessing setup_all values", %{global_value: v} do
    assert v == 100
  end
end
