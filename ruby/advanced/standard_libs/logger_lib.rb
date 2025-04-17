# Ruby's Logger - A flexible logging utility
require "logger"

#################################################################
# Basic Usage
# Logger is used for recording program messages to a file or stream
# with timestamp and severity levels

# Creating a logger that writes to STDOUT
stdout_logger = Logger.new(STDOUT)
stdout_logger.info("This message goes to the console")

# Creating a logger that writes to a file
file_logger = Logger.new("application.log")
file_logger.info("This message goes to application.log")

#################################################################
# Severity Levels
# Logger has 6 levels of severity (from lowest to highest):
# DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN

# Setting the minimum severity level
# Messages below this level will be ignored
stdout_logger.level = Logger::INFO

stdout_logger.debug("This debug message won't be shown")
stdout_logger.info("This info message will be shown")
stdout_logger.warn("This is a warning message")
stdout_logger.error("This is an error message")
stdout_logger.fatal("This is a fatal error message")
stdout_logger.unknown("This is an unknown message")

# You can also check if a level would be logged
puts stdout_logger.debug? # false
puts stdout_logger.info?  # true

#################################################################
# Log Message Format
# By default, log messages include timestamp, severity, program name, and message

# Customizing the program name
stdout_logger.progname = "MyRubyApp"
stdout_logger.info("Message with custom program name")

# Logger allows you to pass a block to generate a message only if that level is enabled
# This is useful for expensive message generation
stdout_logger.debug { "Expensive debug message that won't be calculated since debug level is disabled" }
stdout_logger.info { "Expensive info message that will be calculated" }

#################################################################
# Formatters
# You can customize how log messages are formatted

# Simple formatter that only shows the message
stdout_logger.formatter = proc do |severity, datetime, progname, msg|
  "#{msg}\n"
end
stdout_logger.info("This message has no timestamp or severity")

# Custom formatter with colored output for different severity levels
stdout_logger.formatter = proc do |severity, datetime, progname, msg|
  color = case severity
    when "DEBUG" then "\e[34m" # blue
    when "INFO" then "\e[32m" # green
    when "WARN" then "\e[33m" # yellow
    when "ERROR" then "\e[31m" # red
    when "FATAL" then "\e[35m" # magenta
    else "\e[37m" # white
    end
  reset_color = "\e[0m"
  "#{color}[#{datetime}] #{severity} - #{msg}#{reset_color}\n"
end

stdout_logger.info("This message is green")
stdout_logger.error("This message is red")

#################################################################
# Log Rotation
# For production applications, you'll want log rotation to manage file sizes

# Create a logger with age-based rotation (daily logs for 7 days)
daily_logger = Logger.new("daily.log", "daily", 7)
daily_logger.info("This goes into today's daily log file")

# Create a logger with size-based rotation (5 files of 1MB each)
size_logger = Logger.new("size.log", 5, 1024 * 1024)
size_logger.info("This message is part of a size-rotated log")

#################################################################
# Multiple Handlers
# Sometimes we want to log to multiple destinations

# Log to both console and file
$multi_logger = Logger.new(STDOUT)
$file_logger = Logger.new("application.log")

# When we want to log a message to both
def log_everywhere(message, severity = :info)
  $multi_logger.send(severity, message)
  $file_logger.send(severity, message)
end

log_everywhere("This message goes to both console and file")

#################################################################
# Logger and Exceptions
# A common pattern for logging exceptions

begin
  # Simulate an error
  raise "Something went wrong!"
rescue => e
  # Log the exception with backtrace
  stdout_logger.error("Error occurred: #{e.message}")
  stdout_logger.error(e.backtrace.join("\n"))
end

#################################################################
# Logger Subclassing
# You can create custom loggers by subclassing Logger

class CustomLogger < Logger
  def initialize(logdev, shift_age = 0, shift_size = 1048576)
    super
    self.formatter = proc do |severity, datetime, progname, msg|
      "[#{datetime}] CustomLogger #{severity}: #{msg}\n"
    end
    self.level = INFO
  end

  def startup_message
    info("Application starting up...")
  end

  def shutdown_message
    info("Application shutting down...")
  end
end

custom_logger = CustomLogger.new(STDOUT)
custom_logger.startup_message
custom_logger.info("Application running")
custom_logger.shutdown_message

#################################################################
# Thread Safety
# Logger is thread-safe by default

# In a multi-threaded application:
require "thread"

threads = []
logger = Logger.new("threaded.log")

3.times do |i|
  threads << Thread.new do
    5.times do |j|
      logger.info("Thread #{i} - Log entry #{j}")
      sleep rand(0.1)
    end
  end
end

threads.each(&:join)
puts "All threads have completed logging"

#################################################################
# Clean up log files at the end
puts "\nCleaning up log files..."

# List of files to clean up
log_files = ["application.log", "daily.log", "size.log", "threaded.log"]

# Delete each file if it exists
log_files.each do |file|
  if File.exist?(file)
    File.delete(file)
  else
    puts "Not found: #{file}"
  end
end

puts "Cleanup complete!"
