class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    self.name = n
    self.age = a
  end

  def public_disclosure
    "#{self.name} in human years is #{human_years}"
  end

  # private methods are only accessible from other methods in the class
  private
  def human_years
    age * DOG_YEARS
  end
end

sparky = GoodDog.new("Sparky", 4)
sparky.public_disclosure

################################################################
class Person
  def initialize(age)
    @age = age
  end

  def older?(other_person)
    age > other_person.age
  end

  protected

  attr_reader :age
end

malory = Person.new(64)
sterling = Person.new(42)

puts malory.older?(sterling)  # => true
puts sterling.older?(malory)  # => false

# p malory.age  # => NoMethodError: protected method `age' called for #<Person: @age=64>
