# The majority of times we spawn processes in Elixir, we spawn them as linked processes.
# When a process started with spawn/1 fails,
# it merely logged an error but the parent process is still running.

spawn(fn -> raise "oops" end) #PID<0.94.0>
# [error] Process #PID<0.94.00> raised an exception
# ** (RuntimeError) oops
#     (stdlib) erl_eval.erl:668: :erl_eval.do_apply/6

# That's because processes are isolated.
# If we want the failure in one process
# to propagate to another one, we should link them.
# This can be done with spawn_link/1

# spawn_link(fn -> raise "oops" end)

#######################################################
# Process linking
defmodule Link do
  def run do
    # Trap exits in the current process
    Process.flag(:trap_exit, true)

    # Spawn a linked process that will crash
    pid = spawn_link(fn ->
      IO.puts "Child process starting..."
      raise "crash!"
    end)

    # Receive the exit signal
    receive do
      {:EXIT, ^pid, reason} ->
        IO.puts "Received exit signal. Reason: #{inspect(reason)}"
    end
  end
end

Link.run()

#######################################################
# Process monitoring
defmodule Monitor do
  def run do
    # Spawn and monitor a process
    {pid, ref} = spawn_monitor(fn ->
      IO.puts "Monitored process starting..."
      raise "crash!"
    end)

    # Receive the DOWN message
    receive do
      {:DOWN, ^ref, :process, ^pid, reason} ->
        IO.puts "Process terminated. Reason: #{inspect(reason)}"
    end
  end
end

Monitor.run()
