import numpy as np
b = np.arange(1,10).reshape((3,3))
print (b)
repeat_array = np.repeat(b, 3, axis = 0)
none = np.unique(repeat_array, axis = 0)
#print (none)
dia = np.diagonal(b, offset = 2)
print (dia)
