class GoodDog
  attr_accessor :name, :height, :weight
  @@number_of_dogs = 0

  def initialize(n, h, w)
    @name = n
    @height = h
    @weight = w
    @@number_of_dogs += 1
  end

  def speak
    puts "#{name} says arf!"
  end

  # Getter can access instance variable directly
  def info
    "#{name} weighs #{weight} and is #{height} tall."
  end

  # Setter cannot
  def change_info(n, h, w)    # Alternate constructor
    @name = n
    @height = h
    @weight = w
  end

  def change_info2(n, h, w)    # Alternate constructor
    self.name = n
    self.height = h
    self.weight = w
  end

  def self.what_am_i              # Class method definition
    puts "I'm a GoodDog class!"
  end

  def self.total_number_of_dogs   # Static method
    puts @@number_of_dogs
  end
end

sparky = GoodDog.new('Sparky', '12 inches', '10 lbs')
puts sparky.info           # => Sparky weighs 10 lbs and is 12 inches tall.
sparky.speak

sparky.change_info2('Spartacus', '24 inches', '45 lbs')
puts sparky.info           # => Spartacus weighs 45 lbs and is 24 inches tall.

GoodDog.what_am_i          # => I'm a GoodDog class!
GoodDog.total_number_of_dogs



