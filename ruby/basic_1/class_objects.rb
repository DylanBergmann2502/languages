class Book
  attr_accessor :title, :author, :pages
  def initialize(title, author, pages)
    @title = title
    @author = author
    @pages = pages
  end
end

# book1 = Book.new()
# book1.title = "Harry Potter"
# book1.author = "JK Rowling"
# book1.pages = 400

# puts book1.title

book2 = Book.new("Lord of the Rings", "Tolkien", 400)
puts book2.title
#############################################################################
class Student
  attr_accessor :name, :major, :gpa
  def initialize(name, major, gpa)
    @name = name
    @major = major
    @gpa = gpa
  end

  def has_honors
    if @gpa >= 3.5
      return true
    end
    return false
  end
end

jim = Student.new("Jim", "Business", 2.6)
pam = Student.new("Pam", "Art", 3.6)

puts jim.has_honors, pam.has_honors
