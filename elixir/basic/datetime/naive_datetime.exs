# A NaiveDateTime struct can be created with the ~N sigil.
naive = ~N[2024-01-03 14:30:15]

IO.puts naive.year
IO.puts naive.month
IO.puts naive.day
IO.puts naive.hour
IO.puts naive.minute
IO.puts naive.second

# Get current datetime (without timezone)
naive_now = NaiveDateTime.utc_now()  # Returns something like ~N[2024-01-03 14:30:15]

# Create specific NaiveDateTime
{:ok, naive} = NaiveDateTime.new(2024, 1, 3, 14, 30, 15)
# With microseconds
{:ok, naive_micro} = NaiveDateTime.new(2024, 1, 3, 14, 30, 15, 123456)

# Basic arithmetic
later = NaiveDateTime.add(naive, 3600, :second)  # Add 1 hour
earlier = NaiveDateTime.add(naive, -3600, :second)  # Subtract 1 hour

IO.inspect later
IO.inspect earlier

# Compare NaiveDateTimes
IO.inspect NaiveDateTime.compare(later, earlier)  # Returns :gt, :eq, or :lt
IO.inspect NaiveDateTime.diff(later, earlier)     # Returns difference in seconds

# Parsing from strings
{:ok, parsed} = NaiveDateTime.from_iso8601("2024-01-03T14:30:15")
IO.inspect parsed

# Converting to string
IO.inspect NaiveDateTime.to_string(naive)  # => "2024-01-03 14:30:15"

# Pattern matching
%NaiveDateTime{
  year: year,
  month: month,
  day: day,
  hour: hour,
  minute: minute,
  second: second
} = naive

IO.puts "Year: #{year}, Month: #{month}, Day: #{day}, Hour: #{hour}, Minute: #{minute}, Second: #{second}"

# Extract date or time part
date_part = NaiveDateTime.to_date(naive)
time_part = NaiveDateTime.to_time(naive)

IO.inspect date_part
IO.inspect time_part
