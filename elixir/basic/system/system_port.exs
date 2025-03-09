defmodule SystemVsPort do
  # System Module

  # Purpose:       Provides high-level functions for
  #                interacting with the operating system.
  # Function type: Most functions are synchronous and return results directly.
  # Use case:      Best for simple, one-off operations
  #                like getting environment variables or
  #                running a command and waiting for its completion.

  # Port Module

  # Purpose:              Provides a way to communicate with
  #                       external programs asynchronously.
  # Communication style:  Asynchronous, message-based communication.
  # Process relationship: Creates a separate OS process that can
  #                       send messages back to the Elixir process.
  # Use case:             Better for long-running external processes, streaming data,
  #                       or interactive communication with external programs.

  def run do
    IO.puts("=== SYSTEM vs PORT COMPARISON ===\n")

    # Example 1: Simple command execution
    run_example("1. Simple command execution (dir/ls)", fn ->
      IO.puts("SYSTEM: Synchronous, blocks until complete")
      {output, status} = System.cmd("cmd", ["/c", "dir", "/b"], stderr_to_stdout: true)
      IO.puts("Exit status: #{status}")
      IO.puts("First 3 files:")
      output |> String.split("\r\n") |> Enum.take(3) |> Enum.each(&IO.puts("  - #{&1}"))

      IO.puts("\nPORT: Asynchronous, receives output as messages")
      port = Port.open({:spawn, "cmd.exe /c dir /b"}, [:binary])
      files = collect_output(port, 2000, [])
      IO.puts("First 3 files:")
      files |> String.split("\r\n") |> Enum.take(3) |> Enum.each(&IO.puts("  - #{&1}"))
    end)

    # Example 2: Command timing
    run_example("2. Command timing (ping with delay)", fn ->
      IO.puts("SYSTEM: Blocks the Elixir process until command completes")
      start_time = System.monotonic_time(:millisecond)
      {_, _} = System.cmd("ping", ["-n", "3", "127.0.0.1"], stderr_to_stdout: true)
      end_time = System.monotonic_time(:millisecond)
      IO.puts("Total execution time: #{end_time - start_time}ms (entire process blocked)")

      IO.puts("\nPORT: Elixir process can continue while command runs")
      start_time = System.monotonic_time(:millisecond)
      port = Port.open({:spawn, "ping -n 3 127.0.0.1"}, [:binary])
      # We could do other work here while ping runs
      IO.puts("Port started, Elixir process can continue working...")
      # Simulate some other work
      :timer.sleep(100)
      IO.puts("Doing other work while ping runs...")
      collect_output(port, 5000, [])
      end_time = System.monotonic_time(:millisecond)
      IO.puts("Total execution time: #{end_time - start_time}ms (Elixir process remained responsive)")
    end)

    # Example 3: Interactive communication
    run_example("3. Interactive communication", fn ->
      IO.puts("SYSTEM: Can't easily maintain interactive session")
      IO.puts("Limited to one-way execution with input via arguments")
      {result, _} = System.cmd("cmd", ["/c", "echo Hello from System"], stderr_to_stdout: true)
      IO.puts("Result: #{result}")

      IO.puts("\nPORT: Can maintain interactive session, sending commands and getting responses")
      port = Port.open({:spawn, "cmd.exe"}, [:binary, :use_stdio])

      # Get initial output (command prompt)
      initial_output = collect_output_no_close(port, 1000, [])
      IO.puts("Initial prompt: #{String.trim(initial_output)}")

      IO.puts("Sending first command...")
      Port.command(port, "echo First command to cmd.exe\r\n")
      first_response = collect_output_no_close(port, 1000, [])
      IO.puts("Response: #{String.trim(first_response)}")

      IO.puts("Sending second command to the SAME process...")
      Port.command(port, "echo Second command to same cmd.exe process\r\n")
      second_response = collect_output_no_close(port, 1000, [])
      IO.puts("Response: #{String.trim(second_response)}")

      # Close the port when done
      if Port.info(port) != nil, do: Port.close(port)
      IO.puts("Port closed manually")
    end)

    # Example 4: Environment variables
    run_example("4. Working with environment variables", fn ->
      IO.puts("SYSTEM: Direct functions for environment variables")
      System.put_env("TEST_VAR", "Hello from System")
      IO.puts("Value via System: #{System.get_env("TEST_VAR")}")

      IO.puts("\nPORT: Can pass environment to external processes")
      port = Port.open({:spawn, "cmd.exe /c echo %TEST_VAR%"},
                       [:binary, env: [{'TEST_VAR', 'Modified by Port'}]])
      result = collect_output(port, 1000, [])
      IO.puts("Value seen by cmd.exe: #{result}")

      # Show that original environment is still the same
      IO.puts("Value in Elixir still: #{System.get_env("TEST_VAR")}")
    end)
  end

  defp run_example(title, fun) do
    IO.puts("\n" <> String.duplicate("=", 80))
    IO.puts(title)
    IO.puts(String.duplicate("-", 80))
    fun.()
    IO.puts(String.duplicate("=", 80))
  end

  # Standard version that automatically closes the port after timeout
  defp collect_output(port, timeout, acc) do
    receive do
      {^port, {:data, data}} ->
        collect_output(port, timeout, [data | acc])
      {^port, :closed} ->
        IO.puts("Port closed naturally")
        Enum.reverse(acc) |> Enum.join()
    after
      timeout ->
        if Port.info(port) != nil, do: Port.close(port)
        Enum.reverse(acc) |> Enum.join()
    end
  end

  # Version that doesn't close the port after timeout
  defp collect_output_no_close(port, timeout, acc) do
    receive do
      {^port, {:data, data}} ->
        collect_output_no_close(port, timeout, [data | acc])
      {^port, :closed} ->
        IO.puts("Port closed naturally")
        Enum.reverse(acc) |> Enum.join()
    after
      timeout ->
        # Just return accumulated output without closing the port
        Enum.reverse(acc) |> Enum.join()
    end
  end
end

# Run the examples
SystemVsPort.run()
