# Duration was introduced in Elixir 1.17.
# It represents a period of time in calendar units (years, months, weeks, days, etc.)
# rather than a fixed number of seconds.
# This is important because "add 1 month" is not a fixed number of seconds.

################################################################
# Creating Durations

# Duration.new!/1 takes a keyword list of time units.
one_month = Duration.new!(month: 1)
IO.inspect(one_month) # ~Duration[1M]

two_weeks = Duration.new!(week: 2)
IO.inspect(two_weeks) # ~Duration[2W]

mixed = Duration.new!(year: 1, month: 2, day: 3, hour: 4, minute: 5, second: 6)
IO.inspect(mixed) # ~Duration[1Y2M3DT4H5M6S]

# The ~D sigil for Duration (Elixir 1.17+)
dur = ~D[2024-01-15]  # this is a Date, not a Duration
# Duration uses its own sigil representation in inspect output

################################################################
# Date.shift/2 - calendar-aware date arithmetic

date = ~D[2024-01-31]

# Adding 1 month to Jan 31 gives Feb 29 (2024 is a leap year), not Feb 31
next_month = Date.shift(date, month: 1)
IO.inspect(next_month) # ~D[2024-02-29]

# Compare with Date.add/2 which just adds days:
IO.inspect(Date.add(date, 31)) # ~D[2024-03-02] - not what "next month" means

# Adding a year
IO.inspect(Date.shift(~D[2024-02-29], year: 1))  # ~D[2025-02-28] (2025 not a leap year)
IO.inspect(Date.shift(~D[2023-01-15], month: -3)) # ~D[2022-10-15]

# Shifting by weeks and days
IO.inspect(Date.shift(~D[2024-01-01], week: 2, day: 3)) # ~D[2024-01-18]

################################################################
# NaiveDateTime.shift/2

ndt = ~N[2024-01-31 12:00:00]
IO.inspect(NaiveDateTime.shift(ndt, month: 1))            # ~N[2024-02-29 12:00:00]
IO.inspect(NaiveDateTime.shift(ndt, year: 1, hour: -2))   # ~N[2025-01-31 10:00:00]

################################################################
# DateTime.shift/2

# DateTime.shift is timezone-aware - it respects DST transitions
# (requires a timezone database like Tz or Tzdata to be configured)
{:ok, dt} = DateTime.new(~D[2024-03-10], ~T[01:30:00], "Etc/UTC")
IO.inspect(DateTime.shift(dt, hour: 2)) # ~U[2024-03-10 03:30:00Z]

################################################################
# Duration arithmetic

d1 = Duration.new!(month: 1, day: 15)
d2 = Duration.new!(month: 2, day: -5)

# Add two durations
IO.inspect(Duration.add(d1, d2)) # ~Duration[3M10D]

# Negate a duration
IO.inspect(Duration.negate(d1)) # ~Duration[-1M-15D]

# Multiply a duration by a scalar
IO.inspect(Duration.multiply(Duration.new!(week: 1), 3)) # ~Duration[3W]

################################################################
# Comparing and converting

# Duration fields
d = Duration.new!(year: 1, month: 2, week: 3, day: 4, hour: 5, minute: 6, second: 7, microsecond: {0, 0})
IO.inspect(d.year)    # 1
IO.inspect(d.month)   # 2
IO.inspect(d.week)    # 3
IO.inspect(d.day)     # 4
IO.inspect(d.hour)    # 5
IO.inspect(d.minute)  # 6
IO.inspect(d.second)  # 7

# ISO 8601 string representation
IO.inspect(Duration.to_iso8601(Duration.new!(year: 1, month: 2, day: 3, hour: 4, minute: 5, second: 6)))
# "P1Y2M3DT4H5M6S"

# Parse from ISO 8601
IO.inspect(Duration.from_iso8601("P1Y2M3DT4H5M6S"))
# {:ok, ~Duration[1Y2M3DT4H5M6S]}

################################################################
# Practical example: subscription expiry

defmodule Subscription do
  def expires_at(start_date, plan) do
    duration = case plan do
      :monthly  -> Duration.new!(month: 1)
      :yearly   -> Duration.new!(year: 1)
      :biannual -> Duration.new!(month: 6)
    end
    Date.shift(start_date, duration)
  end
end

start = ~D[2024-01-31]
IO.inspect(Subscription.expires_at(start, :monthly))  # ~D[2024-02-29]
IO.inspect(Subscription.expires_at(start, :yearly))   # ~D[2025-01-31]
IO.inspect(Subscription.expires_at(start, :biannual)) # ~D[2024-07-31]
