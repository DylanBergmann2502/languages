# A keyword list is a list of {key, value} tuples.
# There are two way to write a keyword list:

# concise
[month: "April", year: 2018]

# explicit
[{:month, "April"}, {:year, 2018}]

################################
# Keys must be atom
Keyword.keyword?([{"month", "April"}]) # => false

# If you want to use characters other than letters, numbers,
# and _ in the key, you need to wrap it in quotes.
# However, that does not make it a string - it is still an atom.
Keyword.keyword?(["day of week": "Monday"]) # => true

################################
# Keys can repeat
# Keys in a keyword list can repeat, and the key-value pairs are ordered.
# Getting a single value under a given key, you will only get the first value
list = [month: "April", month: "May"]

Keyword.get_values(list, :month) # => ["April", "May"]

Keyword.get(list, :month) # => "April"

list[:month] # => "April"

################################
# Keyword lists as options
if age >= 16, do: "beer", else: "no beer"
# or
if age >= 16, [do: "beer", else: "no beer"]
# or
if age >= 16, [{:do, "beer"}, {:else, "no beer"}]

################################
# Pattern matching
