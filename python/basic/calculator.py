n1 = float(input("Enter the 1st number: "))
op = input ("Enter operator: ")
n2 = float(input("Enter the 2nd number: "))
if op == "*":
    print (n1 * n2)
elif op == "/":
    print (n1 / n2)
elif op == "+":
    print (n1 + n2)
elif op == "-":
    print (n1 - n2)
else:
    print ("Invalid operator")
