nums = [1, 2, 3, 4, 5, 6, 7, 8, 9 ,10]
a = [x for x in nums]
b = [x*x for x in nums]
c = list(map(lambda x: x**x, nums))
d = list(filter(lambda x: x%2 == 0, nums))
e = [(letter, num) for letter in 'abdc' for num in range(4)]
print (c, d)
######################
names = ['Bruce', 'Clark', 'Peter', 'Logan']
heroes = ['Batman', 'Superman', 'Spiderman', 'Wolverine']
f = {name: hero for name, hero in zip(names, heroes) if name != 'Peter'}
print(f)
#####################
nums2 = [1,1,1,3,3,3,2,5,5,5,4,4,7,7,6,6,8,8,9,]
g = {x for x in nums2} #set = list.unique()
print (g)
###################
h = (n*n for n in nums) #generator
for i in h:
    print(i)