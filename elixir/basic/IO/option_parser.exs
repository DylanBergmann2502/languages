defmodule OptionParserDemo do
  def run do
    # Basic usage with a list of arguments
    args = ["--verbose", "--source", "file.txt", "-v", "-n", "10"]
    {parsed, args, invalid} = OptionParser.parse(args, switches: [verbose: :boolean, source: :string, number: :integer])
    IO.inspect(parsed, label: "Parsed options")    # %{verbose: true, source: "file.txt"}
    IO.inspect(args, label: "Remaining args")      # ["-v", "-n", "10"]
    IO.inspect(invalid, label: "Invalid options")  # []
    IO.puts("######################################################")

    # Using aliases for shorter options
    args2 = ["--verbose", "--source", "file.txt", "-v", "-n", "10"]
    {parsed2, args2, invalid2} = OptionParser.parse(args2,
      switches: [verbose: :boolean, source: :string, number: :integer],
      aliases: [v: :verbose, n: :number]
    )
    IO.inspect(parsed2, label: "Parsed with aliases") # %{verbose: true, source: "file.txt", number: 10}
    IO.inspect(args2, label: "Remaining args")        # []
    IO.inspect(invalid2, label: "Invalid options")    # []
    IO.puts("######################################################")

    # Different switch types
    args3 = ["--count", "5", "--names", "john", "--names", "alice", "--enabled", "--value", "3.14"]
    {parsed3, _, _} = OptionParser.parse(args3,
      switches: [
        count: :integer,      # Integer value
        names: [:string],     # List of strings (can appear multiple times)
        enabled: :boolean,    # Boolean flag
        value: :float         # Float value
      ]
    )
    IO.inspect(parsed3, label: "Different switch types") # %{count: 5, names: ["john", "alice"], enabled: true, value: 3.14}

    # Strict mode will report unexpected options as errors
    args4 = ["--verbose", "--unknown", "value"]
    {parsed4, args4, invalid4} = OptionParser.parse(args4,
      strict: [verbose: :boolean]
    )
    IO.inspect(parsed4, label: "Strict mode parsed")   # %{verbose: true}
    IO.inspect(args4, label: "Strict mode remaining")  # []
    IO.inspect(invalid4, label: "Strict mode invalid") # [{"--unknown", "value"}]
  end
end

OptionParserDemo.run()
