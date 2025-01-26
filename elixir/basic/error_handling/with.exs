# First, let's define some functions that might fail
defmodule UserService do
  def get_user(id) when is_integer(id) do
    # Simulate database lookup
    if id == 123 do
      {:ok, %{id: 123, name: "John"}}
    else
      {:error, :user_not_found}
    end
  end

  def get_profile(user) do
    # Simulate profile lookup
    if user.id == 123 do
      {:ok, %{bio: "Elixir developer"}}
    else
      {:error, :profile_not_found}
    end
  end

  # Without using 'with' (nested case statements)
  def get_user_info_without_with(user_id) do
    case UserService.get_user(user_id) do
      {:ok, user} ->
        case UserService.get_profile(user) do
          {:ok, profile} ->
            {:ok, %{user: user, profile: profile}}
          {:error, reason} ->
            {:error, reason}
        end
      {:error, reason} ->
        {:error, reason}
    end
  end

  # Using 'with' (much cleaner)
  def get_user_info_with_with(user_id) do
    # At each step, if a clause matches,
    # the chain will continue until the do block is executed.
    # If one match fails, the chain stops and the non-matching clause is returned.
    with {:ok, user} <- UserService.get_user(user_id),
        {:ok, profile} <- UserService.get_profile(user) do
      {:ok, %{user: user, profile: profile}}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end

# Let's try both approaches
IO.inspect(UserService.get_user_info_with_with(123))
# {:ok, %{user: %{id: 123, name: "John"}, profile: %{bio: "Elixir developer"}}}

IO.inspect(UserService.get_user_info_with_with(456))
# {:error, :user_not_found}
