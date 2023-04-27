class Employee:

    num_of_emps = 0
    raise_amt = 1.04

    def __init__(self, first, last, pay):
        self.first = first
        self.last = last
        self.pay = pay
        self.email = first + '.' + last + '@gmail.com'
        Employee.num_of_emps += 1

    def full_name(self):
        return '{} {}'.format(self.first, self.last)

    def apply_raise(self):
        self.pay = int(self.pay * self.raise_amt)

    @classmethod
    def set_raise_amt(cls, amount):
        cls.raise_amt = amount

    @classmethod
    def from_string(cls, emp_str):
        first, last, pay = emp_str.split('-')
        return cls(first, last, pay)

    @staticmethod
    def is_workday(day):
        if day.weekday() == 5 or day.weekday() == 6:
            return False
        return True
    def __repr__(self):
        return "Employee('{}', '{}', {})".format(self.first, self.last, self.pay)
    def __str__(self):
        return '{} - {}'.format(self.full_name(), self.email)
    def __add__(self, other):
        return self.pay + other.pay
    def __len__(self):
        return len(self.full_name())
emp_1 = Employee('Corey', 'Shafer', 50000)
emp_2 = Employee('Dylan', 'Bergmann', 40000)

#print(emp_1.full_name())
#print(Employee.full_name(emp_2))

#emp_1.raise_amt = 1.05
#print(Employee.raise_amt)
#print(emp_1.raise_amt)
#print(emp_2.raise_amt)
#print(emp_1.pay)
#emp_1.apply_raise()
#print(emp_1.pay)

#emp_str_1 = 'John-Doe-50000'
#new_emp_1 = Employee.from_string(emp_str_1)
#print(new_emp_1.email)
#import datetime
#my_date = datetime.date(2022, 9, 18)
#print(Employee.is_workday(my_date))

class Developer(Employee):
    raise_amt = 1.10
    def __init__(self, first, last, pay, prog_lang):
        super().__init__(first, last, pay)
        #Employee.__init__(self, first, last, pay)
        self.prog_lang = prog_lang

class Manager(Employee):
    def __init__(self, first, last, pay, employees = None):
        super().__init__(first, last, pay)
        if employees is None:
            self.employees = []
        else:
            self.employees = employees

    def add_employees(self, emp):
        if emp not in self.employees:
            self.employees.append(emp)

    def remove_employees(self, emp):
        if emp in self.employees:
            self.employees.remove(emp)

    def print_emp(self):
        for emp in self.employees:
            print ('-->', emp.full_name())

dev_1 = Developer('Anna', 'Joshson', 45000, 'Python')
dev_2 = Developer('Kirill', 'Petrov', 67894, 'Java')
mgr_1 = Manager('Sue', 'Beauchamps', 90000, [dev_1])
#print(dev_1.email)
#print(dev_1.prog_lang)
#mgr_1.add_employees(dev_2)
#mgr_1.remove_employees(dev_1)
#mgr_1.print_emp()

#print(isinstance(mgr_1, Developer))
#print(isinstance(mgr_1, Employee))
#print(issubclass(Manager, Developer))
#print(issubclass(Manager, Employee))
print
#print(emp_1)
#print(repr(emp_1))
#print(str(emp_1))
#print(emp_1.__repr__())
#print(emp_1.__str__())
print(emp_1 + emp_2)
print(len('test'))
print('test'.__len__())
print(len(emp_1))