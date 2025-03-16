###########################################################################
# The Singleton Pattern ensures a class has only one instance and provides
# a global point of access to it. This is useful when exactly one object
# is needed to coordinate actions across the system.
###########################################################################

# Ruby provides a built-in module for implementing the Singleton pattern
require "singleton"

# Example 1: Using Ruby's built-in Singleton module
class ConfigurationManager
  include Singleton

  attr_accessor :settings

  def initialize
    # This will only be called once
    puts "Initializing ConfigurationManager"
    @settings = {
      host: "localhost",
      port: 3000,
      environment: "development",
    }
  end

  def display_settings
    settings.each do |key, value|
      puts "#{key}: #{value}"
    end
  end
end

# Let's try to create multiple instances
# Notice we don't use .new - we use .instance instead
config1 = ConfigurationManager.instance
config2 = ConfigurationManager.instance

# Verify both references point to the same object
puts "Are config1 and config2 the same object? #{config1.object_id == config2.object_id}"

# Modify settings through one reference
config1.settings[:environment] = "production"

# Display settings through the other reference - they reflect the change
puts "\nSettings after modification:"
config2.display_settings

###########################################################################
# Example 2: Implementing the Singleton pattern manually (without the module)
# This demonstrates how the Singleton pattern works under the hood
###########################################################################

class Logger
  # Class variable to hold the single instance
  @@instance = nil

  # Make new private to prevent direct instantiation
  private_class_method :new

  def self.instance
    # Create the instance if it doesn't exist yet
    @@instance ||= new
  end

  def initialize
    puts "Initializing Logger"
    @log = []
  end

  def log(message)
    @log << "[#{Time.now}] #{message}"
  end

  def display_log
    puts "\nLog entries:"
    @log.each { |entry| puts entry }
  end
end

# Create logger instances
logger1 = Logger.instance
logger2 = Logger.instance

# Verify both references point to the same object
puts "\nAre logger1 and logger2 the same object? #{logger1.object_id == logger2.object_id}"

# Add log entries through different references
logger1.log("Application started")
logger2.log("User logged in")
logger1.log("Query executed")

# Display all logs
logger1.display_log

###########################################################################
# Example 3: Thread-safe singleton implementation
# The standard Ruby Singleton module is thread-safe, but here's how you could
# implement thread safety manually
###########################################################################

class DatabaseConnection
  @@instance = nil
  @@mutex = Mutex.new

  private_class_method :new

  def self.instance
    # Thread-safe instance creation using a mutex
    @@mutex.synchronize do
      @@instance ||= new
    end
  end

  def initialize
    puts "\nInitializing DatabaseConnection"
    @connected = false
  end

  def connect
    return "Already connected" if @connected
    # Simulate connection delay
    sleep 0.5
    @connected = true
    "Connected to database"
  end

  def execute_query(sql)
    return "Not connected" unless @connected
    "Executing: #{sql}"
  end
end

# Test thread-safety by creating instances in multiple threads
puts "\nTesting thread-safety:"
threads = []
5.times do |i|
  threads << Thread.new do
    db = DatabaseConnection.instance
    puts "Thread #{i}: #{db.object_id}"
    puts "Thread #{i}: #{db.connect}"
  end
end

threads.each(&:join)

# Execute a query through the singleton
db = DatabaseConnection.instance
puts db.execute_query("SELECT * FROM users")

###########################################################################
# Common use cases for Singleton:
# 1. Configuration settings
# 2. Connection pools
# 3. Logger instances
# 4. Caches
# 5. Device drivers or hardware interfaces
###########################################################################

# Drawbacks of Singleton:
# 1. Can make code harder to test
# 2. Can introduce global state, which may lead to tight coupling
# 3. Can make parallel execution difficult in some cases
# 4. May hide dependencies
