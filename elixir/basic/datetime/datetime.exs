# Get current UTC datetime
now = DateTime.utc_now()  # Returns datetime in UTC
IO.inspect now

# Get current time in specific timezone
# Requires a timezone database (e.g. tzdata). Without one, returns {:error, :utc_only_time_zone_database}.
case DateTime.now("America/Los_Angeles") do
  {:ok, dt} -> IO.inspect(dt)
  {:error, reason} -> IO.puts("Timezone DB not available: #{reason}")
end

# Create specific DateTime (in UTC)
IO.inspect DateTime.new(Date.utc_today(), ~T[14:30:15.0])

# Create with specific timezone (requires timezone DB)
datetime_result = DateTime.new(
  Date.utc_today(),
  ~T[14:30:15.0],
  "America/New_York"
)

datetime = case datetime_result do
  {:ok, dt} -> dt
  {:error, _} ->
    # Fall back to UTC for demonstration purposes
    elem(DateTime.new(Date.utc_today(), ~T[14:30:15.0], "Etc/UTC"), 1)
end

# Timezone conversions (requires timezone DB)
case DateTime.shift_zone(datetime, "America/Los_Angeles") do
  {:ok, shifted} -> IO.inspect(shifted)
  {:error, reason} -> IO.puts("Timezone shift unavailable: #{reason}")
end

# Basic arithmetic
later = DateTime.add(datetime, 3600, :second)    # Add 1 hour
earlier = DateTime.add(datetime, -3600, :second) # Subtract 1 hour

# Compare DateTimes
IO.inspect DateTime.compare(later, earlier)  # Returns :gt, :eq, or :lt
IO.inspect DateTime.diff(later, earlier)     # Returns difference in seconds

# Parse from strings
# from_iso8601 returns {:ok, datetime, utc_offset_seconds}
{:ok, parsed, _offset} = DateTime.from_iso8601("2024-01-03T14:30:15Z")
IO.inspect parsed

# Format to strings
IO.inspect DateTime.to_string(datetime)  # => "2024-01-03 14:30:15Z"

# Pattern matching
%DateTime{
  year: year,
  month: month,
  day: day,
  hour: hour,
  minute: minute,
  second: second,
  time_zone: tz,
  zone_abbr: abbr,
  utc_offset: offset
} = datetime

IO.inspect(%{
  year: year,
  month: month,
  day: day,
  hour: hour,
  minute: minute,
  second: second,
  time_zone: tz,
  zone_abbr: abbr,
  utc_offset: offset
})

# Convert to other formats
date = DateTime.to_date(datetime)
time = DateTime.to_time(datetime)
naive = DateTime.to_naive(datetime)

IO.inspect date
IO.inspect time
IO.inspect naive

# Check if two datetimes are equal
IO.inspect DateTime.compare(datetime, datetime) == :eq  # true
