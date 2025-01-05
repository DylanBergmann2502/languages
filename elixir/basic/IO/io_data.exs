# Every time you concatenate binaries
# or use interpolation (#{}) you are making copies of those binaries.
defmodule OldModule do
  def email(username, domain) do
    username <> "@" <> domain
  end

  def welcome_message(name, username, domain) do
    "Welcome #{name}, your email is: #{email(username, domain)}"
  end
end

IO.puts(OldModule.welcome_message("Meg", "meg", "example.com"))
#=> "Welcome Meg, your email is: meg@example.com"

################################################################
# You can construct the binary by creating IO data instead:
defmodule NewModule do
  def email(username, domain) do
    [username, ?@, domain]
  end

  def welcome_message(name, username, domain) do
    ["Welcome ", name, ", your email is: ", email(username, domain)]
  end
end

IO.puts(NewModule.welcome_message("Meg", "meg", "example.com"))
#=> "Welcome Meg, your email is: meg@example.com"
