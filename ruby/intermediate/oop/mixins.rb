# Mixins are a way to share functionality between classes
# Ruby doesn't support multiple inheritance, so mixins fill this need

########################################################################
# Basic Mixin Example
########################################################################

module Swimmable
  def swim
    "#{self.class} is swimming!"
  end

  def dive
    "#{self.class} is diving underwater!"
  end
end

module Flyable
  def fly
    "#{self.class} is flying!"
  end

  def land
    "#{self.class} is landing!"
  end
end

# Class with one mixin
class Fish
  include Swimmable

  def initialize(name)
    @name = name
  end

  def to_s
    "Fish named #{@name}"
  end
end

# Class with another mixin
class Bird
  include Flyable

  def initialize(name)
    @name = name
  end

  def to_s
    "Bird named #{@name}"
  end
end

# Class with multiple mixins
class Duck
  include Swimmable
  include Flyable

  def initialize(name)
    @name = name
  end

  def to_s
    "Duck named #{@name}"
  end

  def quack
    "#{self}: Quack!"
  end
end

# Test the mixins
fish = Fish.new("Nemo")
bird = Bird.new("Robin")
duck = Duck.new("Donald")

puts fish.swim  # Fish is swimming!
puts bird.fly   # Bird is flying!

puts duck.swim  # Duck is swimming!
puts duck.fly   # Duck is flying!
puts duck.quack # Duck named Donald: Quack!

# This would fail:
# puts fish.fly  # NoMethodError
# puts bird.swim # NoMethodError

########################################################################
# Method Lookup with Mixins
########################################################################

# Let's check the method lookup path (ancestors)
puts "\nAncestors:"
puts "Fish: #{Fish.ancestors.inspect}"
# Fish: [Fish, Swimmable, Object, Kernel, BasicObject]

puts "Duck: #{Duck.ancestors.inspect}"
# Duck: [Duck, Flyable, Swimmable, Object, Kernel, BasicObject]
# Notice that the last included module is checked first

# Let's verify this with a method conflict
module Behavior1
  def shared_method
    "I'm from Behavior1"
  end
end

module Behavior2
  def shared_method
    "I'm from Behavior2"
  end
end

class Example
  include Behavior1
  include Behavior2

  # This class method shows the ancestor chain
  def self.show_ancestors
    ancestors.inspect
  end
end

puts Example.show_ancestors
# [Example, Behavior2, Behavior1, Object, Kernel, BasicObject]

example = Example.new
puts example.shared_method  # I'm from Behavior2
# Behavior2 is checked first as it was included last

########################################################################
# Prepend vs Include
########################################################################

module Prefixer
  def report
    "PREFIX: #{super}"
  end
end

module Suffixer
  def report
    "#{super} :SUFFIX"
  end
end

class ReportInclude
  include Prefixer  # Added to ancestor chain after the class

  def report
    "Original Report"
  end
end

class ReportPrepend
  prepend Prefixer  # Added to ancestor chain before the class

  def report
    "Original Report"
  end
end

class ReportBoth
  prepend Suffixer   # Added before the class
  include Prefixer   # Added after the class

  def report
    "Original Report"
  end
end

puts "\nInclude vs Prepend:"
puts "ReportInclude ancestors: #{ReportInclude.ancestors[0..2].inspect}"
# [ReportInclude, Prefixer, Object]

puts "ReportPrepend ancestors: #{ReportPrepend.ancestors[0..2].inspect}"
# [Prefixer, ReportPrepend, Object]

ri = ReportInclude.new
rp = ReportPrepend.new
rb = ReportBoth.new

puts ri.report  # Original Report
# When included, the class method is called first (no super in this class's method)

puts rp.report  # PREFIX: Original Report
# When prepended, the module method is called first, then super calls the class's method

puts rb.report  # Original Report :SUFFIX
# Complex chain: Suffixer -> ReportBoth -> Prefixer
# But since ReportBoth.report doesn't call super, Prefixer.report is never called

########################################################################
# Real-world Mixin: Comparable
########################################################################

class Temperature
  include Comparable  # This provides <, <=, ==, >=, >, between?

  attr_reader :celsius

  def initialize(celsius)
    @celsius = celsius
  end

  # Comparable requires an implementation of <=>
  def <=>(other)
    celsius <=> other.celsius
  end

  def to_s
    "#{celsius}°C"
  end
end

cold = Temperature.new(10)
mild = Temperature.new(20)
hot = Temperature.new(30)

puts "\nComparable Mixin:"
puts "#{cold} < #{mild}: #{cold < mild}"        # 10°C < 20°C: true
puts "#{hot} > #{mild}: #{hot > mild}"          # 30°C > 20°C: true
puts "#{cold} == #{mild}: #{cold == mild}"      # 10°C == 20°C: false
puts "#{mild} between?(#{cold}, #{hot}): #{mild.between?(cold, hot)}"  # 20°C between?(10°C, 30°C): true

########################################################################
# Real-world Mixin: Enumerable
########################################################################

class Playlist
  include Enumerable  # Provides map, select, reject, any?, all?, etc.

  def initialize
    @songs = []
  end

  def add_song(title, artist)
    @songs << { title: title, artist: artist }
  end

  # Enumerable requires an implementation of each
  def each
    @songs.each { |song| yield song }
  end
end

playlist = Playlist.new
playlist.add_song("Bohemian Rhapsody", "Queen")
playlist.add_song("Imagine", "John Lennon")
playlist.add_song("Billie Jean", "Michael Jackson")
playlist.add_song("Yesterday", "The Beatles")

puts "\nEnumerable Mixin:"

# Using the each method (required for Enumerable)
puts "All songs:"
playlist.each { |song| puts "#{song[:title]} by #{song[:artist]}" }

# Using methods provided by Enumerable
beatles_songs = playlist.select { |song| song[:artist] == "The Beatles" }
puts "\nBeatles songs: #{beatles_songs.inspect}"

song_titles = playlist.map { |song| song[:title] }
puts "All titles: #{song_titles.inspect}"

has_queen = playlist.any? { |song| song[:artist] == "Queen" }
puts "Has Queen songs? #{has_queen}"

long_titles = playlist.count { |song| song[:title].length > 10 }
puts "Songs with long titles: #{long_titles}"

########################################################################
# Creating Modules That Work Well as Mixins
########################################################################

module MixinBestPractices
  # Use a callback to initialize instance variables
  def self.included(base)
    base.class_eval do
      # Add class methods
      extend ClassMethods
      # Add callback
      after_initialize :setup_mixin if method_defined?(:after_initialize)
    end
  end

  # Module for class methods
  module ClassMethods
    def mixin_class_method
      "This is a class method added by the mixin"
    end
  end

  # Initialize mixin data
  def setup_mixin
    @mixin_initialized = true
    @mixin_data = {}
  end

  # Regular instance methods
  def mixin_initialized?
    @mixin_initialized || false
  end

  def store_data(key, value)
    setup_mixin unless mixin_initialized?
    @mixin_data[key] = value
  end

  def retrieve_data(key)
    return nil unless mixin_initialized?
    @mixin_data[key]
  end
end

class MixinUser
  include MixinBestPractices

  def initialize
    # Call our own setup code
    after_initialize
  end

  # Define the callback method expected by the mixin
  def after_initialize
    puts "Initializing MixinUser"
  end
end

puts "\nMixin best practices:"
mixin_user = MixinUser.new
puts "Mixin initialized? #{mixin_user.mixin_initialized?}"  # true

mixin_user.store_data(:status, "active")
puts "Retrieved data: #{mixin_user.retrieve_data(:status)}"  # active

puts "Class method: #{MixinUser.mixin_class_method}"
