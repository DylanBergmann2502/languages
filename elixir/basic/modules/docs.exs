# @moduledoc - describes a module, appears on the first line of the module.
# @doc - describes a function, appears right above the function's definition and its typespec.
# @typedoc- describes a custom type, appears right above the type's definition.

defmodule MyApp.Hello do
  @moduledoc """
  This is the Hello module.
  """
  @moduledoc since: "1.0.0"

  @doc """
  Says hello to the given `name`.

  Returns `:ok`.

  ## Examples

      iex> MyApp.Hello.world(:john)
      :ok

  """
  @doc since: "1.3.0"
  def world(name) do
    IO.puts("hello #{name}")
  end

  # Elixir treats documentation and code comments as two different concepts.
  # Because documentation is meant to describe the public API of your code,
  # trying to add a @doc attribute to a private function will result in a compilation warning
  # For explaining private functions, use code comments instead.


  # If you mark @moduledoc false or @doc false
  # Those modules and functions will not be included in the generated documentation.
  # Note that that doesn't make them private.
  # They can still be invoked and/or imported.

  # Elixir allows developers to attach arbitrary metadata to the documentation.
  # A commonly used metadata is :since

  # Another common metadata is :deprecated,
  # which emits a warning in the documentation, explaining that its usage is discouraged:
  @doc deprecated: "Use Foo.bar/2 instead"

  # Note that the :deprecated key does not warn
  # when a developer invokes the functions.
  # If you want the code to also emit a warning,
  # you can use the @deprecated attribute:
  @deprecated "Use Foo.bar/2 instead"

  # Always document a module.
  # If you do not intend to document a module, do not leave it blank.
  # Consider annotating the module false
end
