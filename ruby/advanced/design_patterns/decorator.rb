###########################################################################
# The Decorator Pattern attaches additional responsibilities to an object dynamically.
# Decorators provide a flexible alternative to subclassing for extending functionality.
# This pattern is also known as the Wrapper pattern.
###########################################################################

# Example 1: Basic Decorator Pattern Implementation

# The Component interface defines operations that can be altered by decorators
class Component
  def operation
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Concrete Component provides the basic implementation of the operation
class ConcreteComponent < Component
  def operation
    "ConcreteComponent"
  end
end

# The Decorator base class follows the same interface as the component it decorates
class Decorator < Component
  def initialize(component)
    @component = component
  end

  # The Decorator delegates all work to the wrapped component
  def operation
    @component.operation
  end
end

# Concrete Decorators extend the functionality of the component by adding behavior
class ConcreteDecoratorA < Decorator
  # Override the operation method to add new behavior
  def operation
    "ConcreteDecoratorA(#{@component.operation})"
  end
end

class ConcreteDecoratorB < Decorator
  # Override the operation method to add new behavior
  def operation
    "ConcreteDecoratorB(#{@component.operation})"
  end

  # Decorators can also add new methods
  def additional_behavior
    "Additional behavior from B"
  end
end

# Client code
puts "=== Basic Decorator Pattern Example ==="
simple = ConcreteComponent.new
puts "Client: Using the simple component:"
puts simple.operation  # ConcreteComponent

# Decorate the simple component with A
decorator1 = ConcreteDecoratorA.new(simple)
puts "\nClient: Now I've got a decorated component with A:"
puts decorator1.operation  # ConcreteDecoratorA(ConcreteComponent)

# Decorate the already decorated component with B
decorator2 = ConcreteDecoratorB.new(decorator1)
puts "\nClient: Now I've got a component decorated with A and B:"
puts decorator2.operation  # ConcreteDecoratorB(ConcreteDecoratorA(ConcreteComponent))

###########################################################################
# Example 2: Text Formatting with Decorators
###########################################################################

# Base component
class TextComponent
  def text
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Concrete component
class PlainText < TextComponent
  def initialize(text)
    @text = text
  end

  def text
    @text
  end
end

# Base decorator
class TextDecorator < TextComponent
  def initialize(text_component)
    @text_component = text_component
  end

  def text
    @text_component.text
  end
end

# Concrete decorators
class BoldText < TextDecorator
  def text
    "<b>#{@text_component.text}</b>"
  end
end

class ItalicText < TextDecorator
  def text
    "<i>#{@text_component.text}</i>"
  end
end

class UnderlineText < TextDecorator
  def text
    "<u>#{@text_component.text}</u>"
  end
end

# Client code
puts "\n=== Text Formatting Example ==="
plain_text = PlainText.new("Hello, World!")
puts "Plain text: #{plain_text.text}"  # Plain text: Hello, World!

bold_text = BoldText.new(plain_text)
puts "Bold text: #{bold_text.text}"  # Bold text: <b>Hello, World!</b>

italic_text = ItalicText.new(plain_text)
puts "Italic text: #{italic_text.text}"  # Italic text: <i>Hello, World!</i>

# Combining decorators - note how we can stack them in any order
bold_italic_text = BoldText.new(ItalicText.new(plain_text))
puts "Bold and italic: #{bold_italic_text.text}"  # Bold and italic: <b><i>Hello, World!</i></b>

italic_bold_text = ItalicText.new(BoldText.new(plain_text))
puts "Italic and bold: #{italic_bold_text.text}"  # Italic and bold: <i><b>Hello, World!</b></i>

# Adding more decorators to the stack
all_decorated_text = UnderlineText.new(BoldText.new(ItalicText.new(plain_text)))
puts "Underlined, bold, and italic: #{all_decorated_text.text}"  # Underlined, bold, and italic: <u><b><i>Hello, World!</i></b></u>

###########################################################################
# Example 3: Real-world example - Coffee Shop
###########################################################################

# The base component: a simple coffee
class Beverage
  attr_reader :description, :cost

  def initialize(description = "Unknown Beverage")
    @description = description
  end

  def cost
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def description
    @description
  end
end

# Concrete components
class Espresso < Beverage
  def initialize
    super("Espresso")
  end

  def cost
    1.99
  end
end

class HouseBlend < Beverage
  def initialize
    super("House Blend Coffee")
  end

  def cost
    0.89
  end
end

class DarkRoast < Beverage
  def initialize
    super("Dark Roast Coffee")
  end

  def cost
    0.99
  end
end

# Decorator base class
class CondimentDecorator < Beverage
  attr_reader :beverage

  def initialize(beverage)
    super()
    @beverage = beverage
  end

  def description
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Concrete decorators
class Mocha < CondimentDecorator
  def description
    "#{@beverage.description}, Mocha"
  end

  def cost
    @beverage.cost + 0.20
  end
end

class Whip < CondimentDecorator
  def description
    "#{@beverage.description}, Whip"
  end

  def cost
    @beverage.cost + 0.10
  end
end

class Soy < CondimentDecorator
  def description
    "#{@beverage.description}, Soy"
  end

  def cost
    @beverage.cost + 0.15
  end
end

# Client code
puts "\n=== Coffee Shop Example ==="

# Order a plain espresso
beverage = Espresso.new
puts "#{beverage.description}: $#{format("%.2f", beverage.cost)}"  # Espresso: $1.99

# Order a Dark Roast with double Mocha and Whip
beverage2 = DarkRoast.new
beverage2 = Mocha.new(beverage2)
beverage2 = Mocha.new(beverage2)
beverage2 = Whip.new(beverage2)
puts "#{beverage2.description}: $#{format("%.2f", beverage2.cost)}"  # Dark Roast Coffee, Mocha, Mocha, Whip: $1.49

# Order a House Blend with Soy, Mocha, and Whip
beverage3 = Soy.new(Mocha.new(Whip.new(HouseBlend.new)))
puts "#{beverage3.description}: $#{format("%.2f", beverage3.cost)}"  # House Blend Coffee, Whip, Mocha, Soy: $1.34

###########################################################################
# Benefits of the Decorator Pattern:
# 1. More flexibility than static inheritance
# 2. Enhances objects without modifying their structure
# 3. Allows responsibilities to be added and removed at runtime
# 4. Follows Single Responsibility Principle by separating concerns
#
# Drawbacks:
# 1. Can result in many small objects that look similar
# 2. Can be complex to understand initially
# 3. The order of decorators can matter and might be confusing
###########################################################################
