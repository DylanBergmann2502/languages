# spawn/1 accepts a function that it will execute directly.
pid_1 = spawn(fn -> 2 + 2 end)

pid_1 |> is_pid() |> IO.puts() # true
IO.inspect pid_1 # PID<0.97.0>

# spawn/3 accepts a function that it will execute by the module name,
# the function name (as atom), and a list of arguments to pass to that function.
pid_2 = spawn(String, :split, ["hello there", " "])

IO.inspect pid_2 # PID<0.98.0>

# A process exits as soon as its function has finished executing.
IO.puts Process.alive?(pid_1)

# We can retrieve the PID of the current process by calling self/0:
IO.inspect self() # PID<0.94.0>
IO.puts Process.alive?(self())

################################################################
# Processes do not directly share information with one another.
# Processes send messages to share data.
# This concurrency pattern is called the Actor model.

# Send messages to a process using send/2.
# The message ends up in the recipient's mailbox in the order that they are sent.
# send does not check if the message was received nor if the recipient is still alive.
# A message can be of any type.
send(pid_1, :hello) # :hello

################################################################
# You can receive a message sent to the current process using receive/1.
# You need to pattern match on messages.
# receive waits until one message matching any given pattern is in the process's mailbox.
# By default, it waits indefinitely, but can be given a timeout using an after block.
# Read messages are removed from the process's mailbox.
# Unread messages will stay there indefinitely.
# Always write a catch-all _ clause in receive/1
# to avoid running of out memory due to piled up unread messages.
receive do
  {:ping, sender_pid} -> send(sender_pid, :pong)
  _ -> nil
after
  1000 ->
    {:error, "No message in 5 seconds"}
end

################################################################
# Put them together
send(self(), {:hello, "world"}) # {:hello, "world"}

msg = receive do
  {:hello, msg} -> msg
  {:world, _msg} -> "won't match"
end

IO.puts msg  # "world"

# Or
parent = self()
spawn(fn -> send(parent, {:hello, self()}) end)

msg = receive do
  {:hello, pid} -> "Got hello from #{inspect pid}"
end
IO.puts msg  # "Got hello from #PID<0.99.0>"

########################################################################
# Process/info/2 can tell us what messages are stored in the process mailbox
send(self(), :hello)
IO.inspect Process.info(self(), :messages) # {:messages, [:hello]}
