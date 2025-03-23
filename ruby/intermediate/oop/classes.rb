# In Ruby, a class is a blueprint for creating objects
# Classes encapsulate data and behavior

########################################################################
# Basic Class Definition
########################################################################

# Define a simple class with the 'class' keyword
class Person
  # The initialize method is a special method (constructor)
  # It runs automatically when you create a new instance with Person.new
  def initialize(name, age)
    # Instance variables start with @
    # They're accessible throughout all instance methods in the class
    @name = name
    @age = age
  end

  # Instance method - available to each instance of Person
  def introduce
    puts "Hi, I'm #{@name} and I'm #{@age} years old."
  end

  # Another instance method
  def birthday
    @age += 1
    puts "Happy birthday! I'm now #{@age}."
  end
end

# Create a new instance (object) of the Person class
john = Person.new("John", 30)
john.introduce  # Hi, I'm John and I'm 30 years old.
john.birthday   # Happy birthday! I'm now 31.

########################################################################
# Getters and Setters
########################################################################

# By default, instance variables are private
# We need methods to access them from outside the class

class Book
  def initialize(title, author)
    @title = title
    @author = author
  end

  # Getter methods (readers)
  def title
    @title
  end

  def author
    @author
  end

  # Setter method (writer)
  def title=(new_title)
    @title = new_title
  end
end

book = Book.new("The Ruby Way", "Hal Fulton")
puts book.title      # The Ruby Way
book.title = "Ruby Best Practices"
puts book.title      # Ruby Best Practices

########################################################################
# Attribute Accessors
########################################################################

# Ruby provides shortcuts for creating getters and setters

class Product
  # attr_reader creates getter methods
  attr_reader :id

  # attr_writer creates setter methods
  attr_writer :price

  # attr_accessor creates both getter and setter methods
  attr_accessor :name, :stock

  def initialize(id, name, price, stock)
    @id = id
    @name = name
    @price = price
    @stock = stock
  end

  # Custom getter that formats the price
  def price
    "$#{@price}"
  end

  def summary
    "#{@name} (ID: #{@id}): #{price}, #{@stock} in stock"
  end
end

laptop = Product.new(101, "MacBook Pro", 1299.99, 10)
puts laptop.summary  # MacBook Pro (ID: 101): $1299.99, 10 in stock

laptop.name = "MacBook Air"
laptop.stock = 15
# laptop.id = 102    # This would raise an error since we only have attr_reader
puts laptop.summary  # MacBook Air (ID: 101): $1299.99, 15 in stock

########################################################################
# Class Variables and Methods
########################################################################

class Counter
  # Class variable - shared across all instances
  # Starts with @@
  @@count = 0

  def initialize
    @@count += 1
  end

  # Instance method - operates on a specific instance
  def report
    puts "I'm counter instance ##{@@count}"
  end

  # Class method - operates on the class itself
  # Defined with self. prefix
  def self.count
    @@count
  end

  # Another way to define a class method
  class << self
    def reset
      @@count = 0
      puts "Counter reset!"
    end
  end
end

# Call class method
puts "Total counters: #{Counter.count}"  # Total counters: 0

# Create instances
counter1 = Counter.new
counter2 = Counter.new
counter3 = Counter.new

# Call instance methods
counter1.report  # I'm counter instance #3
counter2.report  # I'm counter instance #3
counter3.report  # I'm counter instance #3

# Call class methods again
puts "Total counters: #{Counter.count}"  # Total counters: 3
Counter.reset    # Counter reset!
puts "Total counters: #{Counter.count}"  # Total counters: 0

########################################################################
# Method Visibility
########################################################################

class BankAccount
  attr_reader :balance

  def initialize(owner, balance = 0)
    @owner = owner
    @balance = balance
  end

  # Public method - can be called from anywhere
  def deposit(amount)
    @balance += amount
    log_transaction("deposit", amount)
    puts "Deposited #{amount}. New balance: #{@balance}"
  end

  def withdraw(amount)
    if sufficient_funds?(amount)
      @balance -= amount
      log_transaction("withdrawal", amount)
      puts "Withdrew #{amount}. New balance: #{@balance}"
    else
      puts "Insufficient funds!"
    end
  end

  private  # Everything below this is private

  # Private method - can only be called from inside the class
  def sufficient_funds?(amount)
    @balance >= amount
  end

  def log_transaction(type, amount)
    puts "LOGGER: #{type} of #{amount} at #{Time.now}"
  end
end

account = BankAccount.new("Alice", 1000)
account.deposit(500)   # Deposited 500. New balance: 1500
account.withdraw(200)  # Withdrew 200. New balance: 1300
account.withdraw(2000) # Insufficient funds!

# This would raise an error:
# account.sufficient_funds?(100)  # private method `sufficient_funds?' called

puts "Final balance: #{account.balance}"  # Final balance: 1300
