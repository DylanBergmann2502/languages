# Minitest is Ruby's built-in testing framework - simple and straightforward
# Let's start by requiring minitest

require "minitest/autorun"

##############################################################
# Basic Test Class
# A test class inherits from Minitest::Test

class BasicTest < Minitest::Test
  # Test methods must start with 'test_'
  def test_addition
    assert_equal 4, 2 + 2
    assert_equal 0, -5 + 5
  end

  def test_string_concatenation
    assert_equal "hello world", "hello" + " world"
  end
end

##############################################################
# Setup and Teardown
# setup runs before each test, teardown runs after each test

class SetupTeardownTest < Minitest::Test
  def setup
    @number = 5
    @string = "test"
    puts "Running setup"
  end

  def teardown
    puts "Running teardown"
  end

  def test_using_setup_variables
    assert_equal 10, @number * 2
    assert_equal "testtest", @string * 2
  end

  def test_another_test_with_same_setup
    assert_equal 25, @number ** 2
    assert_equal 4, @string.length
  end
end

##############################################################
# Different Assertion Types

class AssertionsTest < Minitest::Test
  def test_various_assertions
    # Basic equality
    assert_equal 42, 42

    # Identity comparison (same object)
    x = "string"
    y = x
    assert_same x, y

    # Truthiness
    assert true
    assert "non-empty string"
    assert 42

    # Falsiness
    refute false
    refute nil

    # Matching
    assert_match /world/, "hello world"

    # Empty collections
    assert_empty []
    assert_empty ""
    assert_empty({})

    # Inclusion
    assert_includes [1, 2, 3], 2

    # Exceptions
    error = assert_raises(ZeroDivisionError) { 1 / 0 }
    assert_equal "divided by 0", error.message

    # No exception raised
    assert_silent { 1 + 1 }
  end
end

##############################################################
# Working with Custom Classes

class Person
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def adult?
    @age >= 18
  end

  def greeting
    "Hello, my name is #{@name}"
  end
end

class PersonTest < Minitest::Test
  def setup
    @child = Person.new("Alice", 10)
    @adult = Person.new("Bob", 30)
  end

  def test_adult_check
    assert @adult.adult?
    refute @child.adult?
  end

  def test_greeting
    assert_equal "Hello, my name is Alice", @child.greeting
    assert_equal "Hello, my name is Bob", @adult.greeting
  end

  def test_age_assignment
    @child.age = 20
    assert @child.adult?
  end
end

##############################################################
# Testing with Specs
# Minitest also supports a spec-style syntax

describe "Array" do
  before do
    @array = [1, 2, 3]
  end

  it "allows access by index" do
    _(@array[1]).must_equal 2
  end

  it "has a size" do
    _(@array.size).must_equal 3
  end

  it "can be modified" do
    @array.push(4)
    _(@array.size).must_equal 4
    _(@array.last).must_equal 4
  end
end

##############################################################
# Skipping Tests

class SkippingTest < Minitest::Test
  def test_normal
    assert_equal 4, 2 + 2
  end

  def test_skipped
    skip "Skipping this test for now"
    assert_equal 1, 2  # This would fail if not skipped
  end

  def test_skip_when_condition
    skip_if 1 == 1, "Skipping because condition is true"
    assert_equal 1, 2  # This would fail if not skipped
  end
end

##############################################################
# Mocks and Stubs

class ServiceClient
  def fetch_data
    # Imagine this calls an external API
    { status: "success", data: [1, 2, 3] }
  end
end

class ServiceTest < Minitest::Test
  def test_with_stub
    client = ServiceClient.new

    # Create a stub for the fetch_data method
    client.stub :fetch_data, { status: "error", message: "API unavailable" } do
      result = client.fetch_data
      assert_equal "error", result[:status]
      assert_equal "API unavailable", result[:message]
    end

    # Outside the stub block, the original method works
    result = client.fetch_data
    assert_equal "success", result[:status]
  end
end

##############################################################
# Benchmarking

require "minitest/benchmark"

class BenchmarkTest < Minitest::Benchmark
  def setup
    @list = (1..1000).to_a
  end

  def bench_sort
    assert_performance_linear 0.9 do |n|
      n.times do
        @list.shuffle.sort
      end
    end
  end
end

##############################################################
# Customizing Output

class CustomizedTest < Minitest::Test
  def test_with_output
    puts "This is a custom message during the test"
    assert true
  end
end

# Run this file with:
# ruby minitest.rb
# You'll see the results of all the tests
