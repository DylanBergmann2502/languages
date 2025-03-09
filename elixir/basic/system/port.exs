# Ports are useful for tasks like:
# - Running system commands
# - Interfacing with legacy systems
# - Using external tools and utilities
# - Performing OS-specific operations

defmodule PortExample do
  def run do
    IO.puts("=== Running Directory Listing ===")
    # Windows uses dir instead of ls
    dir_port = Port.open({:spawn, "cmd.exe /c dir"}, [:binary])
    collect_output(dir_port)

    IO.puts("\n=== Running Hello World Executable ===")
    # Path to your executable - adjust if needed
    hello_port = Port.open({:spawn_executable, "./hello_world.exe"}, [:binary])
    collect_output(hello_port)

    IO.puts("\n=== Interactive Example - Echo Service ===")
    # Opening a command prompt
    cmd_port = Port.open({:spawn, "cmd.exe"}, [:binary, :use_stdio])
    # Send a command to display echo
    Port.command(cmd_port, "echo This is sent from Elixir\r\n")
    collect_output(cmd_port)
  end

  defp collect_output(port) do
    receive do
      {^port, {:data, data}} ->
        IO.write(data)
        collect_output(port)
      {^port, :closed} ->
        IO.puts("Port closed")
    after
      3000 ->
        IO.puts("Output collection complete or timed out")
        # Check if port is still open before closing
        if Port.info(port) != nil do
          Port.close(port)
        end
    end
  end
end

PortExample.run()
