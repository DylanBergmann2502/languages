# Structs are maps with a fixed set of fields defined at compile-time
# You can't add new fields at runtime
# They're defined within modules using defstruct
# They can have default values
# Pattern matching works great with structs
# You can nest structs within other structs
# The struct name is always the same as the module name
# You can enforce required fields using @enforce_keys

# Basic struct definition
defmodule Person do
  # defstruct accepts either
  # a list of atoms (for nil default values) or
  # keyword lists (for specified default values).
  defstruct name: "", age: 0, occupation: nil

  def run do
    # Creating struct instances
    person = %Person{}
    IO.inspect(person)  # %Person{name: "", age: 0, occupation: nil}

    # Creating with values
    john = %Person{name: "John", age: 30, occupation: "Developer"}
    IO.inspect(john)  # %Person{name: "John", age: 30, occupation: "Developer"}

    # Structs are simply maps
    # with a "special" field named __struct__
    # that holds the name of the struct:
    IO.inspect(is_map(john)) # true
    IO.inspect(john.__struct__) # Person

    # However, structs do not inherit any of the protocols that maps do.
    # For example, you can neither enumerate nor access a struct:
    # Accessing fields - using dot notation (recommended)
    #                    using [:key] syntax (raises an exception)
    IO.inspect(john.name)       # "John"
    IO.inspect(john.age)        # 30
    # IO.inspect(person[:name]) # ** (UndefinedFunctionError)

    # IO.inspect(Enum.map(person, fn {k, v} -> {k, v} end))
    # ** (Protocol.UndefinedError) protocol Enumerable not implemented for...

    # Updating struct fields
    updated_john = %Person{john | age: 31, occupation: "Senior Developer"}
    IO.inspect(updated_john)   # %Person{name: "John", age: 31, occupation: "Senior Developer"}
  end
end

Person.run()

# Enforcing required fields
defmodule Employee do
  @enforce_keys [:id, :name]
  # The fields without defaults must precede the fields with default values.
  defstruct [:id, :name, department: "General", salary: 0]

  def run do
    # This will raise an error because id and name are required
    # %Employee{}  # -> ArgumentError

    # This works because we provide required fields
    employee = %Employee{id: 1, name: "Alice"}
    IO.inspect(employee)  # %Employee{id: 1, name: "Alice", department: "General", salary: 0}
  end
end

Employee.run()

# Pattern matching with structs
defmodule HR do
  def give_raise(%Employee{salary: salary} = emp) do
    %Employee{emp | salary: salary + 1000}
  end

  def run do
    employee = %Employee{id: 1, name: "Alice"}
    raised_employee = HR.give_raise(employee)
    IO.inspect(raised_employee)  # %Employee{id: 1, name: "Alice", department: "General", salary: 1000}
  end
end

HR.run()

# Nested structs
defmodule Company do
  defstruct name: "", employees: []

  def run do
    company = %Company{
      name: "TechCorp",
      employees: [
        %Employee{id: 1, name: "Alice"},
        %Employee{id: 2, name: "Bob", department: "Engineering"}
      ]
    }
    IO.inspect(company)
  end
end

Company.run()
