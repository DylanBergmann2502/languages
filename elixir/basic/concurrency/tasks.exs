# Basic async/await example
task = Task.async(fn ->
  Process.sleep(2000)  # Simulate work
  "Hello"
end)
result = Task.await(task)  # Waits for task completion
IO.inspect(result)  # "Hello"

# Task.start - spawns a task that runs independently
# Returns {:ok, pid}. No way to get result
Task.start(fn ->
  Process.sleep(1000)
  IO.puts("Task.start completed")
end)

# Task.start_link - like start but links to current process
# If task crashes, calling process also crashes
{:ok, pid} = Task.start_link(fn ->
  Process.sleep(1000)
  IO.puts("Task.start_link completed")
end)

# Task.await with timeout (default 5000ms)
task = Task.async(fn ->
  Process.sleep(6000)
  "Timeout example"
end)
try do
  Task.await(task, 3000)  # Will timeout after 3 seconds
catch
  :exit, {:timeout, _} -> "Task timed out"
end

# Task.async_stream - process collection in parallel
# Returns ordered results
result = Task.async_stream(1..5, fn x ->
  Process.sleep(1000)
  x * 2
end, max_concurrency: 2)  # Only 2 tasks run simultaneously
|> Enum.to_list()
IO.inspect(result)  # [{:ok, 2}, {:ok, 4}, {:ok, 6}, {:ok, 8}, {:ok, 10}]

# Task.await_many - wait for multiple tasks
tasks = Enum.map(1..3, fn x ->
  Task.async(fn ->
    Process.sleep(1000)
    x * 2
  end)
end)
results = Task.await_many(tasks)
IO.inspect(results)  # [2, 4, 6]
