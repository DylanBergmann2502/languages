# Joining paths
IO.puts Path.join("foo", "bar")      # "foo/bar"
IO.puts Path.join(["foo", "bar"])    # "foo/bar"

# Getting file extension
IO.puts Path.extname("foo.ex") # ".ex"

# Expanding paths
IO.puts Path.expand("~/foo")
