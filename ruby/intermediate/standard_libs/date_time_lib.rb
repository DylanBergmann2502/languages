# Ruby provides several classes for working with dates and times
# The main classes are: Time, Date, DateTime, and since Ruby 2.4, a module called DateAndTime::Calculations
require 'time'
require 'date'

###########################################################################
# Time class - built into Ruby's core
# Time represents a moment in time with microsecond precision

# Creating Time objects
puts "=== Creating Time objects ==="
now = Time.now
puts "Current time: #{now}"

# Creating a specific time (year, month, day, hour, min, sec, usec, utc_offset)
specific_time = Time.new(2025, 3, 16, 14, 30, 45)
puts "Specific time: #{specific_time}"

# Time.at creates a time object from seconds since Unix Epoch (Jan 1, 1970)
epoch_time = Time.at(1647446445)
puts "Time from epoch seconds: #{epoch_time}"

# UTC time
utc_time = Time.now.utc
puts "Current UTC time: #{utc_time}"

###########################################################################
# Time components
puts "\n=== Time components ==="
t = Time.new(2025, 3, 16, 14, 30, 45)
puts "Year: #{t.year}"
puts "Month: #{t.month}"
puts "Day: #{t.day}"
puts "Hour: #{t.hour}"
puts "Minute: #{t.min}"
puts "Second: #{t.sec}"
puts "Microsecond: #{t.usec}"
puts "Nanosecond: #{t.nsec}"
puts "Day of week: #{t.wday}" # 0-6, Sunday is 0
puts "Day of year: #{t.yday}" # 1-366
puts "Timezone: #{t.zone}"
puts "UTC offset: #{t.utc_offset} seconds"

# Time formatting
puts "\n=== Time formatting ==="
puts "ISO 8601: #{t.iso8601}"
puts "RFC 2822: #{t.rfc2822}"
puts "String: #{t.to_s}"
puts "Custom format: #{t.strftime('%Y-%m-%d %H:%M:%S %Z')}"
puts "Custom format (day name): #{t.strftime('%A, %B %d, %Y')}"

###########################################################################
# Time arithmetic
puts "\n=== Time arithmetic ==="
future = t + 60        # Add 60 seconds
past = t - 60          # Subtract 60 seconds
puts "Original: #{t}"
puts "60 seconds later: #{future}"
puts "60 seconds earlier: #{past}"
puts "Difference: #{future - past} seconds"

# Adding/subtracting days is a bit tricky with Time (need to use seconds)
one_day_later = t + (24 * 60 * 60)  # 24 hours * 60 minutes * 60 seconds
puts "One day later: #{one_day_later}"

###########################################################################
# Time comparison
puts "\n=== Time comparison ==="
time1 = Time.new(2025, 3, 16)
time2 = Time.new(2025, 3, 17)

puts "time1 == time2: #{time1 == time2}" # false
puts "time1 < time2: #{time1 < time2}"   # true
puts "time1 > time2: #{time1 > time2}"   # false

###########################################################################
# Date class - requires 'date' library
# Date represents a calendar date (year, month, day) without time
puts "\n=== Date objects ==="
today = Date.today
puts "Today: #{today}"

# Creating a specific date
specific_date = Date.new(2025, 3, 16)
puts "Specific date: #{specific_date}"

# Parsing strings into dates
parsed_date = Date.parse("2025-03-16")
puts "Parsed date: #{parsed_date}"

# Date components
puts "Year: #{today.year}"
puts "Month: #{today.month}"
puts "Day: #{today.day}"
puts "Day of week: #{today.wday}" # 0-6, Sunday is 0
puts "Day of year: #{today.yday}" # 1-366

# Date formatting
puts "String: #{today.to_s}"
puts "Custom format: #{today.strftime('%B %d, %Y')}"

###########################################################################
# Date arithmetic
puts "\n=== Date arithmetic ==="
tomorrow = today + 1          # Add 1 day
yesterday = today - 1         # Subtract 1 day
puts "Today: #{today}"
puts "Tomorrow: #{tomorrow}"
puts "Yesterday: #{yesterday}"

# Adding months
next_month = today >> 1       # Add 1 month
last_month = today << 1       # Subtract 1 month
puts "Next month: #{next_month}"
puts "Last month: #{last_month}"

# Date ranges
date_range = (Date.new(2025, 3, 1)..Date.new(2025, 3, 5))
puts "Days in range: #{date_range.count}"
date_range.each { |date| puts date }

###########################################################################
# DateTime class - combines Date and Time functionality
# DateTime is a subclass of Date that includes time components
puts "\n=== DateTime objects ==="
now_dt = DateTime.now
puts "Current datetime: #{now_dt}"

# Creating a specific datetime
specific_dt = DateTime.new(2025, 3, 16, 14, 30, 45)
puts "Specific datetime: #{specific_dt}"

# Parsing strings into datetimes
parsed_dt = DateTime.parse("2025-03-16T14:30:45+01:00")
puts "Parsed datetime: #{parsed_dt}"

# Components
puts "Timezone: #{parsed_dt.zone}"
puts "Hour: #{parsed_dt.hour}"
puts "Minute: #{parsed_dt.min}"
puts "Second: #{parsed_dt.sec}"

# Formatting
puts "ISO 8601: #{now_dt.iso8601}"
puts "RFC 3339: #{now_dt.rfc3339}"
puts "Custom format: #{now_dt.strftime('%Y-%m-%d %H:%M:%S %Z')}"

###########################################################################
# Converting between Time, Date, and DateTime
puts "\n=== Converting between types ==="
t = Time.now
d = Date.today
dt = DateTime.now

# Time to Date/DateTime
time_to_date = t.to_date
time_to_datetime = t.to_datetime
puts "Time to Date: #{time_to_date.class} - #{time_to_date}"
puts "Time to DateTime: #{time_to_datetime.class} - #{time_to_datetime}"

# Date to Time/DateTime
date_to_time = d.to_time
date_to_datetime = d.to_datetime
puts "Date to Time: #{date_to_time.class} - #{date_to_time}"
puts "Date to DateTime: #{date_to_datetime.class} - #{date_to_datetime}"

# DateTime to Time/Date
datetime_to_time = dt.to_time
datetime_to_date = dt.to_date
puts "DateTime to Time: #{datetime_to_time.class} - #{datetime_to_time}"
puts "DateTime to Date: #{datetime_to_date.class} - #{datetime_to_date}"

###########################################################################
# Working with timezones (requires tzinfo gem)
puts "\n=== Working with timezones ==="
puts "Current timezone: #{Time.now.zone}"

# Converting between timezones with Time
utc_time = Time.now.utc
local_time = utc_time.localtime
puts "UTC time: #{utc_time}"
puts "Local time: #{local_time}"

# Getting timezone information with DateTime
current_offset = DateTime.now.offset
puts "Current offset in days: #{current_offset}"
puts "Current offset in hours: #{current_offset * 24}"

# Note: For more advanced timezone handling, consider using the 'tzinfo' gem

###########################################################################
# Time parsing and formatting
puts "\n=== Parsing and formatting ==="

# Time.parse parses a string into a Time object
parsed_time = Time.parse("2025-03-16 14:30:45")
puts "Parsed time: #{parsed_time}"

# String formatting with strftime
format_string = "%Y-%m-%d %H:%M:%S %Z"
formatted_time = Time.now.strftime(format_string)
puts "Formatted time: #{formatted_time}"

# Common format directives:
# %Y - Year with century (2025)
# %m - Month of year (01..12)
# %d - Day of month (01..31)
# %H - Hour of day, 24-hour clock (00..23)
# %M - Minute of hour (00..59)
# %S - Second of minute (00..60)
# %Z - Time zone name
# %A - Full weekday name (Sunday, Monday...)
# %B - Full month name (January, February...)

###########################################################################
# Date calculations
puts "\n=== Date calculations ==="

birthday = Date.new(1990, 5, 15)
today = Date.today
age = today.year - birthday.year - ((today.month > birthday.month || 
                                    (today.month == birthday.month && today.day >= birthday.day)) ? 0 : 1)
puts "Age: #{age} years"

# Is it a leap year?
puts "2024 is leap year: #{Date.leap?(2024)}"
puts "2025 is leap year: #{Date.leap?(2025)}"

# Days in month
puts "Days in March 2025: #{Date.new(2025, 3, -1).day}"  # Last day of month

# Day of week
puts "Is today a weekend? #{[0, 6].include?(Date.today.wday)}"

# Finding next weekday
today = Date.today
days_until_monday = (1 - today.wday) % 7  # Calculate days until next Monday (1 is Monday in wday)
next_monday = today + days_until_monday
puts "Next Monday: #{next_monday}"

# Finding previous weekday
days_since_friday = (today.wday - 5) % 7  # Calculate days since last Friday (5 is Friday in wday)
last_friday = today - days_since_friday
puts "Last Friday: #{last_friday}"

###########################################################################
# Performance comparison
puts "\n=== Performance comparison ==="
require 'benchmark'

Benchmark.bm(10) do |x|
  x.report("Time:") { 1_000.times { Time.now } }
  x.report("Date:") { 1_000.times { Date.today } }
  x.report("DateTime:") { 1_000.times { DateTime.now } }
end

puts "\nNote: Time is generally fastest and is preferred unless you need Date-specific functionality"