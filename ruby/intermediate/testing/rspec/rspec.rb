require "rspec"
require "rspec/autorun"

###############################################################
# Basic Structure
# RSpec uses a describe/it syntax for organizing tests

# Let's create a simple calculator class to test
class Calculator
  def add(a, b)
    a + b
  end

  def subtract(a, b)
    a - b
  end

  def multiply(a, b)
    a * b
  end

  def divide(a, b)
    raise ZeroDivisionError, "Cannot divide by zero" if b.zero?
    a / b
  end
end

# RSpec tests typically go in a spec folder with _spec.rb suffix
# But for this example, we'll include them in the same file

# To run this file:
# rspec rspec.rb

###############################################################
# Basic Expectations

describe Calculator do
  # Create a new calculator instance before each test
  let(:calculator) { Calculator.new }

  describe "#add" do
    it "returns the sum of two numbers" do
      expect(calculator.add(5, 2)).to eq(7)
    end

    it "works with negative numbers" do
      expect(calculator.add(-1, -2)).to eq(-3)
    end
  end

  describe "#subtract" do
    it "returns the difference of two numbers" do
      expect(calculator.subtract(5, 2)).to eq(3)
    end
  end

  describe "#multiply" do
    it "returns the product of two numbers" do
      expect(calculator.multiply(5, 2)).to eq(10)
    end

    it "returns zero when multiplying by zero" do
      expect(calculator.multiply(5, 0)).to eq(0)
    end
  end

  describe "#divide" do
    it "returns the quotient of two numbers" do
      expect(calculator.divide(10, 2)).to eq(5)
    end

    it "raises an error when dividing by zero" do
      expect { calculator.divide(10, 0) }.to raise_error(ZeroDivisionError)
    end
  end
end

###############################################################
# Before and After Hooks

describe "Hooks example" do
  before(:all) do
    # Runs once before all tests in this describe block
    @value = 0
    puts "Before all tests, @value = #{@value}"
  end

  after(:all) do
    # Runs once after all tests in this describe block
    puts "After all tests, @value = #{@value}"
  end

  before(:each) do
    # Runs before each test
    @value += 1
    puts "Before each test, @value = #{@value}"
  end

  after(:each) do
    # Runs after each test
    puts "After each test, @value = #{@value}"
  end

  it "example test 1" do
    expect(@value).to eq(1)
  end

  it "example test 2" do
    expect(@value).to eq(2)
  end
end

###############################################################
# Context Blocks for Grouping Tests

class User
  attr_reader :name, :admin

  def initialize(name, admin = false)
    @name = name
    @admin = admin
  end

  def admin?
    @admin
  end

  def greeting
    admin? ? "Hello Admin #{name}" : "Hello #{name}"
  end
end

describe User do
  # Context blocks group related tests
  context "when user is an admin" do
    let(:user) { User.new("Alice", true) }

    it "returns true for admin?" do
      expect(user.admin?).to be true
    end

    it "includes Admin in the greeting" do
      expect(user.greeting).to eq("Hello Admin Alice")
    end
  end

  context "when user is not an admin" do
    let(:user) { User.new("Bob") }

    it "returns false for admin?" do
      expect(user.admin?).to be false
    end

    it "does not include Admin in the greeting" do
      expect(user.greeting).to eq("Hello Bob")
    end
  end
end

###############################################################
# Matchers

describe "RSpec Matchers" do
  # Equality
  it "checks equality with eq" do
    expect(5).to eq(5)
    expect("hello").to eq("hello")
  end

  it "checks identity with be" do
    a = "string"
    b = a
    c = "string"

    expect(b).to be(a)  # Same object
    expect(c).not_to be(a)  # Different object with same value
  end

  # Truthiness
  it "checks truthiness" do
    expect(true).to be_truthy
    expect(false).to be_falsey
    expect(nil).to be_nil

    # be_truthy matches anything that's not false or nil
    expect(1).to be_truthy
    expect("string").to be_truthy
    expect([]).to be_truthy
  end

  # Comparisons
  it "checks numeric comparisons" do
    expect(10).to be > 5
    expect(10).to be >= 10
    expect(5).to be < 10
    expect(5).to be <= 5
    expect(7).to be_between(5, 10)
    expect(10).to be_between(5, 10).inclusive
    expect(10).not_to be_between(5, 10).exclusive
  end

  # Collections
  it "checks collections" do
    expect([1, 2, 3]).to include(1)
    expect([1, 2, 3]).to include(1, 3)
    expect([1, 2, 3]).to start_with(1)
    expect([1, 2, 3]).to end_with(3)
    expect([]).to be_empty

    expect({ a: 1, b: 2 }).to include(:a)
    expect({ a: 1, b: 2 }).to include(a: 1)
  end

  # Strings
  it "checks strings" do
    expect("hello world").to include("hello")
    expect("hello world").to start_with("hello")
    expect("hello world").to end_with("world")
    expect("hello world").to match(/hello/)
  end

  # Errors
  it "checks errors" do
    expect { 5 / 0 }.to raise_error(ZeroDivisionError)
    expect { 5 / 0 }.to raise_error("divided by 0")
    expect { 5 / 0 }.to raise_error(ZeroDivisionError, "divided by 0")
  end

  # Predicate matchers
  it "uses predicate matchers" do
    expect(0).to be_zero
    expect([]).to be_empty
    expect(1).to be_odd
    expect(2).to be_even
  end
end

###############################################################
# Custom Matchers

RSpec::Matchers.define :be_divisible_by do |divisor|
  match do |value|
    value % divisor == 0
  end

  failure_message do |value|
    "expected #{value} to be divisible by #{divisor}"
  end

  failure_message_when_negated do |value|
    "expected #{value} not to be divisible by #{divisor}"
  end

  description do
    "be divisible by #{divisor}"
  end
end

describe "Custom matcher examples" do
  it "checks divisibility" do
    expect(10).to be_divisible_by(2)
    expect(10).to be_divisible_by(5)
    expect(10).not_to be_divisible_by(3)
  end
end

###############################################################
# Mocks and Stubs

class PaymentGateway
  def process_payment(amount)
    # Imagine this connects to an external payment processor
    { success: true, amount: amount, id: "pay_123" }
  end
end

class Order
  attr_reader :total, :payment_gateway

  def initialize(total, payment_gateway)
    @total = total
    @payment_gateway = payment_gateway
  end

  def checkout
    result = payment_gateway.process_payment(total)
    if result[:success]
      "Payment of $#{total} processed successfully"
    else
      "Payment failed"
    end
  end
end

describe Order do
  describe "#checkout" do
    # Test doubles (mocks)
    it "processes payment via the payment gateway" do
      # Create a double
      gateway = double("PaymentGateway")

      # Set expectation and return value
      expect(gateway).to receive(:process_payment).with(100).and_return({
                           success: true,
                           amount: 100,
                           id: "pay_123",
                         })

      order = Order.new(100, gateway)
      expect(order.checkout).to eq("Payment of $100 processed successfully")
    end

    # Partial mocks (spies)
    it "handles failed payments" do
      gateway = instance_double(PaymentGateway)
      allow(gateway).to receive(:process_payment).and_return({ success: false })

      order = Order.new(50, gateway)
      expect(order.checkout).to eq("Payment failed")
    end

    # Verifying message passing
    it "verifies the gateway is called" do
      gateway = spy("PaymentGateway")
      allow(gateway).to receive(:process_payment).and_return({ success: true, amount: 75, id: "pay_456" })

      order = Order.new(75, gateway)
      order.checkout

      # Verify after the fact
      expect(gateway).to have_received(:process_payment).with(75)
    end
  end
end

###############################################################
# Shared Examples

RSpec.shared_examples "a collection" do
  let(:collection) { described_class.new([1, 2, 3]) }

  it "has a size method" do
    expect(collection).to respond_to(:size)
    expect(collection.size).to eq(3)
  end

  it "can be enumerated" do
    expect(collection).to respond_to(:each)

    elements = []
    collection.each { |item| elements << item }
    expect(elements).to eq([1, 2, 3])
  end
end

class MyCollection
  def initialize(items)
    @items = items
  end

  def size
    @items.size
  end

  def each(&block)
    @items.each(&block)
  end
end

describe MyCollection do
  it_behaves_like "a collection"
end

###############################################################
# Subject

describe Array do
  # When using described_class, subject is automatically set to Array.new
  subject { described_class.new([1, 2, 3]) }

  it { is_expected.to respond_to(:size) }
  it { is_expected.to include(1) }

  # Named subjects
  subject(:numbers) { [1, 2, 3, 4] }

  it "can access named subjects" do
    expect(numbers.size).to eq(4)
  end
end

###############################################################
# One-liner syntax

describe "one-liners" do
  subject { [1, 2, 3] }

  it { is_expected.to include(1) }
  it { is_expected.not_to include(4) }
  it { is_expected.to start_with(1) }
  it { is_expected.to all(be < 10) }
end

# To run this file with RSpec:
# rspec rspec.rb
