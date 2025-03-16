def get_day_name(day)
  day_name = ""
  case day
  when "mon"
    day_name = "Monday"
  when "tue"
    day_name = "Tuesday"
  else
    day_name = "Invalid abbreviation"
  end

  return day_name
end

puts get_day_name("mon")
