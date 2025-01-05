# The Access Behaviour provides a common interface
# for retrieving key-based data from a data structure.
# It is implemented for maps and keyword lists.
# Structs do not implement the Access behaviour.

# To use the behaviour, you may follow a bound variable
# with square brackets and then use the key
# to retrieve the value associated with that key.

# Let's create some nested data to work with
user = %{
  name: "John",
  profile: %{
    age: 30,
    address: %{
      city: "New York",
      country: "USA"
    },
    hobbies: ["reading", "coding"]
  }
}

# Basic Access behavior
IO.inspect user[:name]  # => "John"
IO.inspect user.profile[:age]  # => 30

# get_in/2 - Gets a value from a nested structure
IO.inspect get_in(user, [:profile, :age])  # => 30
IO.inspect get_in(user, [:profile, :address, :city])  # => "New York"
# If the key does not exist in the data structure, then nil is returned.
# This can be a source of unintended behavior, because it does not raise an error.
IO.inspect get_in(user, [:profile, :invalid])  # => nil

# Note that nil itself implements the Access Behaviour and always returns nil for any key.
IO.inspect nil[:key] # => nil

# put_in/2 and put_in/3 - Updates a value in a nested structure
updated_user = put_in(user, [:profile, :age], 31)
IO.inspect get_in(updated_user, [:profile, :age])  # => 31

# Using put_in/3 with Access behavior
updated_address = put_in(user[:profile][:address][:city], "Los Angeles")
IO.inspect get_in(updated_address, [:profile, :address, :city])  # => "Los Angeles"

# update_in/2 and update_in/3 - Updates a value using a function
aged_user = update_in(user, [:profile, :age], &(&1 + 1))
IO.inspect get_in(aged_user, [:profile, :age])  # => 31

# Using update_in with lists
updated_hobbies = update_in(user, [:profile, :hobbies], &(["gaming" | &1]))
IO.inspect get_in(updated_hobbies, [:profile, :hobbies])  # => ["gaming", "reading", "coding"]

# get_and_update_in/2 and get_and_update_in/3 - Gets and updates a value atomically
{old_age, updated_user} = get_and_update_in(user, [:profile, :age], fn current_age ->
  {current_age, current_age + 1}
end)
IO.inspect old_age  # => 30
IO.inspect get_in(updated_user, [:profile, :age])  # => 31

# pop_in/1 and pop_in/2 - Removes a value and returns it along with the updated structure
{city, user_without_city} = pop_in(user, [:profile, :address, :city])
IO.inspect city  # => "New York"
IO.inspect get_in(user_without_city, [:profile, :address, :city])  # => nil

# Working with lists using Access.all()
users = [
  %{name: "John", age: 30},
  %{name: "Jane", age: 25},
  %{name: "Bob", age: 35}
]

# Update all ages
updated_users = update_in(users, [Access.all(), :age], &(&1 + 1))
IO.inspect updated_users
# => [
#      %{name: "John", age: 31},
#      %{name: "Jane", age: 26},
#      %{name: "Bob", age: 36}
#    ]

# Using Access.at/1 to target specific index
specific_update = update_in(users, [Access.at(1), :age], &(&1 + 10))
IO.inspect specific_update
# => [
#      %{name: "John", age: 30},
#      %{name: "Jane", age: 35},
#      %{name: "Bob", age: 35}
#    ]

# Using Access.filter/1
adults = get_in(users, [Access.filter(&(&1.age >= 30))])
IO.inspect adults  # => [%{name: "John", age: 30}, %{name: "Bob", age: 35}]
