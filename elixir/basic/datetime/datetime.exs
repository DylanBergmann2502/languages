# Get current UTC datetime
now = DateTime.utc_now()  # Returns datetime in UTC
IO.inspect now

# Get current time in specific timezone
IO.inspect DateTime.now("America/Los_Angeles")

# Create specific DateTime (in UTC)
IO.inspect DateTime.new(Date.utc_today(), ~T[14:30:15.0])

# Create with specific timezone
datetime = DateTime.new(
  Date.utc_today(),
  ~T[14:30:15.0],
  "America/New_York"
)

# Timezone conversions
IO.inspect DateTime.shift_zone(datetime, "America/Los_Angeles")

# Basic arithmetic
later = DateTime.add(datetime, 3600, :second)    # Add 1 hour
earlier = DateTime.add(datetime, -3600, :second) # Subtract 1 hour

# Compare DateTimes
DateTime.compare(later, earlier)  # Returns :gt, :eq, or :lt
DateTime.diff(later, earlier)     # Returns difference in seconds

# Parse from strings
{:ok, parsed} = DateTime.from_iso8601("2024-01-03T14:30:15Z")
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
IO.inspect DateTime.equals?(datetime, naive)
