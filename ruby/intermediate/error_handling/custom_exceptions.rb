#############################################################
# Ruby Custom Exceptions
#############################################################

# In Ruby, you can define your own exception classes
# Custom exceptions should inherit from StandardError or one of its subclasses

# Basic custom exception class
class MyError < StandardError
  # Simply inheriting is enough for basic functionality
end

# Testing the basic custom exception
begin
  puts "Raising MyError..."
  raise MyError, "Something went wrong"
rescue MyError => e
  puts "Caught MyError: #{e.message}"
end

#############################################################
# Custom exception with additional functionality
class ValidationError < StandardError
  attr_reader :field, :value

  def initialize(message, field, value)
    @field = field
    @value = value
    # Call parent's initialize
    super(message)
  end

  def details
    "Error in field '#{@field}' with value '#{@value}'"
  end
end

# Testing the custom exception with additional data
begin
  # Simulating validation for a user registration
  email = "invalid-email"

  if !email.include?("@")
    raise ValidationError.new(
      "Email must contain @ symbol",
      "email",
      email
    )
  end
rescue ValidationError => e
  puts "Validation failed: #{e.message}"
  puts e.details
  puts "Field: #{e.field}"
  puts "Value: #{e.value}"
end

#############################################################
# Hierarchies of custom exceptions
# Creating a family of related exceptions

# Base application exception
class AppError < StandardError; end

# More specific exceptions
class DatabaseError < AppError; end
class NetworkError < AppError; end
class ConfigError < AppError; end

# Even more specific database errors
class DatabaseConnectionError < DatabaseError; end
class DatabaseQueryError < DatabaseError; end

# Testing exception hierarchy
def simulate_error(error_type)
  case error_type
  when :db_connection
    raise DatabaseConnectionError, "Could not connect to database"
  when :db_query
    raise DatabaseQueryError, "Invalid SQL syntax"
  when :network
    raise NetworkError, "Connection timeout"
  when :config
    raise ConfigError, "Missing configuration key"
  else
    raise AppError, "Unknown application error"
  end
end

# Demonstrate how exceptions can be caught at different levels
[:db_connection, :db_query, :network, :config, :unknown].each do |error_type|
  puts "\nSimulating error: #{error_type}"

  begin
    simulate_error(error_type)
  rescue DatabaseConnectionError => e
    puts "Specific DB connection handler: #{e.message}"
  rescue DatabaseError => e
    puts "General database handler: #{e.message}"
  rescue AppError => e
    puts "Application-level handler: #{e.message}"
  rescue => e
    puts "Catch-all handler: #{e.message}"
  end
end

#############################################################
# Using custom exceptions in a real-world scenario
# Example: User authentication system

class AuthenticationError < StandardError; end
class UserNotFoundError < AuthenticationError; end
class InvalidPasswordError < AuthenticationError; end
class AccountLockedError < AuthenticationError; end

# Simulate a user database
USERS = {
  "alice" => { password: "secret123", locked: false },
  "bob" => { password: "password123", locked: true },
}

def authenticate(username, password)
  # Check if user exists
  unless USERS.key?(username)
    raise UserNotFoundError, "User '#{username}' does not exist"
  end

  user = USERS[username]

  # Check if account is locked
  if user[:locked]
    raise AccountLockedError, "Account for '#{username}' is locked"
  end

  # Check password
  unless user[:password] == password
    raise InvalidPasswordError, "Invalid password for '#{username}'"
  end

  puts "Authentication successful for #{username}"
  return true
end

# Test authentication with different scenarios
[
  { username: "alice", password: "secret123" },  # Should succeed
  { username: "unknown", password: "anything" }, # User not found
  { username: "alice", password: "wrong" },      # Invalid password
  { username: "bob", password: "password123" },   # Account locked
].each do |credentials|
  puts "\nAttempting to authenticate: #{credentials[:username]}"

  begin
    authenticate(credentials[:username], credentials[:password])
  rescue UserNotFoundError => e
    puts "Login failed: #{e.message}"
    puts "Suggestion: Please check your username or register a new account"
  rescue InvalidPasswordError => e
    puts "Login failed: #{e.message}"
    puts "Suggestion: Reset your password if you've forgotten it"
  rescue AccountLockedError => e
    puts "Login failed: #{e.message}"
    puts "Suggestion: Contact customer support to unlock your account"
  rescue AuthenticationError => e
    puts "Login failed: #{e.message}"
  end
end

#############################################################
# Custom exceptions with backtraces

class DetailedError < StandardError
  def initialize(message)
    super(message)
    # Store additional context about where the exception occurred
    @time = Time.now
    @method = caller_locations(1, 1)[0].label
  end

  def details
    "Error occurred at #{@time} in method '#{@method}'"
  end
end

def problematic_method
  # Simulate a problem
  raise DetailedError, "Something unexpected happened"
end

begin
  problematic_method
rescue DetailedError => e
  puts "Error: #{e.message}"
  puts e.details
  puts "Backtrace: #{e.backtrace.first}"
end
