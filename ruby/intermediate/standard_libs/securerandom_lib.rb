# SecureRandom is a library for generating secure random numbers and strings
# It's used for cryptographic purposes where true randomness is important
# Let's require the library first
require "securerandom"

########################################################################
# Generating random bytes
# SecureRandom.bytes generates a string of random bytes

# Generate 8 random bytes
random_bytes = SecureRandom.bytes(8)
puts "Random bytes: #{random_bytes.inspect}"

# Convert to hex for readable representation
puts "As hex: #{random_bytes.unpack("H*")[0]}"

# Since these are raw bytes, they may include unprintable characters
puts "Byte values: #{random_bytes.bytes}"

########################################################################
# Generating random hex strings
# SecureRandom.hex generates a random hexadecimal string

# Generate a random hex string (16 characters = 8 bytes)
hex_string = SecureRandom.hex(8)
puts "Random hex (8 bytes): #{hex_string}"

# The argument specifies the number of bytes, not the string length
# Each byte becomes 2 hex characters
puts "Length of hex string: #{hex_string.length}" # Should be 16

# Verify that each character is a valid hex digit
is_valid_hex = hex_string.chars.all? { |c| c =~ /[0-9a-f]/ }
puts "Is valid hex? #{is_valid_hex}" # true

########################################################################
# Generating random base64 strings
# SecureRandom.base64 generates a random base64 encoded string

# Generate a random base64 string
base64_string = SecureRandom.base64(8) # 8 bytes = 12 base64 chars (including padding)
puts "Random base64 (8 bytes): #{base64_string}"

# Base64 uses characters A-Z, a-z, 0-9, +, / and padding with =
is_valid_base64 = base64_string.chars.all? { |c| c =~ /[A-Za-z0-9+\/=]/ }
puts "Is valid base64? #{is_valid_base64}" # true

# Converting bytes to base64 manually (for comparison)
manual_base64 = [SecureRandom.bytes(8)].pack("m0")
puts "Manually encoded base64: #{manual_base64}"

########################################################################
# Generating random URL-safe base64 strings
# SecureRandom.urlsafe_base64 generates base64 strings that are safe for URLs

# Generate a URL-safe base64 string
urlsafe_string = SecureRandom.urlsafe_base64(8)
puts "URL-safe base64 (8 bytes): #{urlsafe_string}"

# URL-safe base64 uses characters A-Z, a-z, 0-9, -, _ (no +, / or =)
is_valid_urlsafe = urlsafe_string.chars.all? { |c| c =~ /[A-Za-z0-9\-_]/ }
puts "Is valid URL-safe base64? #{is_valid_urlsafe}" # true

# Compare with regular base64 (+ and / are replaced with - and _)
puts "Regular base64: #{base64_string}"
puts "URL-safe base64: #{urlsafe_string}"

########################################################################
# Generating random UUIDs
# SecureRandom.uuid generates a random UUID (version 4)

# Generate a random UUID
uuid = SecureRandom.uuid
puts "Random UUID: #{uuid}"

# UUIDs have a specific format: 8-4-4-4-12 hexadecimal digits
# Let's verify the format
uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/
is_valid_uuid = uuid =~ uuid_regex
puts "Is valid UUID? #{!!is_valid_uuid}" # true

# The '4' in the third group indicates it's a version 4 UUID (randomly generated)
puts "UUID version: #{uuid[14]}" # Should be '4'

########################################################################
# Generating random numbers
# SecureRandom provides methods for generating random numbers

# Generate a random number between 0 and max integer
random_number = SecureRandom.random_number
puts "Random floating point between 0 and 1: #{random_number}"

# Generate a random integer between 0 and 99
random_int = SecureRandom.random_number(100)
puts "Random integer between 0 and 99: #{random_int}"

# Generate a random integer in a specific range (e.g., 10 to 20)
range = 10..20
random_in_range = SecureRandom.random_number(range)
puts "Random integer between 10 and 20: #{random_in_range}"

########################################################################
# Generating random strings of alphanumeric characters
# SecureRandom.alphanumeric generates random alphanumeric strings

# Generate a random alphanumeric string of length 10
alpha_string = SecureRandom.alphanumeric(10)
puts "Random alphanumeric (10 chars): #{alpha_string}"

# Verify that only alphanumeric characters are used
is_valid_alpha = alpha_string.chars.all? { |c| c =~ /[A-Za-z0-9]/ }
puts "Is valid alphanumeric? #{is_valid_alpha}" # true

########################################################################
# Practical uses
# Let's look at some common practical uses of SecureRandom

# 1. Generate a secure password
password = SecureRandom.alphanumeric(12)
puts "Secure password: #{password}"

# 2. Generate a secure token for API authentication
api_token = SecureRandom.urlsafe_base64(32)
puts "API token: #{api_token}"

# 3. Generate a session ID
session_id = SecureRandom.hex(16)
puts "Session ID: #{session_id}"

# 4. Generate a unique filename
filename = "file_#{SecureRandom.hex(8)}.txt"
puts "Unique filename: #{filename}"

# 5. Generate a reset password token with expiration
reset_token = {
  token: SecureRandom.urlsafe_base64(32),
  expires_at: Time.now + 3600, # 1 hour from now
}
puts "Reset password token: #{reset_token[:token]}"
puts "Expires at: #{reset_token[:expires_at]}"

########################################################################
# Cryptographically secure vs. regular random
# SecureRandom uses OS-provided secure RNG mechanisms
# It's slower but more secure than regular random

require "benchmark"

# Compare speed of SecureRandom.hex vs Random.hex
n = 1000
Benchmark.bm(20) do |x|
  x.report("SecureRandom.hex:") do
    n.times { SecureRandom.hex(16) }
  end

  x.report("Random bytes to hex:") do
    random = Random.new
    n.times { random.bytes(16).unpack("H*")[0] }
  end
end

# Why use SecureRandom?
# - For sensitive data like tokens, passwords, keys
# - When security is more important than speed
# - When true randomness is required
