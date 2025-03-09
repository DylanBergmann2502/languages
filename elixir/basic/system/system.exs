# Exploring the System module

# Get basic system information
IO.puts("Elixir version: #{System.version()}")
IO.puts("OTP release: #{System.otp_release()}")
IO.puts("System architecture: #{:erlang.system_info(:system_architecture)}")
IO.puts("Number of schedulers: #{System.schedulers()}")
IO.puts("Number of schedulers online: #{System.schedulers_online()}")
IO.puts("System endianness: #{System.endianness()}")

# Working with environment variables
System.put_env("MY_TEST_VAR", "hello world")
IO.puts("\nEnvironment variable MY_TEST_VAR: #{System.get_env("MY_TEST_VAR")}")

# Using fetch_env and fetch_env!
case System.fetch_env("MY_TEST_VAR") do
  {:ok, value} -> IO.puts("fetch_env found MY_TEST_VAR: #{value}")
  :error -> IO.puts("fetch_env did not find MY_TEST_VAR")
end

# Uncomment to see error handling with fetch_env!
# value = System.fetch_env!("NON_EXISTENT_VAR")  # This will raise an error

# Get all environment variables
IO.puts("\nFirst 3 environment variables:")
System.get_env() |> Enum.take(3) |> IO.inspect()

# File system operations
IO.puts("\nCurrent working directory: #{File.cwd!()}")
IO.puts("User home directory: #{System.user_home!()}")
IO.puts("Temporary directory: #{System.tmp_dir!()}")

# Find an executable on your system
notepad = System.find_executable("notepad.exe")
IO.puts("\nPath to notepad.exe: #{notepad || "not found"}")

# Command execution examples
# Running a simple command (cmd /c dir on Windows)
IO.puts("\nRunning 'cmd /c dir':")
{output, exit_code} = System.cmd("cmd", ["/c", "dir"], stderr_to_stdout: true)
IO.puts("Exit code: #{exit_code}")
# Print just first few lines to keep output manageable
output |> String.split("\n") |> Enum.take(3) |> Enum.join("\n") |> IO.puts()

# Time related functions
IO.puts("\nCurrent system time: #{System.system_time(:second)} seconds")
IO.puts("Current monotonic time: #{System.monotonic_time(:millisecond)} milliseconds")

# Convert time units
seconds = 120
milliseconds = System.convert_time_unit(seconds, :second, :millisecond)
IO.puts("\n#{seconds} seconds equals #{milliseconds} milliseconds")

# Generate unique integers
IO.puts("\nUnique integers:")
IO.puts(System.unique_integer())
IO.puts(System.unique_integer([:positive]))
IO.puts(System.unique_integer([:monotonic]))
IO.puts(System.unique_integer([:positive, :monotonic]))

# Command line arguments
IO.puts("\nCommand line arguments: #{inspect(System.argv())}")

# Register an at_exit handler
System.at_exit(fn status ->
  IO.puts("Exiting with status: #{status}")
end)

# If you want to see all of System's functions
IO.puts("\nAll functions in System module:")
functions = System.__info__(:functions)
  |> Enum.map(fn {name, arity} -> "#{name}/#{arity}" end)
  |> Enum.take(5)  # Just show first 5 for brevity
IO.inspect(functions)

# Uncommenting this would terminate the script
# System.halt(0)
