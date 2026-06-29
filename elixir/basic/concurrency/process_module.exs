# Deep dive into the Process module beyond the basics.
# You already know spawn, send, receive, and Process.alive?.
# This covers the less obvious but important functions.

################################################################
# Process.send_after/3 - schedule a message in the future

pid = self()

# Send :reminder to self() after 100ms
ref = Process.send_after(pid, :reminder, 100)
IO.inspect(ref) # reference like #Reference<0.1234.5678.9012>

receive do
  :reminder -> IO.puts("Got reminder!")
end

################################################################
# Process.cancel_timer/1 - cancel a scheduled message

ref2 = Process.send_after(self(), :too_late, 1000)

# Cancel it before it fires
result = Process.cancel_timer(ref2)
IO.inspect(result) # integer - milliseconds remaining, or false if already fired

# The message will NOT arrive now
receive do
  :too_late -> IO.puts("this won't print")
after
  200 -> IO.puts("Correctly no message received")
end

################################################################
# Process.flag/2 - set process flags

# :trap_exit - convert exit signals to {:EXIT, pid, reason} messages
# instead of crashing the current process.
Process.flag(:trap_exit, true)

pid2 = spawn_link(fn -> exit(:something_bad) end)

receive do
  {:EXIT, ^pid2, reason} ->
    IO.inspect(reason) # :something_bad
end

Process.flag(:trap_exit, false) # reset

################################################################
# Process.info/2 - inspect a running process

parent = self()
worker = spawn(fn ->
  send(parent, :ready)
  receive do
    :stop -> :ok
  end
end)

receive do :ready -> :ok end

# Check message queue length
send(worker, :msg1)
send(worker, :msg2)
Process.sleep(10)

info = Process.info(worker, [:message_queue_len, :status, :memory])
IO.inspect(info)
# [message_queue_len: 2, status: :waiting, memory: <bytes>]

send(worker, :stop)

################################################################
# Process.hibernate/3 - put a process to sleep, freeing its heap

# Hibernating a process:
# 1. Garbage collects its heap (frees memory)
# 2. Suspends it until a message arrives
# 3. On wake, calls MFA with the message in its mailbox
# This is critical for long-lived idle processes (e.g., idle GenServers)

# In a GenServer you can return {:noreply, state, :hibernate}
# to hibernate after handling a message.

defmodule HibernatingServer do
  use GenServer

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(_), do: {:ok, %{count: 0}}

  def handle_call(:ping, _from, state) do
    {:reply, :pong, state}
  end

  # Hibernate when idle - releases heap memory
  def handle_call(:hibernate_after_reply, _from, state) do
    {:reply, :hibernating, state, :hibernate}
  end
end

{:ok, _pid} = HibernatingServer.start_link([])
IO.inspect(GenServer.call(HibernatingServer, :ping)) # :pong
IO.inspect(GenServer.call(HibernatingServer, :hibernate_after_reply)) # :hibernating

################################################################
# Process.demonitor/2 - remove a monitor

monitored_pid = spawn(fn -> :ok end)
ref3 = Process.monitor(monitored_pid)

# Flush option removes any already-delivered :DOWN message
Process.demonitor(ref3, [:flush])

# Without :flush you might still receive a pending :DOWN
receive do
  {:DOWN, ^ref3, _, _, _} -> IO.puts("won't print - monitor removed")
after
  100 -> IO.puts("Correctly no DOWN message")
end

################################################################
# Process.list/0 - all living processes

all_pids = Process.list()
IO.puts("Total processes: #{length(all_pids)}")

################################################################
# Selective receive - BEAM scans the mailbox in order

send(self(), :b)
send(self(), :a)
send(self(), :c)

# receive matches the FIRST message in the mailbox that fits a pattern.
# :a is second but we match it first - :b stays in the mailbox.
receive do
  :a -> IO.puts("matched :a")
end
receive do
  :b -> IO.puts("matched :b")
end
receive do
  :c -> IO.puts("matched :c")
end

################################################################
# Checking the mailbox without consuming

send(self(), :peek_me)
IO.inspect(Process.info(self(), :messages)) # {:messages, [:peek_me]}
receive do :peek_me -> :ok end

################################################################
# Process.sleep/1 vs receive after

# Process.sleep/1 blocks but the process can still receive messages
# (they just queue up). Under the hood it uses receive after.

# Prefer receive after when you need to handle messages during a wait:
defmodule Waiter do
  def wait_or_receive(timeout) do
    receive do
      msg -> IO.inspect({:got_message, msg})
    after
      timeout -> IO.puts("Timed out after #{timeout}ms")
    end
  end
end

send(self(), :hello)
Waiter.wait_or_receive(1000) # {:got_message, :hello}
Waiter.wait_or_receive(50)   # Timed out after 50ms
