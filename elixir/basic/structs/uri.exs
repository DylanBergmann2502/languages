# Parsing a URL into its components
uri = URI.parse("https://example.com:8080/path?query=value#fragment")
IO.inspect(uri)
# %URI{
#   scheme: "https",
#   userinfo: nil,
#   host: "example.com",
#   port: 8080,
#   path: "/path",
#   query: "query=value",
#   fragment: "fragment"
# }

# Encoding a string to make it URL-safe
encoded = URI.encode("hello world/+")
IO.inspect(encoded) # "hello%20world%2F%2B"

# Decoding a URL-encoded string
decoded = URI.decode(encoded)
IO.inspect(decoded) # "hello world/+"

# Building a URL from components
new_uri = %URI{
  scheme: "https",
  host: "api.example.com",
  path: "/users",
  query: URI.encode_query(%{"name" => "john", "age" => "30"})
}
url = URI.to_string(new_uri)
IO.inspect(url) # "https://api.example.com/users?name=john&age=30"

# Parsing query strings
params = URI.decode_query("name=john&age=30")
IO.inspect(params) # %{"age" => "30", "name" => "john"}
