'''
def square_numbers(nums):
    result = []
    for i in nums:
        result.append(i*i)
        return result
'''

def square_numbers(nums):
    for i in nums:
        yield (i*i)

my_nums = square_numbers([1,2,3,4,5])

my_nums = (x*x for x in [1,2,3,4,5]) # comprehensions with () = generators

print(my_nums) # [1, 4, 9, 16, 25]
print(next(my_nums))
print(list(my_nums)) # transform generator to list => lose performance

for num in my_nums:
   print(num)