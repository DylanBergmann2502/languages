# A Date struct can be created with the ~D sigil.
date = ~D[2024-01-03]

IO.puts date.day
IO.puts date.month
IO.puts date.year

# Get today's date
today = Date.utc_today()  # Returns something like ~D[2024-01-03]

# Creating specific dates
{:ok, date} = Date.new(2024, 1, 3)
{:ok, leap_date} = Date.new(2024, 2, 29)  # 2024 is a leap year

# Basic arithmetic with dates
tomorrow = Date.add(date, 1)
yesterday = Date.add(date, -1)

IO.inspect tomorrow
IO.inspect yesterday

# Calculate difference between dates
IO.inspect Date.diff(tomorrow, yesterday)  # Returns number of days between dates

# Compare dates
IO.inspect Date.compare(tomorrow, yesterday)  # Returns :gt, :eq, or :lt

# Getting day of the week
IO.inspect Date.day_of_week(date)      # 1-7 (Monday is 1, Sunday is 7)
IO.inspect Date.day_of_year(date)      # 1-366

# Range of dates
date_range = Date.range(~D[2024-01-01], ~D[2024-12-31])
IO.inspect Enum.count(date_range)  # Number of days in range

# Check if it's a leap year
IO.inspect Date.leap_year?(~D[2024-01-03])  # Returns true

# Converting to string
IO.inspect Date.to_string(date)  # => "2024-01-03"

# Pattern matching
%Date{year: year, month: month, day: day} = date

IO.puts "#{year}-#{month}-#{day}"

# Beginning/end of month
IO.inspect Date.beginning_of_month(date)  # First day of the month
IO.inspect Date.end_of_month(date)       # Last day of the month
