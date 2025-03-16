###########################################################################
# The Factory Pattern provides an interface for creating objects in a superclass,
# but allows subclasses to alter the type of objects that will be created.
# This is useful when a class can't anticipate the class of objects it needs to create.
###########################################################################

# Example 1: Simple Factory Method Pattern
# First, let's create a common interface that all products will implement
class Vehicle
  attr_reader :type, :wheels

  def initialize(type, wheels)
    @type = type
    @wheels = wheels
  end

  def drive
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def display_info
    puts "Type: #{@type}, Wheels: #{@wheels}"
  end
end

# Now let's create some concrete products
class Car < Vehicle
  def initialize
    super("Car", 4)
  end

  def drive
    "Driving on the road with #{@wheels} wheels"
  end
end

class Motorcycle < Vehicle
  def initialize
    super("Motorcycle", 2)
  end

  def drive
    "Riding on the road with #{@wheels} wheels"
  end
end

class Bicycle < Vehicle
  def initialize
    super("Bicycle", 2)
  end

  def drive
    "Pedaling on the road with #{@wheels} wheels"
  end
end

# The Factory class encapsulates object creation
class VehicleFactory
  def self.create_vehicle(type)
    case type.downcase
    when "car"
      Car.new
    when "motorcycle"
      Motorcycle.new
    when "bicycle"
      Bicycle.new
    else
      raise ArgumentError, "Unknown vehicle type: #{type}"
    end
  end
end

# Client code - Using the factory
puts "=== Simple Factory Example ==="
vehicles = ["car", "motorcycle", "bicycle"].map do |type|
  VehicleFactory.create_vehicle(type)
end

vehicles.each do |vehicle|
  vehicle.display_info
  puts vehicle.drive
  puts
end

###########################################################################
# Example 2: Factory Method Pattern with Creator Hierarchy
# The Factory Method Pattern defines an interface for creating objects,
# but lets subclasses decide which classes to instantiate.
###########################################################################

# Abstract Product
class Document
  attr_reader :pages

  def initialize(pages = [])
    @pages = pages
  end

  def add_page(page)
    @pages << page
  end

  def print
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Concrete Products
class Resume < Document
  def print
    puts "=== RESUME ==="
    @pages.each_with_index do |page, index|
      puts "Resume Page #{index + 1}: #{page}"
    end
    puts "=============="
  end
end

class Report < Document
  def print
    puts "=== REPORT ==="
    @pages.each_with_index do |page, index|
      puts "Report Page #{index + 1}: #{page}"
    end
    puts "==============="
  end
end

# Abstract Creator with factory method
class DocumentCreator
  def create_document
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def create_and_fill_document
    # The factory method is used here
    document = create_document

    # Add some default content
    document.add_page("Standard header content")

    # Add specific content using a template method
    add_document_parts(document)

    document.add_page("Standard footer content")
    document
  end

  # Template method to be overridden by subclasses
  def add_document_parts(document)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Concrete Creators
class ResumeCreator < DocumentCreator
  def create_document
    Resume.new
  end

  def add_document_parts(document)
    document.add_page("Personal Information")
    document.add_page("Education")
    document.add_page("Work Experience")
    document.add_page("Skills")
  end
end

class ReportCreator < DocumentCreator
  def create_document
    Report.new
  end

  def add_document_parts(document)
    document.add_page("Executive Summary")
    document.add_page("Data Analysis")
    document.add_page("Findings")
    document.add_page("Recommendations")
  end
end

# Client code - Using the factory method pattern
puts "\n=== Factory Method Pattern Example ==="
creators = [ResumeCreator.new, ReportCreator.new]

creators.each do |creator|
  document = creator.create_and_fill_document
  document.print
  puts
end

###########################################################################
# Example 3: Abstract Factory Pattern
# The Abstract Factory Pattern provides an interface for creating families
# of related or dependent objects without specifying their concrete classes.
###########################################################################

# Abstract Products
class Button
  def render
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class TextField
  def render
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Concrete Products for Light Theme
class LightButton < Button
  def render
    puts "Rendering a light-colored button"
  end
end

class LightTextField < TextField
  def render
    puts "Rendering a light-colored text field"
  end
end

# Concrete Products for Dark Theme
class DarkButton < Button
  def render
    puts "Rendering a dark-colored button"
  end
end

class DarkTextField < TextField
  def render
    puts "Rendering a dark-colored text field"
  end
end

# Abstract Factory Interface
class UIFactory
  def create_button
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def create_text_field
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Concrete Factories
class LightThemeFactory < UIFactory
  def create_button
    LightButton.new
  end

  def create_text_field
    LightTextField.new
  end
end

class DarkThemeFactory < UIFactory
  def create_button
    DarkButton.new
  end

  def create_text_field
    DarkTextField.new
  end
end

# Client code - Using the abstract factory
puts "\n=== Abstract Factory Pattern Example ==="

def render_ui(factory)
  button = factory.create_button
  text_field = factory.create_text_field

  puts "Creating UI with selected theme:"
  button.render
  text_field.render
  puts
end

# Create UI with Light Theme
render_ui(LightThemeFactory.new)

# Create UI with Dark Theme
render_ui(DarkThemeFactory.new)

###########################################################################
# Benefits of Factory Patterns:
# 1. Encapsulates object creation logic and hides implementation details
# 2. Makes code more flexible, allowing easy addition of new types
# 3. Promotes loose coupling between client code and concrete classes
# 4. Adheres to the Open/Closed Principle: open for extension, closed for modification
###########################################################################
