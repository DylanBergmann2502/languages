class Animal
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def speak
    "Hello!"
  end
end

class GoodDog < Animal
  def initialize(color)
    super  # without () => argument will be used for both
    @color = color
  end

  def speak
    super + " from GoodDog class"
  end
end

sparky = GoodDog.new("brown")
puts sparky.speak        # => "Hello! from GoodDog class"
p sparky                 # => #<GoodDog:0x007fb40b1e6718 @color="brown", @name="brown">

#############################################################
class BadDog < Animal
  def initialize(age, name)
    super(name)
    @age = age
  end
end
sparkish = BadDog.new(2, "bear")        # => #<BadDog:0x007fb40b2beb68 @age=2, @name="bear">
p sparkish

################################################################
class Bear < Animal
  def initialize(color)
    super() # with (), the subclass calls the superclass but without passing any arguments to it
    @color = color
  end
end

bear = Bear.new("black")        # => #<Bear:0x007fb40b1e6718 @color="black">

################################################################
