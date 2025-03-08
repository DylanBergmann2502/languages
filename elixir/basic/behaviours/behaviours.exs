# Define a behaviour for a payment processor
defmodule PaymentProcessor1 do
  @callback process_payment(amount :: float, currency :: String.t()) ::
              {:ok, String.t()} | {:error, String.t()}
  @callback validate_amount(amount :: float) :: boolean()

  # Optional callback with default implementation
  @optional_callbacks validate_currency: 1
  @callback validate_currency(currency :: String.t()) :: boolean()

  # Default implementation for validate_currency
  def validate_currency(currency) do
    supported_currencies = ["USD", "EUR", "GBP"]
    currency in supported_currencies
  end
end

# Implement the behaviour
defmodule StripeProcessor1 do
  # This just declares that we'll implement the behaviour
  @behaviour PaymentProcessor1

  # Required callback implementation
  def process_payment(amount, currency) do
    # Call the default implementation through the PaymentProcessor module
    if validate_amount(amount) && PaymentProcessor1.validate_currency(currency) do
      {:ok, "Payment processed: #{amount} #{currency}"}
    else
      {:error, "Invalid payment details"}
    end
  end

  # Required callback implementation
  def validate_amount(amount) do
    amount > 0 && amount < 1_000_000
  end

  def run do
    result1 = StripeProcessor1.process_payment(100.50, "USD")
    # {:ok, "Payment processed: 100.5 USD"}
    IO.inspect(result1)

    result2 = StripeProcessor1.process_payment(100.50, "XXX")
    # {:error, "Invalid payment details"}
    IO.inspect(result2)
  end
end

StripeProcessor1.run()

###################################################################

defmodule PaymentProcessor2 do
  # Required callbacks
  @callback process_payment(amount :: float, currency :: String.t()) ::
              {:ok, String.t()} | {:error, String.t()}
  @callback validate_amount(amount :: float) :: boolean()

  # Optional callback
  @callback validate_currency(currency :: String.t()) :: boolean()
  @optional_callbacks [validate_currency: 1]

  defmacro __using__(_) do
    quote do
      @behaviour PaymentProcessor2

      # Only provide default implementation for optional callback
      def validate_currency(currency) do
        supported_currencies = ["USD", "EUR", "GBP"]
        currency in supported_currencies
      end

      # Make only the optional callback overridable
      defoverridable [validate_currency: 1]
    end
  end
end

defmodule StripeProcessor2 do
  # This brings in both the behaviour and default implementations
  use PaymentProcessor2

  # Must implement required callbacks
  def process_payment(amount, currency) do
    if validate_amount(amount) && validate_currency(currency) do
      {:ok, "Payment processed: #{amount} #{currency}"}
    else
      {:error, "Invalid payment details"}
    end
  end

  def validate_amount(amount) do
    amount > 0 && amount < 1_000_000
  end

  # validate_currency is optional and uses default implementation

  def run do
    result1 = StripeProcessor2.process_payment(100.50, "USD")
    # {:ok, "Payment processed: 100.5 USD"}
    IO.inspect(result1)

    result2 = StripeProcessor2.process_payment(100.50, "XXX")
    # {:error, "Invalid payment details"}
    IO.inspect(result2)
  end
end

StripeProcessor2.run()
