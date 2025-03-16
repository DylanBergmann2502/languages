require 'forwardable'

########################################################################
# Forwardable is a module that provides delegation of specified methods
# to a designated object, using the methods #def_delegator and
# #def_delegators.
#
# It's part of Ruby's standard library and needs to be required explicitly.
########################################################################

# Let's create a simple class that will use Forwardable
class Stack
  # Include the Forwardable module
  extend Forwardable

  # We'll use an Array internally to store our items
  def initialize
    @items = []
  end
  
  # Delegate specific methods to the @items array
  # This creates methods in Stack that call the same methods on @items
  def_delegator :@items, :push, :add
  def_delegator :@items, :pop, :remove
  
  # We can delegate multiple methods at once
  def_delegators :@items, :size, :empty?, :clear
end

# Create an instance of our Stack
stack = Stack.new
puts "Empty? #{stack.empty?}" # true

# Use our delegated methods
stack.add(1)
stack.add(2)
stack.add(3)
puts "Size: #{stack.size}" # 3

# The remove method is delegated to Array#pop
puts "Removed item: #{stack.remove}" # 3
puts "New size: #{stack.size}" # 2

# Clear the stack
stack.clear
puts "Empty after clear? #{stack.empty?}" # true

########################################################################
# Delegating to instance variables vs. methods
########################################################################

class Person
  extend Forwardable
  
  def initialize(name)
    @name = name
    @address = Address.new("123 Ruby Lane")
  end
  
  # Delegate to an instance variable
  def_delegators :@address, :street, :city, :to_s
  
  # We can also delegate to methods
  def contact_info
    "Contact information"
  end
  
  def_delegator :contact_info, :to_s, :contact_summary
end

class Address
  attr_reader :street
  
  def initialize(street)
    @street = street
  end
  
  def city
    "Ruby City"
  end
  
  def to_s
    "#{street}, #{city}"
  end
end

person = Person.new("Alice")
puts person.street       # "123 Ruby Lane"
puts person.city         # "Ruby City"
puts person.to_s         # "123 Ruby Lane, Ruby City"
puts person.contact_summary # "Contact information"

########################################################################
# SingleForwardable - for delegating from individual objects
########################################################################

# Rather than using require 'singleton_forwardable',
# SingleForwardable is actually part of the forwardable library
require 'forwardable'

string = "Hello, World!".dup
string.extend SingleForwardable
string.def_delegator :itself, :upcase, :shout
string.def_delegator :itself, :reverse, :backwards

puts string.shout      # "HELLO, WORLD!"
puts string.backwards  # "!dlroW ,olleH"

########################################################################
# Real-world example: Creating a wrapper around a complex API
########################################################################

class User
  attr_accessor :name, :email
  
  def initialize(name, email)
    @name = name
    @email = email
  end
end

class UserRepository
  def find(id)
    # Simulate database lookup
    User.new("User #{id}", "user#{id}@example.com")
  end
  
  def save(user)
    # Simulate saving to database
    puts "Saved user: #{user.name}"
    true
  end
  
  def delete(id)
    # Simulate deletion
    puts "Deleted user #{id}"
    true
  end
end

class UserService
  extend Forwardable
  
  def initialize
    @repository = UserRepository.new
  end
  
  # Delegate methods to the repository with same names
  def_delegators :@repository, :find, :save
  
  # Delegate with a different name
  def_delegator :@repository, :delete, :remove_user
  
  # Add custom logic around some operations
  def update(id, attributes)
    user = find(id)
    attributes.each do |key, value|
      user.send("#{key}=", value) if user.respond_to?("#{key}=")
    end
    save(user)
  end
end

service = UserService.new
user = service.find(1)
puts "Found user: #{user.name}, #{user.email}"

service.update(1, {name: "Updated User", email: "updated@example.com"})
service.remove_user(1)

########################################################################
# Limitations of Forwardable
########################################################################

# 1. Performance: There's a slight overhead compared to direct method calls
# 2. Documentation: Tools might not properly document delegated methods
# 3. Method visibility: All delegated methods become public

# Benchmark comparing direct method calls vs. delegation
require 'benchmark'

class DirectAccess
  def initialize
    @array = []
  end
  
  def push(item)
    @array.push(item)
  end
  
  def pop
    @array.pop
  end
end

class DelegatedAccess
  extend Forwardable
  
  def initialize
    @array = []
  end
  
  def_delegators :@array, :push, :pop
end

direct = DirectAccess.new
delegated = DelegatedAccess.new

n = 1_000_000
Benchmark.bm do |x|
  x.report("Direct:") do
    n.times do |i|
      direct.push(i)
    end
    n.times { direct.pop }
  end
  
  x.report("Delegated:") do
    n.times do |i|
      delegated.push(i)
    end
    n.times { delegated.pop }
  end
end

# The benchmark will show that direct calls are marginally faster,
# but the difference is usually negligible for most applications

# When to use Forwardable:
# 1. When implementing the Decorator pattern
# 2. When practicing composition over inheritance
# 3. When creating facade interfaces to complex subsystems
# 4. When you want to limit the exposed API of an object