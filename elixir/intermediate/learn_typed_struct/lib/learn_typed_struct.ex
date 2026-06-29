defmodule LearnTypedStruct do
  @moduledoc """
  TypedStruct v0.3 — macro-based typed struct definition.

  Elixir's built-in defstruct has no type enforcement at definition time.
  TypedStruct generates the struct, @enforce_keys, and @type t() spec
  from a single declarative block — less boilerplate, always in sync.

  Setup in mix.exs:
    {:typed_struct, "~> 0.3"}
  """

  def run do
    IO.puts("\n=== TypedStruct: Declarative Typed Structs ===\n")

    basic_usage()
    enforcement()
    defaults()
    opaque_and_module()
    nested_structs()
    comparison_with_plain_struct()
  end

  # -----------------------------------------------------------------------
  # 1. Basic usage
  # -----------------------------------------------------------------------
  defp basic_usage do
    IO.puts("--- Basic Usage ---")

    user = %BasicUser{name: "Alice", email: "alice@example.com", age: 30}
    IO.puts("User: #{inspect(user)}")
    IO.puts("Name: #{user.name}")
    IO.puts("Type is BasicUser: #{is_struct(user, BasicUser)}")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Enforce keys
  # -----------------------------------------------------------------------
  defp enforcement do
    IO.puts("--- Enforce Keys ---")

    # EnforcedUser requires name and email (they have enforce: true implicitly
    # via the module-level enforce: true option)
    user = %EnforcedUser{name: "Bob", email: "bob@example.com"}
    IO.puts("Enforced user: #{inspect(user)}")

    # This would raise at compile time:
    # %EnforcedUser{}  # missing :name and :email
    IO.puts("Enforce works at struct creation time (compile-time check)")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. Defaults and optional fields
  # -----------------------------------------------------------------------
  defp defaults do
    IO.puts("--- Defaults & Optional Fields ---")

    # Fields with defaults are not enforced
    config = %AppConfig{}
    IO.puts("Default config: #{inspect(config)}")

    config2 = %AppConfig{host: "prod.example.com", port: 443, ssl: true}
    IO.puts("Custom config: #{inspect(config2)}")

    # Fields with no default and not enforced → nil
    product = %Product{name: "Widget"}
    IO.puts("Product (description is nil): #{inspect(product)}")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Opaque types and submodule
  # -----------------------------------------------------------------------
  defp opaque_and_module do
    IO.puts("--- Opaque Type & Submodule ---")

    # opaque: true generates @opaque t() instead of @type t()
    # (prevents external code from inspecting internal type structure)
    token = %OpaqueToken{value: "secret_xyz", expires_at: DateTime.utc_now()}
    IO.puts("Opaque token created: #{inspect(token)}")

    # module: SubmoduleName creates the struct inside a nested module
    point = %Geometry.Point{x: 3.0, y: 4.0}
    IO.puts("Geometry.Point: #{inspect(point)}")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Nested typed structs
  # -----------------------------------------------------------------------
  defp nested_structs do
    IO.puts("--- Nested Structs ---")

    address = %Address{
      street: "123 Main St",
      city:   "Springfield",
      zip:    "12345"
    }

    person = %Person{
      name:    "Carol",
      email:   "carol@example.com",
      address: address
    }

    IO.puts("Person: #{inspect(person)}")
    IO.puts("City: #{person.address.city}")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 6. Compare with plain Elixir
  # -----------------------------------------------------------------------
  defp comparison_with_plain_struct do
    IO.puts("--- TypedStruct vs Plain Struct ---")

    IO.puts("""
    # Without TypedStruct (lots of boilerplate, easy to forget @type):
    defmodule User do
      @enforce_keys [:name, :email]
      defstruct [:name, :email, age: 0, admin: false]

      @type t :: %__MODULE__{
        name:  String.t(),
        email: String.t(),
        age:   non_neg_integer(),
        admin: boolean()
      }
    end

    # With TypedStruct (all in one block, always in sync):
    defmodule User do
      use TypedStruct

      typedstruct enforce: true do
        field :name,  String.t()
        field :email, String.t()
        field :age,   non_neg_integer(), default: 0, enforce: false
        field :admin, boolean(),         default: false, enforce: false
      end
    end

    # TypedStruct generates:
    #   @enforce_keys [:name, :email]
    #   defstruct [name: nil, email: nil, age: 0, admin: false]
    #   @type t() :: %User{
    #     name:  String.t(),
    #     email: String.t(),
    #     age:   non_neg_integer(),
    #     admin: boolean()
    #   }

    # Nullable fields (no default, not enforced):
    #   field :description, String.t()
    # generates: @type with `String.t() | nil`
    #            no entry in @enforce_keys
    #            defstruct default of nil
    """)
  end
end

# ---- Module definitions used by run/0 ----

defmodule BasicUser do
  use TypedStruct

  typedstruct do
    field :name,  String.t()
    field :email, String.t()
    field :age,   non_neg_integer()
  end
end

defmodule EnforcedUser do
  use TypedStruct

  typedstruct enforce: true do
    field :name,  String.t()
    field :email, String.t()
    field :role,  atom(), default: :user, enforce: false
  end
end

defmodule AppConfig do
  use TypedStruct

  typedstruct do
    field :host,    String.t(),     default: "localhost"
    field :port,    non_neg_integer(), default: 4000
    field :ssl,     boolean(),      default: false
    field :timeout, non_neg_integer(), default: 5_000
  end
end

defmodule Product do
  use TypedStruct

  typedstruct do
    field :name,        String.t()           # enforced by default? no — not enforce: true
    field :description, String.t()           # optional (nil by default)
    field :price,       Decimal.t() | nil    # explicitly nilable
    field :sku,         String.t()
  end
end

defmodule OpaqueToken do
  use TypedStruct

  typedstruct opaque: true do
    field :value,      String.t()
    field :expires_at, DateTime.t()
  end
end

defmodule Geometry do
  use TypedStruct

  typedstruct module: Point do
    field :x, float(), default: 0.0
    field :y, float(), default: 0.0
  end
end

defmodule Address do
  use TypedStruct

  typedstruct enforce: true do
    field :street, String.t()
    field :city,   String.t()
    field :zip,    String.t()
    field :country, String.t(), default: "US", enforce: false
  end
end

defmodule Person do
  use TypedStruct

  typedstruct enforce: true do
    field :name,    String.t()
    field :email,   String.t()
    field :address, Address.t() | nil, enforce: false
  end
end
