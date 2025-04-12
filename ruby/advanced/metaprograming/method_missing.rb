# Ruby Metaprogramming: method_missing
# method_missing is invoked when you call a method that doesn't exist

########################################################################
# Basic method_missing example
class Ghost
  def method_missing(method_name, *args, &block)
    puts "You called #{method_name} with #{args.inspect} and a block: #{block.nil? ? "No" : "Yes"}"
  end
end

ghost = Ghost.new
ghost.boo                   # You called boo with [] and a block: No
ghost.haunt("house", 123)   # You called haunt with ["house", 123] and a block: No
ghost.float { puts "Wooo" } # You called float with [] and a block: Yes

########################################################################
# A more practical example: Dynamic attributes
class Person
  def initialize
    @attributes = {}
  end

  def method_missing(method_name, *args)
    attribute = method_name.to_s

    if attribute.end_with?("=") # Setter
      @attributes[attribute.chop] = args.first
    else # Getter
      @attributes[attribute]
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    true
  end
end

person = Person.new
person.name = "Ruby"
person.age = 30
puts "#{person.name} is #{person.age} years old"  # Ruby is 30 years old

########################################################################
# Important: Always define respond_to_missing? when using method_missing
puts "Does person respond to name? #{person.respond_to?(:name)}"  # true
puts "Does person respond to address? #{person.respond_to?(:address)}"  # true

########################################################################
# Call super in method_missing if you don't handle the method
class BetterGhost < Ghost
  def method_missing(method_name, *args, &block)
    if method_name.to_s =~ /boo/
      puts "BOOOOOO!"
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.include?("boo") || super
  end
end

better_ghost = BetterGhost.new
better_ghost.boo       # BOOOOOO!
better_ghost.super_boo # BOOOOOO!
better_ghost.haunt     # You called haunt with [] and a block: No

########################################################################
# method_missing in practice: OpenStruct
require "ostruct"

person = OpenStruct.new
person.name = "Ruby"
person.age = 30
puts "#{person.name} is #{person.age} years old"  # Ruby is 30 years old

########################################################################
# Dangers of method_missing: Performance
# Method lookup is slower due to Ruby trying all methods first

# Dangers of method_missing: Debugging
# Errors can be hard to debug as they happen at the method_missing level

########################################################################
# Example of poor error messages with method_missing
class BadGhost
  def method_missing(method_name, *args)
    "Wooo!"
  end
end

ghost = BadGhost.new
# Attempting to call a non-existent method will return "Wooo!" instead of raising
# This can make debugging difficult
ghost.fly  # "Wooo!"

# If we make a typo in our method call, we won't get a helpful error message
# puts ghost.to_sss  # "Wooo!" instead of a NoMethodError

########################################################################
# Better approach: Combining method_missing with define_method
class DynamicPerson
  def initialize
    @attributes = {}
  end

  def method_missing(method_name, *args, &block)
    attribute = method_name.to_s

    if attribute.end_with?("=") # Setter
      attribute = attribute.chop
      # Define the setter method for future use
      self.class.define_method("#{attribute}=") do |value|
        @attributes[attribute] = value
      end
      @attributes[attribute] = args.first
    else # Getter
      # Define the getter method for future use
      self.class.define_method(attribute) do
        @attributes[attribute]
      end
      @attributes[attribute]
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    true
  end
end

# First access uses method_missing
dynamic_person = DynamicPerson.new
dynamic_person.name = "Dynamic Ruby"
puts dynamic_person.name  # Dynamic Ruby

# Second access uses the defined method (faster)
dynamic_person.name = "Fast Ruby"
puts dynamic_person.name  # Fast Ruby
