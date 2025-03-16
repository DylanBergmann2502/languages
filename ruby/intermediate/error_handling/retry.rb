#############################################################
# Ruby Error Handling with Retry
#############################################################

# The retry statement can be used within a begin/rescue block
# to restart the execution from the beginning of the begin block

# Basic retry example
puts "Basic retry example:"
attempt = 0

begin
  attempt += 1
  puts "  Attempt #{attempt}..."

  # Simulate a failure for the first two attempts
  if attempt < 3
    puts "  Failed!"
    raise "Simulated failure"
  end

  puts "  Success!"
rescue => e
  puts "  Rescued: #{e.message}"
  retry if attempt < 3 # Try again if we haven't reached max attempts
end

puts

#############################################################
# Practical example: Retrying network operations
puts "Network request simulation:"

def simulate_network_request
  # Simulate network flakiness - 70% chance of success
  success = rand(10) < 7

  unless success
    raise "Network timeout"
  end

  return "Response data"
end

def fetch_with_retry(max_attempts = 3, delay = 1)
  attempts = 0

  begin
    attempts += 1
    puts "  Request attempt #{attempts}..."

    response = simulate_network_request
    puts "  Request successful!"
    return response
  rescue => e
    puts "  Request failed: #{e.message}"

    if attempts < max_attempts
      puts "  Waiting #{delay} second(s) before retry..."
      sleep(delay)
      retry # Try the request again
    else
      puts "  Maximum attempts reached. Giving up."
      raise # Re-raise the exception to be handled by the caller
    end
  end
end

begin
  result = fetch_with_retry(5, 0.5) # Allow up to 5 attempts with 0.5s between retries
  puts "  Got result: #{result}"
rescue => e
  puts "  Final error: #{e.message}"
end

puts

#############################################################
# Exponential backoff strategy
puts "Exponential backoff example:"

def fetch_with_backoff(max_attempts = 5)
  attempts = 0

  begin
    attempts += 1
    puts "  Request attempt #{attempts}..."

    # Simulate a request with high chance of failure on early attempts
    # The more attempts we make, the more likely it is to succeed
    success_threshold = attempts * 20 # 20%, 40%, 60%, 80%, 100%
    success = rand(100) < success_threshold

    unless success
      raise "Service unavailable"
    end

    puts "  Request successful!"
    return "Response data"
  rescue => e
    puts "  Request failed: #{e.message}"

    if attempts < max_attempts
      # Calculate backoff time: 2^attempts (exponential backoff)
      # e.g., 1s, 2s, 4s, 8s, ...
      backoff_time = 2 ** (attempts - 1) * 0.1 # Using 0.1 to make example run faster

      puts "  Backing off for #{backoff_time} second(s)..."
      sleep(backoff_time)
      retry
    else
      puts "  Maximum attempts reached. Giving up."
      raise
    end
  end
end

begin
  result = fetch_with_backoff
  puts "  Got result: #{result}"
rescue => e
  puts "  Final error: #{e.message}"
end

puts

#############################################################
# Retry with circuit breaker pattern
puts "Circuit breaker pattern example:"

class CircuitBreaker
  attr_reader :state

  def initialize(failure_threshold = 3, reset_timeout = 5)
    @failure_threshold = failure_threshold
    @reset_timeout = reset_timeout
    @failures = 0
    @last_failure_time = nil
    @state = :closed # closed = working, open = not allowing calls
  end

  def register_failure
    @failures += 1
    @last_failure_time = Time.now

    if @failures >= @failure_threshold
      @state = :open
      puts "  Circuit breaker OPENED (not allowing more calls)"
    end
  end

  def register_success
    @failures = 0
    @state = :closed
  end

  def allow_request?
    # If circuit is closed, always allow
    return true if @state == :closed

    # If it's been long enough since our last failure, try a request
    if @last_failure_time && Time.now - @last_failure_time >= @reset_timeout
      @state = :half_open
      puts "  Circuit breaker HALF-OPEN (allowing test request)"
      return true
    end

    # Otherwise, circuit is open and we don't allow requests
    false
  end
end

def call_service_with_circuit_breaker(circuit_breaker)
  # Don't even try if the circuit breaker says no
  unless circuit_breaker.allow_request?
    puts "  Request blocked by circuit breaker"
    raise "Circuit is open"
  end

  # Try to make the call
  begin
    # Simulate flaky service (70% failure rate for demo purposes)
    if rand < 0.7
      raise "Service error"
    end

    # If we get here, call succeeded
    puts "  Service call successful"
    circuit_breaker.register_success
    return "Response data"
  rescue => e
    puts "  Service call failed: #{e.message}"
    circuit_breaker.register_failure
    raise
  end
end

# Create a circuit breaker with low thresholds for demo purposes
breaker = CircuitBreaker.new(3, 2) # 3 failures to open, 2 seconds to try again

# Try several calls
10.times do |i|
  puts "\n  Request #{i + 1}:"

  begin
    result = call_service_with_circuit_breaker(breaker)
    puts "  Got result: #{result}"
  rescue => e
    puts "  Error: #{e.message}"
  end

  # Pause between requests
  sleep(0.5)
end

puts

#############################################################
# Retry with jitter to prevent thundering herd
puts "Retry with jitter example:"

def retry_with_jitter(max_attempts = 5)
  attempts = 0

  begin
    attempts += 1
    puts "  Attempt #{attempts}..."

    # Simulate failure 80% of the time
    if rand < 0.8
      raise "Temporary failure"
    end

    puts "  Success!"
    return "Data"
  rescue => e
    puts "  Failed: #{e.message}"

    if attempts < max_attempts
      # Calculate base delay: 2^attempt * 100ms
      base_delay = 2 ** (attempts - 1) * 0.1

      # Add randomness (jitter) to avoid retry storms
      # Use 0-50% jitter
      jitter = rand * base_delay * 0.5

      # Apply jitter
      actual_delay = base_delay + jitter

      puts "  Waiting #{actual_delay.round(2)}s before retry..."
      sleep(actual_delay)
      retry
    else
      puts "  Maximum attempts reached. Giving up."
      raise
    end
  end
end

begin
  result = retry_with_jitter
  puts "  Got result: #{result}"
rescue => e
  puts "  Final error: #{e.message}"
end
