try:
    f = open('testfile.txt')
except Exception:
    print('Sorry. This file does not exist')

# else and finally
try:
    f = open('test_file.txt')
    # var = bad_var
except FileNotFoundError:
    print('Sorry. This file does not exist')
except Exception as e: # print out the exception instead of customizing it
    print(e)
else: # else is run when try and except doesn't throw an exception
    print(f.read())
    f.close()
finally: # finally is run regardless of exceptions
    print("Executing Finally...")

# raise exception
try:
    f = open('corrupt_file.txt')
    if f.name == 'corrupt_file.txt':
        raise Exception
except Exception:
    print('Error!')
else:
    print(f.read())