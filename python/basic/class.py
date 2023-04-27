class Student:
    def __init__(self, name, gpa, is_undergraduate):
        self.name = name
        self.gpa = gpa
        self.is_undergraduate = is_undergraduate

#from Std import Student
student1 = Student("John", 3.96, False)
print (student1.name)