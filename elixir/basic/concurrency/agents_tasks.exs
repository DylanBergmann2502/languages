# An Agent is like a simple state container that runs as a separate process
# It's used to maintain mutable state in an immutable language
# You can read from and update the state through the Agent process

# A Task is for executing one-off operations asynchronously
# Tasks are typically used for concurrent operations that don't need to maintain state
# They return their result when completed

# Start an Agent with initial state
{:ok, agent} = Agent.start_link(fn -> 0 end)

# Create a task that interacts with the agent
task = Task.async(fn ->
  current_value = Agent.get(agent, fn state -> state end)
  Agent.update(agent, fn _ -> current_value + 1 end)
  Agent.get(agent, fn state -> state end)
end)

# Wait for task result
result = Task.await(task)
IO.puts result

################################################################
# Multiple Tasks accessing one Agent:
tasks = Enum.map(1..3, fn _ ->
  Task.async(fn ->
    Agent.update(agent, fn count -> count + 1 end)
  end)
end)

# Wait for all tasks to complete
Enum.each(tasks, &Task.await/1)

# Tasks using Agent as a cache or shared state:
{:ok, cache} = Agent.start_link(fn -> %{} end)

task1 = Task.async(fn ->
  Agent.update(cache, fn state ->
    Map.put(state, :key1, "value1")
  end)
end)

task2 = Task.async(fn ->
  Agent.get(cache, fn state ->
    Map.get(state, :key1)
  end)
end)
