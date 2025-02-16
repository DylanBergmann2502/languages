# ETS stands for Erlang Term Storage
# ETS is a powerful in-memory storage
# that comes with Erlang and is commonly used
# in Elixir applications for fast data access.

# Create a new ETS table named :users
# Options:
# - :set means each key must be unique
# - :public means any process can read/write
# - :named_table allows us to reference the table by name
_table = :ets.new(:users, [:set, :public, :named_table])

# Insert some records into the table
# ETS stores data as tuples where first element is typically the key
:ets.insert(:users, {"user1", "John Doe", 25})
:ets.insert(:users, {"user2", "Jane Smith", 30})

# Lookup a specific record by key
result = :ets.lookup(:users, "user1")
IO.inspect(result)  # [{"user1", "John Doe", 25}] - Returns a list of matching records

##################################################################
# Pattern matching to find records
# Use :"$1", :"$2", etc. as placeholders in match patterns
pattern = {:"$1", :"$2", :"$3"}
match_spec = [{pattern, [], [:"$$"]}]  # :"$$" means "return all variables"all_users = :ets.select(:users, match_spec)
all_users = :ets.select(:users, match_spec)
IO.inspect(all_users)  # [{"user1", "John Doe", 25}, {"user2", "Jane Smith", 30}]

# Alternative approach using simpler matching
all_users_simple = :ets.match(:users, {:"$1", :"$2", :"$3"})
IO.inspect(all_users_simple) # [{"user1", "John Doe", 25}, {"user2", "Jane Smith", 30}]

# Find users over 25 years old
pattern = {:"$1", :"$2", :"$3"}
guard = [{:>, :"$3", 25}]
match_spec = [{pattern, guard, [{{:"$1", :"$2", :"$3"}}]}]
older_users = :ets.select(:users, match_spec)
IO.inspect(older_users, label: "Users over 25")

# Find just the names of users
names_pattern = {:"$1", :"$2", :"$3"}
names_spec = [{names_pattern, [], [:"$2"]}]
just_names = :ets.select(:users, names_spec)
IO.inspect(just_names, label: "Just the names")

##################################################################
# Update a record (insert overwrites existing records)
:ets.insert(:users, {"user1", "John Doe", 26})
updated_user = :ets.lookup(:users, "user1")
IO.inspect(updated_user)  # [{"user1", "John Doe", 26}]

##################################################################
# Delete a record
:ets.delete(:users, "user2")
remaining_users = :ets.select(:users, match_spec)
IO.inspect(remaining_users)  # [{"user1", "John Doe", 26}]

# Delete the entire table when done
:ets.delete(:users)
