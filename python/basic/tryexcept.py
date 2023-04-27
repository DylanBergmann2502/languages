try:
    #value = 10/0
    number = int(input("Number: "))
    print (number)
except ZeroDivisionError as err:
    print (err)
except ValueError as err:
    print (err)