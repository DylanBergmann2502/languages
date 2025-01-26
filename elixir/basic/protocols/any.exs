# Define protocol with fallback
defprotocol Converter do
  @fallback_to_any true
  def to_string(value)
end

# Implement for Any
defimpl Converter, for: Any do
  def to_string(value), do: "#Any<#{inspect(value)}>"
end

# Test with any random term
IO.inspect Converter.to_string({:ok, 123})  # "#Any<{:ok, 123}>"
