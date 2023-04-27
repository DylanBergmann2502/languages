# variable
first_name = 'Dylan'
last_name = 'Bergmann'

sentence = 'My name is {} {}'.format(first_name, last_name)
print(sentence)

sentence = f'My name is {first_name.upper()} {last_name.upper()}'
print(sentence)

######################################################################################################
# dictionary
person = {'name': 'Jenn', 'age': 23}

sentence = 'My name is {} and I am {} years old.'.format(person['name'], person['age'])
print(sentence)

sentence = f"My name is {person['name']} and I am {person['age']} years old"
print(sentence) # use double quotes ""

#####################################################################################################
# doing maths
calculation = f'4 times 11 is equal to {4*11}'
print(calculation)

for n in range(1, 11):
    sentence = f'The value is {n:02}'  # return 001, 002, 003, ...
    print(sentence)

pi = 3.14159265
sentence = f'Pi is equal to {pi:.4f}' # .2f => 3.14; .3f => 3.141, it can round up/down the number
print(sentence)

sentence = f'1 MB is equal to {1000**2:,.2f} bytes' # return 1,000,000.00
print(sentence)

#####################################################################################################
from datetime import datetime

birthday = datetime(1990, 1, 1)
sentence = f'Jenna has a birthday on {birthday:%B %d, %Y}'
print(sentence)