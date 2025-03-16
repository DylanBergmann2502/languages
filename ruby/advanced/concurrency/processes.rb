# Ruby Processes
# Processes provide true parallelism by spawning entirely separate OS processes

########################################################################
# Basic Process Creation using system
# The system method runs a command in a subshell and waits for it to complete
puts "Running command with system:"
success = system("echo Hello from subprocess")
puts "Command exited with success: #{success}"

# Running a command that fails
success = system("nonexistent_command 2>/dev/null")
puts "Command exited with success: #{success}"
puts "Exit status: #{$?.exitstatus}"

########################################################################
# Using backticks (`) to capture output
puts "\nCapturing output with backticks:"
output = `ruby -e "puts 'Output from another Ruby process'"`
puts "Captured: #{output}"
puts "Exit status: #{$?.exitstatus}"

# Note: The %x{} syntax does the same thing as backticks
output = %x{ruby -v}
puts "Ruby version: #{output.strip}"

########################################################################
# Using IO.popen for more control
puts "\nUsing IO.popen for bidirectional communication:"
IO.popen("ruby -e 'puts gets.upcase'", "r+") do |io|
  io.puts "send this to the subprocess"
  io.close_write  # Signal we're done writing
  result = io.read
  puts "Got back: #{result}"
end

########################################################################
# Using Process.spawn for non-blocking process creation
puts "\nUsing Process.spawn:"
pid = Process.spawn("ruby -e 'puts \"Process #{Process.pid} is running\"; sleep 1'")
puts "Started process with PID: #{pid}"
puts "Main process continues immediately..."

# Wait for the process to finish
Process.wait(pid)
puts "Process #{pid} has finished"

########################################################################
# Process.fork - Ruby's way to create a new process
# Note: Process.fork is not available on all platforms (e.g., Windows)
puts "\nUsing Process.fork (if available):"

if Process.respond_to?(:fork)
  puts "Fork is available on this platform"

  # Create a child process
  child_pid = Process.fork do
    puts "Child process #{Process.pid} started"
    sleep 1
    puts "Child process exiting"
    exit! # Force exit without running at_exit hooks
  end

  puts "Parent process continues, child PID: #{child_pid}"

  # Wait for child to finish
  Process.wait(child_pid)
  puts "Child process #{child_pid} has finished"

  # Process.detach - lets child run independently
  child_pid = Process.fork do
    puts "Detached child #{Process.pid} started"
    sleep 2
    puts "Detached child exiting"
  end

  # Detach the child process
  Process.detach(child_pid)
  puts "Child process #{child_pid} has been detached"
else
  puts "Fork is not available on this platform"
end

########################################################################
# Open3 module for full process control
require "open3"
puts "\nUsing Open3 for full process control:"

# Capture stdout, stderr, and status
stdout, stderr, status = Open3.capture3("ruby -e 'puts \"Standard output\"; warn \"Standard error\"'")
puts "Stdout: #{stdout}"
puts "Stderr: #{stderr}"
puts "Exit status: #{status.exitstatus}"

# Using popen3 for interactive communication
Open3.popen3("ruby -e 'loop { puts gets.chomp.reverse; STDOUT.flush }'") do |stdin, stdout, stderr, wait_thr|
  # Write to the process
  stdin.puts "Hello, process!"
  puts "Process returned: #{stdout.gets.chomp}"

  stdin.puts "Ruby is fun"
  puts "Process returned: #{stdout.gets.chomp}"

  # Close stdin to signal we're done
  stdin.close

  # Wait for the process to exit
  wait_thr.value
end

########################################################################
# Process communication through pipes
puts "\nProcess communication through pipes:"

if Process.respond_to?(:fork)
  # Create a pipe
  rd, wr = IO.pipe

  # Fork a child process
  child_pid = Process.fork do
    # Close the read end in the child
    rd.close

    # Write to the pipe
    5.times do |i|
      wr.puts "Message #{i} from child process #{Process.pid}"
      sleep 0.5
    end

    wr.close
    exit!
  end

  # Close the write end in the parent
  wr.close

  # Read from the pipe
  while message = rd.gets
    puts "Parent received: #{message.chomp}"
  end

  # Close the read end
  rd.close

  # Wait for the child to finish
  Process.wait(child_pid)
  puts "Child process communication complete"
else
  puts "Pipe example skipped (fork not available)"
end

########################################################################
# Process environment variables
puts "\nProcess environment variables:"

# Set environment variables for a child process
env = { "CUSTOM_VAR" => "custom_value", "ANOTHER_VAR" => "another_value" }
# Fixed line - using proper string escape for the command
system(env, 'ruby -e "puts \"CUSTOM_VAR=#{ENV[\"CUSTOM_VAR\"]}\""')

# Environment variables don't affect the parent process
puts "In parent: CUSTOM_VAR=#{ENV["CUSTOM_VAR"].inspect}"

########################################################################
# Process priority (nice)
puts "\nProcess priority (nice):"

# Check if we're on a Unix-like system where PRIO constants are defined
if defined?(Process::PRIO_PROCESS)
  begin
    # Get current priority
    current_priority = Process.getpriority(Process::PRIO_PROCESS, 0)
    puts "Current process priority: #{current_priority}"

    # Try to lower priority (increase nice value)
    Process.setpriority(Process::PRIO_PROCESS, 0, current_priority + 1)
    new_priority = Process.getpriority(Process::PRIO_PROCESS, 0)
    puts "New process priority: #{new_priority}"
  rescue Errno::EPERM
    puts "Cannot change priority (permission denied)"
  end
else
  puts "Process priority operations not available on this platform"
end

puts "\nProcess execution completed!"
