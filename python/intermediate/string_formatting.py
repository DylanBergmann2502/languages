person = {'name': 'Jenn', 'age': 23}

sentence = 'My name is ' + person['name'] + ' and I am ' + str(person['age']) + ' years old.'
print(sentence)

sentence = 'My name is {} and I am {} years old.'.format(person['name'], person['age'])
print(sentence)

sentence = 'My name is {0} and I am {1} years old.'.format(person['name'], person['age'])
print(sentence)

tag = 'h1'
text = 'This is a headline'
sentence = '<{0}>{1}</{0}>'.format(tag, text)
print(sentence)

sentence = 'My name is {0[name]} and I am {0[age]} years old.'.format(person)
print(sentence)

#####################################################################################################
# using list, instead of dict
l = ['Jenn', 23]
sentence = 'My name is {0[0]} and I am {0[1]} years old.'.format(l)

# using class attribute
class Person():

    def __init__(self, name, age):
        self.name = name
        self.age = age

p1 = Person('Jack', '33')

sentence = 'My name is {0.name} and I am {0.age} years old.'.format(p1)
print(sentence)

# using kwargs**
sentence = 'My name is {name} and I am {age} years old.'.format(name='Jenn', age='30')
print(sentence)

# unpacking dict
sentence = 'My name is {name} and I am {age} years old.'.format(**person)
print(sentence)

#####################################################################################################
for i in range(1, 11):
    sentence = 'The value is {:03}'.format(i)  # return 001, 002, 003, ...
    print(sentence)

pi = 3.14159265
sentence = 'Pi is equal to {:.2f}'.format(pi) # .2f => 3.14; .3f => 3.141
print(sentence)

sentence = '1 MB is equal to {:,.2f} bytes'.format(1000**2)  # return 1,000,000.00
print(sentence)

#####################################################################################################
import datetime

my_date = datetime.datetime(2016, 9, 24, 12, 30, 45)
print(my_date)

# March 01, 2016
sentence = '{:%B %d, %Y}'.format(my_date)
print(sentence)

# March 01, 2016 fell on a Tuesday and was the 061 day of the year.
sentence = '{0:%B %d, %Y} fell on a {0:%A} and was the {0:%j} day of the year'.format(my_date)
print(sentence)