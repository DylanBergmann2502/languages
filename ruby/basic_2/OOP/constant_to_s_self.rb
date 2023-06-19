class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    self.name = n
    self.age  = a * DOG_YEARS
  end

  def to_s
    "This dog's name is #{name} and it is #{age} in dog years."
  end

  def what_is_self
    self
  end

end

sparky = GoodDog.new("Sparky", 4)

puts sparky.age             # => 28

puts sparky

p sparky

p sparky.what_is_self
