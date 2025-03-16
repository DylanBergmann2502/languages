# Test-Driven Development (TDD) is a software development approach where you:
# 1. Write a failing test first (Red)
# 2. Write minimal code to make the test pass (Green)
# 3. Refactor the code while keeping tests passing (Refactor)
#
# This cycle is known as "Red-Green-Refactor"

require "rspec"
require "rspec/autorun"

###############################################################
# Example 1: Building a Simple Stack implementation using TDD
#
# Let's implement a Stack class using TDD principles
#
# Step 1: Write a failing test for the simplest functionality

class Stack
  # Implementation will be driven by tests
end

describe Stack do
  context "when newly created" do
    it "is empty" do
      stack = Stack.new
      expect(stack).to be_empty
    end
  end
end

# Running this test will fail because Stack doesn't exist yet
#
# Step 2: Write minimal code to make the test pass

class Stack
  def empty?
    true
  end
end

# Now our test passes!
#
# Step 3: Write the next failing test

describe Stack do
  context "when newly created" do
    it "is empty" do
      stack = Stack.new
      expect(stack).to be_empty
    end

    it "has size zero" do
      stack = Stack.new
      expect(stack.size).to eq(0)
    end
  end
end

# Step 4: Add code to make the new test pass

class Stack
  def empty?
    true
  end

  def size
    0
  end
end

# Step 5: Add test for pushing an item

describe Stack do
  context "when newly created" do
    it "is empty" do
      stack = Stack.new
      expect(stack).to be_empty
    end

    it "has size zero" do
      stack = Stack.new
      expect(stack.size).to eq(0)
    end
  end

  context "after pushing an element" do
    it "is not empty" do
      stack = Stack.new
      stack.push(1)
      expect(stack).not_to be_empty
    end

    it "has size 1" do
      stack = Stack.new
      stack.push(1)
      expect(stack.size).to eq(1)
    end
  end
end

# Step 6: Implement push method to make the tests pass

class Stack
  def initialize
    @elements = []
  end

  def empty?
    @elements.empty?
  end

  def size
    @elements.size
  end

  def push(element)
    @elements.push(element)
  end
end

# Step 7: Add test for pop

describe Stack do
  # Previous contexts...

  context "when popping elements" do
    it "returns the last element" do
      stack = Stack.new
      stack.push(1)
      stack.push(2)
      expect(stack.pop).to eq(2)
    end

    it "removes the last element" do
      stack = Stack.new
      stack.push(1)
      stack.push(2)
      stack.pop
      expect(stack.size).to eq(1)
    end

    it "raises an error when popping an empty stack" do
      stack = Stack.new
      expect { stack.pop }.to raise_error(RuntimeError, "Stack is empty")
    end
  end
end

# Step 8: Implement pop method

class Stack
  def initialize
    @elements = []
  end

  def empty?
    @elements.empty?
  end

  def size
    @elements.size
  end

  def push(element)
    @elements.push(element)
  end

  def pop
    raise "Stack is empty" if empty?
    @elements.pop
  end
end

# Step 9: Refactor with subject and let for cleaner tests

describe Stack do
  subject(:stack) { Stack.new }

  context "when newly created" do
    it { is_expected.to be_empty }
    it { expect(stack.size).to eq(0) }
  end

  context "after pushing an element" do
    before { stack.push(1) }

    it { is_expected.not_to be_empty }
    it { expect(stack.size).to eq(1) }
  end

  context "when popping elements" do
    before do
      stack.push(1)
      stack.push(2)
    end

    it "returns the last element" do
      expect(stack.pop).to eq(2)
    end

    it "removes the last element" do
      stack.pop
      expect(stack.size).to eq(1)
    end
  end

  context "when popping from empty stack" do
    it "raises an error" do
      expect { stack.pop }.to raise_error(RuntimeError, "Stack is empty")
    end
  end
end

###############################################################
# Example 2: TDD for a String Calculator
class StringCalculator
  # Implementation will be driven by tests
end

describe StringCalculator do
  describe ".add" do
    it "returns 0 for an empty string" do
      expect(StringCalculator.add("")).to eq(0)
    end

    it "returns the number for a single number" do
      expect(StringCalculator.add("1")).to eq(1)
      expect(StringCalculator.add("5")).to eq(5)
    end

    it "returns the sum for two numbers" do
      expect(StringCalculator.add("1,2")).to eq(3)
      expect(StringCalculator.add("4,6")).to eq(10)
    end

    it "returns the sum for multiple numbers" do
      expect(StringCalculator.add("1,2,3")).to eq(6)
      expect(StringCalculator.add("1,2,3,4,5")).to eq(15)
    end

    it "treats newlines between numbers as commas" do
      expect(StringCalculator.add("1\n2,3")).to eq(6)
      expect(StringCalculator.add("4\n6")).to eq(10)
    end

    it "supports custom delimiters" do
      expect(StringCalculator.add("//;\n1;2")).to eq(3)
      expect(StringCalculator.add("//|\n5|3")).to eq(8)
    end

    it "raises an exception for negative numbers" do
      expect { StringCalculator.add("-1,2") }.to raise_error(RuntimeError, "negatives not allowed: -1")

      expect { StringCalculator.add("1,-2,-3") }.to raise_error(RuntimeError, "negatives not allowed: -2, -3")
    end
  end
end

class StringCalculator
  def self.add(input)
    return 0 if input.empty?

    delimiter = ","
    if input.start_with?("//")
      delimiter = input[2]
      input = input[4..-1]
    end

    numbers = input.gsub("\n", delimiter).split(delimiter).map(&:to_i)

    negatives = numbers.select { |n| n < 0 }
    if negatives.any?
      raise "negatives not allowed: #{negatives.join(", ")}"
    end

    numbers.sum
  end
end

###############################################################
# Example 3: Using TDD with mocks and dependency injection
class UserRepository
  # Implementation will be driven by tests
end

class EmailService
  # Implementation will be driven by tests
end

class RegistrationService
  # Implementation will be driven by tests
end

# First, we build simple interfaces for each component
describe UserRepository do
  # No implementation yet, we're just defining the interface
  it { is_expected.to respond_to(:find_by_email) }
  it { is_expected.to respond_to(:save) }
end

describe EmailService do
  # No implementation yet, just defining the interface
  it { is_expected.to respond_to(:send_welcome_email) }
end

describe RegistrationService do
  # The service we want to test
  it { is_expected.to respond_to(:register) }
end

# Now we'll build the real tests with mocks
describe RegistrationService do
  let(:user_repo) { instance_double(UserRepository) }
  let(:email_service) { instance_double(EmailService) }
  let(:service) { RegistrationService.new(user_repo, email_service) }

  describe "#register" do
    let(:user_data) { { email: "user@example.com", name: "Test User" } }
    let(:user) { double("User", id: 1, email: "user@example.com") }

    context "when the email is not already taken" do
      before do
        allow(user_repo).to receive(:find_by_email).with("user@example.com").and_return(nil)
        allow(user_repo).to receive(:save).and_return(user)
        allow(email_service).to receive(:send_welcome_email).with(user)
      end

      it "saves the user" do
        service.register(user_data)
        expect(user_repo).to have_received(:save)
      end

      it "sends a welcome email" do
        service.register(user_data)
        expect(email_service).to have_received(:send_welcome_email).with(user)
      end

      it "returns a success result" do
        result = service.register(user_data)
        expect(result[:success]).to be true
        expect(result[:user_id]).to eq(1)
      end
    end

    context "when the email is already taken" do
      before do
        allow(user_repo).to receive(:find_by_email).with("user@example.com").and_return(user)
      end

      it "does not save the user" do
        service.register(user_data)
        expect(user_repo).not_to have_received(:save)
      end

      it "does not send a welcome email" do
        service.register(user_data)
        expect(email_service).not_to have_received(:send_welcome_email)
      end

      it "returns a failure result" do
        result = service.register(user_data)
        expect(result[:success]).to be false
        expect(result[:error]).to eq("Email already taken")
      end
    end
  end
end

# Implementation to make the tests pass
class UserRepository
  def find_by_email(email)
    # In a real app, this would query a database
    nil
  end

  def save(user_data)
    # In a real app, this would save to a database
    OpenStruct.new(id: 1, email: user_data[:email])
  end
end

class EmailService
  def send_welcome_email(user)
    # In a real app, this would send an actual email
    puts "Sending welcome email to #{user.email}"
  end
end

class RegistrationService
  def initialize(user_repository, email_service)
    @user_repository = user_repository
    @email_service = email_service
  end

  def register(user_data)
    if @user_repository.find_by_email(user_data[:email])
      return { success: false, error: "Email already taken" }
    end

    user = @user_repository.save(user_data)
    @email_service.send_welcome_email(user)

    { success: true, user_id: user.id }
  end
end

###############################################################
# Benefits of TDD:
#
# 1. Ensures your code works as expected
# 2. Helps you write only the code needed to fulfill requirements
# 3. Produces self-documenting tests that explain your code's behavior
# 4. Makes refactoring safer with a test safety net
# 5. Forces you to think about design and interfaces before implementation
#
# TDD Best Practices with RSpec:
#
# 1. Use descriptive contexts and examples
# 2. Leverage let and subject for cleaner tests
# 3. Use shared_examples for common behaviors
# 4. Use before and after hooks judiciously
# 5. Use mocks and stubs to isolate the unit under test
# 6. Write the simplest code to pass the test
# 7. Refactor after getting to green
# 8. Test behavior, not implementation details
#
# Run this file with:
# bundle exec ruby tdd.rb
