defmodule LearnTimex do
  def run do
    IO.puts("=== Learning Timex Library ===\n")

    # Basic date/time operations
    now = Timex.now()
    IO.puts("Current time: #{Timex.format!(now, "{ISO:Extended}")}")

    # Date shifting and manipulation
    tomorrow = Timex.shift(now, days: 1)
    IO.puts("Tomorrow: #{Timex.format!(tomorrow, "{YYYY}-{0M}-{0D}")}")

    # Timezone conversions
    paris_time = Timex.to_datetime(now, "Europe/Paris")
    IO.puts("Time in Paris: #{Timex.format!(paris_time, "{h24}:{m}:{s} {Zabbr}")}")

    # Relative time formatting
    yesterday = Timex.shift(now, days: -1)
    relative = Timex.from_now(yesterday)
    IO.puts("Yesterday relative: #{relative}")

    # Date comparison
    diff_days = Timex.diff(tomorrow, yesterday, :days)
    IO.puts("Days between yesterday and tomorrow: #{diff_days}")

    # Parsing dates from strings
    parsed = Timex.parse!("2023-01-15", "{YYYY}-{0M}-{0D}")
    IO.puts("Parsed date: #{Timex.format!(parsed, "{WDfull}, {Mfull} {D}, {YYYY}")}")

    # Duration calculation
    duration = Timex.Duration.from_days(45)
    IO.puts("45 days as duration: #{Timex.Format.Duration.Formatters.Humanized.format(duration)}")
  end
end
