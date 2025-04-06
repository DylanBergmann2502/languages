###########################################################################
# The Observer Pattern defines a one-to-many dependency between objects so that
# when one object changes state, all its dependents are notified and updated automatically.
# This is also known as the Publish-Subscribe pattern.
###########################################################################

# Example 1: Using Ruby's built-in Observable module
require "observer"

class StockMarket
  include Observable

  def initialize
    @symbol_prices = {}
  end

  def set_price(symbol, price)
    @symbol_prices[symbol] = price
    changed                  # Mark the object as having changed
    notify_observers(self)   # Notify all observers with self as argument
  end

  def get_price(symbol)
    @symbol_prices[symbol]
  end

  def prices
    @symbol_prices
  end
end

class StockViewer
  attr_reader :name

  def initialize(name)
    @name = name
  end

  # Method called when the observed object calls notify_observers
  def update(market)
    puts "#{@name} received update - Current prices: #{market.prices}"
  end
end

# Demo of the built-in Observable
puts "=== Using Ruby's built-in Observable ==="
market = StockMarket.new

# Create and register observers
viewer1 = StockViewer.new("Mobile App")
viewer2 = StockViewer.new("Web Dashboard")
viewer3 = StockViewer.new("Trading Algorithm")

market.add_observer(viewer1)
market.add_observer(viewer2)
market.add_observer(viewer3)

# Change stock prices - this will notify all observers
market.set_price("AAPL", 150.25)
market.set_price("GOOGL", 2730.50)

# Remove an observer
market.delete_observer(viewer3)
puts "\nRemoved Trading Algorithm observer"

# Change another price - only remaining observers will be notified
market.set_price("MSFT", 310.75)

###########################################################################
# Example 2: Custom implementation of the Observer pattern
###########################################################################

# Subject interface (observable)
module Subject
  def initialize
    @observers = []
  end

  def add_observer(observer)
    @observers << observer
  end

  def remove_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each do |observer|
      observer.update(self)
    end
  end
end

# Observer interface
module Observer
  def update(subject)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Concrete Subject - Weather Station
class WeatherStation
  include Subject

  attr_reader :temperature, :humidity, :pressure

  def initialize
    super
    @temperature = 0
    @humidity = 0
    @pressure = 0
  end

  # When measurements change, notify all observers
  def measurements_changed
    notify_observers
  end

  # Set new measurements
  def set_measurements(temperature, humidity, pressure)
    @temperature = temperature
    @humidity = humidity
    @pressure = pressure
    measurements_changed
  end
end

# Concrete Observers
class CurrentConditionsDisplay
  include Observer

  def update(weather_station)
    @temperature = weather_station.temperature
    @humidity = weather_station.humidity
    display
  end

  def display
    puts "Current conditions: #{@temperature}°C and #{@humidity}% humidity"
  end
end

class StatisticsDisplay
  include Observer

  def initialize
    @temperature_sum = 0
    @readings_count = 0
    @max_temperature = -Float::INFINITY
    @min_temperature = Float::INFINITY
  end

  def update(weather_station)
    temp = weather_station.temperature
    @temperature_sum += temp
    @readings_count += 1
    @max_temperature = temp if temp > @max_temperature
    @min_temperature = temp if temp < @min_temperature
    display
  end

  def display
    avg = @temperature_sum / @readings_count
    puts "Avg/Max/Min temperature: #{avg.round(1)}°C/#{@max_temperature}°C/#{@min_temperature}°C"
  end
end

class ForecastDisplay
  include Observer

  def initialize
    @current_pressure = 0
    @last_pressure = 0
  end

  def update(weather_station)
    @last_pressure = @current_pressure
    @current_pressure = weather_station.pressure
    display
  end

  def display
    forecast = if @current_pressure > @last_pressure
        "Improving weather on the way!"
      elsif @current_pressure == @last_pressure
        "More of the same"
      else
        "Watch out for cooler, rainy weather"
      end
    puts "Forecast: #{forecast}"
  end
end

# Demo of the custom implementation
puts "\n=== Using Custom Observer Implementation ==="
weather_station = WeatherStation.new

# Create and register observers
current_display = CurrentConditionsDisplay.new
stats_display = StatisticsDisplay.new
forecast_display = ForecastDisplay.new

weather_station.add_observer(current_display)
weather_station.add_observer(stats_display)
weather_station.add_observer(forecast_display)

# Simulate weather changes
puts "\nWeather update 1:"
weather_station.set_measurements(25.2, 65, 1013.1)

puts "\nWeather update 2:"
weather_station.set_measurements(27.8, 70, 1014.2)

puts "\nWeather update 3:"
weather_station.set_measurements(26.5, 75, 1012.5)

# Remove an observer
weather_station.remove_observer(forecast_display)
puts "\nRemoved forecast display observer"

# One more update - forecast won't be displayed
puts "\nWeather update 4:"
weather_station.set_measurements(24.9, 80, 1011.2)

###########################################################################
# Example 3: Event-driven Observer pattern with specific events
###########################################################################

# A more flexible implementation that allows observers to subscribe to specific events
class EventManager
  def initialize
    @subscribers = {}
  end

  # Subscribe to a specific event
  def subscribe(event_type, observer)
    @subscribers[event_type] ||= []
    @subscribers[event_type] << observer
  end

  # Unsubscribe from a specific event
  def unsubscribe(event_type, observer)
    return unless @subscribers[event_type]
    @subscribers[event_type].delete(observer)
  end

  # Notify observers of a specific event
  def notify(event_type, data = nil)
    return unless @subscribers[event_type]
    @subscribers[event_type].each do |observer|
      observer.update(event_type, data)
    end
  end
end

# News Agency subject
class NewsAgency
  attr_reader :event_manager

  def initialize
    @event_manager = EventManager.new
  end

  def publish_sports_news(news)
    @event_manager.notify(:sports, news)
  end

  def publish_politics_news(news)
    @event_manager.notify(:politics, news)
  end

  def publish_tech_news(news)
    @event_manager.notify(:tech, news)
  end
end

# Concrete Observers that subscribe to specific news categories
class NewsSubscriber
  attr_reader :name, :interests

  def initialize(name, interests)
    @name = name
    @interests = interests
  end

  def update(event_type, news)
    puts "#{@name} received #{event_type} news: #{news}"
  end
end

# Demo of event-driven implementation
puts "\n=== Event-driven Observer Pattern ==="
news_agency = NewsAgency.new

# Create subscribers with different interests
sports_fan = NewsSubscriber.new("John", [:sports])
politics_follower = NewsSubscriber.new("Sarah", [:politics])
tech_enthusiast = NewsSubscriber.new("Mike", [:tech])
all_news_follower = NewsSubscriber.new("Emily", [:sports, :politics, :tech])

# Register subscribers for their interests
sports_fan.interests.each { |interest| news_agency.event_manager.subscribe(interest, sports_fan) }
politics_follower.interests.each { |interest| news_agency.event_manager.subscribe(interest, politics_follower) }
tech_enthusiast.interests.each { |interest| news_agency.event_manager.subscribe(interest, tech_enthusiast) }
all_news_follower.interests.each { |interest| news_agency.event_manager.subscribe(interest, all_news_follower) }

# Publish different types of news
puts "\nPublishing sports news:"
news_agency.publish_sports_news("Liverpool wins Champions League")

puts "\nPublishing politics news:"
news_agency.publish_politics_news("New climate bill passes in parliament")

puts "\nPublishing tech news:"
news_agency.publish_tech_news("Ruby 3.2 released with improved performance")

###########################################################################
# Benefits of the Observer Pattern:
# 1. Loose coupling between subjects and observers
# 2. Support for broadcast communication
# 3. Dynamic relationships between observers and subjects at runtime
#
# Drawbacks:
# 1. Notification order is usually not guaranteed
# 2. If not implemented carefully, can create memory leaks
# 3. May cause cascading updates if observers also act as subjects
###########################################################################
