# A Time struct can be created with the ~T sigil.
time = ~T[12:24:36]

IO.puts time.hour # 12
IO.puts time.minute # 24
IO.puts time.second # 36

# Getting current time
IO.inspect Time.utc_now()

# Avoid creating the Time structs directly and instead
# rely on the functions provided by this module.
{:ok, time} = Time.new(14, 30, 15)  # Basic: hours, minutes, seconds
{:ok, time_micro} = Time.new(14, 30, 15, 123456)  # With microseconds

# Adding/subtracting time
{:ok, later} = Time.add(time, 3600)  # Add 3600 seconds
{:ok, earlier} = Time.add(time, -1800)  # Subtract 1800 seconds

# Comparing times
IO.inspect Time.compare(later, earlier)  # Returns :gt, :eq, or :lt

# Converting to string
IO.inspect Time.to_string(time)  # => "14:30:15"

# Pattern matching
%Time{hour: hour, minute: minute, second: second} = time

IO.puts "#{hour}:#{minute}:#{second}"  # 14:30:15

# Converting from other formats
IO.inspect Time.from_iso8601("14:30:15")  # Parse ISO 8601 string
